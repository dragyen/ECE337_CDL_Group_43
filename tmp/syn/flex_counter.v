/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Wed Apr 15 17:36:46 2026
/////////////////////////////////////////////////////////////


module flex_counter_DW01_inc_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  HAX1 U1_1_6 ( .A(A[6]), .B(carry[6]), .YC(carry[7]), .YS(SUM[6]) );
  HAX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .YC(carry[6]), .YS(SUM[5]) );
  HAX1 U1_1_4 ( .A(A[4]), .B(carry[4]), .YC(carry[5]), .YS(SUM[4]) );
  HAX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .YC(carry[4]), .YS(SUM[3]) );
  HAX1 U1_1_2 ( .A(A[2]), .B(carry[2]), .YC(carry[3]), .YS(SUM[2]) );
  HAX1 U1_1_1 ( .A(A[1]), .B(A[0]), .YC(carry[2]), .YS(SUM[1]) );
  INVX2 U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2X1 U2 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
endmodule


module flex_counter ( clk, n_rst, clear, count_enable, rollover_val, count_out, 
        rollover_flag );
  input [7:0] rollover_val;
  output [7:0] count_out;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   next_rollover_flag, N10, N11, N12, N13, N14, N15, N16, N17, n67, n68,
         n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82,
         n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96,
         n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108,
         n109, n110, n111, n112, n113, n114, n115, n116, n117, n118, n119,
         n120, n121, n122, n123, n124, n125, n126, n127, n128, n129, n130,
         n131;
  wire   [7:0] next_count_out;

  DFFSR \count_out_reg[0]  ( .D(next_count_out[0]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[0]) );
  DFFSR \count_out_reg[1]  ( .D(next_count_out[1]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[1]) );
  DFFSR \count_out_reg[2]  ( .D(next_count_out[2]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[2]) );
  DFFSR \count_out_reg[3]  ( .D(next_count_out[3]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[3]) );
  DFFSR \count_out_reg[4]  ( .D(next_count_out[4]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[4]) );
  DFFSR \count_out_reg[5]  ( .D(next_count_out[5]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[5]) );
  DFFSR \count_out_reg[6]  ( .D(next_count_out[6]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[6]) );
  DFFSR \count_out_reg[7]  ( .D(next_count_out[7]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(count_out[7]) );
  DFFSR rollover_flag_reg ( .D(next_rollover_flag), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(rollover_flag) );
  flex_counter_DW01_inc_0 add_41 ( .A(count_out), .SUM({N17, N16, N15, N14, 
        N13, N12, N11, N10}) );
  NOR2X1 U69 ( .A(n67), .B(n68), .Y(next_rollover_flag) );
  NAND3X1 U70 ( .A(n69), .B(n70), .C(n71), .Y(n68) );
  NOR2X1 U71 ( .A(n72), .B(n73), .Y(n71) );
  XOR2X1 U72 ( .A(rollover_val[4]), .B(next_count_out[4]), .Y(n73) );
  XOR2X1 U73 ( .A(rollover_val[3]), .B(next_count_out[3]), .Y(n72) );
  XOR2X1 U74 ( .A(n74), .B(next_count_out[5]), .Y(n70) );
  XNOR2X1 U75 ( .A(rollover_val[6]), .B(next_count_out[6]), .Y(n69) );
  NAND3X1 U76 ( .A(n75), .B(n76), .C(n77), .Y(n67) );
  NOR2X1 U77 ( .A(n78), .B(n79), .Y(n77) );
  XOR2X1 U78 ( .A(rollover_val[1]), .B(next_count_out[1]), .Y(n79) );
  XOR2X1 U79 ( .A(next_count_out[0]), .B(rollover_val[0]), .Y(n78) );
  XNOR2X1 U80 ( .A(rollover_val[2]), .B(next_count_out[2]), .Y(n76) );
  XOR2X1 U81 ( .A(n80), .B(next_count_out[7]), .Y(n75) );
  OAI21X1 U82 ( .A(n81), .B(n82), .C(n83), .Y(next_count_out[7]) );
  NAND2X1 U83 ( .A(N17), .B(n84), .Y(n83) );
  OAI21X1 U84 ( .A(n85), .B(n82), .C(n86), .Y(next_count_out[6]) );
  NAND2X1 U85 ( .A(N16), .B(n84), .Y(n86) );
  OAI21X1 U86 ( .A(n87), .B(n82), .C(n88), .Y(next_count_out[5]) );
  NAND2X1 U87 ( .A(N15), .B(n84), .Y(n88) );
  OAI21X1 U88 ( .A(n89), .B(n82), .C(n90), .Y(next_count_out[4]) );
  NAND2X1 U89 ( .A(N14), .B(n84), .Y(n90) );
  OAI21X1 U90 ( .A(n91), .B(n82), .C(n92), .Y(next_count_out[3]) );
  NAND2X1 U91 ( .A(N13), .B(n84), .Y(n92) );
  OAI21X1 U92 ( .A(n93), .B(n82), .C(n94), .Y(next_count_out[2]) );
  NAND2X1 U93 ( .A(N12), .B(n84), .Y(n94) );
  OAI21X1 U94 ( .A(n95), .B(n82), .C(n96), .Y(next_count_out[1]) );
  NAND2X1 U95 ( .A(N11), .B(n84), .Y(n96) );
  INVX1 U96 ( .A(n97), .Y(n84) );
  INVX1 U97 ( .A(n98), .Y(n82) );
  OAI21X1 U98 ( .A(n97), .B(n99), .C(n100), .Y(next_count_out[0]) );
  AOI22X1 U99 ( .A(n101), .B(count_enable), .C(n98), .D(count_out[0]), .Y(n100) );
  NOR2X1 U100 ( .A(clear), .B(count_enable), .Y(n98) );
  NOR2X1 U101 ( .A(clear), .B(n102), .Y(n101) );
  INVX1 U102 ( .A(N10), .Y(n99) );
  NAND3X1 U103 ( .A(count_enable), .B(n103), .C(n102), .Y(n97) );
  AOI21X1 U104 ( .A(count_out[7]), .B(n104), .C(n105), .Y(n102) );
  OAI21X1 U105 ( .A(n106), .B(n107), .C(n108), .Y(n105) );
  OAI21X1 U106 ( .A(count_out[7]), .B(n104), .C(n80), .Y(n108) );
  INVX1 U107 ( .A(rollover_val[7]), .Y(n80) );
  NAND2X1 U108 ( .A(n109), .B(n110), .Y(n107) );
  AOI22X1 U109 ( .A(rollover_val[5]), .B(n87), .C(rollover_val[7]), .D(n81), 
        .Y(n110) );
  INVX1 U110 ( .A(count_out[7]), .Y(n81) );
  AOI22X1 U111 ( .A(rollover_val[1]), .B(n95), .C(rollover_val[3]), .D(n91), 
        .Y(n109) );
  NAND3X1 U112 ( .A(n111), .B(n112), .C(n113), .Y(n106) );
  NOR2X1 U113 ( .A(rollover_val[0]), .B(n114), .Y(n113) );
  INVX1 U114 ( .A(n115), .Y(n114) );
  OAI21X1 U115 ( .A(rollover_val[6]), .B(n85), .C(n116), .Y(n104) );
  NAND2X1 U116 ( .A(n117), .B(n112), .Y(n116) );
  NAND2X1 U117 ( .A(rollover_val[6]), .B(n85), .Y(n112) );
  OAI21X1 U118 ( .A(n118), .B(n87), .C(n119), .Y(n117) );
  OAI21X1 U119 ( .A(count_out[5]), .B(n120), .C(n74), .Y(n119) );
  INVX1 U120 ( .A(rollover_val[5]), .Y(n74) );
  INVX1 U121 ( .A(count_out[5]), .Y(n87) );
  INVX1 U122 ( .A(n120), .Y(n118) );
  OAI21X1 U123 ( .A(rollover_val[4]), .B(n89), .C(n121), .Y(n120) );
  NAND2X1 U124 ( .A(n122), .B(n115), .Y(n121) );
  NAND2X1 U125 ( .A(rollover_val[4]), .B(n89), .Y(n115) );
  OAI21X1 U126 ( .A(n123), .B(n91), .C(n124), .Y(n122) );
  OAI21X1 U127 ( .A(count_out[3]), .B(n125), .C(n126), .Y(n124) );
  INVX1 U128 ( .A(rollover_val[3]), .Y(n126) );
  INVX1 U129 ( .A(count_out[3]), .Y(n91) );
  INVX1 U130 ( .A(n125), .Y(n123) );
  OAI21X1 U131 ( .A(rollover_val[2]), .B(n93), .C(n127), .Y(n125) );
  NAND2X1 U132 ( .A(n128), .B(n111), .Y(n127) );
  NAND2X1 U133 ( .A(rollover_val[2]), .B(n93), .Y(n111) );
  OAI21X1 U134 ( .A(n129), .B(n95), .C(n130), .Y(n128) );
  OAI21X1 U135 ( .A(count_out[0]), .B(count_out[1]), .C(n131), .Y(n130) );
  INVX1 U136 ( .A(rollover_val[1]), .Y(n131) );
  INVX1 U137 ( .A(count_out[1]), .Y(n95) );
  INVX1 U138 ( .A(count_out[0]), .Y(n129) );
  INVX1 U139 ( .A(count_out[2]), .Y(n93) );
  INVX1 U140 ( .A(count_out[4]), .Y(n89) );
  INVX1 U141 ( .A(count_out[6]), .Y(n85) );
  INVX1 U142 ( .A(clear), .Y(n103) );
endmodule

