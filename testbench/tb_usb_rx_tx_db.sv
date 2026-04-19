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

        reset_dut;

        $finish;
    end
endmodule

/* verilator coverage_on */

