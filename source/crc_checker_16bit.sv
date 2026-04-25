`timescale 1ns/10ps

module crc_checker_16bit (
    input logic clk,
    input logic n_rst,
    input logic serial_in,
    input logic crc16_en,
    input logic valid_bit,
    input logic crc16_clear,
    output logic crc16_valid
);

    logic [15:0] crc, next_crc;

    logic en;
    assign en = crc16_en & valid_bit;

    logic feedback;
    assign feedback = serial_in ^ crc[15];

    always_comb begin : crc_comb
        next_crc = crc;

        if (crc16_clear) begin
            next_crc = 16'hFFFF;
        end
        else if (en) begin
            next_crc[15] = crc[14] ^ feedback; // x^15
            next_crc[14] = crc[13];
            next_crc[13] = crc[12];
            next_crc[12] = crc[11];
            next_crc[11] = crc[10];
            next_crc[10] = crc[9];
            next_crc[9] = crc[8];
            next_crc[8] = crc[7];
            next_crc[7] = crc[6];
            next_crc[6] = crc[5];
            next_crc[5] = crc[4];
            next_crc[4] = crc[3];
            next_crc[3] = crc[2];
            next_crc[2] = crc[1] ^ feedback; // x^2
            next_crc[1] = crc[0];
            next_crc[0] = feedback; // +1
        end
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            crc <= 16'hFFFF;    
        end else begin
            crc <= next_crc;     
        end
    end

    assign crc16_valid = (crc == 16'b1000_0000_0000_1101);

endmodule
