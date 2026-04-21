// AHB Subordinate Interface

module ahb_subordinate (
    // h signals
    input logic clk, n_rst,
    input logic hsel,
    input logic [3:0] haddr,
    input logic [1:0] htrans, hsize,
    input logic hwrite,
    input logic [31:0] hwdata,
    input logic [2:0] hburst, // bonus
    output logic [31:0] hrdata,
    output logic hready, hresp,
    // rx related signals
    input logic [2:0] rx_packet,
    input logic rx_data_ready, rx_transfer_active, rx_error
    // data buffer signals
    input logic buffer_occupancy,
    input logic [7:0] rx_data,
    output logic get_rx_data, store_tx_data,
    output logic [7:0] tx_data,
    output logic clear,
    // tx related signals
    output logic [1:0] tx_packet,
    input logic tx_transfer_active, tx_error
);

endmodule