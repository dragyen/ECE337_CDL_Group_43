`timescale 1ns/10ps

module tb_usb_rx_tx_db_2();

    logic clk, n_rst;

    logic store_tx_data;
    logic [7:0] tx_data;
    logic get_rx_data;
    logic clear;

    logic [7:0] rx_data;
    logic [6:0] buffer_occupancy;

    logic [2:0] tx_packet;

    logic [3:0] rx_packet;
    logic rx_data_ready, rx_transfer_active, rx_error;

    logic tx_transfer_active, tx_error;

    logic dp_in, dm_in, dp_out, dm_out;

    int tx_ones_run;
    int tx_stuff_count;
    logic tx_prev_dp;
    usb_rx_tx_db_2 DUT (.*);

    localparam CLK_PERIOD = 10;
    localparam BIT_PERIOD = 83.33;

    logic cur_line;

    always begin
        clk = 0; #(CLK_PERIOD/2);
        clk = 1; #(CLK_PERIOD/2);
    end

    // error latching
    logic rx_error_seen, tx_error_seen;
    logic rx_data_ready_seen;
    logic [3:0] rx_packet_captured;

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            rx_error_seen <= 0;
            tx_error_seen <= 0;
            rx_data_ready_seen <= 0;
            rx_packet_captured <= 0;
        end
        else begin
            if (rx_error) rx_error_seen <= 1;
            if (tx_error) tx_error_seen <= 1;
            if (rx_data_ready) begin
                rx_data_ready_seen <= 1;
                rx_packet_captured <= rx_packet;
            end
        end
    end

int rx_ones_run;

    task send_bit_stuffed(input logic b);
        send_bit(b);
        if (b == 1) begin
            rx_ones_run++;
            if (rx_ones_run == 6) begin
                // insert stuffed 0 so the RX's bit-stuffing remover has to strip it
                send_bit(0);
                rx_ones_run = 0;
            end
        end
        else begin
            rx_ones_run = 0;
        end
    endtask

    task send_byte_stuffed(input logic [7:0] data);
        for (int i = 0; i < 8; i++) send_bit_stuffed(data[i]);
    endtask

    task send_sync_stuffed();
        rx_ones_run = 0; // reset stuff tracking at start of packet
        send_byte_lsb(8'b10000000); 
    endtask

    task send_pid_stuffed(input logic [3:0] pid_val);
        logic [3:0] check_bits;
        logic [7:0] pid_byte;
        check_bits = ~pid_val;
        pid_byte = {check_bits, pid_val};
        send_byte_stuffed(pid_byte);
    endtask

    task send_data_payload_stuffed(input logic [7:0] data[], input int len, input logic [15:0] crc16);
        for (int i = 0; i < len; i++) send_byte_stuffed(data[i]);
        send_byte_stuffed(crc16[7:0]);
        send_byte_stuffed(crc16[15:8]);
    endtask

    task send_data0_stuffed(input logic [7:0] data[], input int len, input logic [15:0] crc16);
        send_sync_stuffed();
        send_pid_stuffed(4'b0011);
        send_data_payload_stuffed(data, len, crc16);
        send_eop();
    endtask


    task capture_tx_bit_unstuffed(output logic decoded_bit);
        logic raw_bit;
        capture_tx_bit(raw_bit);
        if (tx_ones_run == 6) begin
            assert(raw_bit == 0) else $error("Bit stuffing: expected stuffed 0 after 6 ones, got 1");
            tx_stuff_count++;
            tx_ones_run = 0;
            capture_tx_bit(raw_bit); // real next bit
        end
        if (raw_bit == 1) tx_ones_run++;
        else tx_ones_run = 0;
        decoded_bit = raw_bit;
    endtask

    task capture_tx_byte_unstuffed(output logic [7:0] byte_val);
        logic bit_val;
        byte_val = 0;
        for (int i = 0; i < 8; i++) begin
            capture_tx_bit_unstuffed(bit_val);
            byte_val[i] = bit_val;
        end
    endtask

    task start_tx_capture_unstuffed();
        while (!tx_transfer_active) @(posedge clk);
        tx_prev_dp = 1;
        tx_ones_run = 0;
        tx_stuff_count = 0;
    endtask

    task reset_dut();
        n_rst = 0;
        dp_in = 1; dm_in = 0;
        cur_line = 1;
        store_tx_data = 0;
        tx_data = 0;
        get_rx_data = 0;
        clear = 0;
        tx_packet = 0;
        @(posedge clk); #1;
        n_rst = 1;
        @(posedge clk); #1;
    endtask

    task send_bit(input logic b);
        if (b == 0) cur_line = ~cur_line;
        dp_in = cur_line;
        dm_in = ~cur_line;
        #(BIT_PERIOD);
    endtask

    task send_byte_lsb(input logic [7:0] data);
        for (int i = 0; i < 8; i++) send_bit(data[i]);
    endtask

    task send_sync();
        send_byte_lsb(8'b10000000);
    endtask

    task send_pid(input logic [3:0] pid_val);
        logic [3:0] check_bits;
        logic [7:0] pid_byte;
        check_bits = ~pid_val;
        pid_byte = {check_bits, pid_val};
        send_byte_lsb(pid_byte);
    endtask

    task send_eop();
        dp_in = 0; dm_in = 0;
        #(BIT_PERIOD * 2);
        dp_in = 1; dm_in = 0;
        cur_line = 1;
        #(BIT_PERIOD);
    endtask

    task send_token_fields(input logic [6:0] addr, input logic [3:0] endp, input logic [4:0] crc5);
        for (int i = 0; i < 7; i++) send_bit(addr[i]);
        for (int i = 0; i < 4; i++) send_bit(endp[i]);
        for (int i = 0; i < 5; i++) send_bit(crc5[i]);
    endtask

    task send_data_payload(input logic [7:0] data[], input int len, input logic [15:0] crc16);
        for (int i = 0; i < len; i++) send_byte_lsb(data[i]);
        send_byte_lsb(crc16[7:0]);
        send_byte_lsb(crc16[15:8]);
    endtask

    task send_out_token(input logic [6:0] addr, input logic [3:0] endp, input logic [4:0] crc5);
        send_sync();
        send_pid(4'b0001);
        send_token_fields(addr, endp, crc5);
        send_eop();
    endtask

    task send_in_token(input logic [6:0] addr, input logic [3:0] endp, input logic [4:0] crc5);
        send_sync();
        send_pid(4'b1001);
        send_token_fields(addr, endp, crc5);
        send_eop();
    endtask

    task send_data0(input logic [7:0] data[], input int len, input logic [15:0] crc16);
        send_sync();
        send_pid(4'b0011);
        send_data_payload(data, len, crc16);
        send_eop();
    endtask

    task send_data1(input logic [7:0] data[], input int len, input logic [15:0] crc16);
        send_sync();
        send_pid(4'b1011);
        send_data_payload(data, len, crc16);
        send_eop();
    endtask

    task send_ack();
        send_sync();
        send_pid(4'b0010);
        send_eop();
    endtask

    task push_tx_byte(input logic [7:0] data);
        @(posedge clk); #1;
        tx_data = data;
        store_tx_data = 1;
        @(posedge clk); #1;
        store_tx_data = 0;
    endtask

    task pop_rx_byte(output logic [7:0] data);
        @(posedge clk); #1;
        data = rx_data;
        get_rx_data = 1;
        @(posedge clk); #1;
        get_rx_data = 0;
    endtask

    task clear_buffer();
        @(posedge clk); #1;
        clear = 1;
        @(posedge clk); #1;
        clear = 0;
    endtask

    task fill_tx_buffer(input logic [7:0] data[], input int len);
        for (int i = 0; i < len; i++) push_tx_byte(data[i]);
    endtask

    task trigger_tx(input logic [2:0] pkt_type);
        int t;
        @(posedge clk); #1;
        tx_packet = pkt_type;

        // wait for TX to start
        t = 0;
        while (!tx_transfer_active && t < 1000) begin
            @(posedge clk);
            t++;
        end
        if (t >= 1000) $error("trigger_tx: TX never started (tx_transfer_active stayed low)");

        // hold tx_packet throughout the entire transmission
        while (tx_transfer_active) @(posedge clk);

        // safe to clear only after TX finishes
        tx_packet = 0;
    endtask

    task wait_for_tx_done(input int timeout_cycles);
        int t;
        t = 0;
        while (tx_transfer_active && t < timeout_cycles) begin
            @(posedge clk);
            t = t + 1;
        end
        if (t >= timeout_cycles) $error("Timeout waiting for TX to finish");
    endtask

    task wait_for_rx_done(input int timeout_cycles);
        int t;
        t = 0;
        while (!rx_data_ready && !rx_error && t < timeout_cycles) begin
            @(posedge clk);
            t = t + 1;
        end
        if (t >= timeout_cycles) $error("Timeout waiting for RX to finish");
    endtask

    task clear_rx_flags();
        force rx_error_seen = 0;
        force rx_data_ready_seen = 0;
        force rx_packet_captured = 0;
        @(posedge clk); #1;
        release rx_error_seen;
        release rx_data_ready_seen;
        release rx_packet_captured;
    endtask
    

    task capture_tx_bit(output logic decoded_bit);
        #(BIT_PERIOD);
        // NRZI: no transition = 1, transition = 0
        decoded_bit = (dp_out == tx_prev_dp) ? 1'b1 : 1'b0;
        tx_prev_dp = dp_out;
    endtask

    task capture_tx_byte(output logic [7:0] byte_val);
        logic bit_val;
        byte_val = 0;
        for (int i = 0; i < 8; i++) begin
            capture_tx_bit(bit_val);
            byte_val[i] = bit_val;
        end
    endtask

    task start_tx_capture();
        while (!tx_transfer_active) @(posedge clk);
        tx_prev_dp = 1;
    endtask

    // Captures a full TX packet header (sync + PID) and returns the PID
    task capture_tx_pid(output logic [3:0] pid);
        logic bit_val;
        logic [7:0] sync_byte, pid_byte;

        // wait for TX to start driving
        while (!tx_transfer_active) @(posedge clk);
        tx_prev_dp = 1; // assume idle J state before first bit

        // skip sync byte (8 bits)
        for (int i = 0; i < 8; i++) capture_tx_bit(bit_val);

        // capture PID byte (LSB first)
        capture_tx_byte(pid_byte);
        pid = pid_byte[3:0];
    endtask

    task wait_tx_eop();
        int t;
        t = 0;
        while (!(dp_out == 0 && dm_out == 0) && t < 10000) begin
            @(posedge clk);
            t++;
        end
        if (t >= 10000) begin
            $error("wait_tx_eop: SE0 never seen");
            return;
        end
        t = 0;
        while (tx_transfer_active && t < 10000) begin
            @(posedge clk);
            t++;
        end
        if (t >= 10000) $error("wait_tx_eop: tx_transfer_active stuck high");
    endtask

    int tb_test_num;
    logic [7:0] test_data[];

    initial begin
        tb_test_num = 0;
        n_rst = 1;
        dp_in = 1; dm_in = 0;
        cur_line = 1;
        store_tx_data = 0;
        tx_data = 0;
        get_rx_data = 0;
        clear = 0;
        tx_packet = 0;

        // Test 0: reset state
        tb_test_num = 0;
        reset_dut();
        assert(buffer_occupancy == 0) else $error("Test %0d failed: occupancy should be 0 after reset", tb_test_num);
        assert(rx_transfer_active == 0) else $error("Test %0d failed: rx_transfer_active nonzero after reset", tb_test_num);
        assert(tx_transfer_active == 0) else $error("Test %0d failed: tx_transfer_active nonzero after reset", tb_test_num);

        // Test 1: Full host-to-endpoint transfer with loopback-verified ACK
        tb_test_num = 1;
        reset_dut();
        begin
            logic [7:0] popped_byte;
            logic [7:0] expected_payload[];

            expected_payload = new[64];
            for (int i = 0; i < 64; i++) begin
                case (i % 8)
                    0: expected_payload[i] = 8'h55;
                    1: expected_payload[i] = 8'hAA;
                    2: expected_payload[i] = 8'h33;
                    3: expected_payload[i] = 8'hCC;
                    4: expected_payload[i] = 8'h5A;
                    5: expected_payload[i] = 8'hA5;
                    6: expected_payload[i] = 8'h3C;
                    7: expected_payload[i] = 8'hC3;
                endcase
            end

            // Step 1: host sends OUT token
            send_out_token(7'h00, 4'h0, 5'h02);
            repeat(10) @(posedge clk);
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: no rx_data_ready for OUT token", tb_test_num);
            assert(rx_packet_captured == 4'b0001) else $error("Test %0d failed: expected OUT PID (0x1), got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error during OUT", tb_test_num);
            clear_rx_flags();

            // Step 2: host sends DATA0 with 64-byte payload
            send_data0(expected_payload, 64, 16'hA54E);
            repeat(20) @(posedge clk);
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: no rx_data_ready for DATA0", tb_test_num);
            assert(rx_packet_captured == 4'b0011) else $error("Test %0d failed: expected DATA0 PID (0x3), got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error during DATA0", tb_test_num);
            assert(buffer_occupancy == 7'd64) else $error("Test %0d failed: occupancy expected 64, got %0d", tb_test_num, buffer_occupancy);
            clear_rx_flags();

            // Step 3: SoC triggers endpoint to send ACK, loopback so RX confirms it
            force dp_in = dp_out;
            force dm_in = dm_out;

            trigger_tx(3'd3); // ACK

            repeat(50) @(posedge clk);

            release dp_in;
            release dm_in;
            dp_in = 1; dm_in = 0;
            cur_line = 1;

            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: RX never decoded the TX ACK", tb_test_num);
            assert(rx_packet_captured == 4'b0010) else $error("Test %0d failed: expected ACK PID (0x2) via loopback, got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error during loopback ACK", tb_test_num);
            assert(tx_error_seen == 0) else $error("Test %0d failed: tx_error during ACK", tb_test_num);

            // Step 4: SoC pops all 64 data bytes from buffer
            for (int i = 0; i < 64; i++) begin
                pop_rx_byte(popped_byte);
                assert(popped_byte == expected_payload[i]) else $error("Test %0d failed: byte %0d expected 0x%h, got 0x%h", tb_test_num, i, expected_payload[i], popped_byte);
            end

            assert(buffer_occupancy == 7'd0) else $error("Test %0d failed: buffer should be empty after pops, got %0d", tb_test_num, buffer_occupancy);
        end

        // Test 2: Full endpoint-to-host transfer
        tb_test_num = 2;
        reset_dut();
        begin
            logic [7:0] captured_byte;
            logic [15:0] captured_crc;
            logic [7:0] expected_payload[];

            expected_payload = new[64];
            for (int i = 0; i < 64; i++) begin
                case (i % 8)
                    0: expected_payload[i] = 8'h55;
                    1: expected_payload[i] = 8'hAA;
                    2: expected_payload[i] = 8'h33;
                    3: expected_payload[i] = 8'hCC;
                    4: expected_payload[i] = 8'h5A;
                    5: expected_payload[i] = 8'hA5;
                    6: expected_payload[i] = 8'h3C;
                    7: expected_payload[i] = 8'hC3;
                endcase
            end

            // Step 1: SoC preloads buffer with data to transmit
            fill_tx_buffer(expected_payload, 64);
            assert(buffer_occupancy == 7'd64) else $error("Test %0d failed: occupancy after fill expected 64, got %0d", tb_test_num, buffer_occupancy);

            // Step 2: host sends IN token
            send_in_token(7'h00, 4'h0, 5'h02);
            repeat(10) @(posedge clk);
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: no rx_data_ready for IN token", tb_test_num);
            assert(rx_packet_captured == 4'b1001) else $error("Test %0d failed: expected IN PID (0x9), got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error during IN", tb_test_num);
            clear_rx_flags();

            // Step 3: endpoint sends DATA0 with the buffered payload
            fork
                trigger_tx(3'd1); 
                begin
                    start_tx_capture();

                    capture_tx_byte(captured_byte); //sync
                    capture_tx_byte(captured_byte); // PID
                    assert(captured_byte[3:0] == 4'b0011) else $error("Test %0d failed: expected DATA0 PID (0x3), got 0x%h", tb_test_num, captured_byte[3:0]);

                    for (int i = 0; i < 64; i++) begin
                        capture_tx_byte(captured_byte);
                        assert(captured_byte == expected_payload[i]) else $error("Test %0d failed: TX byte %0d expected 0x%h, got 0x%h", tb_test_num, i, expected_payload[i], captured_byte);
                    end

                    capture_tx_byte(captured_crc[7:0]);
                    capture_tx_byte(captured_crc[15:8]);
                    assert(captured_crc == 16'hA54E) else $error("Test %0d failed: TX CRC expected 0xA54E, got 0x%h", tb_test_num, captured_crc);
                end
            join

            assert(tx_error_seen == 0) else $error("Test %0d failed: tx_error during DATA0 TX", tb_test_num);
            assert(buffer_occupancy == 7'd0) else $error("Test %0d failed: buffer should be drained after TX, got %0d", tb_test_num, buffer_occupancy);

            // Step 4: host sends ACK to confirm receipt
            send_ack();
            repeat(10) @(posedge clk);
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: no rx_data_ready for host ACK", tb_test_num);
            assert(rx_packet_captured == 4'b0010) else $error("Test %0d failed: expected ACK PID (0x2), got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error during host ACK", tb_test_num);
        end
        
        // Bit stuffing verification on TX
        tb_test_num = 3;
        reset_dut();
        begin
            logic [7:0] captured_byte;
            logic [15:0] captured_crc;
            logic [7:0] payload[];

            payload = new[4];
            payload[0] = 8'hFF;
            payload[1] = 8'hFF;
            payload[2] = 8'h00;
            payload[3] = 8'hAA;
            fill_tx_buffer(payload, 4);
            assert(buffer_occupancy == 7'd4) else $error("Test %0d failed: occupancy expected 4, got %0d", tb_test_num, buffer_occupancy);

            fork
                trigger_tx(3'd1); // DATA0
                begin
                    start_tx_capture_unstuffed();

                    capture_tx_byte_unstuffed(captured_byte); // sync
                    capture_tx_byte_unstuffed(captured_byte); // PID
                    assert(captured_byte[3:0] == 4'b0011) else $error("Test %0d failed: expected DATA0 PID, got 0x%h", tb_test_num, captured_byte[3:0]);

                    capture_tx_byte_unstuffed(captured_byte);
                    assert(captured_byte == 8'hFF) else $error("Test %0d failed: byte 0 expected 0xFF, got 0x%h", tb_test_num, captured_byte);
                    capture_tx_byte_unstuffed(captured_byte);
                    assert(captured_byte == 8'hFF) else $error("Test %0d failed: byte 1 expected 0xFF, got 0x%h", tb_test_num, captured_byte);
                    capture_tx_byte_unstuffed(captured_byte);
                    assert(captured_byte == 8'h00) else $error("Test %0d failed: byte 2 expected 0x00, got 0x%h", tb_test_num, captured_byte);
                    capture_tx_byte_unstuffed(captured_byte);
                    assert(captured_byte == 8'hAA) else $error("Test %0d failed: byte 3 expected 0xAA, got 0x%h", tb_test_num, captured_byte);

                    capture_tx_byte_unstuffed(captured_crc[7:0]);
                    capture_tx_byte_unstuffed(captured_crc[15:8]);
                    assert(captured_crc == 16'h807F) else $error("Test %0d failed: CRC expected 0x807F, got 0x%h", tb_test_num, captured_crc);
                end
            join
            assert(tx_stuff_count >= 2) else $error("Test %0d failed: expected bit stuffing but only %0d stuffs detected - is bit stuffing enabled?", tb_test_num, tx_stuff_count);
            $display("Test %0d: detected %0d bit-stuffing events", tb_test_num, tx_stuff_count);

            assert(tx_error_seen == 0) else $error("Test %0d failed: tx_error during bit-stuffed transmission", tb_test_num);
            assert(buffer_occupancy == 7'd0) else $error("Test %0d failed: buffer should be drained", tb_test_num);
        end

        // Test: Bit stuffing verification on RX
        tb_test_num = 4;
        reset_dut();
        begin
            logic [7:0] popped_byte;
            logic [7:0] payload[];

            payload = new[4];
            payload[0] = 8'hFF;
            payload[1] = 8'hFF;
            payload[2] = 8'hFF;
            payload[3] = 8'hFF;

            send_data0_stuffed(payload, 4, 16'h4FFE);
            repeat(20) @(posedge clk);

            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: rx_data_ready never pulsed", tb_test_num);
            assert(rx_packet_captured == 4'b0011) else $error("Test %0d failed: expected DATA0 PID, got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error - bit stuffing may not be working", tb_test_num);
            assert(buffer_occupancy == 7'd4) else $error("Test %0d failed: occupancy expected 4, got %0d", tb_test_num, buffer_occupancy);

            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hFF) else $error("Test %0d failed: byte 0 expected 0xFF, got 0x%h", tb_test_num, popped_byte);
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hFF) else $error("Test %0d failed: byte 1 expected 0xFF, got 0x%h", tb_test_num, popped_byte);
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hFF) else $error("Test %0d failed: byte 2 expected 0xFF, got 0x%h", tb_test_num, popped_byte);
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hFF) else $error("Test %0d failed: byte 3 expected 0xFF, got 0x%h", tb_test_num, popped_byte);

            assert(buffer_occupancy == 7'd0) else $error("Test %0d failed: buffer should be empty", tb_test_num);
        end

        tb_test_num = 5;
        reset_dut();
        begin
            logic [7:0] payload[];

            payload = new[65];
            for (int i = 0; i < 65; i++) payload[i] = i[7:0];

            // out token
            send_out_token(7'h00, 4'h0, 5'h02);
            repeat(10) @(posedge clk);
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: no rx_data_ready for OUT", tb_test_num);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error during OUT token", tb_test_num);
            clear_rx_flags();

            // oversized DATA0 packet
            send_data0(payload, 65, 16'h9537);
            repeat(20) @(posedge clk);

            assert(rx_error_seen == 1) else $error("Test %0d failed: expected rx_error on oversized packet but it never asserted", tb_test_num);
            assert(buffer_occupancy == 7'd0) else $error("Test %0d failed: buffer should be flushed after error, got %0d", tb_test_num, buffer_occupancy);
        end

        // Test 6: Error handling for invalid sync byte
        tb_test_num = 6;
        reset_dut();
        begin
            send_bit(0);
            for (int i = 0; i < 7; i++) send_bit(1'b1); // garbage sync content
            send_eop();
            repeat(20) @(posedge clk);

            assert(rx_error_seen == 1) else $error("Test %0d failed: expected rx_error on bad sync but it never asserted", tb_test_num);
            assert(rx_data_ready_seen == 0) else $error("Test %0d failed: rx_data_ready should not fire on bad sync", tb_test_num);
            assert(buffer_occupancy == 7'd0) else $error("Test %0d failed: buffer should remain empty", tb_test_num);

            // After error handling, RX should be back to idle and able to recover
            clear_rx_flags();
            repeat(10) @(posedge clk);

            // Send a valid OUT token to confirm recovery
            send_out_token(7'h00, 4'h0, 5'h02);
            repeat(10) @(posedge clk);
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: RX did not recover from error state", tb_test_num);
            assert(rx_packet_captured == 4'b0001) else $error("Test %0d failed: after recovery expected OUT PID, got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error on recovery packet", tb_test_num);
        end

        $finish;
    end

endmodule
