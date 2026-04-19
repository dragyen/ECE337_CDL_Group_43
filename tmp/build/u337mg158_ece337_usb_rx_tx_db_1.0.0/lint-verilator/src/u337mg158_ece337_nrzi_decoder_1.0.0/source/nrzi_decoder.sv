module nrzi_decoder(
    input logic edge_det,
    output logic decoded_data
);

assign decoded_data = ~edge_det;

endmodule
