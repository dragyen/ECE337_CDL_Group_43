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
logic ff2;

always_comb begin : edgeflag
    if (TRIG_RISE & !ff2 & sync_out) begin
        edge_flag = 1'b1;
    end
    else if (TRIG_FALL & ff2 & !sync_out) begin
        edge_flag = 1'b1;
    end
    else begin
        edge_flag = 1'b0;
    end
end

always_ff @(posedge clk, negedge n_rst) begin : ffs
    if (n_rst == 1'b0) begin
        ff1 <= RST_VAL;
        ff2 <= RST_VAL;
        sync_out <= RST_VAL;
    end
    else begin
        ff2 <= sync_out;
        sync_out <= ff1;
        ff1 <= async_in;
    end
end

endmodule

