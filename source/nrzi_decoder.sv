module nrzi_decoder(
    input logic edge_det,
    output logic decoded_bit
);

assign decoded_bit = ~edge_det;

endmodule