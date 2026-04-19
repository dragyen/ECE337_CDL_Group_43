`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_usb_rx_tx_db ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

logic        clk;
logic        n_rst;
// AHB -> Data Buffer (inputs)
logic        store_tx_data;
logic [7:0]  tx_data;
logic        get_rx_data;
logic        clear;
// Data Buffer -> AHB (outputs)
logic [7:0]  rx_data;
logic [6:0]  buffer_occupancy;
// AHB -> USB TX (inputs)
logic [2:0]  tx_packet;
// USB RX -> AHB (outputs)
logic [3:0]  rx_packet;
logic        rx_data_ready;
logic        rx_transfer_active;
logic        rx_error;
// USB TX -> AHB (outputs)
logic        tx_transfer_active;
logic        tx_error;
// USB Physical Interface
logic        dp_in;
logic        dm_in;
logic        dp_out;
logic        dm_out;

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

    usb_rx_tx_db DUT 
    (
    .clk                (clk),
    .n_rst              (n_rst),
    // AHB -> Data Buffer (inputs)
    .store_tx_data      (store_tx_data),
    .tx_data            (tx_data),
    .get_rx_data        (get_rx_data),
    .clear              (clear),
    // Data Buffer -> AHB (outputs)
    .rx_data            (rx_data),
    .buffer_occupancy   (buffer_occupancy),
    // AHB -> USB TX (inputs)
    .tx_packet          (tx_packet),
    // USB RX -> AHB (outputs)
    .rx_packet          (rx_packet),
    .rx_data_ready      (rx_data_ready),
    .rx_transfer_active (rx_transfer_active),
    .rx_error           (rx_error),
    // USB TX -> AHB (outputs)
    .tx_transfer_active (tx_transfer_active),
    .tx_error           (tx_error),
    // USB Physical Interface
    .dp_in              (dp_in),
    .dm_in              (dm_in),
    .dp_out             (dp_out),
    .dm_out             (dm_out)
    );

    initial begin
        n_rst = 1;
        dp_in,
        dm_in,
        tx_packet = '0;
        store_tx_data = '0;
        tx_data = '0;
        get_rx_data = '0;
        clear = '0;
        reset_dut();
        @(negedge clk);
  tx_data       = 8'hAA;
  store_tx_data = 1;
  @(posedge clk);
  @(negedge clk);
  store_tx_data = 0;
  tx_data       = '0;
  @(posedge clk);
  // Push 0xBB
  @(negedge clk);
  tx_data       = 8'hBB;
  store_tx_data = 1;
  @(posedge clk);
  @(negedge clk);
  store_tx_data = 0;
  tx_data       = '0;
  @(posedge clk);
  // Push 0xCC
  @(negedge clk);
  tx_data       = 8'hCC;
  store_tx_data = 1;
  @(posedge clk);
  @(negedge clk);
  store_tx_data = 0;
  tx_data       = '0;
  @(posedge clk);
  // Expect occupancy = 3
  if (buffer_occupancy == 7'd3)
    $display("PASS Test 1: buffer_occupancy = %0d", buffer_occupancy);
  else
    $display("FAIL Test 1: expected 3, got %0d", buffer_occupancy);

  // =======================================================
  // Test 2: AHB Pop bytes - verify FIFO order
  // =======================================================
  // Pop first byte
  @(negedge clk);
  get_rx_data = 1;
  @(posedge clk);
  @(negedge clk);
  get_rx_data = 0;
  @(posedge clk);
  if (rx_data == 8'hAA)
    $display("PASS Test 2a: rx_data = 0x%0h", rx_data);
  else
    $display("FAIL Test 2a: expected 0xAA, got 0x%0h", rx_data);
  // Pop second byte
  @(negedge clk);
  get_rx_data = 1;
  @(posedge clk);
  @(negedge clk);
  get_rx_data = 0;
  @(posedge clk);
  if (rx_data == 8'hBB)
    $display("PASS Test 2b: rx_data = 0x%0h", rx_data);
  else
    $display("FAIL Test 2b: expected 0xBB, got 0x%0h", rx_data);
  // Pop third byte
  @(negedge clk);
  get_rx_data = 1;
  @(posedge clk);
  @(negedge clk);
  get_rx_data = 0;
  @(posedge clk);
  if (rx_data == 8'hCC)
    $display("PASS Test 2c: rx_data = 0x%0h", rx_data);
  else
    $display("FAIL Test 2c: expected 0xCC, got 0x%0h", rx_data);
  if (buffer_occupancy == 7'd0)
    $display("PASS Test 2d: buffer empty after all pops");
  else
    $display("FAIL Test 2d: expected occupancy 0, got %0d", buffer_occupancy);

  // =======================================================
  // Test 3: AHB Flush/Clear Buffer
  // =======================================================
  // Push 2 bytes then clear
  @(negedge clk);
  tx_data       = 8'hDE;
  store_tx_data = 1;
  @(posedge clk);
  @(negedge clk);
  store_tx_data = 0;
  @(negedge clk);
  tx_data       = 8'hAD;
  store_tx_data = 1;
  @(posedge clk);
  @(negedge clk);
  store_tx_data = 0;
  tx_data       = '0;
  @(posedge clk);
  // Assert clear
  @(negedge clk);
  clear = 1;
  @(posedge clk);
  @(negedge clk);
  clear = 0;
  @(posedge clk);
  if (buffer_occupancy == 7'd0)
    $display("PASS Test 3: buffer cleared, occupancy = %0d", buffer_occupancy);
  else
    $display("FAIL Test 3: expected 0, got %0d", buffer_occupancy);

  // =======================================================
  // Test 4: Buffer Overflow Protection (push 65, cap at 64)
  // =======================================================
  @(negedge clk);
  clear = 1;
  @(posedge clk);
  @(negedge clk);
  clear = 0;
  // Push 65 bytes
  repeat(65) begin
    @(negedge clk);
    tx_data       = 8'hFF;
    store_tx_data = 1;
    @(posedge clk);
    @(negedge clk);
    store_tx_data = 0;
  end
  @(posedge clk);
  if (buffer_occupancy == 7'd64)
    $display("PASS Test 4: overflow protected, occupancy = %0d", buffer_occupancy);
  else
    $display("FAIL Test 4: expected 64, got %0d", buffer_occupancy);

  // =======================================================
  // Test 5: Buffer Underflow Protection (pop from empty)
  // =======================================================
  @(negedge clk);
  clear = 1;
  @(posedge clk);
  @(negedge clk);
  clear = 0;
  @(posedge clk);
  @(negedge clk);
  get_rx_data = 1;
  @(posedge clk);
  @(negedge clk);
  get_rx_data = 0;
  @(posedge clk);
  if (buffer_occupancy == 7'd0)
    $display("PASS Test 5: underflow protected, occupancy = %0d", buffer_occupancy);
  else
    $display("FAIL Test 5: expected 0, got %0d", buffer_occupancy);

  // =======================================================
  // Test 6: AHB commands ACK TX (tx_packet=3)
  // Verify tx_transfer_active pulses high then low
  // =======================================================
  @(negedge clk);
  tx_packet = 3'd3; // ACK
  @(posedge tx_transfer_active);
  $display("INFO Test 6: TX ACK started, tx_transfer_active high");
  @(negedge tx_transfer_active);
  $display("INFO Test 6: TX ACK complete, tx_transfer_active low");
  @(negedge clk);
  tx_packet = 3'd0; // Clear per spec
  if (tx_error == 0)
    $display("PASS Test 6: ACK sent with no tx_error");
  else
    $display("FAIL Test 6: tx_error asserted unexpectedly");

  // =======================================================
  // Test 7: AHB fills buffer then commands DATA0 TX
  // (tx_packet=1 per spec)
  // =======================================================
  @(negedge clk);
  clear = 1;
  @(posedge clk);
  @(negedge clk);
  clear = 0;
  // Push 3 bytes
  @(negedge clk); tx_data = 8'h01; store_tx_data = 1;
  @(posedge clk); @(negedge clk); store_tx_data = 0;
  @(negedge clk); tx_data = 8'h02; store_tx_data = 1;
  @(posedge clk); @(negedge clk); store_tx_data = 0;
  @(negedge clk); tx_data = 8'h03; store_tx_data = 1;
  @(posedge clk); @(negedge clk); store_tx_data = 0;
  tx_data = '0;
  // Command DATA0 send
  @(negedge clk);
  tx_packet = 3'd1; // DATA0
  @(posedge tx_transfer_active);
  $display("INFO Test 7: DATA0 TX started");
  @(negedge tx_transfer_active);
  $display("INFO Test 7: DATA0 TX complete");
  @(negedge clk);
  tx_packet = 3'd0;
  if (tx_error == 0)
    $display("PASS Test 7: DATA0 sent with no tx_error");
  else
    $display("FAIL Test 7: tx_error asserted unexpectedly");

  // =======================================================
  // Test 8: USB RX receives OUT token on physical lines
  // NRZI encoded, LSB first
  // OUT PID = 4'b0001 -> full byte = 8'b1110_0001 = 0xE1
  // Sync = 0x80 after NRZI (7 zeros then a 1 = 7 toggles + hold)
  // =======================================================
  // Send sync (decoded 0000_0001, sent LSB first = 7 toggles then hold)
  // Start from idle dp=1
  // Bit 0-6: decoded 0 = toggle
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD); // toggle
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  // Bit 7: decoded 1 = hold (no toggle from last state)
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  // Send OUT PID 0xE1 = 1110_0001 LSB first: 1,0,0,0,0,1,1,1
  // Current state dp=0. 1=hold, 0=toggle
  // bit0=1: hold -> dp=0
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  // bit1=0: toggle -> dp=1
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  // bit2=0: toggle -> dp=0
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  // bit3=0: toggle -> dp=1
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  // bit4=0: toggle -> dp=0
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  // bit5=1: hold -> dp=0
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  // bit6=1: hold -> dp=0
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  // bit7=1: hold -> dp=0
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  // Token data: addr=7'h00, ep=4'h0, CRC5=5'b00000
  // All zeros = all toggles from current state dp=0
  // Byte 1 (addr+ep low bits): 8'h00
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  // Byte 2 (ep high bits + CRC5): 8'h00
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 1; #(USB_BIT_PERIOD);
  // EOP: both low for 2 bit periods, then idle
  dp_in = 0; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 0; dm_in = 0; #(USB_BIT_PERIOD);
  dp_in = 1; dm_in = 0; #(USB_BIT_PERIOD); // return to idle
  // Wait for RX to process
  repeat(20) @(posedge clk);
  $display("INFO Test 8: rx_packet=%0b rx_transfer_active=%0b rx_error=%0b",
           rx_packet, rx_transfer_active, rx_error);
  if (rx_error == 0)
    $display("PASS Test 8: OUT token received without rx_error");
  else
    $display("FAIL Test 8: rx_error asserted on OUT token");

  // =======================================================
  // Test 9: AHB sends NAK (tx_packet=4)
  // =======================================================
  @(negedge clk);
  tx_packet = 3'd4; // NAK
  @(posedge tx_transfer_active);
  $display("INFO Test 9: NAK TX started");
  @(negedge tx_transfer_active);
  @(negedge clk);
  tx_packet = 3'd0;
  if (tx_error == 0)
    $display("PASS Test 9: NAK sent with no tx_error");
  else
    $display("FAIL Test 9: tx_error asserted on NAK");

  // =======================================================
  // Test 10: AHB sends STALL (tx_packet=5)
  // =======================================================
  @(negedge clk);
  tx_packet = 3'd5; // STALL
  @(posedge tx_transfer_active);
  $display("INFO Test 10: STALL TX started");
  @(negedge tx_transfer_active);
  @(negedge clk);
  tx_packet = 3'd0;
  if (tx_error == 0)
    $display("PASS Test 10: STALL sent with no tx_error");
  else
    $display("FAIL Test 10: tx_error asserted on STALL");

        $finish;
    end
endmodule

/* verilator coverage_on */


