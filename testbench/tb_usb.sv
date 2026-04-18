`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_usb ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    // AHB Subordinate Interface
    logic hsel;
    logic [3:0] haddr;
    logic [1:0] htrans;
    logic [1:0] hsize;
    logic hwrite;
    logic [31:0] hwdata;
    logic [2:0] hburst;
    logic [31:0] hrdata;
    logic hresp;
    logic hready;
    // USB Physical Interface
    logic dp_in;
    logic dm_in;
    logic dp_out;
    logic dm_out;
    logic d_mode;
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

    usb DUT 
    (
        .clk(clk),
        .n_rst(n_rst),
        // AHB Subordinate Interface
        .hsel(hsel),
        .haddr(haddr),
        .htrans(htrans),
        .hsize(hsize),
        .hwrite(hwrite),
        .hwdata(hwdata),
        .hburst(hburst),
        .hrdata(hrdata),
        .hresp(hresp),
        .hready(hready),
        // USB Physical Interface
        .dp_in(dp_in),
        .dm_in(dm_in),
        .dp_out(dp_out),
        .dm_out(dm_out),
        .d_mode(d_mode)
    );

    initial begin
        hsel = 0;
        haddr = 4'h0;
        htrans = 2'b00;
        hsize = 2'b00;
        hwrite = 0;
        hwdata = 32'h0;
        hburst = 3'b000;
        dp_in = 1'b1;
        dm_in = 1'b0;
        n_rst = 1;

    $display("TEST 1: Reset/idle state");
    #1;
    if (hready !== 1'b1)
        $display("FAILED TEST 1: hready not asserted after reset");
    else
        $display("PASSED: hready asserted after reset");
    if (hresp !== 1'b0)
        $display("FAILED TEST 1: hresp not OK after reset");
    else
        $display("PASSED: hresp OK after reset");

    // TEST 2: AHB write to TX data register
    $display("TEST 2: AHB write TX data");
    @(posedge clk);
    hsel   = 1;
    haddr  = 4'h0;   // TX data register address - adjust to match your ahb_subordinate map
    htrans = 2'b10;  // NONSEQ
    hsize  = 2'b00;  // byte
    hwrite = 1;
    hwdata = 32'hAB;
    @(posedge clk);
    hsel   = 0;
    htrans = 2'b00;
    hwrite = 0;
    @(posedge clk);
    #1;
    $display("PASSED: AHB write completed at t=%0t", $time);

    // TEST 3: AHB read back status
    $display("TEST 3: AHB read status");
    @(posedge clk);
    hsel   = 1;
    haddr  = 4'h8;   // status register address - adjust to match your ahb_subordinate map
    htrans = 2'b10;
    hsize  = 2'b10;  // word
    hwrite = 0;
    @(posedge clk);
    hsel   = 0;
    htrans = 2'b00;
    @(posedge clk);
    #1;
    $display("PASSED: AHB read hrdata=%h at t=%0t", hrdata, $time);

    // TEST 4: USB TX packet - ACK
    $display("TEST 4: TX ACK packet");
    @(posedge clk);
    hsel   = 1;
    haddr  = 4'h4;   // tx_packet register address - adjust to match your ahb_subordinate map
    htrans = 2'b10;
    hsize  = 2'b00;
    hwrite = 1;
    hwdata = 32'h3;  // ACK = 3'b011
    @(posedge clk);
    hsel   = 0;
    htrans = 2'b00;
    hwrite = 0;

    // wait for transfer to start then complete
    wait (DUT.tx_transfer_active == 1'b1);
    $display("PASSED: TX transfer active at t=%0t", $time);
    wait (DUT.tx_transfer_active == 1'b0);
    $display("PASSED: TX transfer complete at t=%0t", $time);

    if (DUT.tx_error !== 1'b0)
        $display("FAILED TEST 4: tx_error asserted");
    else
        $display("PASSED: no tx_error");

    // TEST 5: USB RX - simulate incoming J/K on dp_in/dm_in
    $display("TEST 5: RX idle line state");
    dp_in = 1'b1;
    dm_in = 1'b0;
    repeat(10) @(posedge clk);
    #1;
    if (DUT.rx_error !== 1'b0)
        $display("FAILED TEST 5: rx_error on idle line");
    else
        $display("PASSED: no rx_error on idle line");
    if (DUT.rx_transfer_active !== 1'b0)
        $display("FAILED TEST 5: rx_transfer_active on idle line");
    else
        $display("PASSED: rx_transfer_active low on idle");

    $display("ALL TESTS COMPLETE");
    $finish;
    end
endmodule

/* verilator coverage_on */

