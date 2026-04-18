/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Sat Apr 18 15:16:18 2026
/////////////////////////////////////////////////////////////


module flex_counter_SIZE4 ( clk, n_rst, clear, count_enable, rollover_val, 
        count_out, rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   next_rollover_flag, n1, n2, n3, n4, n5, n6, n7, n8, n9, n15, n16, n17,
         n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34, n35;
  wire   [3:0] next_count_out;

  DFFSR \count_out_reg[0]  ( .D(next_count_out[0]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[0]) );
  DFFSR \count_out_reg[3]  ( .D(next_count_out[3]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[3]) );
  DFFSR \count_out_reg[1]  ( .D(next_count_out[1]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[1]) );
  DFFSR \count_out_reg[2]  ( .D(next_count_out[2]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[2]) );
  DFFSR rollover_flag_reg ( .D(next_rollover_flag), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(rollover_flag) );
  NOR2X1 U8 ( .A(n1), .B(n2), .Y(next_rollover_flag) );
  NAND2X1 U9 ( .A(n3), .B(n4), .Y(n2) );
  XOR2X1 U10 ( .A(n5), .B(rollover_val[1]), .Y(n4) );
  XNOR2X1 U11 ( .A(rollover_val[2]), .B(next_count_out[2]), .Y(n3) );
  NAND2X1 U12 ( .A(n6), .B(n7), .Y(n1) );
  XOR2X1 U13 ( .A(n8), .B(next_count_out[0]), .Y(n7) );
  XOR2X1 U14 ( .A(n9), .B(next_count_out[3]), .Y(n6) );
  OAI21X1 U15 ( .A(n15), .B(n16), .C(n17), .Y(next_count_out[3]) );
  OAI21X1 U16 ( .A(n18), .B(n19), .C(count_out[3]), .Y(n17) );
  MUX2X1 U17 ( .B(n20), .A(n16), .S(n15), .Y(next_count_out[2]) );
  NAND3X1 U18 ( .A(n18), .B(count_out[1]), .C(count_out[0]), .Y(n16) );
  AOI21X1 U19 ( .A(n21), .B(n18), .C(n19), .Y(n20) );
  INVX1 U20 ( .A(n5), .Y(next_count_out[1]) );
  MUX2X1 U21 ( .B(n19), .A(n22), .S(n21), .Y(n5) );
  INVX1 U22 ( .A(count_out[1]), .Y(n21) );
  AND2X1 U23 ( .A(n18), .B(count_out[0]), .Y(n22) );
  INVX1 U24 ( .A(n23), .Y(n18) );
  OAI22X1 U25 ( .A(count_enable), .B(clear), .C(count_out[0]), .D(n23), .Y(n19) );
  OAI22X1 U26 ( .A(count_out[0]), .B(n23), .C(clear), .D(n24), .Y(
        next_count_out[0]) );
  MUX2X1 U27 ( .B(count_out[0]), .A(n25), .S(count_enable), .Y(n24) );
  NAND3X1 U28 ( .A(n26), .B(n27), .C(count_enable), .Y(n23) );
  INVX1 U29 ( .A(clear), .Y(n27) );
  INVX1 U30 ( .A(n25), .Y(n26) );
  OAI21X1 U31 ( .A(n28), .B(n29), .C(n30), .Y(n25) );
  AOI22X1 U32 ( .A(n31), .B(n9), .C(count_out[3]), .D(n32), .Y(n30) );
  OR2X1 U33 ( .A(n32), .B(count_out[3]), .Y(n31) );
  OAI21X1 U34 ( .A(rollover_val[2]), .B(n15), .C(n33), .Y(n32) );
  NAND3X1 U35 ( .A(n34), .B(n35), .C(count_out[1]), .Y(n33) );
  OAI22X1 U36 ( .A(count_out[3]), .B(n9), .C(count_out[0]), .D(n8), .Y(n29) );
  INVX1 U37 ( .A(rollover_val[0]), .Y(n8) );
  INVX1 U38 ( .A(rollover_val[3]), .Y(n9) );
  OAI21X1 U39 ( .A(count_out[1]), .B(n35), .C(n34), .Y(n28) );
  NAND2X1 U40 ( .A(rollover_val[2]), .B(n15), .Y(n34) );
  INVX1 U41 ( .A(count_out[2]), .Y(n15) );
  INVX1 U42 ( .A(rollover_val[1]), .Y(n35) );
endmodule


module flex_sr_SIZE8 ( clk, n_rst, shift_enable, load_enable, serial_in, 
        parallel_in, serial_out, parallel_out );
  input [7:0] parallel_in;
  output [7:0] parallel_out;
  input clk, n_rst, shift_enable, load_enable, serial_in;
  output serial_out;
  wire   serial_out, n28, n29, n30, n31, n32, n33, n34, n35, n9, n10, n11, n12,
         n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26,
         n27;
  assign parallel_out[0] = serial_out;

  DFFSR \parallel_out_reg[7]  ( .D(n29), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[7]) );
  DFFSR \parallel_out_reg[6]  ( .D(n30), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[6]) );
  DFFSR \parallel_out_reg[5]  ( .D(n31), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[5]) );
  DFFSR \parallel_out_reg[4]  ( .D(n32), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[4]) );
  DFFSR \parallel_out_reg[3]  ( .D(n33), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[3]) );
  DFFSR \parallel_out_reg[2]  ( .D(n34), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[2]) );
  DFFSR \parallel_out_reg[1]  ( .D(n35), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[1]) );
  DFFSR \parallel_out_reg[0]  ( .D(n28), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        serial_out) );
  OAI21X1 U10 ( .A(n9), .B(n10), .C(n11), .Y(n35) );
  AOI22X1 U11 ( .A(parallel_out[2]), .B(n12), .C(parallel_out[1]), .D(n13), 
        .Y(n11) );
  INVX1 U12 ( .A(parallel_in[1]), .Y(n10) );
  OAI21X1 U13 ( .A(n9), .B(n14), .C(n15), .Y(n34) );
  AOI22X1 U14 ( .A(parallel_out[3]), .B(n12), .C(n13), .D(parallel_out[2]), 
        .Y(n15) );
  INVX1 U15 ( .A(parallel_in[2]), .Y(n14) );
  OAI21X1 U16 ( .A(n9), .B(n16), .C(n17), .Y(n33) );
  AOI22X1 U17 ( .A(parallel_out[4]), .B(n12), .C(parallel_out[3]), .D(n13), 
        .Y(n17) );
  INVX1 U18 ( .A(parallel_in[3]), .Y(n16) );
  OAI21X1 U19 ( .A(n9), .B(n18), .C(n19), .Y(n32) );
  AOI22X1 U20 ( .A(parallel_out[5]), .B(n12), .C(parallel_out[4]), .D(n13), 
        .Y(n19) );
  INVX1 U21 ( .A(parallel_in[4]), .Y(n18) );
  OAI21X1 U22 ( .A(n9), .B(n20), .C(n21), .Y(n31) );
  AOI22X1 U23 ( .A(parallel_out[6]), .B(n12), .C(parallel_out[5]), .D(n13), 
        .Y(n21) );
  INVX1 U24 ( .A(parallel_in[5]), .Y(n20) );
  OAI21X1 U25 ( .A(n9), .B(n22), .C(n23), .Y(n30) );
  AOI22X1 U26 ( .A(parallel_out[7]), .B(n12), .C(parallel_out[6]), .D(n13), 
        .Y(n23) );
  INVX1 U27 ( .A(parallel_in[6]), .Y(n22) );
  OAI21X1 U28 ( .A(n9), .B(n24), .C(n25), .Y(n29) );
  AOI22X1 U29 ( .A(serial_in), .B(n12), .C(parallel_out[7]), .D(n13), .Y(n25)
         );
  INVX1 U30 ( .A(parallel_in[7]), .Y(n24) );
  OAI21X1 U31 ( .A(n9), .B(n26), .C(n27), .Y(n28) );
  AOI22X1 U32 ( .A(parallel_out[1]), .B(n12), .C(serial_out), .D(n13), .Y(n27)
         );
  NOR2X1 U33 ( .A(n13), .B(load_enable), .Y(n12) );
  NOR2X1 U34 ( .A(shift_enable), .B(load_enable), .Y(n13) );
  INVX1 U35 ( .A(parallel_in[0]), .Y(n26) );
  INVX1 U36 ( .A(load_enable), .Y(n9) );
endmodule


module usb_tx ( clk, n_rst, tx_packet_data, tx_packet, buffer_occupancy, 
        get_tx_packet_data, tx_transfer_active, tx_error, dm_out, dp_out );
  input [7:0] tx_packet_data;
  input [2:0] tx_packet;
  input [6:0] buffer_occupancy;
  input clk, n_rst;
  output get_tx_packet_data, tx_transfer_active, tx_error, dm_out, dp_out;
  wire   N67, N68, N69, N70, \bit_counter[4] , stuff_active, next_stuff_active,
         bit_pulse, shift_en, load_en, \rollover_val[2] , serial_out, dp_orig,
         next_dp_orig, n183, n185, n205, n206, n207, n208, n209, n210, n211,
         n212, n213, n214, n215, n216, n217, n218, n219, n220, n221, n222,
         n223, n224, n225, n226, n227, n228, n229, n230, n231, n232, n233,
         n234, n235, n236, n237, n238, n239, n240, n241, n242, n243, n244,
         n245, n246, n247, n248, n249, n250, n251, n252, n253, n254, n255,
         n256, n257, n258, n259, n260, n261, n262, n263, n264, n265, n266,
         n267, n268, n269, n270, n271, n272, n273, n274, n275, n276, n277,
         n278, n279, n280, n281, n282, n283, n284, n285, n286, n287, n288,
         n289, n290, n291, n292, n293, n294, n295, n296, n297, n298, n299,
         n300, n301, n302, n303, n304, n305, n306, n307, n308, n309, n310,
         n311, n312, n313, n314, n315, n316, n317, n318, n319, n320, n321,
         n322, n323, n324, n325, n326, n327, n328, n329, n330, n331, n332,
         n333, n334, n335, n336, n337, n338, n339, n340, n341, n342, n343,
         n344, n345, n346, n347, n348, n349, n350, n351, n352, n353, n354,
         n355, n356, n357, n358, n359, n360, n361, n362, n363, n364, n365,
         n366, n367, n368, n369, n370, n371, n372, n373, n374, n375, n376,
         n377, n378, n379, n380, n381, n382, n383, n384, n385, n386, n387,
         n388, n389, n390, n391, n392, n393, n394, n395, n396;
  wire   [3:0] currentState;
  wire   [2:0] ones_count;
  wire   [15:0] crc16;
  wire   [2:0] next_ones_count;
  wire   [15:0] next_crc16;
  wire   [7:0] sr_load_data;
  wire   [1:0] pattern_state;

  DFFSR \pattern_state_reg[0]  ( .D(n185), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        pattern_state[0]) );
  DFFSR \pattern_state_reg[1]  ( .D(n183), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        pattern_state[1]) );
  DFFSR \ones_count_reg[2]  ( .D(next_ones_count[2]), .CLK(clk), .R(n_rst), 
        .S(1'b1), .Q(ones_count[2]) );
  DFFSR stuff_active_reg ( .D(next_stuff_active), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(stuff_active) );
  DFFSR \bit_counter_reg[0]  ( .D(n205), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        N67) );
  DFFSR \bit_counter_reg[4]  ( .D(n213), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        \bit_counter[4] ) );
  DFFSR \currentState_reg[1]  ( .D(n210), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currentState[1]) );
  DFFSR \currentState_reg[0]  ( .D(n211), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currentState[0]) );
  DFFSR \currentState_reg[2]  ( .D(n209), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currentState[2]) );
  DFFSR \currentState_reg[3]  ( .D(n212), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currentState[3]) );
  DFFSR \bit_counter_reg[1]  ( .D(n206), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        N68) );
  DFFSR \bit_counter_reg[2]  ( .D(n207), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        N69) );
  DFFSR \bit_counter_reg[3]  ( .D(n208), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        N70) );
  DFFSR \crc16_reg[0]  ( .D(next_crc16[0]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[0]) );
  DFFSR \crc16_reg[1]  ( .D(next_crc16[1]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[1]) );
  DFFSR \crc16_reg[2]  ( .D(next_crc16[2]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[2]) );
  DFFSR \crc16_reg[3]  ( .D(next_crc16[3]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[3]) );
  DFFSR \crc16_reg[4]  ( .D(next_crc16[4]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[4]) );
  DFFSR \crc16_reg[5]  ( .D(next_crc16[5]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[5]) );
  DFFSR \crc16_reg[6]  ( .D(next_crc16[6]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[6]) );
  DFFSR \crc16_reg[7]  ( .D(next_crc16[7]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[7]) );
  DFFSR \crc16_reg[8]  ( .D(next_crc16[8]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[8]) );
  DFFSR \crc16_reg[9]  ( .D(next_crc16[9]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[9]) );
  DFFSR \crc16_reg[10]  ( .D(next_crc16[10]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[10]) );
  DFFSR \crc16_reg[11]  ( .D(next_crc16[11]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[11]) );
  DFFSR \crc16_reg[12]  ( .D(next_crc16[12]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[12]) );
  DFFSR \crc16_reg[13]  ( .D(next_crc16[13]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[13]) );
  DFFSR \crc16_reg[14]  ( .D(next_crc16[14]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[14]) );
  DFFSR \crc16_reg[15]  ( .D(next_crc16[15]), .CLK(clk), .R(1'b1), .S(n_rst), 
        .Q(crc16[15]) );
  DFFSR \ones_count_reg[0]  ( .D(next_ones_count[0]), .CLK(clk), .R(n_rst), 
        .S(1'b1), .Q(ones_count[0]) );
  DFFSR \ones_count_reg[1]  ( .D(next_ones_count[1]), .CLK(clk), .R(n_rst), 
        .S(1'b1), .Q(ones_count[1]) );
  DFFSR dp_orig_reg ( .D(next_dp_orig), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        dp_orig) );
  flex_counter_SIZE4 clk_div ( .clk(clk), .n_rst(n_rst), .clear(1'b0), 
        .count_enable(1'b1), .rollover_val({n396, \rollover_val[2] , 
        \rollover_val[2] , \rollover_val[2] }), .rollover_flag(bit_pulse) );
  flex_sr_SIZE8 data_sr ( .clk(clk), .n_rst(n_rst), .shift_enable(shift_en), 
        .load_enable(load_en), .serial_in(1'b0), .parallel_in(sr_load_data), 
        .serial_out(serial_out) );
  BUFX2 U251 ( .A(n286), .Y(n214) );
  OR2X1 U252 ( .A(n215), .B(get_tx_packet_data), .Y(tx_transfer_active) );
  OAI21X1 U253 ( .A(n216), .B(n217), .C(n218), .Y(sr_load_data[7]) );
  NAND2X1 U254 ( .A(tx_packet_data[7]), .B(n219), .Y(n218) );
  OR2X1 U255 ( .A(n220), .B(tx_packet[2]), .Y(n217) );
  OAI21X1 U256 ( .A(n220), .B(n221), .C(n222), .Y(sr_load_data[6]) );
  NAND2X1 U257 ( .A(tx_packet_data[6]), .B(n219), .Y(n222) );
  AND2X1 U258 ( .A(tx_packet_data[5]), .B(n219), .Y(sr_load_data[5]) );
  OAI21X1 U259 ( .A(n223), .B(n220), .C(n224), .Y(sr_load_data[4]) );
  NAND2X1 U260 ( .A(tx_packet_data[4]), .B(n219), .Y(n224) );
  INVX1 U261 ( .A(n225), .Y(n223) );
  OAI21X1 U262 ( .A(n226), .B(n227), .C(n228), .Y(sr_load_data[3]) );
  OAI21X1 U263 ( .A(tx_packet[2]), .B(n216), .C(n229), .Y(n228) );
  INVX1 U264 ( .A(tx_packet_data[3]), .Y(n227) );
  OAI21X1 U265 ( .A(n230), .B(n220), .C(n231), .Y(sr_load_data[2]) );
  NAND2X1 U266 ( .A(tx_packet_data[2]), .B(n219), .Y(n231) );
  INVX1 U267 ( .A(n221), .Y(n230) );
  XOR2X1 U268 ( .A(tx_packet[2]), .B(n232), .Y(n221) );
  OAI21X1 U269 ( .A(n226), .B(n233), .C(n220), .Y(sr_load_data[1]) );
  INVX1 U270 ( .A(tx_packet_data[1]), .Y(n233) );
  OAI21X1 U271 ( .A(n226), .B(n234), .C(n235), .Y(sr_load_data[0]) );
  INVX1 U272 ( .A(tx_packet_data[0]), .Y(n234) );
  INVX1 U273 ( .A(n219), .Y(n226) );
  NAND3X1 U274 ( .A(n236), .B(n237), .C(n238), .Y(n219) );
  INVX1 U275 ( .A(n239), .Y(shift_en) );
  INVX1 U276 ( .A(n396), .Y(\rollover_val[2] ) );
  OAI21X1 U277 ( .A(n240), .B(n241), .C(n242), .Y(next_stuff_active) );
  NAND3X1 U278 ( .A(n215), .B(n243), .C(stuff_active), .Y(n242) );
  NAND2X1 U279 ( .A(n244), .B(n245), .Y(n241) );
  INVX1 U280 ( .A(ones_count[1]), .Y(n245) );
  MUX2X1 U281 ( .B(n246), .A(n247), .S(ones_count[2]), .Y(next_ones_count[2])
         );
  NAND2X1 U282 ( .A(ones_count[1]), .B(n244), .Y(n246) );
  MUX2X1 U283 ( .B(n248), .A(n247), .S(ones_count[1]), .Y(next_ones_count[1])
         );
  NAND2X1 U284 ( .A(n249), .B(n215), .Y(n247) );
  OAI21X1 U285 ( .A(n250), .B(n251), .C(bit_pulse), .Y(n249) );
  NAND2X1 U286 ( .A(n252), .B(n253), .Y(n251) );
  NAND2X1 U287 ( .A(n244), .B(n240), .Y(n248) );
  INVX1 U288 ( .A(ones_count[2]), .Y(n240) );
  NOR2X1 U289 ( .A(n252), .B(n254), .Y(n244) );
  INVX1 U290 ( .A(ones_count[0]), .Y(n252) );
  MUX2X1 U291 ( .B(n254), .A(n255), .S(ones_count[0]), .Y(next_ones_count[0])
         );
  NAND2X1 U292 ( .A(n215), .B(n243), .Y(n255) );
  INVX1 U293 ( .A(bit_pulse), .Y(n243) );
  NAND3X1 U294 ( .A(n256), .B(n215), .C(serial_out), .Y(n254) );
  NAND2X1 U295 ( .A(n257), .B(n258), .Y(next_dp_orig) );
  XNOR2X1 U296 ( .A(dp_orig), .B(n259), .Y(n257) );
  AOI21X1 U297 ( .A(n260), .B(n253), .C(n239), .Y(n259) );
  NAND2X1 U298 ( .A(bit_pulse), .B(n215), .Y(n239) );
  NAND2X1 U299 ( .A(n261), .B(n262), .Y(n215) );
  MUX2X1 U300 ( .B(n250), .A(n263), .S(n264), .Y(n260) );
  MUX2X1 U301 ( .B(n265), .A(n266), .S(N70), .Y(n263) );
  MUX2X1 U302 ( .B(n267), .A(n268), .S(N69), .Y(n266) );
  NAND2X1 U303 ( .A(n269), .B(n270), .Y(n268) );
  AOI22X1 U304 ( .A(n271), .B(crc16[14]), .C(crc16[12]), .D(n272), .Y(n270) );
  NOR2X1 U305 ( .A(N67), .B(n273), .Y(n271) );
  AOI22X1 U306 ( .A(crc16[13]), .B(n274), .C(crc16[15]), .D(n275), .Y(n269) );
  OAI21X1 U307 ( .A(n273), .B(n276), .C(n277), .Y(n267) );
  AOI22X1 U308 ( .A(crc16[8]), .B(n272), .C(crc16[9]), .D(n274), .Y(n277) );
  MUX2X1 U309 ( .B(crc16[10]), .A(crc16[11]), .S(N67), .Y(n276) );
  MUX2X1 U310 ( .B(n278), .A(n279), .S(N69), .Y(n265) );
  OAI21X1 U311 ( .A(n273), .B(n280), .C(n281), .Y(n279) );
  AOI22X1 U312 ( .A(crc16[4]), .B(n272), .C(crc16[5]), .D(n274), .Y(n281) );
  MUX2X1 U313 ( .B(crc16[6]), .A(crc16[7]), .S(N67), .Y(n280) );
  OAI21X1 U314 ( .A(n273), .B(n282), .C(n283), .Y(n278) );
  AOI22X1 U315 ( .A(crc16[0]), .B(n272), .C(crc16[1]), .D(n274), .Y(n283) );
  INVX1 U316 ( .A(n284), .Y(n274) );
  NOR2X1 U317 ( .A(N67), .B(N68), .Y(n272) );
  MUX2X1 U318 ( .B(crc16[2]), .A(crc16[3]), .S(N67), .Y(n282) );
  INVX1 U319 ( .A(serial_out), .Y(n250) );
  NAND2X1 U320 ( .A(n285), .B(n236), .Y(next_crc16[9]) );
  MUX2X1 U321 ( .B(crc16[9]), .A(crc16[8]), .S(n214), .Y(n285) );
  NAND2X1 U322 ( .A(n287), .B(n236), .Y(next_crc16[8]) );
  MUX2X1 U323 ( .B(crc16[8]), .A(crc16[7]), .S(n214), .Y(n287) );
  NAND2X1 U324 ( .A(n288), .B(n236), .Y(next_crc16[7]) );
  MUX2X1 U325 ( .B(crc16[7]), .A(crc16[6]), .S(n214), .Y(n288) );
  NAND2X1 U326 ( .A(n289), .B(n236), .Y(next_crc16[6]) );
  MUX2X1 U327 ( .B(crc16[6]), .A(crc16[5]), .S(n214), .Y(n289) );
  NAND2X1 U328 ( .A(n290), .B(n236), .Y(next_crc16[5]) );
  MUX2X1 U329 ( .B(crc16[5]), .A(crc16[4]), .S(n214), .Y(n290) );
  NAND2X1 U330 ( .A(n291), .B(n236), .Y(next_crc16[4]) );
  MUX2X1 U331 ( .B(crc16[4]), .A(crc16[3]), .S(n214), .Y(n291) );
  NAND2X1 U332 ( .A(n292), .B(n236), .Y(next_crc16[3]) );
  MUX2X1 U333 ( .B(crc16[3]), .A(crc16[2]), .S(n214), .Y(n292) );
  OR2X1 U334 ( .A(n293), .B(n294), .Y(next_crc16[2]) );
  OAI21X1 U335 ( .A(crc16[1]), .B(n295), .C(n236), .Y(n294) );
  MUX2X1 U336 ( .B(n296), .A(n297), .S(n214), .Y(n293) );
  NAND2X1 U337 ( .A(crc16[1]), .B(n298), .Y(n297) );
  INVX1 U338 ( .A(crc16[2]), .Y(n296) );
  NAND2X1 U339 ( .A(n299), .B(n236), .Y(next_crc16[1]) );
  MUX2X1 U340 ( .B(crc16[1]), .A(crc16[0]), .S(n214), .Y(n299) );
  OR2X1 U341 ( .A(n300), .B(n301), .Y(next_crc16[15]) );
  OAI21X1 U342 ( .A(crc16[14]), .B(n295), .C(n236), .Y(n301) );
  MUX2X1 U343 ( .B(n302), .A(n303), .S(n214), .Y(n300) );
  NAND2X1 U344 ( .A(crc16[14]), .B(n298), .Y(n303) );
  INVX1 U345 ( .A(n304), .Y(n298) );
  NAND2X1 U346 ( .A(n305), .B(n236), .Y(next_crc16[14]) );
  MUX2X1 U347 ( .B(crc16[14]), .A(crc16[13]), .S(n214), .Y(n305) );
  NAND2X1 U348 ( .A(n306), .B(n236), .Y(next_crc16[13]) );
  MUX2X1 U349 ( .B(crc16[13]), .A(crc16[12]), .S(n214), .Y(n306) );
  NAND2X1 U350 ( .A(n307), .B(n236), .Y(next_crc16[12]) );
  MUX2X1 U351 ( .B(crc16[12]), .A(crc16[11]), .S(n214), .Y(n307) );
  NAND2X1 U352 ( .A(n308), .B(n236), .Y(next_crc16[11]) );
  MUX2X1 U353 ( .B(crc16[11]), .A(crc16[10]), .S(n214), .Y(n308) );
  NAND2X1 U354 ( .A(n309), .B(n236), .Y(next_crc16[10]) );
  MUX2X1 U355 ( .B(crc16[10]), .A(crc16[9]), .S(n214), .Y(n309) );
  OAI21X1 U356 ( .A(n214), .B(n310), .C(n311), .Y(next_crc16[0]) );
  AND2X1 U357 ( .A(n295), .B(n236), .Y(n311) );
  NAND2X1 U358 ( .A(n214), .B(n304), .Y(n295) );
  XNOR2X1 U359 ( .A(n302), .B(serial_out), .Y(n304) );
  INVX1 U360 ( .A(crc16[15]), .Y(n302) );
  INVX1 U361 ( .A(crc16[0]), .Y(n310) );
  NOR2X1 U362 ( .A(n312), .B(n313), .Y(n286) );
  NOR2X1 U363 ( .A(n314), .B(pattern_state[0]), .Y(n396) );
  INVX1 U364 ( .A(n315), .Y(tx_error) );
  OAI21X1 U365 ( .A(n316), .B(n317), .C(n318), .Y(n213) );
  OAI21X1 U366 ( .A(n319), .B(n320), .C(\bit_counter[4] ), .Y(n318) );
  NOR2X1 U367 ( .A(N70), .B(n316), .Y(n319) );
  OAI21X1 U368 ( .A(n321), .B(n322), .C(n323), .Y(n212) );
  NAND3X1 U369 ( .A(n324), .B(N68), .C(n325), .Y(n323) );
  INVX1 U370 ( .A(n326), .Y(n324) );
  INVX1 U371 ( .A(currentState[3]), .Y(n322) );
  NAND3X1 U372 ( .A(n327), .B(n328), .C(n329), .Y(n211) );
  AOI22X1 U373 ( .A(currentState[0]), .B(n330), .C(n331), .D(
        get_tx_packet_data), .Y(n329) );
  OAI21X1 U374 ( .A(n256), .B(n237), .C(n321), .Y(n330) );
  NOR2X1 U375 ( .A(n332), .B(n333), .Y(n321) );
  OAI21X1 U376 ( .A(n334), .B(n335), .C(n336), .Y(n333) );
  INVX1 U377 ( .A(n337), .Y(n335) );
  OAI21X1 U378 ( .A(tx_packet[2]), .B(n338), .C(n339), .Y(n328) );
  INVX1 U379 ( .A(n236), .Y(n339) );
  AOI21X1 U380 ( .A(n340), .B(n334), .C(n341), .Y(n327) );
  INVX1 U381 ( .A(n342), .Y(n341) );
  NOR2X1 U382 ( .A(n220), .B(n225), .Y(n340) );
  OAI21X1 U383 ( .A(n235), .B(n343), .C(n344), .Y(n210) );
  AND2X1 U384 ( .A(n345), .B(n342), .Y(n344) );
  NAND3X1 U385 ( .A(n346), .B(n253), .C(n334), .Y(n342) );
  OAI21X1 U386 ( .A(n347), .B(n348), .C(currentState[1]), .Y(n345) );
  OAI21X1 U387 ( .A(n237), .B(n349), .C(n220), .Y(n348) );
  NAND2X1 U388 ( .A(n350), .B(n313), .Y(n349) );
  INVX1 U389 ( .A(n351), .Y(n235) );
  OAI21X1 U390 ( .A(n220), .B(n225), .C(n352), .Y(n351) );
  OR2X1 U391 ( .A(n353), .B(n354), .Y(n209) );
  OAI21X1 U392 ( .A(n312), .B(n350), .C(n355), .Y(n354) );
  OAI21X1 U393 ( .A(n356), .B(n347), .C(currentState[2]), .Y(n355) );
  NAND3X1 U394 ( .A(n357), .B(n262), .C(n358), .Y(n347) );
  INVX1 U395 ( .A(n332), .Y(n358) );
  OAI21X1 U396 ( .A(n256), .B(n359), .C(n360), .Y(n332) );
  AND2X1 U397 ( .A(n258), .B(n315), .Y(n359) );
  NAND3X1 U398 ( .A(currentState[0]), .B(n361), .C(n362), .Y(n315) );
  NAND3X1 U399 ( .A(n363), .B(n364), .C(currentState[3]), .Y(n258) );
  OAI21X1 U400 ( .A(n343), .B(n365), .C(n366), .Y(n353) );
  OAI21X1 U401 ( .A(n331), .B(n256), .C(get_tx_packet_data), .Y(n366) );
  INVX1 U402 ( .A(n350), .Y(n331) );
  NAND3X1 U403 ( .A(n367), .B(n368), .C(n369), .Y(n350) );
  NOR2X1 U404 ( .A(buffer_occupancy[0]), .B(n370), .Y(n369) );
  OR2X1 U405 ( .A(buffer_occupancy[2]), .B(buffer_occupancy[1]), .Y(n370) );
  NOR2X1 U406 ( .A(buffer_occupancy[6]), .B(buffer_occupancy[5]), .Y(n368) );
  NOR2X1 U407 ( .A(buffer_occupancy[4]), .B(buffer_occupancy[3]), .Y(n367) );
  NAND2X1 U408 ( .A(n229), .B(n225), .Y(n365) );
  OAI21X1 U409 ( .A(n216), .B(n371), .C(n372), .Y(n225) );
  NOR2X1 U410 ( .A(tx_packet[2]), .B(n232), .Y(n372) );
  INVX1 U411 ( .A(n338), .Y(n232) );
  NAND2X1 U412 ( .A(n371), .B(n216), .Y(n338) );
  INVX1 U413 ( .A(tx_packet[1]), .Y(n371) );
  INVX1 U414 ( .A(tx_packet[0]), .Y(n216) );
  INVX1 U415 ( .A(n220), .Y(n229) );
  MUX2X1 U416 ( .B(n373), .A(n374), .S(N70), .Y(n208) );
  INVX1 U417 ( .A(n320), .Y(n374) );
  OAI21X1 U418 ( .A(n375), .B(n316), .C(n376), .Y(n320) );
  NAND2X1 U419 ( .A(n377), .B(n375), .Y(n373) );
  MUX2X1 U420 ( .B(n378), .A(n379), .S(N69), .Y(n207) );
  INVX1 U421 ( .A(n380), .Y(n379) );
  OAI21X1 U422 ( .A(n316), .B(n275), .C(n376), .Y(n380) );
  NAND2X1 U423 ( .A(n377), .B(n275), .Y(n378) );
  INVX1 U424 ( .A(n316), .Y(n377) );
  OAI21X1 U425 ( .A(n284), .B(n316), .C(n381), .Y(n206) );
  NAND2X1 U426 ( .A(N68), .B(n382), .Y(n381) );
  OAI21X1 U427 ( .A(N67), .B(n316), .C(n376), .Y(n382) );
  NAND2X1 U428 ( .A(N67), .B(n273), .Y(n284) );
  MUX2X1 U429 ( .B(n316), .A(n376), .S(N67), .Y(n205) );
  AOI21X1 U430 ( .A(n383), .B(n313), .C(n384), .Y(n376) );
  NAND2X1 U431 ( .A(n236), .B(n360), .Y(n384) );
  OAI21X1 U432 ( .A(currentState[2]), .B(n385), .C(currentState[3]), .Y(n360)
         );
  INVX1 U433 ( .A(n363), .Y(n385) );
  NAND2X1 U434 ( .A(n363), .B(n238), .Y(n236) );
  NAND2X1 U435 ( .A(n256), .B(n383), .Y(n316) );
  NAND3X1 U436 ( .A(n357), .B(n336), .C(n386), .Y(n383) );
  INVX1 U437 ( .A(n356), .Y(n386) );
  OAI22X1 U438 ( .A(n253), .B(n312), .C(n334), .D(n261), .Y(n356) );
  NOR2X1 U439 ( .A(n337), .B(n346), .Y(n261) );
  INVX1 U440 ( .A(n312), .Y(n346) );
  INVX1 U441 ( .A(n343), .Y(n334) );
  NAND3X1 U442 ( .A(n387), .B(n388), .C(n375), .Y(n343) );
  NAND2X1 U443 ( .A(n363), .B(n362), .Y(n312) );
  NOR2X1 U444 ( .A(currentState[0]), .B(currentState[1]), .Y(n363) );
  NAND2X1 U445 ( .A(n264), .B(n317), .Y(n336) );
  NAND3X1 U446 ( .A(N70), .B(n388), .C(n375), .Y(n317) );
  AND2X1 U447 ( .A(N69), .B(n275), .Y(n375) );
  NOR2X1 U448 ( .A(n273), .B(n389), .Y(n275) );
  INVX1 U449 ( .A(N67), .Y(n389) );
  INVX1 U450 ( .A(n262), .Y(n264) );
  NAND3X1 U451 ( .A(currentState[1]), .B(currentState[0]), .C(n362), .Y(n262)
         );
  OAI21X1 U452 ( .A(n273), .B(n326), .C(n325), .Y(n357) );
  INVX1 U453 ( .A(n313), .Y(n256) );
  NAND2X1 U454 ( .A(bit_pulse), .B(n253), .Y(n313) );
  INVX1 U455 ( .A(stuff_active), .Y(n253) );
  MUX2X1 U456 ( .B(n390), .A(bit_pulse), .S(pattern_state[0]), .Y(n185) );
  NAND2X1 U457 ( .A(bit_pulse), .B(n314), .Y(n390) );
  INVX1 U458 ( .A(pattern_state[1]), .Y(n314) );
  MUX2X1 U459 ( .B(n391), .A(bit_pulse), .S(pattern_state[1]), .Y(n183) );
  NAND2X1 U460 ( .A(pattern_state[0]), .B(bit_pulse), .Y(n391) );
  NOR2X1 U461 ( .A(n326), .B(n392), .Y(load_en) );
  OAI21X1 U462 ( .A(get_tx_packet_data), .B(n337), .C(n273), .Y(n392) );
  INVX1 U463 ( .A(N68), .Y(n273) );
  NAND2X1 U464 ( .A(n220), .B(n352), .Y(n337) );
  NAND3X1 U465 ( .A(n238), .B(n361), .C(currentState[0]), .Y(n352) );
  INVX1 U466 ( .A(currentState[1]), .Y(n361) );
  NAND3X1 U467 ( .A(n238), .B(n393), .C(currentState[1]), .Y(n220) );
  INVX1 U468 ( .A(n237), .Y(get_tx_packet_data) );
  NAND3X1 U469 ( .A(currentState[0]), .B(n238), .C(currentState[1]), .Y(n237)
         );
  NOR2X1 U470 ( .A(currentState[2]), .B(currentState[3]), .Y(n238) );
  NAND3X1 U471 ( .A(n387), .B(n388), .C(n394), .Y(n326) );
  NOR2X1 U472 ( .A(N69), .B(N67), .Y(n394) );
  INVX1 U473 ( .A(\bit_counter[4] ), .Y(n388) );
  INVX1 U474 ( .A(N70), .Y(n387) );
  AND2X1 U475 ( .A(n395), .B(dp_orig), .Y(dp_out) );
  NOR2X1 U476 ( .A(dp_orig), .B(n325), .Y(dm_out) );
  INVX1 U477 ( .A(n395), .Y(n325) );
  NAND3X1 U478 ( .A(currentState[1]), .B(n393), .C(n362), .Y(n395) );
  NOR2X1 U479 ( .A(n364), .B(currentState[3]), .Y(n362) );
  INVX1 U480 ( .A(currentState[2]), .Y(n364) );
  INVX1 U481 ( .A(currentState[0]), .Y(n393) );
endmodule

