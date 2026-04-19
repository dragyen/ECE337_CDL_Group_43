`timescale 1ns / 10ps

    module usb #(
    // parameters
    ) (
    input  logic clk,
    input  logic n_rst,

    // AHB Subordinate Interface
    input  logic hsel,
    input  logic [3:0] haddr,
    input  logic [1:0] htrans,
    input  logic [1:0] hsize,
    input  logic hwrite,
    input  logic [31:0] hwdata,
    input  logic [2:0] hburst,
    output logic [31:0] hrdata,
    output logic hresp,
    output logic hready,

    // USB Physical Interface
    input  logic dp_in,
    input  logic dm_in,
    output logic dp_out,
    output logic dm_out,
    output logic d_mode
    );

  // AHB <-> Data Buffer
  logic [7:0] tx_data;
  logic store_tx_data;
  logic [7:0] rx_data;
  logic get_rx_data;
  logic [6:0] buffer_occupancy;
  logic clear;

  // AHB <-> USB RX
  logic [3:0] rx_packet;
  logic rx_data_ready;
  logic rx_transfer_active;
  logic rx_error;

  // AHB <-> USB TX
  logic [2:0] tx_packet;
  logic tx_transfer_active;
  logic tx_error;

  // Data Buffer <-> USB RX
  logic [7:0] rx_packet_data;
  logic store_rx_packet_data;

  // Data Buffer <-> USB TX
  logic [7:0] tx_packet_data;
  logic get_tx_packet_data;

  // USB RX -> Data Buffer
  logic flush;


  ahb_subordinate u_ahb_sub (
    .clk(clk),
    .n_rst(n_rst),
    // AHB bus
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
    // Data Buffer
    .tx_data(tx_data),
    .store_tx_data(store_tx_data),
    .rx_data(rx_data),
    .get_rx_data(get_rx_data),
    .buffer_occupancy(buffer_occupancy),
    .clear(clear),
    // USB RX status
    .rx_packet(rx_packet),
    .rx_data_ready(rx_data_ready),
    .rx_transfer_active(rx_transfer_active),
    .rx_error(rx_error),
    // USB TX control/status
    .tx_packet(tx_packet),
    .tx_transfer_active(tx_transfer_active),
    .tx_error(tx_error)
  );

  data_buffer u_data_buffer (
    .clk(clk),
    .n_rst(n_rst),
    // AHB side
    .store_tx_data(store_tx_data),
    .tx_data(tx_data),
    .get_rx_data(get_rx_data),
    .rx_data(rx_data),
    .buffer_occupancy(buffer_occupancy),
    .clear(clear),
    // USB RX side
    .store_rx_packet_data(store_rx_packet_data),
    .rx_packet_data(rx_packet_data),
    .flush(flush),
    // USB TX side
    .get_tx_packet_data(get_tx_packet_data),
    .tx_packet_data(tx_packet_data)
  );

  usb_rx u_usb_rx (
    .clk(clk),
    .n_rst(n_rst),
    // Physical
    .dp_in(dp_in),
    .dm_in(dm_in),
    // To AHB
    .rx_packet(rx_packet),
    .rx_data_ready(rx_data_ready),
    .rx_transfer_active(rx_transfer_active),
    .rx_error(rx_error),
    // To Data Buffer
    .rx_packet_data(rx_packet_data),
    .store_rx_packet_data(store_rx_packet_data),
    .flush(flush),
    .buffer_occupancy(buffer_occupancy)
  );


  usb_tx u_usb_tx (
    .clk(clk),
    .n_rst(n_rst),
    // Physical
    .dp_out(dp_out),
    .dm_out(dm_out),
    // From AHB
    .tx_packet(tx_packet),
    // To AHB
    .tx_transfer_active(tx_transfer_active),
    .tx_error(tx_error),
    // From Data Buffer
    .tx_packet_data(tx_packet_data),
    .get_tx_packet_data(get_tx_packet_data)
  );

endmodule
