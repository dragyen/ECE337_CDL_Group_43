`timescale 1ns/10ps

module tb_crc_checker_16bit();

    logic clk, n_rst, serial_in, crc16_en, valid_bit, crc16_valid;

    crc_checker_16bit DUT (
        .clk(clk),
        .n_rst(n_rst),
        .serial_in(serial_in),
        .crc16_en(crc16_en),
        .valid_bit(valid_bit),
        .crc16_valid(crc16_valid)
    );

    localparam CLK_PERIOD = 10;

    always begin
        clk = 0;
        #(CLK_PERIOD / 2);
        clk = 1;
        #(CLK_PERIOD / 2);
    end

    task send_bit(input logic bit_in);
        serial_in = bit_in;
        valid_bit = 1;
        crc16_en = 1;
        @(posedge clk);
        #1;
    endtask

    // MSB first - the non-reflected LFSR expects data in this order
    task send_byte(input logic [7:0] data);
        int i;
        for (i = 7; i >= 0; i--) begin
            send_bit(data[i]);
        end
    endtask

    task reset_dut();
        n_rst = 0;
        serial_in = 0;
        crc16_en = 0;
        valid_bit = 0;
        @(posedge clk);
        #1;
        n_rst = 1;
        @(posedge clk);
        #1;
    endtask

    integer tb_test_num;

    initial begin
        tb_test_num = 0;
        n_rst = 1;
        serial_in = 0;
        crc16_en = 0;
        valid_bit = 0;

        // Test 0: reset state check
        tb_test_num = 0;
        @(posedge clk);
        #1;
        n_rst = 0;
        @(posedge clk);
        #1;
        assert(crc16_valid == 0) else $error("Test %0d failed: crc16_valid should be 0 after reset", tb_test_num);
        n_rst = 1;
        @(posedge clk);
        #1;

        // Test 1: crc16_en gate - register should not shift
        tb_test_num = 1;
        reset_dut();
        serial_in = 1;
        crc16_en = 0;
        valid_bit = 1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        assert(crc16_valid == 0) else $error("Test %0d failed: register should not shift when crc16_en=0", tb_test_num);

        // Test 2: valid_bit gate - register should not shift
        tb_test_num = 2;
        reset_dut();
        serial_in = 1;
        crc16_en = 1;
        valid_bit = 0;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        assert(crc16_valid == 0) else $error("Test %0d failed: register should not shift when valid_bit=0", tb_test_num);

        // Test 3: 0x00 data byte + its CRC (0x02FD), high byte first
        tb_test_num = 3;
        reset_dut();
        send_byte(8'h00);
        send_byte(8'h02);   // CRC high byte first
        send_byte(8'hFD);   // CRC low byte
        crc16_en = 0;
        valid_bit = 0;
        assert(crc16_valid == 1) else $error("Test %0d failed: residual not reached for 0x00 payload", tb_test_num);

        // Test 4: corrupt one CRC byte - should NOT match residual
        tb_test_num = 4;
        reset_dut();
        send_byte(8'h00);
        send_byte(8'h03);   // wrong high byte
        send_byte(8'hFD);
        crc16_en = 0;
        valid_bit = 0;
        assert(crc16_valid == 0) else $error("Test %0d failed: corrupted packet should not match residual", tb_test_num);

        // Test 5: two byte payload 0xDE 0xAD + its CRC (0xB810), high byte first
        tb_test_num = 5;
        reset_dut();
        send_byte(8'hDE);
        send_byte(8'hAD);
        send_byte(8'hB8);   // CRC high byte first
        send_byte(8'h10);   // CRC low byte
        crc16_en = 0;
        valid_bit = 0;
        assert(crc16_valid == 1) else $error("Test %0d failed: residual not reached for 0xDEAD payload", tb_test_num);

        // Test 6: pause mid-stream with valid_bit=0, should resume cleanly
        tb_test_num = 6;
        reset_dut();
        send_byte(8'hDE);
        valid_bit = 0;
        crc16_en = 1;
        serial_in = 1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        send_byte(8'hAD);
        send_byte(8'hB8);
        send_byte(8'h10);
        crc16_en = 0;
        valid_bit = 0;
        assert(crc16_valid == 1) else $error("Test %0d failed: pausing mid-stream corrupted the CRC state", tb_test_num);

        $display("All tests completed");
        $finish;
    end

endmodule
