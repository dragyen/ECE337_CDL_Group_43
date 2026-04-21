`timescale 1ns / 10ps
module usb_rx_tx_db #(
// parameters
) (
  input  logic clk,
  input  logic n_rst,
  // AHB -> Data Buffer (inputs)
  input  logic store_tx_data,
  input  logic [7:0] tx_data,
  input  logic get_rx_data,
  input  logic clear,
  // Data Buffer -> AHB (outputs)
  output logic [7:0] rx_data,
  output logic [6:0] buffer_occupancy,
  // AHB -> USB TX (inputs)
  input  logic [2:0] tx_packet,
  // USB RX -> AHB (outputs)
  output logic [3:0] rx_packet,
  output logic rx_data_ready,
  output logic rx_transfer_active,
  output logic rx_error,
  // USB TX -> AHB (outputs)
  output logic tx_transfer_active,
  output logic tx_error,
  // USB Physical Interface
  input  logic dp_in,
  input  logic dm_in,
  output logic dp_out,
  output logic dm_out
);

  // Data Buffer <-> USB RX
  logic [7:0] rx_packet_data;
  logic store_rx_packet_data;
  logic flush;
  // Data Buffer <-> USB TX
  logic [7:0] tx_packet_data;
  logic get_tx_packet_data;

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
    .get_tx_packet_data(get_tx_packet_data),
    .buffer_occupancy(buffer_occupancy)
  );

endmodule
