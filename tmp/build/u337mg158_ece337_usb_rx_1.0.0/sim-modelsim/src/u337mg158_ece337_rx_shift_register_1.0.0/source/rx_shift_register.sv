module rx_shift_register (
    input logic clk, n_rst, valid_bit, serial_in, en, clear,
    output logic [15:0] parallel_out
);

logic [15:0] regs, next_regs;
logic valid_en;
assign valid_en = valid_bit & en;
assign parallel_out = regs;

always_comb begin : sr_comb
    next_regs = regs;

    if (clear) begin
        next_regs = 16'b0;
    end
    else if (valid_en) begin
        next_regs = serial_in << 15 | regs >> 1;
    end
end

always_ff @ (posedge clk, negedge n_rst) begin
    if (n_rst == 1'b0) begin
        regs <= 16'b0;
    end
    else begin
        regs <= next_regs;
    end
end

endmodule
