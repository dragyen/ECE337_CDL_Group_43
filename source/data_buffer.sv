`timescale 1ns / 10ps


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

    logic [7:0] reg_mem [0:63];
    logic [6:0] write_ptr, read_ptr, counter;
    logic [6:0] next_write_ptr, next_read_ptr, next_counter;
    logic [7:0] next_reg_mem [0:63];
    logic full, empty;

    assign full = (counter == 7'd64);
    assign empty = (counter == 7'd0);
    assign tx_packet_data = reg_mem[read_ptr];
    assign rx_data = reg_mem[read_ptr];
    assign buffer_occupancy = counter;

    always_comb begin
        next_write_ptr = write_ptr;
        next_read_ptr = read_ptr;
        next_counter = counter;

        if (flush | clear) begin
            next_write_ptr = 0;
            next_read_ptr = 0;
            next_counter = 0;
        end else begin
            if ((store_tx_data | store_rx_packet_data) && !full) begin
                next_write_ptr = (write_ptr + 1) % 64;
                next_counter = counter + 1;
            end
            if ((get_tx_packet_data | get_rx_data) && !empty) begin
                next_read_ptr = (read_ptr + 1) % 64;
                next_counter = next_counter - 1;
            end
        end
    end

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            write_ptr <= 0;
            read_ptr <= 0;
            counter <= 0;
        end else begin
            write_ptr <= next_write_ptr;
            read_ptr <= next_read_ptr;
            counter <= next_counter;
            if (store_tx_data && !full) 
                reg_mem[write_ptr] <= tx_data;
            else if (store_rx_packet_data && !full)
                reg_mem[write_ptr] <= rx_packet_data;
            end
        end

endmodule