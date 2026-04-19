`timescale 1ns / 10ps

module usb_rx (
    input logic clk, n_rst, 
    dp_in, dm_in,
    input logic [7:0] buffer_occupancy,
    output logic rx_data_ready, rx_transfer_active,
    rx_error, flush, store_rx_packet_data,
    output logic [3:0] rx_packet,
    output logic [7:0] rx_packet_data
);

logic edge_det, decoded_data, valid_bit,
    shift_strobe, crc5_en, crc16_en,
    crc5_valid, crc16_valid,
    crc5_clear, crc16_clear,
    sr_en, sr_clear, clear_count,
    byte_done, token_done, eop_det;

logic [3:0] count, next_count; //counter logic
logic [15:0] data_parallel;

/* verilator lint_off UNUSEDSIGNAL */
logic [3:0] bit_count;
/* verilator lint_on UNUSEDSIGNAL */

rx_edge_detector ed1 (.*);
eop_detector eopd1 (.*);
nrzi_decoder nrzi1 (.*);
bit_stuffing_remover bsr1 (.*);
rx_bit_timer bt1 (.*);
crc_checker_5bit crc5 (
    .clk(shift_strobe),
    .n_rst(n_rst),
    .crc_valid(crc5_valid),
    .crc_en(crc5_en),
    .crc_clear(crc5_clear),
    .valid_bit(valid_bit),
    .serial_in(decoded_data)
);
crc_checker_16bit crc16 (
    .clk(shift_strobe),
    .n_rst(n_rst),
    .crc16_valid(crc16_valid),
    .crc16_en(crc16_en),
    .crc16_clear(crc16_clear),
    .valid_bit(valid_bit),
    .serial_in(decoded_data)
);
rx_shift_register sr1 (
    .clk(shift_strobe),
    .n_rst(n_rst),
    .serial_in(decoded_data),
    .parallel_out(data_parallel),
    .en(sr_en),
    .valid_bit(valid_bit),
    .clear(sr_clear)
);

typedef enum logic [2:0] { 
    IDLE, SYNC, PID, ERROR,
    TOKEN, DATA, EOP, DONE
} state_t;

typedef enum logic [3:0] {
    OUT = 4'b0001,
    IN = 4'b1001,
    DATA0 = 4'b0011,
    DATA1 = 4'b1011,
    ACK = 4'b0010,
    NAK = 4'b1010,
    STALL = 4'b1110,
    UNKNOWN = 4'b0000
} pid_t;

state_t state, next_state;
pid_t pid, next_pid;

logic next_byte_done, next_token_done;
logic packet_size; //1 for 16 bit, 0 for 8 bit

assign packet_size = (pid == OUT || pid == IN) ? 1 : 0;

always_comb begin : counter_comb
    next_byte_done = 0;
    next_token_done = 0;
    next_count = count;

    
    if (shift_strobe) begin
        next_count = count + 1;
    end
    if (clear_count) begin
        next_count = 0;
    end
    if (count == 7) begin
        next_byte_done = 1;

        if (packet_size == 0) begin
            next_count = 0;
        end
    end
    else if (count == 15) begin
        next_token_done = 1;
        next_count = 0;
    end
end

always_ff @(posedge clk, negedge n_rst) begin : counter_ff
    if (n_rst == 1'b0) begin
        count <= 0;
        byte_done <= 0;
        token_done <= 0;
    end
    else begin
        count <= next_count;
        byte_done <= next_byte_done;
        token_done <= next_token_done;
    end
end

always_comb begin : fsm_comb
    next_state = state;
    crc5_en = 0;
    crc5_clear = 0;
    crc16_en = 0;
    crc16_clear = 0;
    sr_en = 0;
    sr_clear = 0;
    clear_count = 0;
    flush = 0;
    rx_error = 0;
    rx_packet = pid;
    rx_data_ready = 0;
    rx_transfer_active = 0;
    rx_packet_data = 8'b0;
    store_rx_packet_data = 0;
    next_pid = pid;

    case (state)
        IDLE: begin
            clear_count = 1;

            if (edge_det) begin
                next_state = SYNC;
            end
        end
        SYNC: begin
            //packet type 8 bit
            flush = 1;
            sr_en = 1;
            rx_transfer_active = 1;

            if (byte_done && data_parallel == 16'h0001) begin
                next_state = PID;
            end
            else if (byte_done) begin
                next_state = ERROR;
            end
        end
        PID: begin
            //packet type 8 bit
            sr_en = 1;
            rx_transfer_active = 1;

            if (byte_done) begin
                if (data_parallel[3:0] == ~(data_parallel[7:4])) begin
                    next_pid = pid_t'(data_parallel[7:4]); // inverted is 4 lsb
                    if (next_pid == OUT || next_pid == IN) begin
                        next_state = TOKEN;
                    end
                    else if (next_pid == DATA0 || next_pid == DATA1) begin
                        next_state = DATA;
                    end
                    else if (next_pid == ACK) begin
                        next_state = EOP;
                    end
                    else begin
                        next_state = ERROR;
                    end
                end
                else begin
                    next_state = ERROR;
                end
            end
        end
        ERROR: begin
            if (eop_det) begin
                next_state = DONE;
            end

            rx_transfer_active = 1;
        end
        TOKEN: begin
            rx_transfer_active = 1;
            crc5_en = 1;
            sr_en = 1;

            if (token_done) begin
                next_state = EOP;
            end
        end
        DATA: begin
            next_state = DATA;
            if (eop_det) begin
                next_state = EOP;
            end
            if (byte_done) begin
                if (buffer_occupancy >= 64) begin
                    next_state = ERROR;
                    flush = 1;
                end
                else begin
                    rx_packet_data = data_parallel[7:0];
                    store_rx_packet_data = 1;
                end
            end

            rx_transfer_active = 1;
            crc16_en = 1;
            sr_en = 1;
        end
        EOP: begin
            rx_transfer_active = 1;

            if (!eop_det) begin //from all packet types
                next_state = ERROR;
            end

            else if (pid == OUT || pid == IN) begin
                if (crc5_valid) begin
                    rx_data_ready = 1;
                    next_state = DONE;
                end
                else begin
                    next_state = ERROR;
                end
            end
            else if (pid == DATA0 || pid == DATA1) begin
                if (crc16_valid) begin
                    rx_data_ready = 1;
                    next_state = DONE;
                end
                else begin
                    next_state = ERROR;
                end
            end
            else begin //ACK
                next_state = DONE;
            end
        end
        DONE: begin
            crc16_clear = 1;
            crc5_clear = 1;
            sr_clear = 1;
            clear_count = 1;
        end
    endcase
end

always_ff @ (posedge clk, negedge n_rst) begin : fsm_ff
    if (n_rst == 1'b0) begin
        state <= IDLE;
        pid <= UNKNOWN;
    end
    else begin
        state <= next_state;
        pid <= next_pid;
    end
end

endmodule
