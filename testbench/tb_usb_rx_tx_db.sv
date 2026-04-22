`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_usb_rx_tx_db ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end
    logic [6:0] occ_before;
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

    logic last_dp;
    logic last_dm;

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

    task automatic send_bit(input logic b);
    begin
        if (b == 1'b0) begin
            last_dp = ~last_dp;
            last_dm = ~last_dm;
        end
        dp_in = last_dp;
        dm_in = last_dm;
        repeat (8) @(negedge clk);
    end
    endtask

    task automatic send_eop;
    begin
        dp_in = 1'b0;
        dm_in = 1'b0;
        repeat (16) @(negedge clk);
        dp_in   = 1'b1;
        dm_in   = 1'b0;
        last_dp = 1'b1;
        last_dm = 1'b0;
        repeat (8) @(negedge clk);
    end
    endtask

    task automatic send_in_token;
    begin
        last_dp = 1'b1;
        last_dm = 1'b0;
        dp_in   = 1'b1;
        dm_in   = 1'b0;
        repeat (8) @(negedge clk);

        send_bit(0); send_bit(0); send_bit(0); send_bit(0);
        send_bit(0); send_bit(0); send_bit(0); send_bit(1);

send_bit(1); send_bit(0); send_bit(0); send_bit(1);
send_bit(0); send_bit(1); send_bit(1); send_bit(0);

        send_bit(0); send_bit(0); send_bit(0); send_bit(0);
        send_bit(0); send_bit(0); send_bit(0);

        send_bit(0); send_bit(0); send_bit(0); send_bit(0);

        send_bit(0); send_bit(0); send_bit(1); send_bit(1); send_bit(0);

        send_eop();
    end
    endtask

    task automatic send_ack_handshake;
    begin
        last_dp = 1'b1;
        last_dm = 1'b0;
        dp_in   = 1'b1;
        dm_in   = 1'b0;
        repeat (16) @(negedge clk);

        send_bit(0); send_bit(0); send_bit(0); send_bit(0);
        send_bit(0); send_bit(0); send_bit(0); send_bit(1);

        send_bit(0); send_bit(1); send_bit(0); send_bit(0);
        send_bit(1); send_bit(0); send_bit(1); send_bit(1);

        send_eop();
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
       task automatic send_data_packet(input logic [7:0] data_byte, input logic [15:0] crc16);
begin
    last_dp = 1'b1;
    last_dm = 1'b0;
    dp_in   = 1'b1;
    dm_in   = 1'b0;
    repeat (8) @(negedge clk);

    // SYNC
    send_bit(0); send_bit(0); send_bit(0); send_bit(0);
    send_bit(0); send_bit(0); send_bit(0); send_bit(1);

    // PID = DATA0
    send_bit(1); send_bit(1); send_bit(0); send_bit(0);
    send_bit(0); send_bit(0); send_bit(1); send_bit(1);

    // Send one byte payload LSB first
    send_bit(data_byte[0]);
    send_bit(data_byte[1]);
    send_bit(data_byte[2]);
    send_bit(data_byte[3]);
    send_bit(data_byte[4]);
    send_bit(data_byte[5]);
    send_bit(data_byte[6]);
    send_bit(data_byte[7]);

    // CRC16 LSB first, low byte then high byte
    send_bit(crc16[0]);  send_bit(crc16[1]);  send_bit(crc16[2]);  send_bit(crc16[3]);
    send_bit(crc16[4]);  send_bit(crc16[5]);  send_bit(crc16[6]);  send_bit(crc16[7]);
    send_bit(crc16[8]);  send_bit(crc16[9]);  send_bit(crc16[10]); send_bit(crc16[11]);
    send_bit(crc16[12]); send_bit(crc16[13]); send_bit(crc16[14]); send_bit(crc16[15]);

    send_eop();
end
endtask

    initial begin
    n_rst         = 1;
    dp_in         = 1;
    dm_in         = 0;
    tx_packet     = 0;
    store_tx_data = 0;
    tx_data       = 0;
    get_rx_data   = 0;
    clear         = 0;
    last_dp       = 1;
    last_dm       = 0;

    reset_dut();

    // AHB Subordinate <-> Data Buffer

    // Write three bytes into FIFO and verify occupancy
    @(negedge clk); tx_data = 8'hAA; store_tx_data = 1;
    @(negedge clk); store_tx_data = 0;
    @(negedge clk); tx_data = 8'hBB; store_tx_data = 1;
    @(negedge clk); store_tx_data = 0;
    @(negedge clk); tx_data = 8'hCC; store_tx_data = 1;
    @(negedge clk); store_tx_data = 0;

    @(negedge clk);
    if (buffer_occupancy == 3)
        $display("[%0t] PASS: FIFO stores incoming AHB data", $time);

    // Read FIFO contents sequentially
    @(negedge clk);
    if (rx_data == 8'hAA)
        $display("[%0t] PASS: FIFO outputs first byte", $time);
    get_rx_data = 1; @(negedge clk); get_rx_data = 0;

    @(negedge clk);
    if (rx_data == 8'hBB)
        $display("[%0t] PASS: FIFO outputs second byte", $time);
    get_rx_data = 1; @(negedge clk); get_rx_data = 0;

    @(negedge clk);
    if (rx_data == 8'hCC)
        $display("[%0t] PASS: FIFO outputs third byte", $time);
    get_rx_data = 1; @(negedge clk); get_rx_data = 0;

    // Clear FIFO and verify occupancy resets
    @(negedge clk); clear = 1;
    @(negedge clk); clear = 0;

    @(negedge clk);
    if (buffer_occupancy == 0)
        $display("[%0t] PASS: FIFO clears correctly", $time);

    // TX Module <-> AHB Subordinate

    // Send ACK packet and verify TX completes without error
    @(negedge clk);
    tx_packet = 3'd3;
    @(posedge tx_transfer_active);
    @(negedge tx_transfer_active);
    tx_packet = 0;

    if (!tx_error)
        $display("[%0t] PASS: TX sends ACK successfully", $time);

    // Send DATA0 packet and verify TX completes without error

    @(negedge clk);
    tx_packet = 3'd1;
    @(posedge tx_transfer_active);
    @(negedge tx_transfer_active);
    tx_packet = 0;
    if (!tx_error)
        $display("[%0t] PASS: AHB commands TX to send DATA0", $time);
    else
        $display("[%0t] FAIL: DATA0 transmission error", $time);

    // Send NAK packet and verify TX completes without error

    @(negedge clk);
    tx_packet = 3'd4;
    @(posedge tx_transfer_active);
    @(negedge tx_transfer_active);
    tx_packet = 0;
    if (!tx_error)
        $display("[%0t] PASS: AHB commands TX to send NAK", $time);
    else
        $display("[%0t] FAIL: NAK transmission error", $time);

    // Send STALL packet and verify TX completes without error

    @(negedge clk);
    tx_packet = 3'd5;
    @(posedge tx_transfer_active);
    @(negedge tx_transfer_active);
    tx_packet = 0;
    if (!tx_error)
        $display("[%0t] PASS: AHB commands TX to send STALL", $time);
    else
        $display("[%0t] FAIL: STALL transmission error", $time);


    // Data Buffer <-> TX

    // Load FIFO and verify TX transmits buffered data
    @(negedge clk); clear = 1;
    @(negedge clk); clear = 0;

    @(negedge clk); tx_data = 8'hA1; store_tx_data = 1;
    @(negedge clk); store_tx_data = 0;
    @(negedge clk); tx_data = 8'hB2; store_tx_data = 1;
    @(negedge clk); store_tx_data = 0;
    @(negedge clk); tx_data = 8'hC3; store_tx_data = 1;
    @(negedge clk); store_tx_data = 0;

    @(negedge clk);
    tx_packet = 3'd1;
    send_in_token();

    @(posedge tx_transfer_active);
    @(negedge tx_transfer_active);
    tx_packet = 0;

    if (!tx_error)
        $display("[%0t] PASS: TX sends DATA0 from FIFO", $time);

    send_ack_handshake();
    repeat (32) @(negedge clk);

    if (buffer_occupancy == 0)
        $display("[%0t] PASS: FIFO empties after ACK", $time);


    // Data Buffer <-> TX with NAK/STALL

    // Verify NAK response preserves FIFO contents
    @(negedge clk); clear = 1;
    @(negedge clk); clear = 0;
    @(negedge clk); tx_data = 8'hDE; store_tx_data = 1;
    @(negedge clk); store_tx_data = 0;
    @(negedge clk); tx_data = 8'hAD; store_tx_data = 1;
    @(negedge clk); store_tx_data = 0;

    @(negedge clk);
    occ_before = buffer_occupancy;
    tx_packet = 3'd4;
    send_in_token();

    @(posedge tx_transfer_active);
    @(negedge tx_transfer_active);

    if (buffer_occupancy == occ_before)
        $display("[%0t] PASS: NAK preserves FIFO data", $time);

    // Verify STALL response preserves FIFO contents
    tx_packet = 3'd5;
    occ_before = buffer_occupancy;
    send_in_token();

    @(posedge tx_transfer_active);
    @(negedge tx_transfer_active);

    if (buffer_occupancy == occ_before)
        $display("[%0t] PASS: STALL preserves FIFO data", $time);


    // Data Buffer <-> RX

    @(negedge clk); clear = 1;

    @(negedge clk); clear = 0;

    send_data_packet(8'h5A,16'h3E64);

    repeat (40) @(negedge clk);

    if (buffer_occupancy == 1)

        $display("[%0t] PASS: RX stores received byte in FIFO", $time);

    else

        $display("[%0t] FAIL: RX did not store received byte", $time);

    // Read received byte from FIFO and verify correctness

    @(negedge clk);

    if (rx_data == 8'h5A)

        $display("[%0t] PASS: FIFO outputs RX received byte", $time);

    else

        $display("[%0t] FAIL: FIFO output mismatch after RX", $time);

    get_rx_data = 1;

    @(negedge clk);

    get_rx_data = 0;



    $finish;
    end
endmodule

/* verilator coverage_on */
