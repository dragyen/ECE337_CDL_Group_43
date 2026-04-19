`timescale 1ns/10ps

module crc_checker_16bit (
    input logic clk,
    input logic n_rst,
    input logic serial_in,
    input logic crc16_en,
    input logic valid_bit,
    input logic crc16_clear
    output logic crc16_valid
);

    // The 16-bit shift register (parallel_out in the diagram)
    logic [15:0] crc;

    // en = crc16_en & valid_bit, as shown in diagram
    logic en;
    assign en = crc16_en & valid_bit;

    // Feedback is XOR of the incoming bit and the MSB of the register.
    // This is what makes it a "modified" shift register for CRC.
    logic feedback;
    assign feedback = serial_in ^ crc[15];

    // Shift register with taps for x^16 + x^15 + x^2 + 1
    // USB CRC presets the register to all 1s on reset
    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            crc <= 16'hFFFF;    // USB "preset to -1" requirement
        end else if (en) begin
            // Most bits just shift normally...
            crc[15] <= crc[14] ^ feedback;  // tap for x^15
            crc[14] <= crc[13];
            crc[13] <= crc[12];
            crc[12] <= crc[11];
            crc[11] <= crc[10];
            crc[10] <= crc[9];
            crc[9]  <= crc[8];
            crc[8]  <= crc[7];
            crc[7]  <= crc[6];
            crc[6]  <= crc[5];
            crc[5]  <= crc[4];
            crc[4]  <= crc[3];
            crc[3]  <= crc[2];
            crc[2]  <= crc[1] ^ feedback;   // tap for x^2
            crc[1]  <= crc[0];
            crc[0]  <= feedback;             // tap for x^0 (the +1 term)
        end
    end

    // As shown in diagram: check parallel_out against expected USB residual.
    // A valid packet (data + CRC bits fed through together) will always
    // land on this exact residual value if there were no bit errors.
    assign crc16_valid = (crc == 16'b1000_0000_0000_1101);

endmodule
