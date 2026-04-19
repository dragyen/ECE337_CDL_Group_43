`timescale 1ns / 10ps
/* verilator coverage_off */
module tb_data_buffer ();
    localparam CLK_PERIOD = 2.5ns;
    logic clk, n_rst;
    logic [7:0] tx_data;
    logic [7:0] rx_packet_data;
    logic store_tx_data;
    logic store_rx_packet_data;
    logic get_tx_packet_data;
    logic get_rx_data;
    logic clear;
    logic flush;
    logic [6:0] buffer_occupancy;
    logic [7:0] tx_packet_data;
    logic [7:0] rx_data;

data_buffer DUT (
    .clk(clk),
    .n_rst(n_rst),
    .tx_data(tx_data),
    .rx_packet_data(rx_packet_data),
    .store_tx_data(store_tx_data),
    .store_rx_packet_data(store_rx_packet_data),
    .get_tx_packet_data(get_tx_packet_data),
    .get_rx_data(get_rx_data),
    .clear(clear),
    .flush(flush),
    .buffer_occupancy(buffer_occupancy),
    .tx_packet_data(tx_packet_data),
    .rx_data(rx_data)
);

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
    @(negedge clk);
    @(negedge clk);
end
endtask

task init_signals;
begin
    tx_data = 8'h00;
    rx_packet_data = 8'h00;
    store_tx_data = 0;
    store_rx_packet_data = 0;
    get_tx_packet_data = 0;
    get_rx_data = 0;
    clear = 0;
    flush = 0;
end
endtask

initial begin
    n_rst = 1;
    init_signals();
    reset_dut();

    // tx write logic 

    flush = 1;
    @(negedge clk);
    flush = 0;
    @(negedge clk);

    tx_data = 8'hAB;
    store_tx_data = 1;
    @(negedge clk);
    store_tx_data = 0;
    @(negedge clk);

    if (tx_packet_data !== 8'hAB) begin
        $error("FAILED TX Write: expected tx_packet_data = 0xAB, got 0x%0h", tx_packet_data);
    end else begin
        $display("PASSED TX Write");
    end

   // tx read logic
    get_tx_packet_data = 1;
    @(negedge clk);
    get_tx_packet_data = 0;
    @(negedge clk);

    if (buffer_occupancy !== 7'd0) begin
        $error("FAILED TX Read: expected buffer_occupancy = 0, got %0d", buffer_occupancy);
    end else begin
        $display("PASSED TX Read");
    end

    reset_dut();
    init_signals();

   // rx write
    flush = 1;
    @(negedge clk);
    flush = 0;
    @(negedge clk);

    rx_packet_data = 8'hCD;
    store_rx_packet_data = 1;
    @(negedge clk);
    store_rx_packet_data = 0;
    @(negedge clk);

    if (rx_data !== 8'hCD) begin
        $error("FAILED RX Write: expected rx_data = 0xCD, got 0x%0h", rx_data);
    end else begin
        $display("PASSED RX Write");
    end

    // rx read check

    get_rx_data = 1;
    @(negedge clk);
    get_rx_data = 0;
    @(negedge clk);

    if (buffer_occupancy !== 7'd0) begin
        $error("FAILED RX Read: expected buffer_occupancy = 0, got %0d", buffer_occupancy);
    end else begin
        $display("PASSED RX Read");
    end

    reset_dut();
    init_signals();

    // full error flag

    flush = 1;
    @(negedge clk);
    flush = 0;
    @(negedge clk);

    for (int i = 0; i < 64; i++) begin
        tx_data = i[7:0];
        store_tx_data = 1;
        @(negedge clk);
        store_tx_data = 0;
        @(negedge clk);
    end

    if (buffer_occupancy !== 7'd64) begin
        $error("FAILED Full Buffer: expected occupancy = 64, got %0d", buffer_occupancy);
    end else begin
        $display("PASSED Full Buffer");
    end

    // try to write when full - occupancy should stay 64
    tx_data = 8'hFF;
    store_tx_data = 1;
    @(negedge clk);
    store_tx_data = 0;
    @(negedge clk);

    if (buffer_occupancy !== 7'd64) begin
        $error("FAILED Overflow Protection: expected occupancy = 64, got %0d", buffer_occupancy);
    end else begin
        $display("PASSED Overflow Protection");
    end

    // try to read when empty

    flush = 1;
    @(negedge clk);
    flush = 0;
    @(negedge clk);

    get_tx_packet_data = 1;
    @(negedge clk);
    get_tx_packet_data = 0;
    @(negedge clk);

    if (buffer_occupancy !== 7'd0) begin
        $error("FAILED Underflow Protection: expected occupancy = 0, got %0d", buffer_occupancy);
    end else begin
        $display("PASSED Underflow Protection");
    end

    reset_dut();
    init_signals();

    // flush logic 

    tx_data = 8'hAA;
    store_tx_data = 1;
    @(negedge clk);
    store_tx_data = 0;
    @(negedge clk);
    tx_data = 8'hBB;
    store_tx_data = 1;
    @(negedge clk);
    store_tx_data = 0;
    @(negedge clk);

    flush = 1;
    @(negedge clk);
    flush = 0;
    @(negedge clk);

    if (buffer_occupancy !== 7'd0) begin
        $error("FAILED Flush: expected occupancy = 0, got %0d", buffer_occupancy);
    end else begin
        $display("PASSED Flush");
    end

    // clear logic

    tx_data = 8'hCC;
    store_tx_data = 1;
    @(negedge clk);
    store_tx_data = 0;
    @(negedge clk);

    clear = 1;
    @(negedge clk);
    clear = 0;
    @(negedge clk);

    if (buffer_occupancy !== 7'd0) begin
        $error("FAILED Clear: expected occupancy = 0, got %0d", buffer_occupancy);
    end else begin
        $display("PASSED Clear");
    end

    reset_dut();
    $finish;
end
endmodule
/* verilator coverage_on */
