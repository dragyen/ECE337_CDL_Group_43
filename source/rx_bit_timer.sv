module rx_bit_timer (
    input logic clk, n_rst, edge_det,
    output logic shift_strobe, new_bit,
    output logic [3:0] bit_count
);

typedef enum logic [1:0] {BIT8_1, BIT8_2, BIT9} state_t;
state_t state, next_state;

logic next_new_bit;
logic [3:0] count, next_count;
assign bit_count = count;

always_comb begin : comb_logic
    next_count = count + 1;
    next_state = state;
    next_new_bit = 0;
    shift_strobe = 0;

    if (count == 4) begin
        shift_strobe = 1;
    end
    if (edge_det) begin
        next_count = 0;
        next_new_bit = 1;
        next_state = BIT8_1;
    end
    else if (state == BIT8_1 && count == 7) begin
        next_count = 0;
        next_new_bit = 1;
        next_state = BIT8_2;
    end
    else if (state == BIT8_2 && count == 7) begin
        next_count = 0;
        next_new_bit = 1;
        next_state = BIT9;
    end
    else if (state == BIT9 && count == 8) begin
        next_count = 0;
        next_new_bit = 1;
        next_state = BIT8_1;
    end
    
    //force new bit to trigger only once
    if (new_bit == 1) begin
        next_new_bit = 0;
    end
end

always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 1'b0) begin
        count <= 0;
        state <= BIT8_1;
        new_bit <= 0;
    end
    else begin
        count <= next_count;
        state <= next_state;
        new_bit <= next_new_bit;
    end
end

endmodule
