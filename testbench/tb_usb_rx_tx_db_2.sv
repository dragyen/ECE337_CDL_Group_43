`timescale 1ns/10ps

module tb_usb_rx_tx_db_2();

    logic clk, n_rst;

    // AHB -> Data Buffer
    logic store_tx_data;
    logic [7:0] tx_data;
    logic get_rx_data;
    logic clear;

    // Data Buffer -> AHB
    logic [7:0] rx_data;
    logic [6:0] buffer_occupancy;

    // AHB -> USB TX
    logic [2:0] tx_packet;

    // USB RX -> AHB
    logic [3:0] rx_packet;
    logic rx_data_ready, rx_transfer_active, rx_error;

    // USB TX -> AHB
    logic tx_transfer_active, tx_error;

    // USB physical interface
    logic dp_in, dm_in, dp_out, dm_out;

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

        // hold tx_packet throughout the entire transmission (AHB register behavior)
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

    //tx
    // Captures one bit from dp_out/dm_out (synchronized to the TX's bit rate)
    // Returns the NRZI-decoded bit
    logic tx_prev_dp;

    task capture_tx_bit(output logic decoded_bit);
        #(BIT_PERIOD);
        // NRZI: no transition = 1, transition = 0
        decoded_bit = (dp_out == tx_prev_dp) ? 1'b1 : 1'b0;
        tx_prev_dp = dp_out;
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
        pid_byte = 0;
        for (int i = 0; i < 8; i++) begin
            capture_tx_bit(bit_val);
            pid_byte[i] = bit_val;
        end
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

        // Test 1: Host-to-endpoint transfer
        // Host sends OUT token, then DATA0 with payload.
        // Verify RX correctly receives both and stores payload in buffer.
        tb_test_num = 1;
        reset_dut();
        begin
            logic [7:0] popped_byte;

            // Step 1: OUT token
            send_out_token(7'h00, 4'h0, 5'h02);
            repeat(10) @(posedge clk);
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: rx_data_ready never pulsed for OUT token", tb_test_num);
            assert(rx_packet_captured == 4'b0001) else $error("Test %0d failed: expected OUT PID (0x1), got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error asserted during OUT token", tb_test_num);
            clear_rx_flags();

            // Step 2: DATA0 with 4-byte payload
            test_data = new[4];
            test_data[0] = 8'hDE;
            test_data[1] = 8'hAD;
            test_data[2] = 8'hBE;
            test_data[3] = 8'hEF;
            send_data0(test_data, 4, 16'h3E64);
            repeat(10) @(posedge clk);
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: rx_data_ready never pulsed for DATA0", tb_test_num);
            assert(rx_packet_captured == 4'b0011) else $error("Test %0d failed: expected DATA0 PID (0x3), got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error asserted during DATA0 packet", tb_test_num);

            // Step 3: buffer occupancy should equal payload length
            assert(buffer_occupancy == 7'd4) else $error("Test %0d failed: buffer_occupancy expected 4, got %0d", tb_test_num, buffer_occupancy);

            // Step 4: pop bytes and verify order and content
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hDE) else $error("Test %0d failed: byte 0 expected 0xDE, got 0x%h", tb_test_num, popped_byte);
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hAD) else $error("Test %0d failed: byte 1 expected 0xAD, got 0x%h", tb_test_num, popped_byte);
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hBE) else $error("Test %0d failed: byte 2 expected 0xBE, got 0x%h", tb_test_num, popped_byte);
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hEF) else $error("Test %0d failed: byte 3 expected 0xEF, got 0x%h", tb_test_num, popped_byte);

            // Step 5: buffer should be empty
            assert(buffer_occupancy == 7'd0) else $error("Test %0d failed: buffer should be empty after pops, got %0d", tb_test_num, buffer_occupancy);

            // Step 6: rx_transfer_active low
            assert(rx_transfer_active == 0) else $error("Test %0d failed: rx_transfer_active stuck high after packet", tb_test_num);
        end

        // Test 2: Full host-to-endpoint transfer with ACK response
        // Flow: OUT token -> DATA0 -> endpoint sends ACK -> SoC pops data
        tb_test_num = 2;
        reset_dut();
        begin
            logic [7:0] popped_byte;
            logic [3:0] tx_pid_captured;

            // Step 1: OUT token
            send_out_token(7'h00, 4'h0, 5'h02);
            repeat(10) @(posedge clk);
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: no rx_data_ready for OUT", tb_test_num);
            assert(rx_packet_captured == 4'b0001) else $error("Test %0d failed: expected OUT PID, got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error during OUT", tb_test_num);
            clear_rx_flags();

            // Step 2: DATA0 with 4-byte payload
            test_data = new[4];
            test_data[0] = 8'hDE;
            test_data[1] = 8'hAD;
            test_data[2] = 8'hBE;
            test_data[3] = 8'hEF;
            send_data0(test_data, 4, 16'h3E64);
            repeat(10) @(posedge clk);
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: no rx_data_ready for DATA0", tb_test_num);
            assert(rx_packet_captured == 4'b0011) else $error("Test %0d failed: expected DATA0 PID, got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error during DATA0", tb_test_num);
            assert(buffer_occupancy == 7'd4) else $error("Test %0d failed: occupancy expected 4, got %0d", tb_test_num, buffer_occupancy);
            clear_rx_flags();

            // Step 3: SoC triggers endpoint to send ACK
            fork
                trigger_tx(3'd3);
                capture_tx_pid(tx_pid_captured);
            join

            assert(tx_pid_captured == 4'b0010) else $error("Test %0d failed: expected ACK PID (0x2), got 0x%h", tb_test_num, tx_pid_captured);
            assert(tx_error_seen == 0) else $error("Test %0d failed: tx_error during ACK", tb_test_num);

            // Step 4: SoC pops data and verifies
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hDE) else $error("Test %0d failed: byte 0 expected 0xDE, got 0x%h", tb_test_num, popped_byte);
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hAD) else $error("Test %0d failed: byte 1 expected 0xAD, got 0x%h", tb_test_num, popped_byte);
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hBE) else $error("Test %0d failed: byte 2 expected 0xBE, got 0x%h", tb_test_num, popped_byte);
            pop_rx_byte(popped_byte);
            assert(popped_byte == 8'hEF) else $error("Test %0d failed: byte 3 expected 0xEF, got 0x%h", tb_test_num, popped_byte);

            assert(buffer_occupancy == 7'd0) else $error("Test %0d failed: buffer should be empty after pops", tb_test_num);
        end

        // Test 3 (or replace test 2's TX check): verify TX by looping back into RX
        // Trigger TX to send an ACK, loop dp_out/dm_out into dp_in/dm_in
        tb_test_num = 3;
        reset_dut();
        begin
            force dp_in = dp_out;
            force dm_in = dm_out;

            // trigger ACK
            trigger_tx(3'd3);
            repeat(100) @(posedge clk);


            release dp_in;
            release dm_in;
            dp_in = 1; dm_in = 0;

            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: RX never saw TX's ACK", tb_test_num);
            assert(rx_packet_captured == 4'b0010) else $error("Test %0d failed: RX decoded PID 0x%h, expected 0x2 (ACK)", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error during loopback", tb_test_num);
        end

        // Test 4: TX sends 64-byte DATA0, loopback verified by RX
        // Flow: fill buffer -> trigger TX DATA0 -> loopback dp_out/dm_out to RX -> verify
        tb_test_num = 4;
        reset_dut();
        begin
            logic [7:0] popped_byte;

            // Step 1: fill buffer with 64 incrementing bytes
            test_data = new[64];
            for (int i = 0; i < 64; i++) test_data[i] = i[7:0];
            fill_tx_buffer(test_data, 64);
            assert(buffer_occupancy == 7'd64) else $error("Test %0d failed: occupancy after fill expected 64, got %0d", tb_test_num, buffer_occupancy);

            // Step 2: set up loopback from TX to RX
            force dp_in = dp_out;
            force dm_in = dm_out;

            // Step 3: trigger TX DATA0, run capture in parallel
            fork
                trigger_tx(3'd1); // 1 = DATA0
                begin
                    // RX should catch the packet from the loopback
                    // just wait until rx finishes or times out
                    int t;
                    t = 0;
                    while (!rx_data_ready_seen && !rx_error_seen && t < 200000) begin
                        @(posedge clk);
                        t++;
                    end
                    if (t >= 200000) $error("Test %0d failed: RX never finished during loopback", tb_test_num);
                end
            join

            // settle before releasing loopback
            repeat(20) @(posedge clk);
            release dp_in;
            release dm_in;
            dp_in = 1; dm_in = 0;
            cur_line = 1;

            // Step 4: verify RX decoded the TX output correctly
            assert(rx_data_ready_seen == 1) else $error("Test %0d failed: rx_data_ready never pulsed", tb_test_num);
            assert(rx_packet_captured == 4'b0011) else $error("Test %0d failed: expected DATA0 PID (0x3), got 0x%h", tb_test_num, rx_packet_captured);
            assert(rx_error_seen == 0) else $error("Test %0d failed: rx_error during loopback", tb_test_num);
            assert(tx_error_seen == 0) else $error("Test %0d failed: tx_error during DATA0 transmission", tb_test_num);

            // Step 5: verify buffer contents
            // After TX drains 64 bytes and RX re-pushes 64 bytes, occupancy should be 64 again
            assert(buffer_occupancy == 7'd64) else $error("Test %0d failed: occupancy after loopback expected 64, got %0d", tb_test_num, buffer_occupancy);

            // Step 6: pop the re-received bytes and verify content order matches
            for (int i = 0; i < 64; i++) begin
                pop_rx_byte(popped_byte);
                assert(popped_byte == i[7:0]) else $error("Test %0d failed: byte %0d expected 0x%h, got 0x%h", tb_test_num, i, i[7:0], popped_byte);
            end

            assert(buffer_occupancy == 7'd0) else $error("Test %0d failed: buffer should be empty after all pops", tb_test_num);
        end

        $display("All tests completed");
        $finish;
    end

endmodule
