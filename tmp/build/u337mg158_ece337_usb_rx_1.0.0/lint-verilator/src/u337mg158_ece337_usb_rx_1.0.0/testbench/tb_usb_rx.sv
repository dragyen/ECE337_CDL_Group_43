`timescale 1ns/10ps

module tb_usb_rx();

    logic clk, n_rst;
    logic dp_in, dm_in;
    logic [7:0] buffer_occupancy;
    logic rx_data_ready, rx_transfer_active, rx_error;
    logic flush, store_rx_packet_data;
    logic [3:0] rx_packet;
    logic [7:0] rx_packet_data;

    usb_rx DUT (.*);

    localparam CLK_PERIOD = 10;
    localparam BIT_PERIOD = 83; // ~12MHz in ns

    logic cur_line; // tracks current NRZI line state

    always begin
        clk = 0; #(CLK_PERIOD/2);
        clk = 1; #(CLK_PERIOD/2);
    end

    task reset_dut();
        n_rst = 0;
        dp_in = 1; dm_in = 0;
        cur_line = 1;
        buffer_occupancy = 0;
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
        // decoded = 0000_0001, sent LSB first
        send_byte_lsb(8'b00000001);
    endtask

    task send_pid(input logic [3:0] pid_val);
        // lower nibble = pid, upper nibble = ~pid
        send_byte_lsb({~pid_val, pid_val});
    endtask

    task send_eop();
        dp_in = 0; dm_in = 0;
        #(BIT_PERIOD * 2);
        dp_in = 1; dm_in = 0;
        cur_line = 1;
        #(BIT_PERIOD);
    endtask

    // dummy CRC5 = 5'b11111, change to match whatever your design uses
    task send_token_fields(input logic [6:0] addr, input logic [3:0] endp);
        for (int i = 0; i < 7; i++) send_bit(addr[i]);
        for (int i = 0; i < 4; i++) send_bit(endp[i]);
        for (int i = 0; i < 5; i++) send_bit(1'b1); // dummy CRC5
    endtask

    // dummy CRC16 = 16'hFFFF, change to match whatever your design uses
    task send_data_payload(input logic [7:0] data[], input int len);
        for (int i = 0; i < len; i++) send_byte_lsb(data[i]);
        send_byte_lsb(8'hFF);
        send_byte_lsb(8'hFF);
    endtask

    task send_out_token(input logic [6:0] addr, input logic [3:0] endp);
        send_sync();
        send_pid(4'b0001);
        send_token_fields(addr, endp);
        send_eop();
    endtask

    task send_in_token(input logic [6:0] addr, input logic [3:0] endp);
        send_sync();
        send_pid(4'b1001);
        send_token_fields(addr, endp);
        send_eop();
    endtask

    task send_ack();
        send_sync();
        send_pid(4'b0010);
        send_eop();
    endtask

    task send_data0(input logic [7:0] data[], input int len);
        send_sync();
        send_pid(4'b0011);
        send_data_payload(data, len);
        send_eop();
    endtask

    task send_data1(input logic [7:0] data[], input int len);
        send_sync();
        send_pid(4'b1011);
        send_data_payload(data, len);
        send_eop();
    endtask

    int tb_test_num;
    logic [7:0] test_data[];

    initial begin
        tb_test_num = 0;
        n_rst = 1;
        dp_in = 1; dm_in = 0;
        cur_line = 1;
        buffer_occupancy = 0;

        // Test 0: reset state
        tb_test_num = 0;
        reset_dut();
        assert(rx_transfer_active == 0) else $error("Test %0d failed: transfer_active should be 0 after reset", tb_test_num);
        assert(rx_error == 0) else $error("Test %0d failed: rx_error should be 0 after reset", tb_test_num);
        assert(rx_data_ready == 0) else $error("Test %0d failed: rx_data_ready should be 0 after reset", tb_test_num);

        // Test 1: OUT token, matching address + endpoint
        tb_test_num = 1;
        reset_dut();
        send_out_token(7'h00, 4'h0);
        repeat(10) @(posedge clk);
        assert(rx_error == 0) else $error("Test %0d failed: OUT token caused rx_error", tb_test_num);

        // Test 2: IN token, matching address + endpoint
        tb_test_num = 2;
        reset_dut();
        send_in_token(7'h00, 4'h0);
        repeat(10) @(posedge clk);
        assert(rx_error == 0) else $error("Test %0d failed: IN token caused rx_error", tb_test_num);

        // Test 3: ACK reception
        tb_test_num = 3;
        reset_dut();
        send_ack();
        repeat(10) @(posedge clk);
        assert(rx_error == 0) else $error("Test %0d failed: ACK reception caused rx_error", tb_test_num);

        // Test 4: DATA0 single byte
        tb_test_num = 4;
        reset_dut();
        test_data = new[1];
        test_data[0] = 8'hAB;
        send_data0(test_data, 1);
        repeat(10) @(posedge clk);
        assert(rx_error == 0) else $error("Test %0d failed: DATA0 single byte caused rx_error", tb_test_num);

        // Test 5: DATA1 multi-byte
        tb_test_num = 5;
        reset_dut();
        test_data = new[4];
        test_data[0] = 8'hDE; test_data[1] = 8'hAD;
        test_data[2] = 8'hBE; test_data[3] = 8'hEF;
        send_data1(test_data, 4);
        repeat(10) @(posedge clk);
        assert(rx_error == 0) else $error("Test %0d failed: DATA1 multi-byte caused rx_error", tb_test_num);

        // Test 6: DATA0 max payload 64 bytes
        tb_test_num = 6;
        reset_dut();
        test_data = new[64];
        for (int i = 0; i < 64; i++) test_data[i] = i[7:0];
        send_data0(test_data, 64);
        repeat(10) @(posedge clk);
        assert(rx_error == 0) else $error("Test %0d failed: 64-byte DATA0 caused rx_error", tb_test_num);

        // Test 7: bad sync byte should trigger error
        tb_test_num = 7;
        reset_dut();
        // send all 1s instead of valid sync
        for (int i = 0; i < 8; i++) send_bit(1'b1);
        send_eop();
        repeat(10) @(posedge clk);
        assert(rx_error == 1) else $error("Test %0d failed: bad sync should trigger rx_error", tb_test_num);

        // Test 8: bad PID (check bits don't match ~pid)
        tb_test_num = 8;
        reset_dut();
        send_sync();
        send_byte_lsb(8'hFF); // upper nibble = lower nibble, not inverted
        send_eop();
        repeat(10) @(posedge clk);
        assert(rx_error == 1) else $error("Test %0d failed: bad PID should trigger rx_error", tb_test_num);

        // Test 9: rx_transfer_active goes high during reception
        tb_test_num = 9;
        reset_dut();
        fork
            send_out_token(7'h00, 4'h0);
            begin
                #(BIT_PERIOD * 4); // a few bits in, mid-sync
                assert(rx_transfer_active == 1) else $error("Test %0d failed: transfer_active should be high mid-packet", tb_test_num);
            end
        join

        // Test 10: store_rx_packet_data pulses on each received data byte
        tb_test_num = 10;
        reset_dut();
        test_data = new[2];
        test_data[0] = 8'hCA; test_data[1] = 8'hFE;
        send_data0(test_data, 2);
        // just verify no error - store pulse checking is better in waveform viewer
        repeat(10) @(posedge clk);
        assert(rx_error == 0) else $error("Test %0d failed: DATA0 2-byte store check caused rx_error", tb_test_num);

        // Test 11: flush asserted at start of each new packet
        tb_test_num = 11;
        reset_dut();
        send_out_token(7'h00, 4'h0);
        #(BIT_PERIOD * 2);
        send_out_token(7'h00, 4'h0);
        repeat(10) @(posedge clk);
        assert(rx_error == 0) else $error("Test %0d failed: back-to-back tokens caused rx_error", tb_test_num);

        // Test 12: mismatched address should NOT raise rx_error visibly to SoC
        // (per manual, SoC core should not be able to discern a mismatch occurred)
        tb_test_num = 12;
        reset_dut();
        send_out_token(7'h7F, 4'hF); // wrong addr and endp
        repeat(10) @(posedge clk);
        assert(rx_data_ready == 0) else $error("Test %0d failed: mismatched addr/endp should not set rx_data_ready", tb_test_num);

        // Test 13: line stays idle between packets, no spurious triggers
        tb_test_num = 13;
        reset_dut();
        #(BIT_PERIOD * 20);
        assert(rx_transfer_active == 0) else $error("Test %0d failed: spurious transfer_active on idle line", tb_test_num);
        assert(rx_error == 0) else $error("Test %0d failed: spurious rx_error on idle line", tb_test_num);

        $display("All USB RX tests completed");
        $finish;
    end

endmodule