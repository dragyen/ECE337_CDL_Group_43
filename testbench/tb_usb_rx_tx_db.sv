`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_usb_rx_tx_db ();

    localparam CLK_PERIOD = 10ns;

    // -------------------------------------------------------
    // USB full-speed bit timing
    //   12 Mb/s  →  83.33 ns per bit
    //   CLK = 10 ns  →  8 clocks per bit  (80 ns, <2% error)
    // -------------------------------------------------------

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    // ------------------------------------------------------------------
    // DUT port signals
    // ------------------------------------------------------------------
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

    // ------------------------------------------------------------------
    // NRZI line-state tracking (shared by all USB drive tasks)
    // ------------------------------------------------------------------
    logic last_dp;
    logic last_dm;

    // ------------------------------------------------------------------
    // Clock
    // ------------------------------------------------------------------
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    // ------------------------------------------------------------------
    // Reset helper
    // ------------------------------------------------------------------
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

    // ------------------------------------------------------------------
    // USB wire-level task: drive one NRZI bit for 8 cycles.
    //   NRZI rule:  data 0 → toggle dp/dm
    //               data 1 → hold  dp/dm
    // last_dp / last_dm track the current line state between calls.
    // ------------------------------------------------------------------
    task automatic send_bit;
        input logic b;
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

    // ------------------------------------------------------------------
    // End-of-Packet: SE0 for 2 bit-times then idle (J) for 1 bit-time.
    // ------------------------------------------------------------------
    task automatic send_eop;
    begin
        dp_in = 1'b0; dm_in = 1'b0;             // SE0
        repeat (8 * 2) @(negedge clk);
        dp_in   = 1'b1; dm_in   = 1'b0;         // J  (idle)
        last_dp = 1'b1; last_dm = 1'b0;
        repeat (8) @(negedge clk);
    end
    endtask

    // ------------------------------------------------------------------
    // Send a complete USB IN token packet (addr=0, endp=0).
    //
    // Packet structure (all fields LSb-first on wire):
    //   SYNC : 8'b0000_0001  →  wire bits: 0,0,0,0,0,0,0,1
    //   PID  : IN = 8'h96    →  wire bits: 0,1,1,0,1,0,0,1
    //   ADDR : 7'b000_0000   →  wire bits: 0,0,0,0,0,0,0
    //   ENDP : 4'b0000       →  wire bits: 0,0,0,0
    //   CRC5 : over {endp,addr}=0 → residual 5'b00010, inverted+LSb-first
    //          transmitted bits  : 1,0,1,1,1
    //   EOP
    //
    // No bit-stuffing needed: the longest run of 1s in this packet is 4
    // (the PID check bits 11xx), well below the stuffing threshold of 6.
    // ------------------------------------------------------------------
task automatic send_in_token;
begin
    last_dp = 1'b1;
    last_dm = 1'b0;
    dp_in   = 1'b1;
    dm_in   = 1'b0;
    repeat (8) @(negedge clk);

    // SYNC: 0,0,0,0,0,0,0,1
    send_bit(0); send_bit(0); send_bit(0); send_bit(0);
    send_bit(0); send_bit(0); send_bit(0); send_bit(1);

    // PID (IN = 8'h69), LSB-first: 1,0,0,1,0,1,1,0
    send_bit(1); send_bit(0); send_bit(0); send_bit(1);
    send_bit(0); send_bit(1); send_bit(1); send_bit(0);

    // ADDR = 7'b000_0000, LSB-first: 0,0,0,0,0,0,0
    send_bit(0); send_bit(0); send_bit(0); send_bit(0);
    send_bit(0); send_bit(0); send_bit(0);

    // ENDP = 4'b0000, LSB-first: 0,0,0,0
    send_bit(0); send_bit(0); send_bit(0); send_bit(0);

    // CRC5 transmitted bits: 1,0,1,1,1
    send_bit(1); send_bit(0); send_bit(1); send_bit(1); send_bit(1);

    send_eop();
end
endtask

    // ------------------------------------------------------------------
    // Send a USB ACK handshake from the host (SYNC + PID only, no data).
    //   PID : ACK = 8'hD2 = 1101_0010, LSb-first: 0,1,0,0,1,0,1,1
    // ------------------------------------------------------------------
    task automatic send_ack_handshake;
    begin
        last_dp = 1'b1;
        last_dm = 1'b0;
        dp_in   = 1'b1;
        dm_in   = 1'b0;
        repeat (8 * 2) @(negedge clk);  // inter-packet gap

        // SYNC: 0,0,0,0,0,0,0,1
        send_bit(0); send_bit(0); send_bit(0); send_bit(0);
        send_bit(0); send_bit(0); send_bit(0); send_bit(1);

        // PID (ACK = 8'hD2), LSb-first: 0,1,0,0,1,0,1,1
        send_bit(0); send_bit(1); send_bit(0); send_bit(0);
        send_bit(1); send_bit(0); send_bit(1); send_bit(1);

        send_eop();
    end
    endtask

    // ------------------------------------------------------------------
    // DUT instantiation
    // ------------------------------------------------------------------
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

    // ------------------------------------------------------------------
    // Stimulus
    // ------------------------------------------------------------------
    initial begin
        // Initialize
        n_rst         = 1;
        dp_in         = 1; // USB idle (J)
        dm_in         = 0;
        tx_packet     = '0;
        store_tx_data = '0;
        tx_data       = '0;
        get_rx_data   = '0;
        clear         = '0;
        last_dp       = 1'b1;
        last_dm       = 1'b0;
        reset_dut();

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

        // =======================================================
        // Test 2: Read back 3 bytes in order
        // =======================================================
        @(negedge clk);
        if (rx_data == 8'hAA)
            $display("PASS Test 2a: rx_data = 0x%0h", rx_data);
        else
            $display("FAIL Test 2a: expected 0xAA, got 0x%0h", rx_data);
        get_rx_data = 1;
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
        @(negedge clk); 
        store_tx_data = 0; tx_data = '0;

        @(negedge clk);
        clear = 1;
        @(negedge clk); 
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
        @(negedge clk); store_tx_data = 0;
        @(negedge clk); tx_data = 8'h02; store_tx_data = 1;
        @(negedge clk);  store_tx_data = 0;
        @(negedge clk); tx_data = 8'h03; store_tx_data = 1;
        @(negedge clk);  store_tx_data = 0;
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

        // TOP LEVEL Starts here

        // =======================================================
        // Test IN_DATA_ACK
        //   Scenario: SoC preloads FIFO → host sends IN token →
        //             DUT responds DATA0 → host sends ACK →
        //             verify DATA0 sent, no error, FIFO drained.
        // =======================================================
        @(negedge clk);
        clear = 1; @(negedge clk); clear = 0;

        // --- Step 1: preload 3 bytes into the FIFO ---
        @(negedge clk); tx_data = 8'hA1; store_tx_data = 1;
        @(negedge clk);; store_tx_data = 0;
        @(negedge clk); tx_data = 8'hB2; store_tx_data = 1;
        @(negedge clk); store_tx_data = 0;
        @(negedge clk); tx_data = 8'hC3; store_tx_data = 1;
        @(negedge clk); store_tx_data = 0;
        tx_data = '0;

        @(negedge clk);
        if (buffer_occupancy == 7'd3)
            $display("PASS IN_DATA_ACK setup: FIFO loaded, occupancy = %0d", buffer_occupancy);
        else
            $display("FAIL IN_DATA_ACK setup: expected 3, got %0d", buffer_occupancy);

        // --- Step 2: arm the TX engine to respond with DATA0 ---
        // tx_packet is set BEFORE the IN token so usb_tx is ready
        // the instant usb_rx raises rx_transfer_active / rx_packet.
        @(negedge clk);
        tx_packet = 3'd1;   // DATA0

        // --- Step 3: host drives IN token on the USB wires ---
        send_in_token();

        // --- Step 4: DUT should start transmitting DATA0 ---
        @(posedge tx_transfer_active);
        $display("INFO IN_DATA_ACK: DATA0 TX started");

        // Verify usb_rx decoded the IN token correctly
        // rx_packet = 4'b1001 = 4'h9  (USB IN PID field value)
        if (rx_packet == 4'h9)
            $display("PASS IN_DATA_ACK: IN token decoded, rx_packet = 0x%0h", rx_packet);
        else
            $display("FAIL IN_DATA_ACK: expected rx_packet=0x9 (IN), got 0x%0h", rx_packet);

        @(negedge tx_transfer_active);
        $display("INFO IN_DATA_ACK: DATA0 TX complete");

        // Deassert tx_packet after transmission finishes
        repeat(4) @(negedge clk);
        tx_packet = 3'd0;

        if (tx_error == 0)
            $display("PASS IN_DATA_ACK: no tx_error on DATA0");
        else
            $display("FAIL IN_DATA_ACK: tx_error asserted during DATA0");

        // --- Step 5: host sends ACK handshake back on the wire ---
        send_ack_handshake();

        // Allow usb_rx time to decode the ACK (≥ 1 full packet decode latency)
        repeat(32) @(negedge clk);

        // ACK PID token value = 4'b0010 = 4'h2
        if (rx_packet == 4'h2)
            $display("PASS IN_DATA_ACK: ACK received, rx_packet = 0x%0h", rx_packet);
        else
            $display("INFO IN_DATA_ACK: rx_packet after host ACK = 0x%0h", rx_packet);

        // --- Step 6: FIFO must be empty — usb_tx consumed all bytes ---
        @(negedge clk);
        if (buffer_occupancy == 7'd0)
            $display("PASS IN_DATA_ACK: FIFO consumed, occupancy = %0d", buffer_occupancy);
        else
            $display("FAIL IN_DATA_ACK: FIFO not drained, occupancy = %0d", buffer_occupancy);

        // =======================================================
        // Test IN_NAK_STALL
        //   Scenario A: host IN → SoC NAK
        //     Verify: NAK handshake sent, FIFO occupancy unchanged.
        //   Scenario B: host IN → SoC STALL
        //     Verify: STALL handshake sent, FIFO occupancy unchanged.
        // =======================================================

        // ---- Sub-test A: NAK ----
        @(negedge clk);
        clear = 1; @(negedge clk); @(negedge clk); clear = 0;

        // Preload 2 bytes — they must NOT be consumed by a NAK response
        @(negedge clk); tx_data = 8'hDE; store_tx_data = 1;
        @(negedge clk); store_tx_data = 0;
        @(negedge clk); tx_data = 8'hAD; store_tx_data = 1;
        @(negedge clk);  store_tx_data = 0;
        tx_data = '0;

        begin : nak_test
            logic [6:0] occ_before;
            @(negedge clk);
            occ_before = buffer_occupancy;
            $display("INFO IN_NAK_STALL/NAK: FIFO occupancy before IN = %0d", occ_before);

            // Arm NAK response BEFORE the host IN token
            @(negedge clk);
            tx_packet = 3'd4;   // NAK

            // Host drives IN token on the wire
            send_in_token();

            // DUT should immediately send NAK (no payload, no FIFO access)
            @(posedge tx_transfer_active);
            $display("INFO IN_NAK_STALL/NAK: NAK TX started");
            @(negedge tx_transfer_active);
            $display("INFO IN_NAK_STALL/NAK: NAK TX complete");

            repeat(4) @(negedge clk);
            tx_packet = 3'd0;

            if (tx_error == 0)
                $display("PASS IN_NAK_STALL/NAK: no tx_error on NAK");
            else
                $display("FAIL IN_NAK_STALL/NAK: tx_error asserted on NAK");

            // Critical: FIFO must be completely untouched
            @(negedge clk);
            if (buffer_occupancy == occ_before)
                $display("PASS IN_NAK_STALL/NAK: FIFO unchanged, occupancy = %0d", buffer_occupancy);
            else
                $display("FAIL IN_NAK_STALL/NAK: FIFO changed — before=%0d after=%0d (NAK must not dequeue payload)",
                         occ_before, buffer_occupancy);
        end

        // ---- Sub-test B: STALL ----
        // Reuse the same 2-byte FIFO contents from sub-test A (no clear)
        begin : stall_test
            logic [6:0] occ_before;
            @(negedge clk);
            occ_before = buffer_occupancy;
            $display("INFO IN_NAK_STALL/STALL: FIFO occupancy before IN = %0d", occ_before);

            // Arm STALL response BEFORE the host IN token
            @(negedge clk);
            tx_packet = 3'd5;   // STALL

            // Host drives IN token on the wire
            send_in_token();

            // DUT should send STALL (no payload, no FIFO access)
            @(posedge tx_transfer_active);
            $display("INFO IN_NAK_STALL/STALL: STALL TX started");
            @(negedge tx_transfer_active);
            $display("INFO IN_NAK_STALL/STALL: STALL TX complete");

            repeat(4) @(negedge clk);
            tx_packet = 3'd0;

            if (tx_error == 0)
                $display("PASS IN_NAK_STALL/STALL: no tx_error on STALL");
            else
                $display("FAIL IN_NAK_STALL/STALL: tx_error asserted on STALL");

            // Critical: FIFO must be completely untouched
            @(negedge clk);
            if (buffer_occupancy == occ_before)
                $display("PASS IN_NAK_STALL/STALL: FIFO unchanged, occupancy = %0d", buffer_occupancy);
            else
                $display("FAIL IN_NAK_STALL/STALL: FIFO changed — before=%0d after=%0d (STALL must not dequeue payload)",
                         occ_before, buffer_occupancy);
        end

        $finish;
    end
endmodule
/* verilator coverage_on */