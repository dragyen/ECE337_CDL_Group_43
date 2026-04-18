module tb_bit_stuffing_remover;

localparam CLK_PERIOD = 10ns;
logic clk, n_rst, decoded_data, valid_bit;

always begin
    #(CLK_PERIOD/2)
    clk = 0;
    #(CLK_PERIOD/2)
    clk = 1;
end

bit_stuffing_remover DUT (.*);

task check_output;
    input logic exp_out;
begin
    if (valid_bit == exp_out) begin
        $display("%d: PASSED CHECK", $time);
    end
    else begin
        $display("%d: FAILED CHECK: EXPECTED %d GOT %d", $time, exp_out, valid_bit);
    end
end

endtask

task reset_dut;
begin
    n_rst = 1;
    @(posedge clk)
    @(posedge clk)
    n_rst = 0;
    decoded_data = 0;
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    n_rst = 1;
end
endtask

initial begin
    reset_dut;

    @(posedge clk)
    @(negedge clk)
    decoded_data = 1;
    
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    check_output(1'b0);
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    

    $finish;
end

endmodule