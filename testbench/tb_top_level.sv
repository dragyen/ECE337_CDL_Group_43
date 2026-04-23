`timescale 1ns/10ps
module tb_top_level();
    logic clk, n_rst;
    logic store_tx_data;
    logic [7:0] tx_data;
    logic get_rx_data;
    logic clear;
    logic [7:0] rx_data;
    logic [6:0] buffer_occupancy;
    logic [2:0] tx_packet;
    logic [3:0] rx_packet;
    logic rx_data_ready, rx_transfer_active, rx_error;
    logic tx_transfer_active, tx_error;
    logic dp_in, dm_in, dp_out, dm_out;

    top_level DUT (.*);

    localparam CLK_PERIOD       = 10;
    localparam BIT_PERIOD       = 83.33;
    localparam USB_CLKS_PER_BIT = 8;

    localparam logic [6:0] USB_ADDR    = 7'h00;
    localparam logic [3:0] USB_ENDP    = 4'h0;
    localparam logic [4:0] DUMMY_CRC5  = 5'h02;
    localparam logic [15:0] DUMMY_CRC16 = 16'h3E64;

    logic cur_line;

    always begin
        clk = 0; #(CLK_PERIOD/2);
        clk = 1; #(CLK_PERIOD/2);
    end

    logic rx_error_seen, tx_error_seen;
    logic rx_data_ready_seen;
    logic [3:0] rx_packet_captured;

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            rx_error_seen      <= 0;
            tx_error_seen      <= 0;
            rx_data_ready_seen <= 0;
            rx_packet_captured <= 0;
        end else begin
            if (rx_error)       rx_error_seen      <= 1;
            if (tx_error)       tx_error_seen      <= 1;
            if (rx_data_ready) begin
                rx_data_ready_seen <= 1;
                rx_packet_captured <= rx_packet;
            end
        end
    end

    task reset_dut();
        n_rst         = 0;
        dp_in         = 1; dm_in = 0;
        cur_line      = 1;
        store_tx_data = 0;
        tx_data       = 0;
        get_rx_data   = 0;
        clear         = 0;
        tx_packet     = 0;
        @(posedge clk); #1;
        n_rst = 1;
        @(posedge clk); #1;
    endtask

    task send_bit(input logic b);
        if (b == 0) cur_line = ~cur_line;
        dp_in = cur_line;
        dm_in = ~cur_line;
        #(BIT_PERIOD);
    endtask

    task send_byte_lsb(input logic [7:0] data);
        for (int i = 0; i < 8; i++) send_bit(data[i]);
    endtask

    task send_sync();
        send_byte_lsb(8'b10000000);
    endtask

    task send_pid(input logic [3:0] pid_val);
        logic [3:0] check_bits;
        logic [7:0] pid_byte;
        check_bits = ~pid_val;
        pid_byte   = {check_bits, pid_val};
        send_byte_lsb(pid_byte);
    endtask

    task send_eop();
        dp_in = 0; dm_in = 0;
        #(BIT_PERIOD * 2);
        dp_in = 1; dm_in = 0;
        cur_line = 1;
        #(BIT_PERIOD);
    endtask

    task send_token_fields(input logic [6:0] addr, input logic [3:0] endp, input logic [4:0] crc5);
        for (int i = 0; i < 7; i++) send_bit(addr[i]);
        for (int i = 0; i < 4; i++) send_bit(endp[i]);
        for (int i = 0; i < 5; i++) send_bit(crc5[i]);
    endtask

    task send_data_payload(input logic [7:0] data[], input int len, input logic [15:0] crc16);
        for (int i = 0; i < len; i++) send_byte_lsb(data[i]);
        send_byte_lsb(crc16[7:0]);
        send_byte_lsb(crc16[15:8]);
    endtask

    task send_out_token(input logic [6:0] addr, input logic [3:0] endp, input logic [4:0] crc5);
        send_sync(); send_pid(4'b0001); send_token_fields(addr, endp, crc5); send_eop();
    endtask

    task send_in_token(input logic [6:0] addr, input logic [3:0] endp, input logic [4:0] crc5);
        send_sync(); send_pid(4'b1001); send_token_fields(addr, endp, crc5); send_eop();
    endtask

    task send_data0(input logic [7:0] data[], input int len, input logic [15:0] crc16);
        send_sync(); send_pid(4'b0011); send_data_payload(data, len, crc16); send_eop();
    endtask

    task send_data1(input logic [7:0] data[], input int len, input logic [15:0] crc16);
        send_sync(); send_pid(4'b1011); send_data_payload(data, len, crc16); send_eop();
    endtask

    task send_ack();
        send_sync(); send_pid(4'b0010); send_eop();
    endtask

    task push_tx_byte(input logic [7:0] data);
        @(posedge clk); #1;
        tx_data = data; store_tx_data = 1;
        @(posedge clk); #1;
        store_tx_data = 0;
    endtask

    task pop_rx_byte(output logic [7:0] data);
        @(posedge clk); #1;
        data = rx_data; get_rx_data = 1;
        @(posedge clk); #1;
        get_rx_data = 0;
    endtask

    task clear_buffer();
        @(posedge clk); #1;
        clear = 1;
        @(posedge clk); #1;
        clear = 0;
    endtask

    task fill_tx_buffer(input logic [7:0] data[], input int len);
        for (int i = 0; i < len; i++) push_tx_byte(data[i]);
    endtask

    task trigger_tx(input logic [2:0] pkt_type);
        int t;
        @(posedge clk); #1;
        tx_packet = pkt_type;
        t = 0;
        while (!tx_transfer_active && t < 1000) begin @(posedge clk); t++; end
        if (t >= 1000) $error("trigger_tx: TX never started");
        while (tx_transfer_active) @(posedge clk);
        tx_packet = 0;
    endtask

    task wait_for_tx_done(input int timeout_cycles);
        int t;
        t = 0;
        while (tx_transfer_active && t < timeout_cycles) begin @(posedge clk); t++; end
        if (t >= timeout_cycles) $error("Timeout waiting for TX to finish");
    endtask

    task wait_for_rx_done(input int timeout_cycles);
        int t;
        t = 0;
        while (!rx_data_ready && !rx_error && t < timeout_cycles) begin @(posedge clk); t++; end
        if (t >= timeout_cycles) $error("Timeout waiting for RX to finish");
    endtask

    task clear_rx_flags();
        force rx_error_seen      = 0;
        force rx_data_ready_seen = 0;
        force rx_packet_captured = 0;
        @(posedge clk); #1;
        release rx_error_seen;
        release rx_data_ready_seen;
        release rx_packet_captured;
    endtask

    logic tx_prev_dp;

    task capture_tx_bit(output logic decoded_bit);
        #(BIT_PERIOD);
        decoded_bit = (dp_out == tx_prev_dp) ? 1'b1 : 1'b0;
        tx_prev_dp  = dp_out;
    endtask

    task capture_tx_pid(output logic [3:0] pid);
        logic bit_val;
        logic [7:0] pid_byte;
        while (!tx_transfer_active) @(posedge clk);
        tx_prev_dp = 1;
        for (int i = 0; i < 8; i++) capture_tx_bit(bit_val);
        pid_byte = 0;
        for (int i = 0; i < 8; i++) begin capture_tx_bit(bit_val); pid_byte[i] = bit_val; end
        pid = pid_byte[3:0];
    endtask

    task wait_tx_eop();
        int t;
        t = 0;
        while (!(dp_out == 0 && dm_out == 0) && t < 10000) begin @(posedge clk); t++; end
        if (t >= 10000) begin $error("wait_tx_eop: SE0 never seen"); return; end
        t = 0;
        while (tx_transfer_active && t < 10000) begin @(posedge clk); t++; end
        if (t >= 10000) $error("wait_tx_eop: tx_transfer_active stuck high");
    endtask

    int tb_test_num;
    logic [7:0] test_data[];
    logic [7:0] popped;
    logic [6:0] occ_snap;
    int pass_cnt, fail_cnt;

    task check(input string name, input logic cond, input string detail);
        if (cond) begin
            $display("[%0t ns] [T%0d] PASS: %s | %s", $time, tb_test_num, name, detail);
            pass_cnt++;
        end else begin
            $display("[%0t ns] [T%0d] FAIL: %s | %s", $time, tb_test_num, name, detail);
            fail_cnt++;
        end
        tb_test_num++;
    endtask

    initial begin
        tb_test_num = 0;
        pass_cnt    = 0;
        fail_cnt    = 0;
        n_rst         = 1;
        dp_in         = 1; dm_in = 0;
        cur_line      = 1;
        store_tx_data = 0;
        tx_data       = 0;
        get_rx_data   = 0;
        clear         = 0;
        tx_packet     = 0;

        // =====================================================================
        // GROUP 1: Data Buffer — AHB push/pop/occupancy/overflow/underflow/clear
        // =====================================================================
        reset_dut();
        clear_buffer();

        push_tx_byte(8'hAA); push_tx_byte(8'hBB); push_tx_byte(8'hCC);
        @(posedge clk); #1;
        check("FIFO stores 3 AHB writes", buffer_occupancy == 3,
              $sformatf("occupancy=%0d", buffer_occupancy));

        check("FIFO head=0xAA", rx_data == 8'hAA,
              $sformatf("rx_data=0x%02h", rx_data));
        pop_rx_byte(popped);
        @(posedge clk); #1;
        check("After pop, head=0xBB", rx_data == 8'hBB,
              $sformatf("rx_data=0x%02h", rx_data));
        pop_rx_byte(popped);
        @(posedge clk); #1;
        check("After pop, head=0xCC", rx_data == 8'hCC,
              $sformatf("rx_data=0x%02h", rx_data));
        pop_rx_byte(popped);
        @(posedge clk); #1;
        check("FIFO empty after 3 pops", buffer_occupancy == 0,
              $sformatf("occupancy=%0d", buffer_occupancy));

        // Overflow: fill to 64, try one more
        clear_buffer();
        for (int i = 0; i < 64; i++) push_tx_byte(8'(i));
        @(posedge clk); #1;
        check("FIFO fills to 64", buffer_occupancy == 64,
              $sformatf("occupancy=%0d", buffer_occupancy));
        push_tx_byte(8'hFF);
        @(posedge clk); #1;
        check("Overflow: push to full FIFO stays 64", buffer_occupancy == 64,
              $sformatf("occupancy=%0d", buffer_occupancy));

        // Underflow: pop from empty
        clear_buffer();
        @(posedge clk); #1;
        pop_rx_byte(popped);
        @(posedge clk); #1;
        check("Underflow: pop from empty stays 0", buffer_occupancy == 0,
              $sformatf("occupancy=%0d", buffer_occupancy));

        // Clear mid-fill
        push_tx_byte(8'hAA); push_tx_byte(8'hBB);
        clear_buffer();
        @(posedge clk); #1;
        check("Clear mid-fill resets occupancy", buffer_occupancy == 0,
              $sformatf("occupancy=%0d", buffer_occupancy));

        // =====================================================================
        // GROUP 2: TX Handshake Packets — ACK, NAK, STALL
        // =====================================================================
        reset_dut();

        $display("[%0t ns] Sending ACK (tx_packet=3)", $time);
        trigger_tx(3'd3);
        check("TX ACK: no tx_error", !tx_error, $sformatf("tx_error=%0b", tx_error));

        $display("[%0t ns] Sending NAK (tx_packet=4)", $time);
        trigger_tx(3'd4);
        check("TX NAK: no tx_error", !tx_error, $sformatf("tx_error=%0b", tx_error));

        $display("[%0t ns] Sending STALL (tx_packet=5)", $time);
        trigger_tx(3'd5);
        check("TX STALL: no tx_error", !tx_error, $sformatf("tx_error=%0b", tx_error));

        // tx_error on DATA0 with empty FIFO
        // NOTE: if tx_error never asserts here, DUT does not implement this error condition
        reset_dut(); clear_buffer();
        @(posedge clk); #1;
        $display("[%0t ns] DATA0 request with empty FIFO (expect tx_error or no TX activity)", $time);
        tx_packet = 3'd1;
        begin : wait_tx_err
            int t;
            t = 0;
            // Wait only as long as one full handshake packet would take (~20 bit periods)
            while (!tx_error && !tx_transfer_active && t < 300) begin @(posedge clk); t++; end
            if (tx_transfer_active) begin
                // TX started — wait for it to finish then re-check
                while (tx_transfer_active) @(posedge clk);
                repeat(10) @(posedge clk);
            end
        end
        tx_packet = 0;
        if (!tx_error)
            $display("[%0t ns] NOTE: DUT does not assert tx_error for empty FIFO DATA0 request (DUT design choice)", $time);
        check("TX DATA0 on empty FIFO: tx_error", tx_error,
              $sformatf("tx_error=%0b (NOTE: DUT may not implement this error)", tx_error));

        // =====================================================================
        // GROUP 3: TX DATA0/DATA1 from FIFO
        // =====================================================================
        reset_dut();
        push_tx_byte(8'hA1); push_tx_byte(8'hB2); push_tx_byte(8'hC3);
        @(posedge clk); #1;
        check("Pre-TX FIFO: occupancy=3", buffer_occupancy == 3,
              $sformatf("occupancy=%0d", buffer_occupancy));

        $display("[%0t ns] AHB commands DATA0 (tx_packet=1)", $time);
        trigger_tx(3'd1);
        check("TX DATA0: no tx_error", !tx_error, $sformatf("tx_error=%0b", tx_error));

        reset_dut();
        push_tx_byte(8'hD4); push_tx_byte(8'hE5);
        $display("[%0t ns] AHB commands DATA1 (tx_packet=2)", $time);
        trigger_tx(3'd2);
        check("TX DATA1: no tx_error", !tx_error, $sformatf("tx_error=%0b", tx_error));

        // =====================================================================
        // GROUP 4: USB RX — Token Packets
        // =====================================================================
        reset_dut(); clear_rx_flags();

        $display("[%0t ns] Sending OUT token addr=0x%02h endp=0x%0h", $time, USB_ADDR, USB_ENDP);
        send_out_token(USB_ADDR, USB_ENDP, DUMMY_CRC5);
        repeat(20) @(posedge clk);
        check("RX OUT token (match): no rx_error", !rx_error,
              $sformatf("rx_error=%0b rx_packet=0x%0h", rx_error, rx_packet));

        reset_dut(); clear_rx_flags();
        $display("[%0t ns] Sending IN token addr=0x%02h endp=0x%0h", $time, USB_ADDR, USB_ENDP);
        send_in_token(USB_ADDR, USB_ENDP, DUMMY_CRC5);
        repeat(20) @(posedge clk);
        check("RX IN token (match): no rx_error", !rx_error,
              $sformatf("rx_error=%0b rx_packet=0x%0h", rx_error, rx_packet));

        // Mismatched address: rx_data_ready must stay 0
        reset_dut(); clear_rx_flags();
        $display("[%0t ns] Sending OUT token WRONG addr=0x7F endp=0xF", $time);
        send_out_token(7'h7F, 4'hF, 5'h08);
        repeat(20) @(posedge clk);
        check("RX OUT token (addr mismatch): rx_data_ready stays 0", !rx_data_ready_seen,
              $sformatf("rx_data_ready_seen=%0b", rx_data_ready_seen));

        // rx_transfer_active goes high mid-packet
        reset_dut(); clear_rx_flags();
        begin
            logic seen_active;
            seen_active = 0;
            fork
                send_out_token(USB_ADDR, USB_ENDP, DUMMY_CRC5);
                begin
                    #(BIT_PERIOD * 12);
                    seen_active = rx_transfer_active;
                end
            join
            check("RX transfer_active HIGH mid-packet", seen_active,
                  $sformatf("sampled rx_transfer_active=%0b", seen_active));
        end
        repeat(20) @(posedge clk);
        check("RX transfer_active LOW after EOP", !rx_transfer_active,
              $sformatf("rx_transfer_active=%0b", rx_transfer_active));

        // =====================================================================
        // GROUP 5: USB RX — Data Packets
        // =====================================================================
        reset_dut(); clear_rx_flags(); clear_buffer();

        test_data = new[1]; test_data[0] = 8'h5A;
        $display("[%0t ns] Sending DATA0 payload=[0x5A]", $time);
        send_data0(test_data, 1, DUMMY_CRC16);
        repeat(40) @(posedge clk);
        check("RX DATA0 1-byte: occupancy=1", buffer_occupancy == 1,
              $sformatf("occupancy=%0d rx_error=%0b", buffer_occupancy, rx_error));
        check("RX DATA0 1-byte: no rx_error", !rx_error,
              $sformatf("rx_error=%0b", rx_error));
        check("RX DATA0 1-byte: rx_data=0x5A", rx_data == 8'h5A,
              $sformatf("rx_data=0x%02h", rx_data));

        reset_dut(); clear_rx_flags(); clear_buffer();
        test_data = new[4];
        test_data[0]=8'hDE; test_data[1]=8'hAD; test_data[2]=8'hBE; test_data[3]=8'hEF;
        $display("[%0t ns] Sending DATA1 payload=[0xDE,0xAD,0xBE,0xEF]", $time);
        send_data1(test_data, 4, DUMMY_CRC16);
        repeat(60) @(posedge clk);
        check("RX DATA1 4-byte: occupancy=4", buffer_occupancy == 4,
              $sformatf("occupancy=%0d rx_error=%0b", buffer_occupancy, rx_error));
        check("RX DATA1 4-byte: no rx_error", !rx_error,
              $sformatf("rx_error=%0b", rx_error));

        pop_rx_byte(popped); check("RX DATA1 byte[0]=0xDE", popped==8'hDE, $sformatf("got 0x%02h",popped));
        pop_rx_byte(popped); check("RX DATA1 byte[1]=0xAD", popped==8'hAD, $sformatf("got 0x%02h",popped));
        pop_rx_byte(popped); check("RX DATA1 byte[2]=0xBE", popped==8'hBE, $sformatf("got 0x%02h",popped));
        pop_rx_byte(popped); check("RX DATA1 byte[3]=0xEF", popped==8'hEF, $sformatf("got 0x%02h",popped));

        // 64-byte max payload
        reset_dut(); clear_rx_flags(); clear_buffer();
        test_data = new[64];
        for (int i = 0; i < 64; i++) test_data[i] = 8'(i);
        $display("[%0t ns] Sending DATA0 max payload (64 bytes)", $time);
        send_data0(test_data, 64, DUMMY_CRC16);
        repeat(120) @(posedge clk);
        check("RX DATA0 64-byte: occupancy=64", buffer_occupancy == 64,
              $sformatf("occupancy=%0d rx_error=%0b", buffer_occupancy, rx_error));
        check("RX DATA0 64-byte: no rx_error", !rx_error,
              $sformatf("rx_error=%0b", rx_error));

        // =====================================================================
        // GROUP 6: USB RX — Error Detection
        // =====================================================================

        // Bad SYNC
        reset_dut(); clear_rx_flags();
        $display("[%0t ns] Sending bad SYNC (all 1s after first edge)", $time);
        dp_in=1; dm_in=0; cur_line=1;
        #(BIT_PERIOD);
        send_bit(0);
        for (int i=0; i<7; i++) send_bit(1);
        send_eop();
        repeat(20) @(posedge clk);
        check("RX bad SYNC: rx_error_seen", rx_error_seen,
              $sformatf("rx_error_seen=%0b", rx_error_seen));

        // Bad PID check bits
        reset_dut(); clear_rx_flags();
        $display("[%0t ns] Sending valid SYNC + bad PID (0xFF)", $time);
        send_sync();
        send_byte_lsb(8'hFF);
        send_eop();
        repeat(20) @(posedge clk);
        check("RX bad PID: rx_error_seen", rx_error_seen,
              $sformatf("rx_error_seen=%0b", rx_error_seen));

        // Premature EOP in data packet — FIFO must be flushed
        reset_dut(); clear_rx_flags();
        push_tx_byte(8'hAB);
        @(posedge clk); #1;
        $display("[%0t ns] Sending premature EOP mid-DATA0 (expect error + flush)", $time);
        send_sync(); send_pid(4'b0011);
        for (int i=0; i<4; i++) send_bit(1);
        send_eop();
        repeat(30) @(posedge clk);
        check("RX premature EOP: rx_error_seen", rx_error_seen,
              $sformatf("rx_error_seen=%0b", rx_error_seen));
        check("RX error: FIFO flushed (occupancy=0)", buffer_occupancy == 0,
              $sformatf("occupancy=%0d", buffer_occupancy));

        // =====================================================================
        // GROUP 7: USB RX — ACK Reception
        // =====================================================================
        reset_dut(); clear_rx_flags();
        $display("[%0t ns] Sending ACK from host", $time);
        send_ack();
        repeat(20) @(posedge clk);
        check("RX ACK: no rx_error", !rx_error,
              $sformatf("rx_error=%0b rx_packet=0x%0h", rx_error, rx_packet));

        // =====================================================================
        // GROUP 8: NRZI Encoding on dp_out
        // Byte 0xAB = 8'b10101011, LSB-first bits: 1,1,0,1,0,1,0,1
        // NRZI: 1=no change, 0=toggle
        // =====================================================================
        reset_dut(); clear_buffer();
        push_tx_byte(8'hAB);
        @(posedge clk); #1;
        begin
            logic prev_dp_val, cur_dp_val;
            logic [7:0] nrzi_data;
            nrzi_data = 8'hAB;
            tx_packet = 3'd1;
            @(posedge tx_transfer_active);
            // Skip SYNC (8 bits) + PID (8 bits) using time delays for precise bit-boundary alignment
            #(BIT_PERIOD * 16);
            // Advance to the middle of bit 0
            #(BIT_PERIOD / 2.0);
            prev_dp_val = dp_out;
            $display("[%0t ns] NRZI check start: dp_out=%0b (sampling data bits)", $time, prev_dp_val);
            // Sample at the TRANSITION BOUNDARY (start of each bit) not mid-bit,
            // since TX updates dp_out on the clock edge, not mid-period.
            // We advance a full BIT_PERIOD then sample immediately.
            for (int b = 0; b < 8; b++) begin
                #(BIT_PERIOD);
                // Small setup margin to let combinational settle
                #1;
                cur_dp_val = dp_out;
                if (nrzi_data[b] == 0) begin
                    if (cur_dp_val !== prev_dp_val)
                        $display("[%0t ns] [T%0d] PASS: NRZI bit[%0d]=0: dp toggles | prev=%0b cur=%0b",
                                 $time, tb_test_num, b, prev_dp_val, cur_dp_val);
                    else
                        $display("[%0t ns] [T%0d] FAIL: NRZI bit[%0d]=0: dp toggles | prev=%0b cur=%0b (DUT NRZI bug: no toggle on data 0)",
                                 $time, tb_test_num, b, prev_dp_val, cur_dp_val);
                    check($sformatf("NRZI bit[%0d]=0: dp toggles",b), cur_dp_val !== prev_dp_val,
                          $sformatf("prev=%0b cur=%0b",prev_dp_val,cur_dp_val));
                end else begin
                    check($sformatf("NRZI bit[%0d]=1: dp stays",b), cur_dp_val === prev_dp_val,
                          $sformatf("prev=%0b cur=%0b",prev_dp_val,cur_dp_val));
                end
                prev_dp_val = cur_dp_val;
            end
            @(negedge tx_transfer_active);
            tx_packet = 0;
        end

        // =====================================================================
        // GROUP 9: Host->Endpoint Bulk Transfer (end-to-end)
        // OUT token -> DATA0 payload -> DUT sends ACK -> AHB reads data back
        // =====================================================================
        reset_dut(); clear_rx_flags(); clear_buffer();

        $display("[%0t ns] [H->E] Step1: Host sends OUT token", $time);
        send_out_token(USB_ADDR, USB_ENDP, DUMMY_CRC5);
        repeat(20) @(posedge clk);
        check("H->E OUT token: no rx_error", !rx_error,
              $sformatf("rx_error=%0b rx_packet=0x%0h", rx_error, rx_packet));

        $display("[%0t ns] [H->E] Step2: Host sends DATA0 [0x11,0x22,0x33]", $time);
        test_data = new[3]; test_data[0]=8'h11; test_data[1]=8'h22; test_data[2]=8'h33;
        send_data0(test_data, 3, DUMMY_CRC16);
        repeat(60) @(posedge clk);
        check("H->E DATA0: 3 bytes in FIFO", buffer_occupancy == 3,
              $sformatf("occupancy=%0d", buffer_occupancy));
        check("H->E DATA0: no rx_error", !rx_error,
              $sformatf("rx_error=%0b", rx_error));

        $display("[%0t ns] [H->E] Step3: data available occupancy=%0d", $time, buffer_occupancy);

        $display("[%0t ns] [H->E] Step4: AHB sends ACK (tx_packet=3)", $time);
        trigger_tx(3'd3);
        check("H->E ACK send: no tx_error", !tx_error,
              $sformatf("tx_error=%0b", tx_error));

        $display("[%0t ns] [H->E] Step5: AHB reads back received data", $time);
        pop_rx_byte(popped);
        check("H->E read byte[0]=0x11", popped==8'h11, $sformatf("got 0x%02h",popped));
        pop_rx_byte(popped);
        check("H->E read byte[1]=0x22", popped==8'h22, $sformatf("got 0x%02h",popped));
        pop_rx_byte(popped);
        check("H->E read byte[2]=0x33", popped==8'h33, $sformatf("got 0x%02h",popped));
        @(posedge clk); #1;
        check("H->E FIFO empty after reads", buffer_occupancy == 0,
              $sformatf("occupancy=%0d", buffer_occupancy));

        // =====================================================================
        // GROUP 10: Endpoint->Host Bulk Transfer (end-to-end)
        // AHB loads FIFO -> IN token -> DUT sends DATA0 -> host ACKs -> FIFO drains
        // =====================================================================
        reset_dut(); clear_rx_flags(); clear_buffer();

        $display("[%0t ns] [E->H] Step1: AHB loads [0xA1,0xB2,0xC3]", $time);
        push_tx_byte(8'hA1); push_tx_byte(8'hB2); push_tx_byte(8'hC3);
        @(posedge clk); #1;
        check("E->H FIFO loaded: occupancy=3", buffer_occupancy == 3,
              $sformatf("occupancy=%0d", buffer_occupancy));

        $display("[%0t ns] [E->H] Step2: AHB arms DATA0, host sends IN token", $time);
        tx_packet = 3'd1;
        send_in_token(USB_ADDR, USB_ENDP, DUMMY_CRC5);
        @(posedge tx_transfer_active);
        $display("[%0t ns]   tx_transfer_active HIGH — sending DATA0", $time);
        @(negedge tx_transfer_active);
        $display("[%0t ns]   tx_transfer_active LOW — DATA0 done", $time);
        tx_packet = 0;
        check("E->H DATA0 sent: no tx_error", !tx_error,
              $sformatf("tx_error=%0b", tx_error));

        $display("[%0t ns] [E->H] Step3: Host sends ACK", $time);
        send_ack();
        repeat(40) @(posedge clk);
        check("E->H FIFO empty after ACK", buffer_occupancy == 0,
              $sformatf("occupancy=%0d", buffer_occupancy));
        check("E->H ACK: no rx_error", !rx_error,
              $sformatf("rx_error=%0b", rx_error));

        // =====================================================================
        // GROUP 11: NAK and STALL preserve FIFO contents
        // =====================================================================
        reset_dut(); clear_rx_flags(); clear_buffer();
        // Let line settle to idle before loading FIFO
        dp_in = 1; dm_in = 0; cur_line = 1;
        repeat(20) @(posedge clk);
        push_tx_byte(8'hDE); push_tx_byte(8'hAD);
        // Wait for occupancy to settle before snapping
        repeat(5) @(posedge clk); #1;
        occ_snap = buffer_occupancy;
        $display("[%0t ns] FIFO has %0d bytes before NAK/STALL", $time, occ_snap);

        // NAK — host sends IN token, DUT replies with NAK, FIFO must not drain
        // NOTE: if this fails, DUT is incorrectly draining FIFO during NAK response
        tx_packet = 3'd4;
        send_in_token(USB_ADDR, USB_ENDP, DUMMY_CRC5);
        @(posedge tx_transfer_active); @(negedge tx_transfer_active);
        tx_packet = 0;
        repeat(5) @(posedge clk); #1;
        if (buffer_occupancy != occ_snap)
            $display("[%0t ns] NOTE: DUT drained FIFO during NAK (occupancy=%0d, expected=%0d) — DUT BUG: TX should not consume buffer data when sending NAK",
                     $time, buffer_occupancy, occ_snap);
        check("NAK preserves FIFO", buffer_occupancy == occ_snap,
              $sformatf("occupancy=%0d expected=%0d", buffer_occupancy, occ_snap));

        occ_snap = buffer_occupancy;
        // STALL — same check
        tx_packet = 3'd5;
        send_in_token(USB_ADDR, USB_ENDP, DUMMY_CRC5);
        @(posedge tx_transfer_active); @(negedge tx_transfer_active);
        tx_packet = 0;
        repeat(5) @(posedge clk); #1;
        check("STALL preserves FIFO", buffer_occupancy == occ_snap,
              $sformatf("occupancy=%0d expected=%0d", buffer_occupancy, occ_snap));

        // =====================================================================
        // GROUP 12: Idle line — no spurious activity
        // =====================================================================
        reset_dut();
        repeat(8 * 50) @(posedge clk);
        check("Idle: rx_transfer_active=0", !rx_transfer_active,
              $sformatf("rx_transfer_active=%0b", rx_transfer_active));
        check("Idle: rx_error=0", !rx_error,
              $sformatf("rx_error=%0b", rx_error));
        check("Idle: tx_transfer_active=0", !tx_transfer_active,
              $sformatf("tx_transfer_active=%0b", tx_transfer_active));

        // =====================================================================
        $display("=== DONE: PASS=%0d FAIL=%0d TOTAL=%0d ===",
                 pass_cnt, fail_cnt, pass_cnt+fail_cnt);
        $finish;
    end
endmodule