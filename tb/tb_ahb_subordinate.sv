`timescale 1ns / 10ps
/* verilator coverage_off */

// key functions to verify

// read
// read without checking
// read until wanted value is seen
// verify if wanted value was read

// write
// write to different subordinate (hsel = 0)

// hburst 
// incr
// wrap

module tb_ahb_subordinate ();

    localparam CLK_PERIOD = 10ns;

    logic clk, n_rst;
    string test_name;

    // inputs
    logic hsel;
    logic [3:0] haddr;
    logic [1:0] htrans, hsize;
    logic hwrite;
    logic [31:0] hwdata;
    logic [2:0] hburst; // bonus

    logic [2:0] rx_packet;
    logic rx_data_ready, rx_transfer_active, rx_error;

    logic buffer_occupancy;
    logic [7:0] rx_data;

    logic tx_transfer_active, tx_error;


    // outputs
    logic [31:0] hrdata;
    logic hready, hresp;

    logic get_rx_data, store_tx_data;
    logic [7:0] tx_data;
    logic clear;

    logic [1:0] tx_packet;

    // DUT
    ahb_subordinate DUT(
        (.*)

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
        test_name = "POWER ON RESET";
        n_rst = 0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
        @(negedge clk);
    end
    endtask

    task INIT;
    begin
        test_name = "INIT";

        @(posedge clk);
    end
    endtask


    // Read from a register without checking the value
    task enqueue_poll ( input logic [3:0] addr, input logic [1:0] size );
    logic [31:0] data [];
        begin
            data = new [1];
            data[0] = {32'hXXXX};
            //              Fields: hsel,  R/W, addr, data, exp err,         size, burst, chk prdata or not
            BFM.enqueue_transaction(1'b1, 1'b0, addr, data,    1'b0, {1'b0, size},  3'b0,            1'b0);
        end
    endtask

    // Read from a register until a requested value is observed
    task poll_until ( input logic [3:0] addr, input logic [1:0] size, input logic [31:0] data);
        int iters;
        begin
            for (iters = 0; iters < TIMEOUT; iters++) begin
                enqueue_poll(addr, size);
                execute_transactions(1);
                if(BFM.get_last_read() == data) break;
            end
            if(iters >= TIMEOUT) begin
                $error("Bus polling timeout hit.");
            end
        end
    endtask

    // Read Transaction, verifying a specific value is read
    task enqueue_read ( input logic [3:0] addr, input logic [1:0] size, input logic [31:0] exp_read );
        logic [31:0] data [];
        begin
            data = new [1];
            data[0] = exp_read;
            BFM.enqueue_transaction(1'b1, 1'b0, addr, data, 1'b0, {1'b0, size}, 3'b0, 1'b1);
        end
    endtask

    // Write Transaction
    task enqueue_write ( input logic [3:0] addr, input logic [1:0] size, input logic [31:0] wdata );
        logic [31:0] data [];
        begin
            data = new [1];
            data[0] = wdata;
            BFM.enqueue_transaction(1'b1, 1'b1, addr, data, 1'b0, {2'b0, size}, 3'b0, 1'b0);
        end
    endtask

    // Write Transaction Intended for a different subordinate from yours
    task enqueue_fakewrite ( input logic [3:0] addr, input logic [1:0] size, input logic [31:0] wdata );
        logic [31:0] data [];
        begin
            data = new [1];
            data[0] = wdata;
            BFM.enqueue_transaction(1'b0, 1'b1, addr, data, 1'b0, {1'b0, size}, 3'b0, 1'b0);
        end
    endtask

    // Create a burst read of size based on the burst type.
    // If INCR, burst size dependent on dynamic array size
    task enqueue_burst_read ( input logic [3:0] base_addr, input logic [1:0] size, input logic [2:0] burst, input logic [31:0] data [] );
        BFM.enqueue_transaction(1'b1, 1'b0, base_addr, data, 1'b0, {1'b0, size}, burst, 1'b1);
    endtask

    // Create a burst write of size based on the burst type.
    task enqueue_burst_write ( input logic [3:0] base_addr, input logic [1:0] size, input logic [2:0] burst, input logic [31:0] data [] );
        BFM.enqueue_transaction(1'b1, 1'b1, base_addr, data, 1'b0, {1'b0, size}, burst, 1'b1);
    endtask

    // Run n transactions, where a k-beat burst counts as k transactions.
    task execute_transactions (input int num_transactions);
        BFM.run_transactions(num_transactions);
    endtask

    // Finish the current transaction
    task finish_transactions();
        BFM.wait_done();
    endtask


    initial begin
        n_rst = 1;

        reset_dut();

        INIT;


        $finish;
    end
endmodule

/* verilator coverage_on */



