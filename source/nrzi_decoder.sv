module nrzi_decoder(
    input logic edge_det, clk, n_rst, new_bit,
    output logic decoded_data
);

logic next_decoded_data, edge_seen, next_edge_seen;

always_comb begin
    next_decoded_data = decoded_data;
    next_edge_seen = edge_seen;

    if (edge_det) begin
        next_edge_seen = 1;
    end
    if (new_bit) begin
        next_edge_seen = 0;
        if (edge_seen || edge_det) begin
            next_decoded_data = 0;
        end
        else begin
            next_decoded_data = 1;
        end
    end
    
end

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        decoded_data <= 1;
        edge_seen = 0;
    end
    else begin
        decoded_data <= next_decoded_data;
        edge_seen = next_edge_seen;
    end
end


endmodule
