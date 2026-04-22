`timescale 1ns / 10ps


module usb_tx
(
    input logic clk,
    input logic n_rst,
    input logic [7:0] tx_packet_data,
    input logic [2:0] tx_packet,
    input logic [6:0] buffer_occupancy,
    output logic get_tx_packet_data,
    output logic tx_transfer_active,
    output logic tx_error,
    output logic dm_out,
    output logic dp_out
);

    // fsm

    typedef enum logic [3:0] {IDLE, SYNC, PID,DATA,WAIT_DATA,ERROR,EOP,CRC,WAIT} state_e;
    state_e currentState, nextState;

    logic shift_en;
    logic load_en;
    logic bit_pulse;
    logic [4:0] bit_counter;
    logic [4:0] next_bit_counter;
    logic [2:0] ones_count, next_ones_count;
    logic stuff_active, next_stuff_active;
    logic [15:0] crc16, next_crc16;
    logic nrzi_bit;


    always_ff@(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            currentState <= IDLE;
            bit_counter <= '0;
            ones_count <= '0;
            stuff_active <= '0;
            crc16 <= 16'hFFFF;
        end
        else begin
            currentState <= nextState;
            bit_counter <= next_bit_counter;
            ones_count <= next_ones_count;
            stuff_active <= next_stuff_active;
            crc16 <= next_crc16;
        end
    end
    
    typedef enum logic [3:0] {
        PID_OUT = 4'b0001,
        PID_IN = 4'b1001,
        PID_DATA0 = 4'b0011,
        PID_DATA1 = 4'b1011,
        PID_ACK = 4'b0010,
        PID_NAK = 4'b1010,
        PID_STALL = 4'b1110
    } pid_e;

    logic [3:0] pid;
        
    always_comb begin
        case (tx_packet)
        3'b000: pid = PID_STALL;// idle - no packet
        3'b001: pid = PID_DATA0;
        3'b010: pid = PID_DATA1;
        3'b011: pid = PID_ACK;
        3'b100: pid = PID_NAK;
        default: pid = PID_STALL;
        endcase
    end

        always_comb begin
        nextState = currentState;   
        next_bit_counter = bit_counter;
        case(currentState)
            IDLE: begin
                if(tx_packet !== 3'b000) begin
                    nextState = SYNC;
                end
            end
            SYNC: begin
                if (bit_pulse && !stuff_active)
                next_bit_counter = bit_counter + 1;
                if(bit_counter == 7) begin
                    nextState = PID;
                    next_bit_counter = 0;
                end
            end
            PID: begin
    if (bit_pulse && !stuff_active)
        next_bit_counter = bit_counter + 1;
    if(bit_counter == 7) begin
        if(pid == PID_ACK || pid == PID_NAK || pid == PID_STALL)
            nextState = EOP;
        else if(pid == PID_DATA0 || pid == PID_DATA1)
            nextState = DATA;
        else
            nextState = ERROR;
        next_bit_counter = 0;
    end
            end
            DATA: begin
    next_bit_counter = 0;
    // NO occupancy check here at all
    if(bit_pulse && !stuff_active)
        nextState = WAIT_DATA;

            end
            WAIT_DATA: begin
            next_bit_counter = bit_counter;
            if(bit_pulse && !stuff_active)
                next_bit_counter = bit_counter + 1;
            if(bit_counter == 7 && !stuff_active) begin
                next_bit_counter = 0;
                if(buffer_occupancy != 0)
                    nextState = DATA;
                else
                    nextState = CRC;
            end
            end
            ERROR: begin
                next_bit_counter = 0;
                if(bit_pulse && !stuff_active) 
                    nextState = IDLE;
            end
            CRC: begin
                if (bit_pulse && !stuff_active)
                next_bit_counter = bit_counter + 1;
                if(bit_counter == 15) begin // crc bonus tx_packet_data == CONST
                    nextState = EOP;
                    next_bit_counter = 0;
                end
            end
            EOP: begin
                if (bit_pulse && !stuff_active)
                next_bit_counter = bit_counter + 1;
                if(bit_counter == 2) begin
                    nextState = WAIT;
                    next_bit_counter = 0;
                end
            end
            WAIT: begin
                next_bit_counter = 0;
                if(bit_pulse && !stuff_active)
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
                load_en = 0;
            if(currentState == IDLE) begin
                tx_transfer_active = '0;
                shift_en = '0;
                get_tx_packet_data = '0;   
            end
            if(currentState == SYNC) begin
                load_en = (bit_counter == 0);
                tx_transfer_active = 1;
                shift_en = bit_pulse;
                get_tx_packet_data = '0;   
            end
            if(currentState == PID) begin
                load_en = (bit_counter == 0);
                tx_transfer_active = 1;
                shift_en = bit_pulse;
                get_tx_packet_data = '0;   
            end
            if(currentState == DATA) begin
                load_en = (bit_counter == 0);
                tx_transfer_active = 1;
                shift_en = 0;
                get_tx_packet_data = 1;
            end
            if(currentState == ERROR) begin
                tx_transfer_active = 0;
                shift_en = 0;
                get_tx_packet_data = 0;  
                tx_error = 1; 
            end
            if(currentState == WAIT_DATA) begin
                tx_transfer_active = 1;
                shift_en = bit_pulse;
                get_tx_packet_data = 0;
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

    logic [7:0] sr_load_data;

    always_comb begin
        case (currentState)
            SYNC: sr_load_data = 8'b00000001;  
            PID: sr_load_data = {~pid, pid};  // PID + complement
            DATA: sr_load_data = tx_packet_data;
            default: sr_load_data = tx_packet_data;
        endcase
    end


        // flex counter
    logic [1:0] pattern_state;
    logic [3:0] rollover_val;
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
        /* verilator lint_off PINCONNECTEMPTY */
        .count_out(),
        /* verilator lint_on PINCONNECTEMPTY */
        .rollover_flag(bit_pulse)
    );  

    flex_sr #(.SIZE(8)) data_sr (
        .clk(clk),
        .n_rst(n_rst),
        .shift_enable(shift_en),
        .load_enable(load_en),
        .serial_in(1'b0),
        .parallel_in(sr_load_data),
        .serial_out(serial_out),
        /* verilator lint_off PINCONNECTEMPTY */
        .parallel_out()
        /* verilator lint_on PINCONNECTEMPTY */
    );


    always_comb begin
    next_ones_count = ones_count;
    next_stuff_active = stuff_active;

    // Reset outside stuffable states
    if (!(currentState == SYNC || currentState == PID || currentState == WAIT_DATA || currentState == CRC)) begin
        next_ones_count = '0;
        next_stuff_active = 1'b0;
    end else if (bit_pulse) begin
        if (stuff_active) begin
            // Just sent the stuffed 0, resume
            next_stuff_active = 1'b0;
            next_ones_count = '0;
        end else if (serial_out == 1'b1) begin
            if (ones_count == 3'd5) begin
                next_stuff_active = 1'b1;  // next bit_pulse will be stuffed
                next_ones_count = '0;
            end else begin
                next_ones_count = ones_count + 1'b1;
            end
        end else begin
            next_ones_count = '0;
        end
    end
    end
    logic [15:0] crc16_inv;
    assign crc16_inv = ~crc16;
    assign nrzi_bit = (currentState == CRC) ? crc16_inv[bit_counter[3:0]] : serial_out;

    logic fb;
    assign fb = serial_out ^ crc16[15];

    always_comb begin
        next_crc16 = crc16;
        if (currentState == IDLE) begin
            next_crc16 = 16'hFFFF;
        end else if (bit_pulse && !stuff_active && currentState == WAIT_DATA) begin
            next_crc16[0] = fb;
            next_crc16[1] = crc16[0];
            next_crc16[2] = crc16[1]  ^ fb;
            next_crc16[3] = crc16[2];
            next_crc16[4] = crc16[3];
            next_crc16[5] = crc16[4];
            next_crc16[6] = crc16[5];
            next_crc16[7] = crc16[6];
            next_crc16[8] = crc16[7];
            next_crc16[9] = crc16[8];
            next_crc16[10] = crc16[9];
            next_crc16[11] = crc16[10];
            next_crc16[12] = crc16[11];
            next_crc16[13] = crc16[12];
            next_crc16[14] = crc16[13];
            next_crc16[15] = crc16[14] ^ fb;
        end
    end


    // DP/DM + NRZI encoder

    logic dp_orig;
    logic next_dp_orig;

    always_comb begin
        next_dp_orig = dp_orig;

        if (currentState == WAIT)
            next_dp_orig = 1'b1;

        else if ((currentState == SYNC || currentState == PID || currentState == WAIT_DATA || currentState == CRC) && bit_pulse) begin
            if (stuff_active || nrzi_bit == 1'b0)
                next_dp_orig = ~dp_orig;
        end
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst)
            dp_orig <= 1'b1;
        else
            dp_orig <= next_dp_orig;
    end

    always_comb begin
            dp_out = dp_orig;
            dm_out = ~dp_orig;
        if (currentState == EOP) begin
            dp_out = 1'b0;
            dm_out = 1'b0;
        end
    end
    

    // bit stuffing





endmodule

