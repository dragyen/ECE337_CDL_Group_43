`timescale 1ns / 10ps

module rx_edge_detector (
    input  logic clk,
    input  logic n_rst,
    input  logic dp_in,

    /* verilator lint_off UNUSEDSIGNAL */
    input  logic dm_in,   // not used directly, but kept for interface consistency
    /* verilator lint_on UNUSEDSIGNAL */


    output logic edge_det
);

    // logic current_state;
    // logic prev_state;

    // // Line-state encoding (simple)
    // assign current_state = dp_in && ~dm_in;

    // // Edge detection (1-cycle pulse)
    // always_ff @(posedge clk or negedge n_rst) begin
    //     if (!n_rst) begin
    //         prev_state <= 1'b0;
    //         edge_det <= 1'b0;
    //     end else begin
    //         edge_det <= (current_state != prev_state);
    //         prev_state <= current_state;
    //     end
    // end

     /* verilator lint_off UNUSEDSIGNAL */
    logic sync_out; //unused
    logic dummy;
    assign dummy = 1'b0 & dm_in;
     /* verilator lint_on UNUSEDSIGNAL */

    /* verilator lint_off PINCONNECTEMPTY */
    edge_dual ed (
        .clk(clk), 
        .n_rst(n_rst), 
        .async_in(dp_in), 
        .edge_flag(edge_det), 
        .sync_out(sync_out)
    );
    /* verilator lint_on PINCONNECTEMPTY */

endmodule
