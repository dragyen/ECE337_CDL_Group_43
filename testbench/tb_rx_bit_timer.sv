`timescale 1ns / 10ps

module tb_rx_bit_timer;

    localparam CLK_PERIOD = 10ns;

    logic clk;
    logic n_rst;
    logic edge_det;
    logic shift_strobe;

    rx_bit_timer DUT (
        .clk(clk),
        .n_rst(n_rst),
        .edge_det(edge_det),
        .shift_strobe(shift_strobe)
    );

    // Clock
    always #(CLK_PERIOD/2) clk = ~clk;

    task automatic tick;
    begin
        @(posedge clk);
        #1;
    end
    endtask

    task automatic check_strobe(
        input logic expected,
        input string msg
    );
    begin
        if (shift_strobe !== expected) begin
            $error("FAIL: %s | expected shift_strobe=%0b got %0b at time %0t",
                   msg, expected, shift_strobe, $time);
        end
        else begin
            $display("PASS: %s | shift_strobe=%0b at time %0t",
                     msg, shift_strobe, $time);
        end
    end
    endtask

    task automatic check_state_count(
        input logic [1:0] exp_state,
        input logic [3:0] exp_count,
        input string msg
    );
    begin
        if ((DUT.state !== exp_state) || (DUT.count !== exp_count)) begin
            $error("FAIL: %s | expected state=%0d count=%0d got state=%0d count=%0d at time %0t",
                   msg, exp_state, exp_count, DUT.state, DUT.count, $time);
        end
        else begin
            $display("PASS: %s | state=%0d count=%0d at time %0t",
                     msg, DUT.state, DUT.count, $time);
        end
    end
    endtask

    // Checks one full 8-cycle bit state
        input logic [1:0] expected_state,
        input string label
    );
        integer i;
    begin
        check_state_count(expected_state, 4'd0, {label, " starts at count 0"});

        for (i = 1; i <= 3; i++) begin
            tick();
            check_state_count(expected_state, i[3:0], $sformatf("%s count %0d", label, i));
            check_strobe(1'b0, $sformatf("%s no strobe at count %0d", label, i));
        end

        tick();
        check_state_count(expected_state, 4'd4, {label, " count 4"});
        check_strobe(1'b1, {label, " strobe at count 4"});

        for (i = 5; i <= 7; i++) begin
            tick();
            check_state_count(expected_state, i[3:0], $sformatf("%s count %0d", label, i));
            check_strobe(1'b0, $sformatf("%s no strobe at count %0d", label, i));
        end

        // one more tick: should wrap to next state with count 0
        tick();
    end
    endtask

    // Checks one full 9-cycle bit state:
    task automatic do_9bit_test(
        input logic [1:0] expected_state,
        input string label
    );
        integer i;
    begin
        check_state_count(expected_state, 4'd0, {label, " starts at count 0"});

        for (i = 1; i <= 3; i++) begin
            tick();
            check_state_count(expected_state, i[3:0], $sformatf("%s count %0d", label, i));
            check_strobe(1'b0, $sformatf("%s no strobe at count %0d", label, i));
        end

        tick();
        check_state_count(expected_state, 4'd4, {label, " count 4"});
        check_strobe(1'b1, {label, " strobe at count 4"});

        for (i = 5; i <= 8; i++) begin
            tick();
            check_state_count(expected_state, i[3:0], $sformatf("%s count %0d", label, i));
            check_strobe(1'b0, $sformatf("%s no strobe at count %0d", label, i));
        end

        // one more tick: should wrap to next state with count 0
        tick();
    end
    endtask

    // Pulse edge_det near the middle of a bit and make sure timer restarts
    task automatic do_edge_resync_midbit_test;
    begin
        $display("\n--- Edge resync test (near middle of bit) ---");

        check_state_count(DUT.BIT8_1, 4'd0, "Resync test starts in BIT8_1 count 0");

        tick(); // count 1
        check_state_count(DUT.BIT8_1, 4'd1, "Resync pre-edge count 1");
        check_strobe(1'b0, "No strobe before edge at count 1");

        tick(); // count 2
        check_state_count(DUT.BIT8_1, 4'd2, "Resync pre-edge count 2");
        check_strobe(1'b0, "No strobe before edge at count 2");

        // Assert edge_det near the middle, before count 4 strobe
        edge_det = 1'b1;
        tick();
        edge_det = 1'b0;

        check_state_count(DUT.BIT8_1, 4'd0, "Timer reset to BIT8_1 count 0 after edge");
        check_strobe(1'b0, "No strobe on resync cycle");

        tick();
        check_state_count(DUT.BIT8_1, 4'd1, "Post-resync count 1");
        check_strobe(1'b0, "No strobe at post-resync count 1");

        tick();
        check_state_count(DUT.BIT8_1, 4'd2, "Post-resync count 2");
        check_strobe(1'b0, "No strobe at post-resync count 2");

        tick();
        check_state_count(DUT.BIT8_1, 4'd3, "Post-resync count 3");
        check_strobe(1'b0, "No strobe at post-resync count 3");

        tick();
        check_state_count(DUT.BIT8_1, 4'd4, "Post-resync count 4");
        check_strobe(1'b1, "Strobe at count 4 after resync");

        tick();
        check_state_count(DUT.BIT8_1, 4'd5, "Post-resync count 5");
        check_strobe(1'b0, "No strobe at post-resync count 5");

        tick();
        check_state_count(DUT.BIT8_1, 4'd6, "Post-resync count 6");
        check_strobe(1'b0, "No strobe at post-resync count 6");

        tick();
        check_state_count(DUT.BIT8_1, 4'd7, "Post-resync count 7");
        check_strobe(1'b0, "No strobe at post-resync count 7");

        tick();
        check_state_count(DUT.BIT8_2, 4'd0, "Post-resync advanced to BIT8_2");
    end
    endtask

    initial begin
        clk = 1'b0;
        n_rst = 1'b0;
        edge_det = 1'b0;

        $display("Starting rx_bit_timer testbench...");

        // Reset
        tick();
        tick();
        n_rst = 1'b1;

        // Check initial reset state
        check_state_count(DUT.BIT8_1, 4'd0, "After reset release");
        check_strobe(1'b0, "No strobe immediately after reset");

        $display("\n--- BIT8_1 test ---");
        do_8bit_test(DUT.BIT8_1, "BIT8_1");
        check_state_count(DUT.BIT8_2, 4'd0, "Transition to BIT8_2");

        $display("\n--- BIT8_2 test ---");
        do_8bit_test(DUT.BIT8_2, "BIT8_2");
        check_state_count(DUT.BIT9, 4'd0, "Transition to BIT9");

        $display("\n--- BIT9 test ---");
        do_9bit_test(DUT.BIT9, "BIT9");
        check_state_count(DUT.BIT8_1, 4'd0, "Transition back to BIT8_1");

        do_edge_resync_midbit_test();

        $display("\nAll rx_bit_timer tests completed.");
        $finish;
    end

endmodule