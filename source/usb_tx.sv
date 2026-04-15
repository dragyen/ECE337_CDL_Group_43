`timescale 1ns / 10ps


module usb_tx
(
    input logic clk,
    input logic n_rst,
    input logic [7:0] tx_packet_data,
    input logic [1:0] tx_packet,
    input logic [6:0] buffer_occupancy,
    output logic get_tx_packet_data,
    output logic tx_transfer_active,
    output logic tx_error,
    output logic dm_out,
    output logic dp_out
)



    // fsm

    typedef enum logic [3:0] {IDLE, SYNC, PID,DATA,WAIT_DATA,ERROR,EOP,CRC,WAIT} state_e;
    state_e currentState, nextState;

    logic shift_en;
    logic load_en;
    logic bit_pulse;
    logic [4:0] bit_counter;
    logic [4:0] next_bit_counter;

    always_ff@(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            currentState <= IDLE;
            bit_counter <= '0;
        end
        else begin
            currentState <= nextState;
            bit_counter <= next_bit_counter;
        end
    end

    typedef enum logic [3:0] {
        PID_OUT   = 4'b0001,
        PID_IN    = 4'b1001,
        PID_DATA0 = 4'b0011,
        PID_DATA1 = 4'b1011,
        PID_ACK   = 4'b0010,
        PID_NAK   = 4'b1010,
        PID_STALL = 4'b1110
    } pid_e;

    logic [3:0] pid;

    always_comb begin
        case (tx_packet)
            2'b00: pid = PID_DATA0;
            2'b01: pid = PID_DATA1;
            2'b10: pid = PID_ACK;
            2'b11: pid = PID_NAK;
            default: pid = PID_STALL;
        endcase
    end

     always_comb begin
        nextState = currentState;   
        next_bit_counter = bit_counter;
        case(currentState)
            IDLE: begin
                if(tx_packet != 0) begin
                    nextState = SYNC;
                end
            end
            SYNC: begin
                if (bit_pulse)
                next_bit_counter = bit_counter + 1;
                if(bit_counter == 7) begin
                    nextState = PID;
                    next_bit_counter = 0;
                end
            end
            PID: begin
                if (bit_pulse)
                next_bit_counter = bit_counter + 1;
                if(bit_counter == 7) begin
                    if(pid == PID_ACK || pid == PID_NAK || pid == PID_STALL)
                        nextState = EOP;
                    else if(pid == PID_DATA0 || pid == PID_DATA1)
                        nextState = DATA;
                    else begin
                        nextState = ERROR;
                    end
                    next_bit_counter = 0;
                end
            end
            DATA: begin
                next_bit_counter = 0;
                if(buffer_occupancy == 0) begin
                    nextState = ERROR;
                end
                else begin
                    nextState = WAIT_DATA;
                end
            end
            WAIT_DATA: begin
                next_bit_counter = 0;
                if(buffer_occupancy !== 0) begin
                    nextState = DATA;
                end
                else begin
                    nextState = CRC;
                    next_bit_counter = 0;
                end
            end
            ERROR: begin
                next_bit_counter = 0;
               nextState = IDLE;
            end
            CRC: begin
                if (bit_pulse)
                next_bit_counter = bit_counter + 1;
                if(bit_counter == 15) begin // crc bonus tx_packet_data == CONST
                    nextState = EOP;
                    next_bit_counter = 0;
                end
            end
            EOP: begin
                if (bit_pulse)
                next_bit_counter = bit_counter + 1;
                if(bit_counter == 2) begin
                    nextState = WAIT;
                    next_bit_counter = 0;
                end
            end
            WAIT: begin
                next_bit_counter = 0;
                nextState = IDLE;
            end
            default : nextState = currentState;
        endcase
    end


     always_comb begin
                tx_transfer_active = '0;
                shift_en = '0;
                get_tx_packet_data = '0;   
                tx_error = '0;
            if(currentState == IDLE) begin
                tx_transfer_active = '0;
                shift_en = '0;
                get_tx_packet_data = '0;   
            end
            if(currentState == SYNC) begin
                tx_transfer_active = 1;
                shift_en = bit_pulse;
                get_tx_packet_data = '0;   
            end
            if(currentState == PID) begin
                tx_transfer_active = 1;
                shift_en = bit_pulse;
                get_tx_packet_data = '0;   
            end
            if(currentState == DATA) begin
                tx_transfer_active = 1;
                shift_en = bit_pulse;
                get_tx_packet_data = bit_pulse;   
            end
            if(currentState == ERROR) begin
                tx_transfer_active = 0;
                shift_en = 0;
                get_tx_packet_data = 0;  
                tx_error = 1; 
            end
            if(currentState == WAIT_DATA) begin
                tx_transfer_active = '0;
                shift_en = '0;
                get_tx_packet_data = '0;   
            end
            if(currentState == CRC) begin
                tx_transfer_active = 1;
                shift_en = bit_pulse;
                get_tx_packet_data = '0;   
            end
            if(currentState == EOP) begin
                tx_transfer_active = '0;
                shift_en = '0;
                get_tx_packet_data = '0;   
            end
            if(currentState == WAIT) begin
                tx_transfer_active = '0;
                shift_en = '0;
                get_tx_packet_data = '0;  
            end
        end


        // flex counter
    logic [1:0] pattern_state;
    logic [3:0] rollover_val;
    logic [3:0] clk_count;
    logic serial_out;

    // pattern 8,8,9
    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst)
            pattern_state <= 0;
        else if(bit_pulse) begin
            pattern_state <= (pattern_state == 2) ? 0 : pattern_state + 1;
        end
    end

    always_comb begin
        case(pattern_state)
            2'd0: rollover_val = 4'd7; // 8 
            2'd1: rollover_val = 4'd7; // 8 
            2'd2: rollover_val = 4'd8; // 9
            default: rollover_val = 4'd7;
        endcase
    end

    flex_counter #(.SIZE(4)) clk_div (
        .clk(clk),
        .n_rst(n_rst),
        .clear(1'b0),
        .count_enable(1'b1),
        .rollover_val(rollover_val),
        .count_out(clk_count),
        .rollover_flag(bit_pulse)
    );  

    flex_sr #(.SIZE(8)) data_sr (
        .clk(clk),
        .n_rst(n_rst),
        .shift_enable(shift_en),
        .load_enable(load_en),
        .serial_in(1'b0),
        .parallel_in(tx_packet_data),
        .serial_out(serial_out),
        .parallel_out()
    );


    // DP/DM + NRZI encoder

    logic dp_orig;
    logic [1:0] eop_count;

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dp_orig <= 1'b1;
            dp_out <= 1'b1;
            dm_out <= 1'b0;
            eop_count <= 0;
        end
        else begin
            if (currentState == EOP) begin
                if (eop_count < 2) begin
                    dp_out <= 1'b0;
                    dm_out <= 1'b0;
                    eop_count <= eop_count + 1;
                end
                else begin
                    dp_out <= 1'b1;
                    dm_out <= 1'b0;
                end
            end
            else begin
                eop_count <= 0;
                if (shift_en) begin
                    // 0 toggles, 1 holds
                    if (serial_out == 1'b0)
                    dp_orig <= ~dp_orig;
                    dp_out <= dp_orig;
                    dm_out <= ~dp_orig;
                end
            end
        end
    end

endmodule

