`timescale 1ns / 10ps

module tb_rx_edge_detector;

    localparam CLK_PERIOD = 10ns;

    logic clk;
    logic n_rst;
    logic dp_in;
    logic dm_in;
    logic edge_det;

    // DUT
    rx_edge_detector DUT (
        .clk(clk),
        .n_rst(n_rst),
        .dp_in(dp_in),
        .dm_in(dm_in),
        .edge_det(edge_det)
    );

    // Clock generation
    always begin
        #(CLK_PERIOD/2);
        clk = ~clk;
    end

    // Helper: wait one clock
    task automatic tick;
    begin
        @(posedge clk);
        #1;
    end
    endtask

    // Helper: check edge_det
    task automatic check_edge(
        input logic exp_edge,
        input string msg
    );
    begin
        if (edge_det !== exp_edge) begin
            $error("FAIL: %s | expected edge_det=%0b, got %0b at time %0t",
                   msg, exp_edge, edge_det, $time);
        end
        else begin
            $display("PASS: %s | edge_det=%0b at time %0t",
                     msg, edge_det, $time);
        end
    end
    endtask

    initial begin
        // Init
        clk   = 1'b0;
        n_rst = 1'b0;
        dp_in = 1'b1;
        dm_in = 1'b0;

        // Reset
        tick();
        tick();
        n_rst = 1'b1;

        // After reset, hold same state: no edge
        tick();
        check_edge(1'b0, "No change after reset");

        // Change dp/dm to opposite state: should detect edge
        dp_in = 1'b0;
        dm_in = 1'b1;
        tick();
        check_edge(1'b1, "Detect edge on J->K transition");

        // Hold same state: edge pulse should clear
        tick();
        check_edge(1'b0, "No edge when state held constant");

        // Change back: should detect edge again
        dp_in = 1'b1;
        dm_in = 1'b0;
        tick();
        check_edge(1'b1, "Detect edge on K->J transition");

        // Hold same state again
        tick();
        check_edge(1'b0, "No edge after transition pulse");

        // Toggle only dp_in
        dp_in = 1'b0;
        tick();
        check_edge(1'b1, "Detect edge when only dp changes");

        // Hold
        tick();
        check_edge(1'b0, "No edge after dp-only transition");

        // Toggle only dm_in
        dm_in = 1'b1;
        tick();
        check_edge(1'b1, "Detect edge when only dm changes");

        // Hold
        tick();
        check_edge(1'b0, "No edge after dm-only transition");

        $display("All edge detector tests completed.");
        $finish;
    end

endmodule
