`timescale 1ns / 10ps

module edge_det #(
    parameter TRIG_RISE = 1,
    parameter TRIG_FALL = 0,
    parameter RST_VAL = 0
) (
    input logic clk,
    input logic n_rst,
    input logic async_in,
    output logic sync_out,
    output logic edge_flag
);

logic ff1;
logic [1:0] warmup;

always_ff @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        ff1      <= RST_VAL;
        sync_out <= RST_VAL;
        warmup   <= 2'd0;
    end
    else begin
        ff1      <= async_in;
        sync_out <= ff1;

        if (warmup != 2'd2)
            warmup <= warmup + 1'b1;
    end
end

always_comb begin
    edge_flag = 1'b0;
    if (warmup == 2'd2) begin
        if (TRIG_RISE && !sync_out && ff1)
            edge_flag = 1'b1;
        else if (TRIG_FALL && sync_out && !ff1)
            edge_flag = 1'b1;
    end
end


endmodule

