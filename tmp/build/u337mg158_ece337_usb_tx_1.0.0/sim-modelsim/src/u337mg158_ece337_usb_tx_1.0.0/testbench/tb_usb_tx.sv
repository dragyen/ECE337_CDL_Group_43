`timescale 1ns / 10ps
/* verilator coverage_off */
module tb_usb_tx ();
localparam CLK_PERIOD = 10ns;

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;
end

logic clk, n_rst;
logic [7:0] tx_packet_data;
logic [2:0] tx_packet;
logic [6:0] buffer_occupancy;
logic get_tx_packet_data;
logic tx_transfer_active;
logic tx_error;
logic dm_out;
logic dp_out;
logic prev_dp;

// clockgen
always begin
    clk = 0;
    #(CLK_PERIOD / 2.0);
    clk = 1;
    #(CLK_PERIOD / 2.0);
end

task reset_dut;
begin
    n_rst = 0;
    @(posedge clk);
    @(posedge clk);
    @(negedge clk);
    n_rst = 1;
    @(posedge clk);
    @(posedge clk);
end
endtask

task init_signals;
begin
    tx_packet_data   = 8'h00;
    tx_packet        = 3'b000;
    buffer_occupancy = 7'h00;
end
endtask


usb_tx DUT (
    .clk(clk),
    .n_rst(n_rst),
    .tx_packet_data(tx_packet_data),
    .tx_packet(tx_packet),
    .buffer_occupancy(buffer_occupancy),
    .get_tx_packet_data(get_tx_packet_data),
    .tx_transfer_active(tx_transfer_active),
    .tx_error(tx_error),
    .dm_out(dm_out),
    .dp_out(dp_out)
);

initial begin
    n_rst = 1;
    init_signals();
    reset_dut();

    // TEST 1 ACK FSM traversal
    $display("TEST 1: ACK packet FSM traversal");

    tx_packet = 3'b011;
    buffer_occupancy = 7'h00;

    wait (DUT.currentState == DUT.SYNC);
    #1;
    if (tx_transfer_active !== 1)
        $error("FAILED TEST 1: SYNC active");
    else
        $display("PASSED: SYNC active");

    wait (DUT.currentState == DUT.EOP);
    #1;
    if (dp_out !== 1'b0 || dm_out !== 1'b0)
        $error("FAILED TEST 1: EOP wrong");
    else
        $display("PASSED: EOP correct");

    wait (DUT.currentState == DUT.WAIT);
    #1;
    if (dp_out !== 1'b1 || dm_out !== 1'b0)
        $error("FAILED TEST 1: WAIT wrong");
    else
        $display("PASSED: WAIT correct");

    wait (DUT.currentState == DUT.IDLE);
    #1;
    if (tx_transfer_active !== 0)
        $error("FAILED TEST 1: IDLE wrong");
    else
        $display("PASSED: IDLE correct");

    reset_dut();
    init_signals();

    // TEST 2 NAK FSM traversal
    $display("TEST 2: NAK packet FSM traversal");

    tx_packet = 3'b100;
    buffer_occupancy = 7'h00;

    wait (DUT.currentState == DUT.SYNC);
    #1;

    if (tx_transfer_active !== 1)
        $error("FAILED TEST 2: SYNC active");
    else
        $display("PASSED: SYNC active");

    wait (DUT.currentState == DUT.EOP);
    #1;

    if (dp_out !== 1'b0 || dm_out !== 1'b0)
        $error("FAILED TEST 2: EOP wrong");
    else
        $display("PASSED: EOP correct");

    reset_dut();
    init_signals();

    // TEST 3 DATA0 FSM traversal
    $display("TEST 3: DATA0 packet FSM traversal");

    tx_packet        = 3'b001;
    buffer_occupancy = 7'd4;
    tx_packet_data   = 8'hAB;

    wait (DUT.currentState == DUT.SYNC);
    #20;

    wait (DUT.currentState == DUT.DATA);
    #20;

    if (get_tx_packet_data !== 1)
        $error("FAILED TEST 3: DATA enable failed");
    else
        $display("PASSED: DATA active");

    // IMPORTANT: wait for WAIT_DATA before changing buffer
    wait (DUT.currentState == DUT.WAIT_DATA);
    buffer_occupancy = 0;

    wait (DUT.currentState == DUT.CRC);
    #20;

    wait (DUT.currentState == DUT.EOP);
    #20;

    if (dp_out !== 1'b0 || dm_out !== 1'b0)
        $error("FAILED TEST 3: EOP wrong");
    else
        $display("PASSED: EOP correct");

    reset_dut();
    init_signals();

    // TEST 4 ERROR state
    $display("TEST 4: ERROR state");

    tx_packet = 3'b001;
    buffer_occupancy = 7'h00;

    wait (DUT.currentState == DUT.SYNC);
    wait (DUT.currentState == DUT.ERROR);
    #20;

    if (tx_error !== 1)
        $error("FAILED TEST 4: error flag failed");
    else
        $display("PASSED: error flag");

    if (tx_transfer_active !== 0)
        $error("FAILED TEST 4: active not cleared");
    else
        $display("PASSED: inactive in error");

    reset_dut();
    init_signals();

    // TEST 5: NRZI encoding
    tx_packet        = 3'b001;
buffer_occupancy = 7'd1;
tx_packet_data   = 8'b10011011;
  wait (DUT.currentState == DUT.WAIT_DATA);
prev_dp = dp_out;
$display("Test 5: entering WAIT_DATA, prev_dp=%0b at t=%0t", prev_dp, $time);

// bit 0 - data=1, expect NO change
@(posedge DUT.bit_pulse);
@(negedge clk); // settle after flop update
if (dp_out !== prev_dp)
    $error("FAILED TEST 5: bit0 unexpected toggle, dp=%0b at t=%0t", dp_out, $time);
else
    $display("PASSED: bit0 no toggle (dp=%0b) at t=%0t", dp_out, $time);
prev_dp = dp_out;

// bit 1 - data=1, expect NO change
@(posedge DUT.bit_pulse);
@(negedge clk);
if (dp_out !== prev_dp)
    $error("FAILED TEST 5: bit1 unexpected toggle, dp=%0b at t=%0t", dp_out, $time);
else
    $display("PASSED: bit1 no toggle (dp=%0b) at t=%0t", dp_out, $time);
prev_dp = dp_out;

// bit 2 - data=0, expect TOGGLE
@(posedge DUT.bit_pulse);
@(negedge clk);
if (dp_out === prev_dp)
    $error("FAILED TEST 5: bit2 no toggle, dp=%0b at t=%0t", dp_out, $time);
else
    $display("PASSED: bit2 toggle (dp=%0b) at t=%0t", dp_out, $time);
prev_dp = dp_out;

// bit 3 - data=1, expect NO change
@(posedge DUT.bit_pulse);
@(negedge clk);
if (dp_out !== prev_dp)
    $error("FAILED TEST 5: bit3 unexpected toggle, dp=%0b at t=%0t", dp_out, $time);
else
    $display("PASSED: bit3 no toggle (dp=%0b) at t=%0t", dp_out, $time);
prev_dp = dp_out;

// bit 4 - data=1, expect NO change
@(posedge DUT.bit_pulse);
@(negedge clk);
if (dp_out !== prev_dp)
    $error("FAILED TEST 5: bit4 unexpected toggle, dp=%0b at t=%0t", dp_out, $time);
else
    $display("PASSED: bit4 no toggle (dp=%0b) at t=%0t", dp_out, $time);
prev_dp = dp_out;

// bit 5 - data=0, expect TOGGLE
@(posedge DUT.bit_pulse);
@(negedge clk);
if (dp_out === prev_dp)
    $error("FAILED TEST 5: bit5 no toggle, dp=%0b at t=%0t", dp_out, $time);
else
    $display("PASSED: bit5 toggle (dp=%0b) at t=%0t", dp_out, $time);
prev_dp = dp_out;

// bit 6 - data=0, expect TOGGLE
@(posedge DUT.bit_pulse);
@(negedge clk);
if (dp_out === prev_dp)
    $error("FAILED TEST 5: bit6 no toggle, dp=%0b at t=%0t", dp_out, $time);
else
    $display("PASSED: bit6 toggle (dp=%0b) at t=%0t", dp_out, $time);
prev_dp = dp_out;

// bit 7 - data=1, expect NO change
@(posedge DUT.bit_pulse);
@(negedge clk);
if (dp_out !== prev_dp) 
    $error("FAILED TEST 5: bit7 unexpected toggle, dp=%0b at t=%0t", dp_out, $time);
else
    $display("PASSED: bit7 no toggle (dp=%0b) at t=%0t", dp_out, $time);


    tx_packet        = 3'b001;
tx_packet_data   = 8'hFF;
buffer_occupancy = 7'd1;

@(negedge clk);
repeat(200) @(posedge clk);

tx_packet        = 3'b001;
tx_packet_data   = 8'hAB;
buffer_occupancy = 7'd1;

@(negedge clk);
repeat(300) @(posedge clk);

tx_packet = 3'b000;
buffer_occupancy = 7'd0;
$finish;
end  
endmodule
/* verilator coverage_on */


/*
logic dp_orig;
    logic next_dp_orig;

    always_comb begin
        next_dp_orig = dp_orig;

        if (currentState == SYNC && bit_pulse)
            next_dp_orig = 1'b1;
        else if (currentState == WAIT)
            next_dp_orig = 1'b1;
        else if (currentState != EOP && currentState != IDLE && currentState != SYNC && bit_pulse) begin
            if (serial_out == 1'b0)
                next_dp_orig = ~dp_orig;
        end
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            dm_out <= 1'b0;
            dp_out <= 1'b1;
        end
        else begin
            dm_out <= ~next_dp_orig;
            dp_out <= next_dp_orig;
        end
    end
    
*/
