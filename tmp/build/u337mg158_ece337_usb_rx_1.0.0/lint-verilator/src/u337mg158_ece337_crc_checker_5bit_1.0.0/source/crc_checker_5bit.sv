`timescale 1ns / 10ps

module crc_checker_5bit (
    input  logic clk,
    input  logic n_rst,
    input  logic serial_in,
    input  logic crc_en,
    input  logic crc_clear,
    input  logic valid_bit,
    output logic crc_valid
);

logic [4:0] crc_reg, next_crc;
logic valid_en;
logic feedback;
logic next_crc_valid;

assign valid_en = crc_en & valid_bit;

// CRC-5 checker for polynomial x^5 + x^2 + 1
// Preset = all 1's
// Residual = 5'b01100
always_comb begin : crc5_comb
    next_crc = crc_reg;
    next_crc_valid = 1'b0;

    // Fold serial input into feedback path
    feedback = crc_reg[4] ^ serial_in;

    if (crc_clear) begin
        next_crc = 5'b11111;
        next_crc_valid = 1'b0;
    end
    else if (valid_en) begin
        next_crc[0] = feedback;
        next_crc[1] = crc_reg[0];
        next_crc[2] = crc_reg[1] ^ feedback;
        next_crc[3] = crc_reg[2];
        next_crc[4] = crc_reg[3];

        if (next_crc == 5'b01100) begin
            next_crc_valid = 1'b1;
        end
    end
end

always_ff @(posedge clk or negedge n_rst) begin : crc5_ff
    if (!n_rst) begin
        crc_reg <= 5'b11111;
        crc_valid <= 1'b0;
    end
    else begin
        crc_reg <= next_crc;
        crc_valid <= next_crc_valid;
    end
end

endmodule