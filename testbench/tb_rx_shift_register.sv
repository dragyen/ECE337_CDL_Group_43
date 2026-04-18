`timescale 10ns/1ps

module tb_rx_shift_register;

localparam CLK_PERIOD = 10ns;
logic clk, n_rst, valid_bit, serial_in, en, clear;
logic [15:0] parallel_out, exp_regs;

rx_shift_register DUT (.*);

//clock gen
always begin
    #(CLK_PERIOD/2);
    clk = 0;
    #(CLK_PERIOD/2);
    clk = 1;
end

task check_output;
begin
    if (parallel_out == exp_regs) begin
        $display("%d: OUTPUT AS EXPECTED", $time);
    end
    else begin
        $error("%d: OUTPUT DOES NOT MATCH EXPECTED", $time);
    end
end
endtask

task check_output_manual(
    input logic [15:0] regs
);
begin
    if (parallel_out == regs) begin
        $display("%d: OUTPUT AS EXPECTED", $time);
    end
    else begin
        $error("%d: OUTPUT DOES NOT MATCH EXPECTED, EXPECTED: %d, ACTUAL: %d", $time, regs, parallel_out);
    end
end
endtask

task shift_bit (
    input logic s_in
);
begin
    en = 1'b1;
    valid_bit = 1'b1;
    serial_in = s_in;
    @(posedge clk)
    exp_regs = s_in << 15 | exp_regs >> 1;
    check_output;
end
endtask

task clear_regs;
begin
    clear = 1;
    exp_regs = 16'b0;
    @(posedge clk)
    check_output;
end
endtask;

task reset_dut;
begin
    n_rst = 0;
    clear = 0;
    serial_in = 0;

    exp_regs = 16'b0;

    @(posedge clk)
    @(posedge clk)
    @(posedge clk)

    n_rst = 1;

end
endtask

initial begin
    n_rst = 1;
    //Test 0: power on reset
    reset_dut;
    @(posedge clk)
    check_output;
    //Test 1: Normal behavior
    shift_bit(1'b1);
    shift_bit(1'b1);
    shift_bit(1'b1);
    shift_bit(1'b1);
    shift_bit(1'b1);
    shift_bit(1'b1);

    $finish;
end

endmodule
