`timescale 1ns/10ps

module bit_stuffing_remover(
    input logic decoded_data, clk, n_rst,
    output logic valid_bit
);

logic [2:0] count, next_count;
logic next_valid_bit;

always_comb begin : stuffing_comb
    next_count = count + 1;
    next_valid_bit = 1;

    if (decoded_data == 0 && count != 5) begin
        next_count = 0;
    end
    else if (count == 5) begin
        next_count = 0;
        next_valid_bit = 0;
    end
end

always_ff @( posedge clk, negedge n_rst ) begin : stuffing_ff
    if (n_rst == 1'b0) begin
        count <= 0;
        valid_bit <= 1;
    end
    else begin
        count <= next_count;
        valid_bit <= next_valid_bit;
    end
end

endmodule
