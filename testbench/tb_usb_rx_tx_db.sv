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
logic        store_tx_data;
logic [7:0]  tx_data;
logic        get_rx_data;
logic        clear;
logic [7:0]  rx_data;
logic [6:0]  buffer_occupancy;
logic [2:0]  tx_packet;
logic [3:0]  rx_packet;
logic        rx_data_ready;
logic        rx_transfer_active;
logic        rx_error;
logic        tx_transfer_active;
logic        tx_error;
logic        dp_in;
logic        dm_in;
logic        dp_out;
logic        dm_out;

    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        n_rst = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
        @(negedge clk);
    end
    endtask

    usb_rx_tx_db DUT (
        .clk                (clk),
        .n_rst              (n_rst),
        .store_tx_data      (store_tx_data),
        .tx_data            (tx_data),
        .get_rx_data        (get_rx_data),
        .clear              (clear),
        .rx_data            (rx_data),
        .buffer_occupancy   (buffer_occupancy),
        .tx_packet          (tx_packet),
        .rx_packet          (rx_packet),
        .rx_data_ready      (rx_data_ready),
        .rx_transfer_active (rx_transfer_active),
        .rx_error           (rx_error),
        .tx_transfer_active (tx_transfer_active),
        .tx_error           (tx_error),
        .dp_in              (dp_in),
        .dm_in              (dm_in),
        .dp_out             (dp_out),
        .dm_out             (dm_out)
    );

    initial begin
        // Initialize
        n_rst         = 1;
        dp_in         = 1; // USB idle
        dm_in         = 0;
        tx_packet     = '0;
        store_tx_data = '0;
        tx_data       = '0;
        get_rx_data   = '0;
        clear         = '0;
        reset_dut();

        // new tests

        


        // =======================================================
        // Test 1: Push 3 bytes, check occupancy
        // =======================================================
        @(negedge clk);
        tx_data = 8'hAA; store_tx_data = 1;
        @(negedge clk);
        store_tx_data = 0; tx_data = '0;

        @(negedge clk);
        tx_data = 8'hBB; store_tx_data = 1;
        @(negedge clk);
        store_tx_data = 0; tx_data = '0;

        @(negedge clk);
        tx_data = 8'hCC; store_tx_data = 1;
        @(negedge clk);
        store_tx_data = 0; tx_data = '0;

        @(negedge clk);
        if (buffer_occupancy == 7'd3)
            $display("PASS Test 1: buffer_occupancy = %0d", buffer_occupancy);
        else
            $display("FAIL Test 1: expected 3, got %0d", buffer_occupancy);
// Test 2: sample BEFORE pulsing get_rx_data
@(negedge clk);
if (rx_data == 8'hAA)  // sample first
    $display("PASS Test 2a: rx_data = 0x%0h", rx_data);
else
    $display("FAIL Test 2a: expected 0xAA, got 0x%0h", rx_data);
get_rx_data = 1;        // then advance
@(negedge clk);
get_rx_data = 0;

@(negedge clk);
if (rx_data == 8'hBB)
    $display("PASS Test 2b: rx_data = 0x%0h", rx_data);
else
    $display("FAIL Test 2b: expected 0xBB, got 0x%0h", rx_data);
get_rx_data = 1;
@(negedge clk);
get_rx_data = 0;

@(negedge clk);
if (rx_data == 8'hCC)
    $display("PASS Test 2c: rx_data = 0x%0h", rx_data);
else
    $display("FAIL Test 2c: expected 0xCC, got 0x%0h", rx_data);
get_rx_data = 1;
@(negedge clk);
get_rx_data = 0;
        // =======================================================
        // Test 3: Clear buffer
        // =======================================================
        @(negedge clk);
        tx_data = 8'hDE; store_tx_data = 1;
        @(negedge clk); @(negedge clk);
        store_tx_data = 0;

        @(negedge clk);
        tx_data = 8'hAD; store_tx_data = 1;
        @(negedge clk); @(negedge clk);
        store_tx_data = 0; tx_data = '0;

        @(negedge clk);
        clear = 1;
        @(negedge clk); @(negedge clk);
        clear = 0;
        @(negedge clk);
        if (buffer_occupancy == 7'd0)
            $display("PASS Test 3: buffer cleared, occupancy = %0d", buffer_occupancy);
        else
            $display("FAIL Test 3: expected 0, got %0d", buffer_occupancy);

        // =======================================================
        // Test 4: Overflow protection (push 65, cap at 64)
        // =======================================================
        @(negedge clk);
        clear = 1;
        @(negedge clk); @(negedge clk);
        clear = 0;

        repeat(65) begin
            @(negedge clk);
            tx_data = 8'hFF; store_tx_data = 1;
            @(negedge clk); @(negedge clk);
            store_tx_data = 0;
        end
        @(negedge clk);
        if (buffer_occupancy == 7'd64)
            $display("PASS Test 4: overflow protected, occupancy = %0d", buffer_occupancy);
        else
            $display("FAIL Test 4: expected 64, got %0d", buffer_occupancy);

        // =======================================================
        // Test 5: Underflow protection (pop from empty)
        // =======================================================
        @(negedge clk);
        clear = 1;
        @(negedge clk); @(negedge clk);
        clear = 0;

        @(negedge clk);
        get_rx_data = 1;
        @(negedge clk); @(negedge clk);
        get_rx_data = 0;
        @(negedge clk);
        if (buffer_occupancy == 7'd0)
            $display("PASS Test 5: underflow protected, occupancy = %0d", buffer_occupancy);
        else
            $display("FAIL Test 5: expected 0, got %0d", buffer_occupancy);

        // =======================================================
        // Test 6: Send ACK (tx_packet=3)
        // =======================================================
        @(negedge clk);
        tx_packet = 3'd3;
        @(posedge tx_transfer_active);
        $display("INFO Test 6: ACK TX started");
        @(negedge tx_transfer_active);
        $display("INFO Test 6: ACK TX complete");
        @(negedge clk);
        tx_packet = 3'd0;
        if (tx_error == 0)
            $display("PASS Test 6: ACK sent with no tx_error");
        else
            $display("FAIL Test 6: tx_error asserted on ACK");

// =======================================================
// Test 7: Fill buffer then send DATA0 (tx_packet=1)
// =======================================================
@(negedge clk);
clear = 1;
@(negedge clk); @(negedge clk);
clear = 0;

@(negedge clk); tx_data = 8'h01; store_tx_data = 1;
@(negedge clk); @(negedge clk); store_tx_data = 0;
@(negedge clk); tx_data = 8'h02; store_tx_data = 1;
@(negedge clk); @(negedge clk); store_tx_data = 0;
@(negedge clk); tx_data = 8'h03; store_tx_data = 1;
@(negedge clk); @(negedge clk); store_tx_data = 0;
tx_data = '0;

@(negedge clk);
tx_packet = 3'd1;
@(posedge tx_transfer_active);
$display("INFO Test 7: DATA0 TX started");
@(negedge tx_transfer_active);
$display("INFO Test 7: DATA0 TX complete");
@(negedge clk);
@(negedge clk);
@(negedge clk);
tx_packet = 3'd0;
if (tx_error == 0)
    $display("PASS Test 7: DATA0 sent with no tx_error");
else
    $display("FAIL Test 7: tx_error asserted on DATA0");

        // =======================================================
        // Test 8: Send NAK (tx_packet=4)
        // =======================================================
        @(negedge clk);
        tx_packet = 3'd4;
        @(posedge tx_transfer_active);
        $display("INFO Test 8: NAK TX started");
        @(negedge tx_transfer_active);
        @(negedge clk);
        tx_packet = 3'd0;
        if (tx_error == 0)
            $display("PASS Test 8: NAK sent with no tx_error");
        else
            $display("FAIL Test 8: tx_error asserted on NAK");

        // =======================================================
        // Test 9: Send STALL (tx_packet=5)
        // =======================================================
        @(negedge clk);
        tx_packet = 3'd5;
        @(posedge tx_transfer_active);
        $display("INFO Test 9: STALL TX started");
        @(negedge tx_transfer_active);
        @(negedge clk);
        tx_packet = 3'd0;
        if (tx_error == 0)
            $display("PASS Test 9: STALL sent with no tx_error");
        else
            $display("FAIL Test 9: tx_error asserted on STALL");

        




        $finish;
    end
endmodule
/* verilator coverage_on */
