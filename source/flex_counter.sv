`timescale 1ns / 10ps

module flex_counter #(
    parameter SIZE = 8
) 
(
    input logic clk,
    input logic n_rst,
    input logic clear,
    input logic count_enable,
    input logic [SIZE-1:0] rollover_val,
    output logic [SIZE-1:0] count_out,
    output logic rollover_flag
);
    logic [SIZE-1:0] next_count_out;
    logic next_rollover_flag;
    always_ff@(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            count_out <= '0;
            rollover_flag <= '0;
        end
        else begin
            count_out <= next_count_out;
            rollover_flag <= next_rollover_flag; //counter and flag when rollover
        end
    end

    always_comb begin
        next_count_out = count_out;
        if(clear) begin
        next_count_out = '0;
        end
        else if(count_enable) begin
            if(count_out > rollover_val) begin
                next_count_out = 'd1;
            end
            else if(count_out == rollover_val) begin
                next_count_out = 'd1;
            end
            else begin
                next_count_out = count_out + 1'b1;
            end
        end
    end

    always_comb begin
        next_rollover_flag = (next_count_out == rollover_val);
    end

    

   /* 
        if(!n_rst) begin
            count_out <= '0;
            rollover_flag <= 1'b0;
        end
        else if(clear) begin
            count_out <= '0;
            rollover_flag <= 1'b0;
        end
        else if(count_enable) begin
            if(count_out > rollover_val) begin
                count_out <= 'b1;
                rollover_flag <= 1'b0;
            else if(count_out == rollover_val) begin
                count_out <= 'b1;
                rollover_flag <= 1'b1;
            end
            end
            else begin
            count_out <= count_out + 1'b1;
            rollover_flag <= 1'b0;
            end
        end
        else begin
            rollover_flag <= 1'b0; 
        end 

    end
    */
endmodule

