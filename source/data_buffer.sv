`timescale 1ns / 10ps
/* verilator coverage_off */

module data_buffer (
    input logic clk,
    input logic n_rst,
    input logic [7:0] tx_data,
    input logic [7:0] rx_packet_data,
    input logic store_tx_data,
    input logic store_rx_packet_data,
    input logic get_tx_packet_data,
    input logic get_rx_data,
    input logic clear,
    input logic flush,
    output logic [6:0] buffer_occupancy,
    output logic [7:0] tx_packet_data,
    output logic [7:0] rx_data
);

    // 64 x 8-bit memory (flattened to avoid bad reg inference)
    logic [511:0] reg_mem;

    logic [5:0] write_ptr, read_ptr;
    logic [5:0] next_write_ptr, next_read_ptr;
    logic [6:0] counter, next_counter;

    logic full, empty;

    logic [7:0] write_data;
    logic [7:0] read_data;

    assign full  = (counter == 7'd64);
    assign empty = (counter == 7'd0);
    assign buffer_occupancy = counter;

    // READ PATH
    assign read_data = reg_mem[read_ptr*8 +: 8];
    assign tx_packet_data = read_data;
    assign rx_data        = read_data;

    // WRITE DATA SELECT
    assign write_data =
        store_tx_data        ? tx_data :
        store_rx_packet_data ? rx_packet_data :
        8'd0;

    // POINTER / COUNTER LOGIC
    always_comb begin
        next_write_ptr = write_ptr;
        next_read_ptr  = read_ptr;
        next_counter   = counter;

        if (flush || clear) begin
            next_write_ptr = 0;
            next_read_ptr  = 0;
            next_counter    = 0;
        end else begin
            if ((store_tx_data || store_rx_packet_data) && !full) begin
                next_write_ptr = write_ptr + 1;
                next_counter   = counter + 1;
            end

            if ((get_tx_packet_data || get_rx_data) && !empty) begin
                next_read_ptr = read_ptr + 1;
                next_counter  = counter - 1;
            end
        end
    end

    // SEQUENTIAL LOGIC
    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            write_ptr <= 0;
            read_ptr  <= 0;
            counter   <= 0;
            reg_mem   <= '0;
        end else begin
            write_ptr <= next_write_ptr;
            read_ptr  <= next_read_ptr;
            counter   <= next_counter;

            // FIXED WRITE (this is the key fix for your Q error)
            if ((store_tx_data || store_rx_packet_data) && !full) begin
                reg_mem[write_ptr*8 +: 8] <= write_data;
            end
        end
    end

endmodule

/* verilator coverage_on */
