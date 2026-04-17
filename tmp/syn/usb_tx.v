/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Wed Apr 15 21:47:50 2026
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
  input [1:0] tx_packet;
  input [6:0] buffer_occupancy;
  input clk, n_rst;
  output get_tx_packet_data, tx_transfer_active, tx_error, dm_out, dp_out;
  wire   bit_pulse, \rollover_val[2] , serial_out, dp_orig, n91, n93, n98, n99,
         n100, n101, n102, n103, n104, n105, n106, n107, n108, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127, n128, n129, n130, n131, n132, n133,
         n134, n135, n136, n137, n138, n139, n140, n141, n142, n143, n144,
         n145, n146, n147, n148, n149, n150, n151, n152, n153, n154, n155,
         n156, n157, n158, n159, n160, n161, n162, n163, n164, n165, n166,
         n167, n168, n169, n170, n171, n172, n173, n174, n175, n176, n177,
         n178, n179, n180, n181, n182, n183, n184, n185, n186, n187, n188,
         n189, n190, n191, n192, n194;
  wire   [3:0] currentState;
  wire   [4:0] bit_counter;
  wire   [1:0] pattern_state;
  wire   [1:0] eop_count;

  DFFSR \pattern_state_reg[0]  ( .D(n93), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        pattern_state[0]) );
  DFFSR \pattern_state_reg[1]  ( .D(n91), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        pattern_state[1]) );
  DFFSR \bit_counter_reg[0]  ( .D(n100), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bit_counter[0]) );
  DFFSR \bit_counter_reg[1]  ( .D(n101), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bit_counter[1]) );
  DFFSR \currentState_reg[2]  ( .D(n104), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currentState[2]) );
  DFFSR \currentState_reg[1]  ( .D(n105), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currentState[1]) );
  DFFSR \bit_counter_reg[4]  ( .D(n108), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bit_counter[4]) );
  DFFSR \bit_counter_reg[2]  ( .D(n102), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bit_counter[2]) );
  DFFSR \bit_counter_reg[3]  ( .D(n103), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bit_counter[3]) );
  DFFSR \currentState_reg[0]  ( .D(n106), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currentState[0]) );
  DFFSR \currentState_reg[3]  ( .D(n107), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currentState[3]) );
  DFFSR dp_orig_reg ( .D(n99), .CLK(clk), .R(1'b1), .S(n_rst), .Q(dp_orig) );
  DFFSR \eop_count_reg[0]  ( .D(n98), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        eop_count[0]) );
  DFFSR \eop_count_reg[1]  ( .D(n194), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        eop_count[1]) );
  flex_counter_SIZE4 clk_div ( .clk(clk), .n_rst(n_rst), .clear(1'b0), 
        .count_enable(1'b1), .rollover_val({n192, \rollover_val[2] , 
        \rollover_val[2] , \rollover_val[2] }), .rollover_flag(bit_pulse) );
  flex_sr_SIZE8 data_sr ( .clk(clk), .n_rst(n_rst), .shift_enable(n191), 
        .load_enable(get_tx_packet_data), .serial_in(1'b0), .parallel_in(
        tx_packet_data), .serial_out(serial_out) );
  NOR2X1 U116 ( .A(n110), .B(n111), .Y(tx_error) );
  NAND2X1 U117 ( .A(currentState[2]), .B(currentState[0]), .Y(n111) );
  NAND2X1 U118 ( .A(n112), .B(n113), .Y(n110) );
  INVX1 U119 ( .A(n192), .Y(\rollover_val[2] ) );
  INVX1 U120 ( .A(n114), .Y(n191) );
  NOR2X1 U121 ( .A(n115), .B(pattern_state[0]), .Y(n192) );
  INVX1 U122 ( .A(n116), .Y(n194) );
  OAI21X1 U123 ( .A(eop_count[1]), .B(eop_count[0]), .C(n117), .Y(n116) );
  XOR2X1 U124 ( .A(dp_orig), .B(n118), .Y(n99) );
  NOR2X1 U125 ( .A(serial_out), .B(n114), .Y(n118) );
  NAND2X1 U126 ( .A(bit_pulse), .B(tx_transfer_active), .Y(n114) );
  NAND3X1 U127 ( .A(n119), .B(n120), .C(n121), .Y(tx_transfer_active) );
  MUX2X1 U128 ( .B(n122), .A(n123), .S(eop_count[0]), .Y(n98) );
  NAND2X1 U129 ( .A(eop_count[1]), .B(n117), .Y(n123) );
  INVX1 U130 ( .A(n124), .Y(n117) );
  MUX2X1 U131 ( .B(n125), .A(bit_pulse), .S(pattern_state[0]), .Y(n93) );
  NAND2X1 U132 ( .A(bit_pulse), .B(n115), .Y(n125) );
  INVX1 U133 ( .A(pattern_state[1]), .Y(n115) );
  MUX2X1 U134 ( .B(n126), .A(bit_pulse), .S(pattern_state[1]), .Y(n91) );
  NAND2X1 U135 ( .A(pattern_state[0]), .B(bit_pulse), .Y(n126) );
  OAI21X1 U136 ( .A(n127), .B(n128), .C(n129), .Y(n108) );
  NAND3X1 U137 ( .A(bit_counter[3]), .B(n130), .C(n131), .Y(n129) );
  INVX1 U138 ( .A(bit_counter[4]), .Y(n128) );
  AOI21X1 U139 ( .A(n131), .B(n132), .C(n133), .Y(n127) );
  OAI21X1 U140 ( .A(n124), .B(n134), .C(n135), .Y(n107) );
  OR2X1 U141 ( .A(n136), .B(n137), .Y(n106) );
  OAI21X1 U142 ( .A(n138), .B(n119), .C(n139), .Y(n137) );
  OAI21X1 U143 ( .A(n140), .B(n141), .C(currentState[0]), .Y(n139) );
  NAND3X1 U144 ( .A(n142), .B(n143), .C(n144), .Y(n136) );
  OAI21X1 U145 ( .A(tx_packet[0]), .B(tx_packet[1]), .C(n145), .Y(n144) );
  INVX1 U146 ( .A(n146), .Y(n142) );
  NOR3X1 U147 ( .A(n147), .B(tx_packet[1]), .C(n148), .Y(n146) );
  OAI21X1 U148 ( .A(n121), .B(n147), .C(n149), .Y(n105) );
  AOI21X1 U149 ( .A(currentState[1]), .B(n150), .C(n151), .Y(n149) );
  INVX1 U150 ( .A(n143), .Y(n151) );
  NAND3X1 U151 ( .A(n121), .B(n135), .C(n152), .Y(n150) );
  INVX1 U152 ( .A(n153), .Y(n121) );
  OR2X1 U153 ( .A(n154), .B(n155), .Y(n104) );
  OAI21X1 U154 ( .A(n156), .B(n135), .C(n152), .Y(n155) );
  INVX1 U155 ( .A(n157), .Y(n152) );
  OAI21X1 U156 ( .A(n158), .B(n124), .C(n120), .Y(n157) );
  OAI21X1 U157 ( .A(n138), .B(n143), .C(n159), .Y(n154) );
  AOI21X1 U158 ( .A(n160), .B(tx_packet[1]), .C(get_tx_packet_data), .Y(n159)
         );
  INVX1 U159 ( .A(n119), .Y(get_tx_packet_data) );
  NAND3X1 U160 ( .A(n161), .B(n156), .C(currentState[0]), .Y(n119) );
  NOR2X1 U161 ( .A(n147), .B(n148), .Y(n160) );
  NAND3X1 U162 ( .A(n112), .B(n113), .C(n162), .Y(n143) );
  NOR2X1 U163 ( .A(currentState[0]), .B(n156), .Y(n162) );
  NAND3X1 U164 ( .A(n163), .B(n164), .C(n165), .Y(n138) );
  NOR2X1 U165 ( .A(buffer_occupancy[0]), .B(n166), .Y(n165) );
  OR2X1 U166 ( .A(buffer_occupancy[2]), .B(buffer_occupancy[1]), .Y(n166) );
  NOR2X1 U167 ( .A(buffer_occupancy[6]), .B(buffer_occupancy[5]), .Y(n164) );
  NOR2X1 U168 ( .A(buffer_occupancy[4]), .B(buffer_occupancy[3]), .Y(n163) );
  MUX2X1 U169 ( .B(n167), .A(n168), .S(bit_counter[3]), .Y(n103) );
  INVX1 U170 ( .A(n133), .Y(n168) );
  OAI21X1 U171 ( .A(n169), .B(n170), .C(n171), .Y(n133) );
  NAND2X1 U172 ( .A(n131), .B(n169), .Y(n167) );
  INVX1 U173 ( .A(n172), .Y(n169) );
  MUX2X1 U174 ( .B(n173), .A(n174), .S(bit_counter[2]), .Y(n102) );
  AOI21X1 U175 ( .A(n131), .B(n175), .C(n176), .Y(n174) );
  NAND3X1 U176 ( .A(bit_counter[1]), .B(bit_counter[0]), .C(n131), .Y(n173) );
  MUX2X1 U177 ( .B(n177), .A(n178), .S(bit_counter[1]), .Y(n101) );
  INVX1 U178 ( .A(n176), .Y(n178) );
  OAI21X1 U179 ( .A(bit_counter[0]), .B(n170), .C(n171), .Y(n176) );
  NAND2X1 U180 ( .A(n131), .B(bit_counter[0]), .Y(n177) );
  INVX1 U181 ( .A(n170), .Y(n131) );
  MUX2X1 U182 ( .B(n170), .A(n171), .S(bit_counter[0]), .Y(n100) );
  INVX1 U183 ( .A(n179), .Y(n171) );
  OAI21X1 U184 ( .A(bit_pulse), .B(n180), .C(n181), .Y(n179) );
  NOR2X1 U185 ( .A(n145), .B(n140), .Y(n181) );
  INVX1 U186 ( .A(n135), .Y(n140) );
  OAI21X1 U187 ( .A(currentState[0]), .B(n182), .C(currentState[3]), .Y(n135)
         );
  NAND2X1 U188 ( .A(n112), .B(n156), .Y(n182) );
  NOR2X1 U189 ( .A(n183), .B(currentState[0]), .Y(n145) );
  INVX1 U190 ( .A(n141), .Y(n180) );
  NAND2X1 U191 ( .A(bit_pulse), .B(n141), .Y(n170) );
  OAI21X1 U192 ( .A(n158), .B(n124), .C(n184), .Y(n141) );
  AOI21X1 U193 ( .A(n147), .B(n153), .C(n185), .Y(n184) );
  AOI21X1 U194 ( .A(bit_counter[3]), .B(n130), .C(n120), .Y(n185) );
  NAND3X1 U195 ( .A(currentState[0]), .B(n161), .C(currentState[2]), .Y(n120)
         );
  OAI21X1 U196 ( .A(n186), .B(n183), .C(n148), .Y(n153) );
  NAND3X1 U197 ( .A(n186), .B(n156), .C(n161), .Y(n148) );
  NAND3X1 U198 ( .A(n156), .B(n113), .C(n112), .Y(n183) );
  INVX1 U199 ( .A(currentState[3]), .Y(n113) );
  INVX1 U200 ( .A(currentState[2]), .Y(n156) );
  NAND2X1 U201 ( .A(n130), .B(n132), .Y(n147) );
  INVX1 U202 ( .A(bit_counter[3]), .Y(n132) );
  NOR2X1 U203 ( .A(n172), .B(bit_counter[4]), .Y(n130) );
  NAND3X1 U204 ( .A(bit_counter[1]), .B(bit_counter[0]), .C(bit_counter[2]), 
        .Y(n172) );
  INVX1 U205 ( .A(n134), .Y(n158) );
  NAND3X1 U206 ( .A(n187), .B(n188), .C(n189), .Y(n134) );
  NOR2X1 U207 ( .A(bit_counter[0]), .B(n175), .Y(n189) );
  INVX1 U208 ( .A(bit_counter[1]), .Y(n175) );
  INVX1 U209 ( .A(bit_counter[2]), .Y(n188) );
  NOR2X1 U210 ( .A(bit_counter[4]), .B(bit_counter[3]), .Y(n187) );
  AND2X1 U211 ( .A(n122), .B(dp_orig), .Y(dp_out) );
  INVX1 U212 ( .A(n190), .Y(n122) );
  NOR2X1 U213 ( .A(dp_orig), .B(n190), .Y(dm_out) );
  NOR2X1 U214 ( .A(n124), .B(eop_count[1]), .Y(n190) );
  NAND3X1 U215 ( .A(n161), .B(n186), .C(currentState[2]), .Y(n124) );
  INVX1 U216 ( .A(currentState[0]), .Y(n186) );
  NOR2X1 U217 ( .A(n112), .B(currentState[3]), .Y(n161) );
  INVX1 U218 ( .A(currentState[1]), .Y(n112) );
endmodule

