`timescale 1ns / 10ps

module tb_crc_checker_5bit;

logic clk, n_rst, serial_in, crc_en, crc_clear, valid_bit;
logic crc_valid;

crc_checker_5bit DUT (
    .clk(clk),
    .n_rst(n_rst),
    .serial_in(serial_in),
    .crc_en(crc_en),
    .crc_clear(crc_clear),
    .valid_bit(valid_bit),
    .crc_valid(crc_valid)
);

always #5 clk = ~clk;

task tick; begin @(posedge clk); #1; end endtask

task reset; begin
    n_rst=0; crc_en=0; crc_clear=0; valid_bit=0; serial_in=0;
    tick(); tick();
    n_rst=1; tick();
end endtask

task clear_crc; begin
    crc_clear=1; tick();
    crc_clear=0; tick();
end endtask

task send_bit(input logic b); begin
    serial_in=b; crc_en=1; valid_bit=1; tick();
end endtask

task send_stream(input logic [10:0] data, input logic [4:0] suffix);
    int i;
begin
    for(i=0;i<11;i++) send_bit(data[i]);
    for(i=0;i<5;i++) send_bit(suffix[i]);
    crc_en=0; valid_bit=0;
end endtask

task find_suffix(input logic [10:0] data, output logic [4:0] good);
    int s;
begin
    good=0;
    for(s=0;s<32;s++) begin
        clear_crc();
        send_stream(data, s[4:0]);
        if(crc_valid) begin
            good=s[4:0];
            $display("found suffix %b", good);
            disable find_suffix;
        end
    end
end endtask

logic [10:0] data;
logic [4:0] good;

initial begin
    clk=0;
    
    data = 11'b10101101101;

    reset();

    find_suffix(data, good);

    // valid case
    clear_crc();
    send_stream(data, good);
    if(!crc_valid) $error("valid case failed");
    else $display("pass valid case");

    // bad crc
    clear_crc();
    send_stream(data, good ^ 5'b00001);
    if(crc_valid) $error("bad crc not detected");
    else $display("pass bad crc");

    // bad data
    clear_crc();
    send_stream(data ^ 11'b00000000001, good);
    if(crc_valid) $error("bad data not detected");
    else $display("pass bad data");

    // valid_bit gating
    clear_crc();
    crc_en=1; valid_bit=0;
    repeat(16) begin serial_in=$random; tick(); end
    crc_en=0;
    if(crc_valid) $error("valid_bit gating failed");
    else $display("pass valid_bit gating");

    $display("done");
    $finish;
end

endmodule