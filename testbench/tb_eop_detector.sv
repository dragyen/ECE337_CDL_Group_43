module tb_eop_detector;

localparam CLK_PERIOD = 10ns;
logic clk;
logic dm_in, dp_in, eop_det, exp_eop_det;
assign exp_eop_det = (dm_in == 0) && (dp_in == 0);

eop_detector DUT (.*);

always begin
    #(CLK_PERIOD/2)
    clk = 0;
    #(CLK_PERIOD/2)
    clk = 1;
    
end

task check_output;
begin
    if (exp_eop_det == eop_det) begin
        $display("PASSED");
    end
    else begin
        $display("FAILED");
    end
end
endtask

// task reset_dut;
// begin
//     n_rst = 1;
//     dp_in = 1;
//     dm_in = 0;

//     @(posedge clk)

//     n_rst = 0

//     @(posedge clk)
//     @(posedge clk)
//     @(posedge clk)

//     n_rst = 1;
// end
// endtask

initial begin
    @(posedge clk)
    //reset_dut;
    @(posedge clk)

    dm_in = 0;
    dp_in = 0;
    @(posedge clk)
    check_output;

    $finish;
end

endmodule