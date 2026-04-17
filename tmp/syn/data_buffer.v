/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Wed Apr 15 21:47:36 2026
/////////////////////////////////////////////////////////////


module data_buffer_DW01_inc_1 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;

  wire   [6:2] carry;

  HAX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .YC(carry[6]), .YS(SUM[5]) );
  HAX1 U1_1_4 ( .A(A[4]), .B(carry[4]), .YC(carry[5]), .YS(SUM[4]) );
  HAX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .YC(carry[4]), .YS(SUM[3]) );
  HAX1 U1_1_2 ( .A(A[2]), .B(carry[2]), .YC(carry[3]), .YS(SUM[2]) );
  HAX1 U1_1_1 ( .A(A[1]), .B(A[0]), .YC(carry[2]), .YS(SUM[1]) );
  INVX2 U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2X1 U2 ( .A(carry[6]), .B(A[6]), .Y(SUM[6]) );
endmodule


module data_buffer ( clk, n_rst, tx_data, rx_packet_data, store_tx_data, 
        store_rx_packet_data, get_tx_packet_data, get_rx_data, clear, flush, 
        buffer_occupancy, tx_packet_data, rx_data );
  input [7:0] tx_data;
  input [7:0] rx_packet_data;
  output [6:0] buffer_occupancy;
  output [7:0] tx_packet_data;
  output [7:0] rx_data;
  input clk, n_rst, store_tx_data, store_rx_packet_data, get_tx_packet_data,
         get_rx_data, clear, flush;
  wire   N19, N20, N21, N22, N23, N24, \reg_mem[0][7] , \reg_mem[0][6] ,
         \reg_mem[0][5] , \reg_mem[0][4] , \reg_mem[0][3] , \reg_mem[0][2] ,
         \reg_mem[0][1] , \reg_mem[0][0] , \reg_mem[1][7] , \reg_mem[1][6] ,
         \reg_mem[1][5] , \reg_mem[1][4] , \reg_mem[1][3] , \reg_mem[1][2] ,
         \reg_mem[1][1] , \reg_mem[1][0] , \reg_mem[2][7] , \reg_mem[2][6] ,
         \reg_mem[2][5] , \reg_mem[2][4] , \reg_mem[2][3] , \reg_mem[2][2] ,
         \reg_mem[2][1] , \reg_mem[2][0] , \reg_mem[3][7] , \reg_mem[3][6] ,
         \reg_mem[3][5] , \reg_mem[3][4] , \reg_mem[3][3] , \reg_mem[3][2] ,
         \reg_mem[3][1] , \reg_mem[3][0] , \reg_mem[4][7] , \reg_mem[4][6] ,
         \reg_mem[4][5] , \reg_mem[4][4] , \reg_mem[4][3] , \reg_mem[4][2] ,
         \reg_mem[4][1] , \reg_mem[4][0] , \reg_mem[5][7] , \reg_mem[5][6] ,
         \reg_mem[5][5] , \reg_mem[5][4] , \reg_mem[5][3] , \reg_mem[5][2] ,
         \reg_mem[5][1] , \reg_mem[5][0] , \reg_mem[6][7] , \reg_mem[6][6] ,
         \reg_mem[6][5] , \reg_mem[6][4] , \reg_mem[6][3] , \reg_mem[6][2] ,
         \reg_mem[6][1] , \reg_mem[6][0] , \reg_mem[7][7] , \reg_mem[7][6] ,
         \reg_mem[7][5] , \reg_mem[7][4] , \reg_mem[7][3] , \reg_mem[7][2] ,
         \reg_mem[7][1] , \reg_mem[7][0] , \reg_mem[8][7] , \reg_mem[8][6] ,
         \reg_mem[8][5] , \reg_mem[8][4] , \reg_mem[8][3] , \reg_mem[8][2] ,
         \reg_mem[8][1] , \reg_mem[8][0] , \reg_mem[9][7] , \reg_mem[9][6] ,
         \reg_mem[9][5] , \reg_mem[9][4] , \reg_mem[9][3] , \reg_mem[9][2] ,
         \reg_mem[9][1] , \reg_mem[9][0] , \reg_mem[10][7] , \reg_mem[10][6] ,
         \reg_mem[10][5] , \reg_mem[10][4] , \reg_mem[10][3] ,
         \reg_mem[10][2] , \reg_mem[10][1] , \reg_mem[10][0] ,
         \reg_mem[11][7] , \reg_mem[11][6] , \reg_mem[11][5] ,
         \reg_mem[11][4] , \reg_mem[11][3] , \reg_mem[11][2] ,
         \reg_mem[11][1] , \reg_mem[11][0] , \reg_mem[12][7] ,
         \reg_mem[12][6] , \reg_mem[12][5] , \reg_mem[12][4] ,
         \reg_mem[12][3] , \reg_mem[12][2] , \reg_mem[12][1] ,
         \reg_mem[12][0] , \reg_mem[13][7] , \reg_mem[13][6] ,
         \reg_mem[13][5] , \reg_mem[13][4] , \reg_mem[13][3] ,
         \reg_mem[13][2] , \reg_mem[13][1] , \reg_mem[13][0] ,
         \reg_mem[14][7] , \reg_mem[14][6] , \reg_mem[14][5] ,
         \reg_mem[14][4] , \reg_mem[14][3] , \reg_mem[14][2] ,
         \reg_mem[14][1] , \reg_mem[14][0] , \reg_mem[15][7] ,
         \reg_mem[15][6] , \reg_mem[15][5] , \reg_mem[15][4] ,
         \reg_mem[15][3] , \reg_mem[15][2] , \reg_mem[15][1] ,
         \reg_mem[15][0] , \reg_mem[16][7] , \reg_mem[16][6] ,
         \reg_mem[16][5] , \reg_mem[16][4] , \reg_mem[16][3] ,
         \reg_mem[16][2] , \reg_mem[16][1] , \reg_mem[16][0] ,
         \reg_mem[17][7] , \reg_mem[17][6] , \reg_mem[17][5] ,
         \reg_mem[17][4] , \reg_mem[17][3] , \reg_mem[17][2] ,
         \reg_mem[17][1] , \reg_mem[17][0] , \reg_mem[18][7] ,
         \reg_mem[18][6] , \reg_mem[18][5] , \reg_mem[18][4] ,
         \reg_mem[18][3] , \reg_mem[18][2] , \reg_mem[18][1] ,
         \reg_mem[18][0] , \reg_mem[19][7] , \reg_mem[19][6] ,
         \reg_mem[19][5] , \reg_mem[19][4] , \reg_mem[19][3] ,
         \reg_mem[19][2] , \reg_mem[19][1] , \reg_mem[19][0] ,
         \reg_mem[20][7] , \reg_mem[20][6] , \reg_mem[20][5] ,
         \reg_mem[20][4] , \reg_mem[20][3] , \reg_mem[20][2] ,
         \reg_mem[20][1] , \reg_mem[20][0] , \reg_mem[21][7] ,
         \reg_mem[21][6] , \reg_mem[21][5] , \reg_mem[21][4] ,
         \reg_mem[21][3] , \reg_mem[21][2] , \reg_mem[21][1] ,
         \reg_mem[21][0] , \reg_mem[22][7] , \reg_mem[22][6] ,
         \reg_mem[22][5] , \reg_mem[22][4] , \reg_mem[22][3] ,
         \reg_mem[22][2] , \reg_mem[22][1] , \reg_mem[22][0] ,
         \reg_mem[23][7] , \reg_mem[23][6] , \reg_mem[23][5] ,
         \reg_mem[23][4] , \reg_mem[23][3] , \reg_mem[23][2] ,
         \reg_mem[23][1] , \reg_mem[23][0] , \reg_mem[24][7] ,
         \reg_mem[24][6] , \reg_mem[24][5] , \reg_mem[24][4] ,
         \reg_mem[24][3] , \reg_mem[24][2] , \reg_mem[24][1] ,
         \reg_mem[24][0] , \reg_mem[25][7] , \reg_mem[25][6] ,
         \reg_mem[25][5] , \reg_mem[25][4] , \reg_mem[25][3] ,
         \reg_mem[25][2] , \reg_mem[25][1] , \reg_mem[25][0] ,
         \reg_mem[26][7] , \reg_mem[26][6] , \reg_mem[26][5] ,
         \reg_mem[26][4] , \reg_mem[26][3] , \reg_mem[26][2] ,
         \reg_mem[26][1] , \reg_mem[26][0] , \reg_mem[27][7] ,
         \reg_mem[27][6] , \reg_mem[27][5] , \reg_mem[27][4] ,
         \reg_mem[27][3] , \reg_mem[27][2] , \reg_mem[27][1] ,
         \reg_mem[27][0] , \reg_mem[28][7] , \reg_mem[28][6] ,
         \reg_mem[28][5] , \reg_mem[28][4] , \reg_mem[28][3] ,
         \reg_mem[28][2] , \reg_mem[28][1] , \reg_mem[28][0] ,
         \reg_mem[29][7] , \reg_mem[29][6] , \reg_mem[29][5] ,
         \reg_mem[29][4] , \reg_mem[29][3] , \reg_mem[29][2] ,
         \reg_mem[29][1] , \reg_mem[29][0] , \reg_mem[30][7] ,
         \reg_mem[30][6] , \reg_mem[30][5] , \reg_mem[30][4] ,
         \reg_mem[30][3] , \reg_mem[30][2] , \reg_mem[30][1] ,
         \reg_mem[30][0] , \reg_mem[31][7] , \reg_mem[31][6] ,
         \reg_mem[31][5] , \reg_mem[31][4] , \reg_mem[31][3] ,
         \reg_mem[31][2] , \reg_mem[31][1] , \reg_mem[31][0] ,
         \reg_mem[32][7] , \reg_mem[32][6] , \reg_mem[32][5] ,
         \reg_mem[32][4] , \reg_mem[32][3] , \reg_mem[32][2] ,
         \reg_mem[32][1] , \reg_mem[32][0] , \reg_mem[33][7] ,
         \reg_mem[33][6] , \reg_mem[33][5] , \reg_mem[33][4] ,
         \reg_mem[33][3] , \reg_mem[33][2] , \reg_mem[33][1] ,
         \reg_mem[33][0] , \reg_mem[34][7] , \reg_mem[34][6] ,
         \reg_mem[34][5] , \reg_mem[34][4] , \reg_mem[34][3] ,
         \reg_mem[34][2] , \reg_mem[34][1] , \reg_mem[34][0] ,
         \reg_mem[35][7] , \reg_mem[35][6] , \reg_mem[35][5] ,
         \reg_mem[35][4] , \reg_mem[35][3] , \reg_mem[35][2] ,
         \reg_mem[35][1] , \reg_mem[35][0] , \reg_mem[36][7] ,
         \reg_mem[36][6] , \reg_mem[36][5] , \reg_mem[36][4] ,
         \reg_mem[36][3] , \reg_mem[36][2] , \reg_mem[36][1] ,
         \reg_mem[36][0] , \reg_mem[37][7] , \reg_mem[37][6] ,
         \reg_mem[37][5] , \reg_mem[37][4] , \reg_mem[37][3] ,
         \reg_mem[37][2] , \reg_mem[37][1] , \reg_mem[37][0] ,
         \reg_mem[38][7] , \reg_mem[38][6] , \reg_mem[38][5] ,
         \reg_mem[38][4] , \reg_mem[38][3] , \reg_mem[38][2] ,
         \reg_mem[38][1] , \reg_mem[38][0] , \reg_mem[39][7] ,
         \reg_mem[39][6] , \reg_mem[39][5] , \reg_mem[39][4] ,
         \reg_mem[39][3] , \reg_mem[39][2] , \reg_mem[39][1] ,
         \reg_mem[39][0] , \reg_mem[40][7] , \reg_mem[40][6] ,
         \reg_mem[40][5] , \reg_mem[40][4] , \reg_mem[40][3] ,
         \reg_mem[40][2] , \reg_mem[40][1] , \reg_mem[40][0] ,
         \reg_mem[41][7] , \reg_mem[41][6] , \reg_mem[41][5] ,
         \reg_mem[41][4] , \reg_mem[41][3] , \reg_mem[41][2] ,
         \reg_mem[41][1] , \reg_mem[41][0] , \reg_mem[42][7] ,
         \reg_mem[42][6] , \reg_mem[42][5] , \reg_mem[42][4] ,
         \reg_mem[42][3] , \reg_mem[42][2] , \reg_mem[42][1] ,
         \reg_mem[42][0] , \reg_mem[43][7] , \reg_mem[43][6] ,
         \reg_mem[43][5] , \reg_mem[43][4] , \reg_mem[43][3] ,
         \reg_mem[43][2] , \reg_mem[43][1] , \reg_mem[43][0] ,
         \reg_mem[44][7] , \reg_mem[44][6] , \reg_mem[44][5] ,
         \reg_mem[44][4] , \reg_mem[44][3] , \reg_mem[44][2] ,
         \reg_mem[44][1] , \reg_mem[44][0] , \reg_mem[45][7] ,
         \reg_mem[45][6] , \reg_mem[45][5] , \reg_mem[45][4] ,
         \reg_mem[45][3] , \reg_mem[45][2] , \reg_mem[45][1] ,
         \reg_mem[45][0] , \reg_mem[46][7] , \reg_mem[46][6] ,
         \reg_mem[46][5] , \reg_mem[46][4] , \reg_mem[46][3] ,
         \reg_mem[46][2] , \reg_mem[46][1] , \reg_mem[46][0] ,
         \reg_mem[47][7] , \reg_mem[47][6] , \reg_mem[47][5] ,
         \reg_mem[47][4] , \reg_mem[47][3] , \reg_mem[47][2] ,
         \reg_mem[47][1] , \reg_mem[47][0] , \reg_mem[48][7] ,
         \reg_mem[48][6] , \reg_mem[48][5] , \reg_mem[48][4] ,
         \reg_mem[48][3] , \reg_mem[48][2] , \reg_mem[48][1] ,
         \reg_mem[48][0] , \reg_mem[49][7] , \reg_mem[49][6] ,
         \reg_mem[49][5] , \reg_mem[49][4] , \reg_mem[49][3] ,
         \reg_mem[49][2] , \reg_mem[49][1] , \reg_mem[49][0] ,
         \reg_mem[50][7] , \reg_mem[50][6] , \reg_mem[50][5] ,
         \reg_mem[50][4] , \reg_mem[50][3] , \reg_mem[50][2] ,
         \reg_mem[50][1] , \reg_mem[50][0] , \reg_mem[51][7] ,
         \reg_mem[51][6] , \reg_mem[51][5] , \reg_mem[51][4] ,
         \reg_mem[51][3] , \reg_mem[51][2] , \reg_mem[51][1] ,
         \reg_mem[51][0] , \reg_mem[52][7] , \reg_mem[52][6] ,
         \reg_mem[52][5] , \reg_mem[52][4] , \reg_mem[52][3] ,
         \reg_mem[52][2] , \reg_mem[52][1] , \reg_mem[52][0] ,
         \reg_mem[53][7] , \reg_mem[53][6] , \reg_mem[53][5] ,
         \reg_mem[53][4] , \reg_mem[53][3] , \reg_mem[53][2] ,
         \reg_mem[53][1] , \reg_mem[53][0] , \reg_mem[54][7] ,
         \reg_mem[54][6] , \reg_mem[54][5] , \reg_mem[54][4] ,
         \reg_mem[54][3] , \reg_mem[54][2] , \reg_mem[54][1] ,
         \reg_mem[54][0] , \reg_mem[55][7] , \reg_mem[55][6] ,
         \reg_mem[55][5] , \reg_mem[55][4] , \reg_mem[55][3] ,
         \reg_mem[55][2] , \reg_mem[55][1] , \reg_mem[55][0] ,
         \reg_mem[56][7] , \reg_mem[56][6] , \reg_mem[56][5] ,
         \reg_mem[56][4] , \reg_mem[56][3] , \reg_mem[56][2] ,
         \reg_mem[56][1] , \reg_mem[56][0] , \reg_mem[57][7] ,
         \reg_mem[57][6] , \reg_mem[57][5] , \reg_mem[57][4] ,
         \reg_mem[57][3] , \reg_mem[57][2] , \reg_mem[57][1] ,
         \reg_mem[57][0] , \reg_mem[58][7] , \reg_mem[58][6] ,
         \reg_mem[58][5] , \reg_mem[58][4] , \reg_mem[58][3] ,
         \reg_mem[58][2] , \reg_mem[58][1] , \reg_mem[58][0] ,
         \reg_mem[59][7] , \reg_mem[59][6] , \reg_mem[59][5] ,
         \reg_mem[59][4] , \reg_mem[59][3] , \reg_mem[59][2] ,
         \reg_mem[59][1] , \reg_mem[59][0] , \reg_mem[60][7] ,
         \reg_mem[60][6] , \reg_mem[60][5] , \reg_mem[60][4] ,
         \reg_mem[60][3] , \reg_mem[60][2] , \reg_mem[60][1] ,
         \reg_mem[60][0] , \reg_mem[61][7] , \reg_mem[61][6] ,
         \reg_mem[61][5] , \reg_mem[61][4] , \reg_mem[61][3] ,
         \reg_mem[61][2] , \reg_mem[61][1] , \reg_mem[61][0] ,
         \reg_mem[62][7] , \reg_mem[62][6] , \reg_mem[62][5] ,
         \reg_mem[62][4] , \reg_mem[62][3] , \reg_mem[62][2] ,
         \reg_mem[62][1] , \reg_mem[62][0] , \reg_mem[63][7] ,
         \reg_mem[63][6] , \reg_mem[63][5] , \reg_mem[63][4] ,
         \reg_mem[63][3] , \reg_mem[63][2] , \reg_mem[63][1] ,
         \reg_mem[63][0] , N36, N37, N38, N39, N40, N41, N42, n704, n705, n706,
         n707, n708, n709, n710, n711, n712, n713, n714, n715, n716, n717,
         n718, n719, n720, n721, n722, n723, n724, n725, n726, n727, n728,
         n729, n730, n731, n732, n733, n734, n735, n736, n737, n738, n739,
         n740, n741, n742, n743, n744, n745, n746, n747, n748, n749, n750,
         n751, n752, n753, n754, n755, n756, n757, n758, n759, n760, n761,
         n762, n763, n764, n765, n766, n767, n768, n769, n770, n771, n772,
         n773, n774, n775, n776, n777, n778, n779, n780, n781, n782, n783,
         n784, n785, n786, n787, n788, n789, n790, n791, n792, n793, n794,
         n795, n796, n797, n798, n799, n800, n801, n802, n803, n804, n805,
         n806, n807, n808, n809, n810, n811, n812, n813, n814, n815, n816,
         n817, n818, n819, n820, n821, n822, n823, n824, n825, n826, n827,
         n828, n829, n830, n831, n832, n833, n834, n835, n836, n837, n838,
         n839, n840, n841, n842, n843, n844, n845, n846, n847, n848, n849,
         n850, n851, n852, n853, n854, n855, n856, n857, n858, n859, n860,
         n861, n862, n863, n864, n865, n866, n867, n868, n869, n870, n871,
         n872, n873, n874, n875, n876, n877, n878, n879, n880, n881, n882,
         n883, n884, n885, n886, n887, n888, n889, n890, n891, n892, n893,
         n894, n895, n896, n897, n898, n899, n900, n901, n902, n903, n904,
         n905, n906, n907, n908, n909, n910, n911, n912, n913, n914, n915,
         n916, n917, n918, n919, n920, n921, n922, n923, n924, n925, n926,
         n927, n928, n929, n930, n931, n932, n933, n934, n935, n936, n937,
         n938, n939, n940, n941, n942, n943, n944, n945, n946, n947, n948,
         n949, n950, n951, n952, n953, n954, n955, n956, n957, n958, n959,
         n960, n961, n962, n963, n964, n965, n966, n967, n968, n969, n970,
         n971, n972, n973, n974, n975, n976, n977, n978, n979, n980, n981,
         n982, n983, n984, n985, n986, n987, n988, n989, n990, n991, n992,
         n993, n994, n995, n996, n997, n998, n999, n1000, n1001, n1002, n1003,
         n1004, n1005, n1006, n1007, n1008, n1009, n1010, n1011, n1012, n1013,
         n1014, n1015, n1016, n1017, n1018, n1019, n1020, n1021, n1022, n1023,
         n1024, n1025, n1026, n1027, n1028, n1029, n1030, n1031, n1032, n1033,
         n1034, n1035, n1036, n1037, n1038, n1039, n1040, n1041, n1042, n1043,
         n1044, n1045, n1046, n1047, n1048, n1049, n1050, n1051, n1052, n1053,
         n1054, n1055, n1056, n1057, n1058, n1059, n1060, n1061, n1062, n1063,
         n1064, n1065, n1066, n1067, n1068, n1069, n1070, n1071, n1072, n1073,
         n1074, n1075, n1076, n1077, n1078, n1079, n1080, n1081, n1082, n1083,
         n1084, n1085, n1086, n1087, n1088, n1089, n1090, n1091, n1092, n1093,
         n1094, n1095, n1096, n1097, n1098, n1099, n1100, n1101, n1102, n1103,
         n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112, n1113,
         n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122, n1123,
         n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132, n1133,
         n1134, n1135, n1136, n1137, n1138, n1139, n1140, n1141, n1142, n1143,
         n1144, n1145, n1146, n1147, n1148, n1149, n1150, n1151, n1152, n1153,
         n1154, n1155, n1156, n1157, n1158, n1159, n1160, n1161, n1162, n1163,
         n1164, n1165, n1166, n1167, n1168, n1169, n1170, n1171, n1172, n1173,
         n1174, n1175, n1176, n1177, n1178, n1179, n1180, n1181, n1182, n1183,
         n1184, n1185, n1186, n1187, n1188, n1189, n1190, n1191, n1192, n1193,
         n1194, n1195, n1196, n1197, n1198, n1199, n1200, n1201, n1202, n1203,
         n1204, n1205, n1206, n1207, n1208, n1209, n1210, n1211, n1212, n1213,
         n1214, n1215, n1216, n1217, n1218, n1219, n1220, n1221, n1222, n1223,
         n1224, n1225, n1226, n1227, n1228, n1229, n1230, n1231, n1232, n1233,
         n1234, n1235, n1236, n1237, n1238, n1239, n1240, n1241, n1242, n1243,
         n1244, n1245, n1246, n1247, n1248, n1249, n1250, n1251, n1252, n1253,
         n1254, n1255, n1256, n1257, n1258, n1259, n1260, n1261, n1262, n1263,
         n1264, n1265, n1266, n1267, n1268, n1269, n1270, n1271, n1272, n1273,
         n1274, n1275, n1276, n1277, n1278, n1279, n1280, n1281, n1282, n1283,
         n1284, n1285, n1286, n1287, n1288, n1289, n1290, n1291, n1292, n1293,
         n1294, n1295, n1296, n1297, n1298, n1299, n1300, n1301, n1302, n1303,
         n1304, n1305, n1306, n1307, n1308, n1309, n1310, n1311, n1312, n1313,
         n1314, n1315, n1316, n1317, n1318, n1319, n1320, n1321, n1322, n1323,
         n1324, n1325, n1326, n1327, n1328, n1329, n1330, n1331, n1332, n1333,
         n1334, n1335, n1336, n1337, n1338, n1339, n1340, n1341, n1342, n1343,
         n1344, n1345, n1346, n1347, n1348, n1349, n1350, n1351, n1352, n1353,
         n1354, n1355, n1356, n1357, n1358, n1359, n1360, n1361, n1362, n1363,
         n1364, n1365, n1366, n1367, n1368, n1369, n1370, n1371, n1372, n1373,
         n1374, n1375, n1376, n1377, n1378, n1379, n1380, n1381, n1382, n1383,
         n1384, n1385, n1386, n1387, n1388, n1389, n1390, n1391, n1392, n1393,
         n1394, n1395, n1396, n1397, n1398, n1399, n1400, n1401, n1402, n1403,
         n1404, n1405, n1406, n1407, n1408, n1409, n1410, n1411, n1412, n1413,
         n1414, n1415, n1416, n1417, n1418, n1419, n1420, n1421, n1422, n1423,
         n1424, n1425, n1426, n1427, n1428, n1429, n1430, n1431, n1432, n1433,
         n1434, n1435, n1436, n1437, n1438, n1439, n1440, n1441, n1442, n1443,
         n1444, n1445, n1446, n1447, n1448, n1449, n1450, n1451, n1452, n1453,
         n1454, n1455, n1456, n1457, n1458, n1459, n1460, n1461, n1462, n1463,
         n1464, n1465, n1466, n1467, n1468, n1469, n1470, n1471, n1472, n1473,
         n1474, n1475, n1476, n1477, n1478, n1479, n1480, n1481, n1482, n1483,
         n1484, n1485, n1486, n1487, n1488, n1489, n1490, n1491, n1492, n1493,
         n1494, n1495, n1496, n1497, n1498, n1499, n1500, n1501, n1502, n1503,
         n1504, n1505, n1506, n1507, n1508, n1509, n1510, n1511, n1512, n1513,
         n1514, n1515, n1516, n1517, n1518, n1519, n1520, n1521, n1522, n1523,
         n1524, n1525, n1526, n1527, n1528, n1529, n1530, n1531, n1532, n1533,
         n1534, n1535, n1536, n1537, n1538, n1539, n1540, n1541, n1542, n1543,
         n1544, n1545, n1546, n1547, n1548, n1549, n1550, n1551, n1552, n1553,
         n1554, n1555, n1556, n1557, n1558, n1559, n1560, n1561, n1562, n1563,
         n1564, n1565, n1566, n1567, n1568, n1569, n1570, n1571, n1572, n1573,
         n1574, n1575, n1576, n1577, n1578, n1579, n1580, n1581, n1582, n1583,
         n1584, n1585, n1586, n1587, n1588, n1589, n1590, n1591, n1592, n1593,
         n1594, n1595, n1596, n1597, n1598, n1599, n1600, n1601, n1602, n1603,
         n1604, n1605, n1606, n1607, n1608, n1609, n1610, n1611, n1612, n1613,
         n1614, n1615, n1616, n1617, n1618, n1619, n1620, n1621, n1622, n1623,
         n1624, n1625, n1626, n1627, n1628, n1629, n1630, n1631, n1632, n1633,
         n1634, n1635, n1636, n1637, n1638, n1639, n1640, n1641, n1642, n1643,
         n1644, n1645, n1646, n1647, n1648, n1649, n1650, n1651, n1652, n1653,
         n1654, n1655, n1656, n1657, n1658, n1659, n1660, n1661, n1662, n1663,
         n1664, n1665, n1666, n1667, n1668, n1669, n1670, n1671, n1672, n1673,
         n1674, n1675, n1676, n1677, n1678, n1679, n1680, n1681, n1682, n1683,
         n1684, n1685, n1686, n1687, n1688, n1689, n1690, n1691, n1692, n1693,
         n1694, n1695, n1696, n1697, n1698, n1699, n1700, n1701, n1702, n1703,
         n1704, n1705, n1706, n1707, n1708, n1709, n1710, n1711, n1712, n1713,
         n1714, n1715, n1716, n1717, n1718, n1719, n1720, n1721, n1722, n1723,
         n1724, n1725, n1726, n1727, n1728, n1729, n1730, n1731, n1732, n1733,
         n1734, n1735, n1736, n1737, n1738, n1739, n1740, n1741, n1742, n1743,
         n1744, n1745, n1746, n1747, n1748, n1749, n1750, n1751, n1752, n1753,
         n1754, n1755, n1756, n1757, n1758, n1759, n1760, n1761, n1762, n1763,
         n1764, n1765, n1766, n1767, n1768, n1769, n1770, n1771, n1772, n1773,
         n1774, n1775, n1776, n1777, n1778, n1779, n1780, n1781, n1782, n1783,
         n1784, n1785, n1786, n1787, n1788, n1789, n1790, n1791, n1792, n1793,
         n1794, n1795, n1796, n1797, n1798, n1799, n1800, n1801, n1802, n1803,
         n1804, n1805, n1806, n1807, n1808, n1809, n1810, n1811, n1812, n1813,
         n1814, n1815, n1816, n1817, n1818, n1819, n1820, n1821, n1822, n1823,
         n1824, n1825, n1826, n1827, n1828, n1829, n1830, n1831, n1832, n1833,
         n1834, n1835, n1836, n1837, n1838, n1839, n1840, n1841, n1842, n1843,
         n1844, n1845, n1846, n1847, n1848, n1849, n1850, n1851, n1852, n1853,
         n1854, n1855, n1856, n1857, n1858, n1859, n1860, n1861, n1862, n1863,
         n1864, n1865, n1866, n1867, n1868, n1869, n1870, n1871, n1872, n1873,
         n1874, n1875, n1876, n1877, n1878, n1879, n1880, n1881, n1882, n1883,
         n1884, n1885, n1886, n1887, n1888, n1889, n1890, n1891, n1892, n1893,
         n1894, n1895, n1896, n1897, n1898, n1899, n1900, n1901, n1902, n1903,
         n1904, n1905, n1906, n1907, n1908, n1909, n1910, n1911, n1912, n1913,
         n1914, n1915, n1916, n1917, n1918, n1919, n1920, n1921, n1922, n1923,
         n1924, n1925, n1926, n1927, n1928, n1929, n1930, n1931, n1932, n1933,
         n1934, n1935, n1936, n1937, n1938, n1939, n1940, n1941, n1942, n1943,
         n1944, n1945, n1946, n1947, n1948, n1949, n1950, n1951, n1952, n1953,
         n1954, n1955, n1956, n1957, n1958, n1959, n1960, n1961, n1962, n1963,
         n1964, n1965, n1966, n1967, n1968, n1969, n1970, n1971, n1972, n1973,
         n1974, n1975, n1976, n1977, n1978, n1979, n1980, n1981, n1982, n1983,
         n1984, n1985, n1986, n1987, n1988, n1989, n1990, n1991, n1992, n1993,
         n1994, n1995, n1996, n1997, n1998, n1999, n2000, n2001, n2002, n2003,
         n2004, n2005, n2006, n2007, n2008, n2009, n2010, n2011, n2012, n2013,
         n2014, n2015, n2016, n2017, n2018, n2019, n2020, n2021, n2022, n2023,
         n2024, n2025, n2026, n2027, n2028, n2029, n2030, n2031, n2032, n2033,
         n2034, n2035, n2036, n2037, n2038, n2039, n2040, n2041, n2042, n2043,
         n2044, n2045, n2046, n2047, n2048, n2049, n2050, n2051, n2052, n2053,
         n2054, n2055, n2056, n2057, n2058, n2059, n2060, n2061, n2062, n2063,
         n2064, n2065, n2066, n2067, n2068, n2069, n2070, n2071, n2072, n2073,
         n2074, n2075, n2076, n2077, n2078, n2079, n2080, n2081, n2082, n2083,
         n2084, n2085, n2086, n2087, n2088, n2089, n2090, n2091, n2092, n2093,
         n2094, n2095, n2096, n2097, n2098, n2099, n2100, n2101, n2102, n2103,
         n2104, n2105, n2106, n2107, n2108, n2109, n2110, n2111, n2112, n2113,
         n2114, n2115, n2116, n2117, n2118, n2119, n2120, n2121, n2122, n2123,
         n2124, n2125, n2126, n2127, n2128, n2129, n2130, n2131, n2132, n2133,
         n2134, n2135, n2136, n2137, n2138, n2139, n2140, n2141, n2142, n2143,
         n2144, n2145, n2146, n2147, n2148, n2149, n2150, n2151, n2152, n2153,
         n2154, n2155, n2156, n2157, n2158, n2159, n2160, n2161, n2162, n2163,
         n2164, n2165, n2166, n2167, n2168, n2169, n2170, n2171, n2172, n2173,
         n2174, n2175, n2176, n2177, n2178, n2179, n2180, n2181, n2182, n2183,
         n2184, n2185, n2186, n2187, n2188, n2189, n2190, n2191, n2192, n2193,
         n2194, n2195, n2196, n2197, n2198, n2199, n2200, n2201, n2202, n2203,
         n2204, n2205, n2206, n2207, n2208, n2209, n2210, n2211, n2212, n2213,
         n2214, n2215, n2216, n2217, n2218, n2219, n2220, n2221, n2222, n2223,
         n2224, n2225, n2226, n2227, n2228, n2229, n2230, n2231, n2232, n2233,
         n2234, n2235, n2236, n2237, n2238, n2239, n2240, n2241, n2242, n2243,
         n2244, n2245, n2246, n2247, n2248, n2249, n2250, n2251, n2252, n2253,
         n2254, n2255, n2256, n2257, n2258, n2259, n2260, n2261, n2262, n2263,
         n2264, n2265, n2266, n2267, n2268, n2269, n2270, n2271, n2272, n2273,
         n2274, n2275, n2276, n2277, n2278, n2279, n2280, n2281, n2282, n2283,
         n2284, n2285, n2286, n2287, n2288, n2289, n2290, n2291, n2292, n2293,
         n2294, n2295, n2296, n2297, n2298, n2299, n2300, n2301, n2302, n2303,
         n2304, n2305, n2306, n2307, n2308, n2309, n2310, n2311, n2312, n2313,
         n2314, n2315, n2316, n2317, n2318, n2319, n2320, n2321, n2322, n2323,
         n2324, n2325, n2326, n2327, n2328, n2329, n2330, n2331, n2332, n2333,
         n2334, n2335, n2336, n2337, n2338, n2339, n2340, n2341, n2342, n2343,
         n2344, n2345, n2346, n2347, n2348, n2349, n2350, n2351, n2352, n2353,
         n2354, n2355, n2356, n2357, n2358, n2359, n2360, n2361, n2362, n2363,
         n2364, n2365, n2366, n2367, n2368, n2369, n2370, n2371, n2372, n2373,
         n2374, n2375, n2376, n2377, n2378, n2379, n2380, n2381, n2382, n2383,
         n2384, n2385, n2386, n2387, n2388, n2389, n2390, n2391, n2392, n2393,
         n2394, n2395, n2396, n2397, n2398, n2399, n2400, n2401, n2402, n2403,
         n2404, n2405, n2406, n2407, n2408, n2409, n2410, n2411, n2412, n2413,
         n2414, n2415, n2416, n2417, n2418, n2419, n2420, n2421, n2422, n2423,
         n2424, n2425, n2426, n2427, n2428, n2429, n2430, n2431, n2432, n2433,
         n2434, n2435, n2436, n2437, n2438, n2439, n2440, n2441, n2442, n2443,
         n2444, n2445, n2446, n2447, n2448, n2449, n2450, n2451, n2452, n2453,
         n2454, n2455, n2456, n2457, n2458, n2459, n2460, n2461, n2462, n2463,
         n2464, n2465, n2466, n2467, n2468, n2469, n2470, n2471, n2472, n2473,
         n2474, n2475, n2476, n2477, n2478, n2479, n2480, n2481, n2482, n2483,
         n2484, n2485, n2486, n2487, n2488, n2489, n2490, n2491, n2492, n2493,
         n2494, n2495, n2496, n2497, n2498, n2499, n2500, n2501, n2502, n2503,
         n2504, n2505, n2506, n2507, n2508, n2509, n2510, n2511, n2512, n2513,
         n2514, n2515, n2516, n2517, n2518, n2519, n2520, n2521, n2522, n2523,
         n2524, n2525, n2526, n2527, n2528, n2529, n2530, n2531, n2532, n2533,
         n2534;
  wire   [5:0] write_ptr;
  wire   [6:0] next_counter;
  assign rx_data[7] = tx_packet_data[7];
  assign rx_data[6] = tx_packet_data[6];
  assign rx_data[5] = tx_packet_data[5];
  assign rx_data[4] = tx_packet_data[4];
  assign rx_data[3] = tx_packet_data[3];
  assign rx_data[2] = tx_packet_data[2];
  assign rx_data[1] = tx_packet_data[1];
  assign rx_data[0] = tx_packet_data[0];

  DFFSR \counter_reg[0]  ( .D(next_counter[0]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(buffer_occupancy[0]) );
  DFFSR \counter_reg[1]  ( .D(next_counter[1]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(buffer_occupancy[1]) );
  DFFSR \counter_reg[2]  ( .D(next_counter[2]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(buffer_occupancy[2]) );
  DFFSR \counter_reg[3]  ( .D(next_counter[3]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(buffer_occupancy[3]) );
  DFFSR \counter_reg[4]  ( .D(next_counter[4]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(buffer_occupancy[4]) );
  DFFSR \counter_reg[5]  ( .D(next_counter[5]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(buffer_occupancy[5]) );
  DFFSR \counter_reg[6]  ( .D(next_counter[6]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(buffer_occupancy[6]) );
  DFFSR \read_ptr_reg[0]  ( .D(n1227), .CLK(clk), .R(n_rst), .S(1'b1), .Q(N19)
         );
  DFFSR \read_ptr_reg[1]  ( .D(n1226), .CLK(clk), .R(n_rst), .S(1'b1), .Q(N20)
         );
  DFFSR \read_ptr_reg[2]  ( .D(n1225), .CLK(clk), .R(n_rst), .S(1'b1), .Q(N21)
         );
  DFFSR \read_ptr_reg[3]  ( .D(n1224), .CLK(clk), .R(n_rst), .S(1'b1), .Q(N22)
         );
  DFFSR \read_ptr_reg[4]  ( .D(n1223), .CLK(clk), .R(n_rst), .S(1'b1), .Q(N23)
         );
  DFFSR \read_ptr_reg[5]  ( .D(n1222), .CLK(clk), .R(n_rst), .S(1'b1), .Q(N24)
         );
  DFFSR \write_ptr_reg[0]  ( .D(n1221), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        write_ptr[0]) );
  DFFSR \write_ptr_reg[1]  ( .D(n1220), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        write_ptr[1]) );
  DFFSR \write_ptr_reg[2]  ( .D(n1219), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        write_ptr[2]) );
  DFFSR \write_ptr_reg[3]  ( .D(n1218), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        write_ptr[3]) );
  DFFSR \write_ptr_reg[4]  ( .D(n1217), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        write_ptr[4]) );
  DFFSR \write_ptr_reg[5]  ( .D(n1216), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        write_ptr[5]) );
  DFFPOSX1 \reg_mem_reg[62][0]  ( .D(n1152), .CLK(clk), .Q(\reg_mem[62][0] )
         );
  DFFPOSX1 \reg_mem_reg[61][0]  ( .D(n1153), .CLK(clk), .Q(\reg_mem[61][0] )
         );
  DFFPOSX1 \reg_mem_reg[60][0]  ( .D(n1154), .CLK(clk), .Q(\reg_mem[60][0] )
         );
  DFFPOSX1 \reg_mem_reg[59][0]  ( .D(n1155), .CLK(clk), .Q(\reg_mem[59][0] )
         );
  DFFPOSX1 \reg_mem_reg[58][0]  ( .D(n1156), .CLK(clk), .Q(\reg_mem[58][0] )
         );
  DFFPOSX1 \reg_mem_reg[57][0]  ( .D(n1157), .CLK(clk), .Q(\reg_mem[57][0] )
         );
  DFFPOSX1 \reg_mem_reg[56][0]  ( .D(n1158), .CLK(clk), .Q(\reg_mem[56][0] )
         );
  DFFPOSX1 \reg_mem_reg[55][0]  ( .D(n1159), .CLK(clk), .Q(\reg_mem[55][0] )
         );
  DFFPOSX1 \reg_mem_reg[54][0]  ( .D(n1160), .CLK(clk), .Q(\reg_mem[54][0] )
         );
  DFFPOSX1 \reg_mem_reg[53][0]  ( .D(n1161), .CLK(clk), .Q(\reg_mem[53][0] )
         );
  DFFPOSX1 \reg_mem_reg[52][0]  ( .D(n1162), .CLK(clk), .Q(\reg_mem[52][0] )
         );
  DFFPOSX1 \reg_mem_reg[51][0]  ( .D(n1163), .CLK(clk), .Q(\reg_mem[51][0] )
         );
  DFFPOSX1 \reg_mem_reg[50][0]  ( .D(n1164), .CLK(clk), .Q(\reg_mem[50][0] )
         );
  DFFPOSX1 \reg_mem_reg[49][0]  ( .D(n1165), .CLK(clk), .Q(\reg_mem[49][0] )
         );
  DFFPOSX1 \reg_mem_reg[48][0]  ( .D(n1166), .CLK(clk), .Q(\reg_mem[48][0] )
         );
  DFFPOSX1 \reg_mem_reg[47][0]  ( .D(n1167), .CLK(clk), .Q(\reg_mem[47][0] )
         );
  DFFPOSX1 \reg_mem_reg[46][0]  ( .D(n1168), .CLK(clk), .Q(\reg_mem[46][0] )
         );
  DFFPOSX1 \reg_mem_reg[45][0]  ( .D(n1169), .CLK(clk), .Q(\reg_mem[45][0] )
         );
  DFFPOSX1 \reg_mem_reg[44][0]  ( .D(n1170), .CLK(clk), .Q(\reg_mem[44][0] )
         );
  DFFPOSX1 \reg_mem_reg[43][0]  ( .D(n1171), .CLK(clk), .Q(\reg_mem[43][0] )
         );
  DFFPOSX1 \reg_mem_reg[42][0]  ( .D(n1172), .CLK(clk), .Q(\reg_mem[42][0] )
         );
  DFFPOSX1 \reg_mem_reg[41][0]  ( .D(n1173), .CLK(clk), .Q(\reg_mem[41][0] )
         );
  DFFPOSX1 \reg_mem_reg[40][0]  ( .D(n1174), .CLK(clk), .Q(\reg_mem[40][0] )
         );
  DFFPOSX1 \reg_mem_reg[39][0]  ( .D(n1175), .CLK(clk), .Q(\reg_mem[39][0] )
         );
  DFFPOSX1 \reg_mem_reg[38][0]  ( .D(n1176), .CLK(clk), .Q(\reg_mem[38][0] )
         );
  DFFPOSX1 \reg_mem_reg[37][0]  ( .D(n1177), .CLK(clk), .Q(\reg_mem[37][0] )
         );
  DFFPOSX1 \reg_mem_reg[36][0]  ( .D(n1178), .CLK(clk), .Q(\reg_mem[36][0] )
         );
  DFFPOSX1 \reg_mem_reg[35][0]  ( .D(n1179), .CLK(clk), .Q(\reg_mem[35][0] )
         );
  DFFPOSX1 \reg_mem_reg[34][0]  ( .D(n1180), .CLK(clk), .Q(\reg_mem[34][0] )
         );
  DFFPOSX1 \reg_mem_reg[33][0]  ( .D(n1181), .CLK(clk), .Q(\reg_mem[33][0] )
         );
  DFFPOSX1 \reg_mem_reg[32][0]  ( .D(n1182), .CLK(clk), .Q(\reg_mem[32][0] )
         );
  DFFPOSX1 \reg_mem_reg[31][0]  ( .D(n1183), .CLK(clk), .Q(\reg_mem[31][0] )
         );
  DFFPOSX1 \reg_mem_reg[30][0]  ( .D(n1184), .CLK(clk), .Q(\reg_mem[30][0] )
         );
  DFFPOSX1 \reg_mem_reg[29][0]  ( .D(n1185), .CLK(clk), .Q(\reg_mem[29][0] )
         );
  DFFPOSX1 \reg_mem_reg[28][0]  ( .D(n1186), .CLK(clk), .Q(\reg_mem[28][0] )
         );
  DFFPOSX1 \reg_mem_reg[27][0]  ( .D(n1187), .CLK(clk), .Q(\reg_mem[27][0] )
         );
  DFFPOSX1 \reg_mem_reg[26][0]  ( .D(n1188), .CLK(clk), .Q(\reg_mem[26][0] )
         );
  DFFPOSX1 \reg_mem_reg[25][0]  ( .D(n1189), .CLK(clk), .Q(\reg_mem[25][0] )
         );
  DFFPOSX1 \reg_mem_reg[24][0]  ( .D(n1190), .CLK(clk), .Q(\reg_mem[24][0] )
         );
  DFFPOSX1 \reg_mem_reg[23][0]  ( .D(n1191), .CLK(clk), .Q(\reg_mem[23][0] )
         );
  DFFPOSX1 \reg_mem_reg[22][0]  ( .D(n1192), .CLK(clk), .Q(\reg_mem[22][0] )
         );
  DFFPOSX1 \reg_mem_reg[21][0]  ( .D(n1193), .CLK(clk), .Q(\reg_mem[21][0] )
         );
  DFFPOSX1 \reg_mem_reg[20][0]  ( .D(n1194), .CLK(clk), .Q(\reg_mem[20][0] )
         );
  DFFPOSX1 \reg_mem_reg[19][0]  ( .D(n1195), .CLK(clk), .Q(\reg_mem[19][0] )
         );
  DFFPOSX1 \reg_mem_reg[18][0]  ( .D(n1196), .CLK(clk), .Q(\reg_mem[18][0] )
         );
  DFFPOSX1 \reg_mem_reg[17][0]  ( .D(n1197), .CLK(clk), .Q(\reg_mem[17][0] )
         );
  DFFPOSX1 \reg_mem_reg[16][0]  ( .D(n1198), .CLK(clk), .Q(\reg_mem[16][0] )
         );
  DFFPOSX1 \reg_mem_reg[15][0]  ( .D(n1199), .CLK(clk), .Q(\reg_mem[15][0] )
         );
  DFFPOSX1 \reg_mem_reg[14][0]  ( .D(n1200), .CLK(clk), .Q(\reg_mem[14][0] )
         );
  DFFPOSX1 \reg_mem_reg[13][0]  ( .D(n1201), .CLK(clk), .Q(\reg_mem[13][0] )
         );
  DFFPOSX1 \reg_mem_reg[12][0]  ( .D(n1202), .CLK(clk), .Q(\reg_mem[12][0] )
         );
  DFFPOSX1 \reg_mem_reg[11][0]  ( .D(n1203), .CLK(clk), .Q(\reg_mem[11][0] )
         );
  DFFPOSX1 \reg_mem_reg[10][0]  ( .D(n1204), .CLK(clk), .Q(\reg_mem[10][0] )
         );
  DFFPOSX1 \reg_mem_reg[9][0]  ( .D(n1205), .CLK(clk), .Q(\reg_mem[9][0] ) );
  DFFPOSX1 \reg_mem_reg[8][0]  ( .D(n1206), .CLK(clk), .Q(\reg_mem[8][0] ) );
  DFFPOSX1 \reg_mem_reg[7][0]  ( .D(n1207), .CLK(clk), .Q(\reg_mem[7][0] ) );
  DFFPOSX1 \reg_mem_reg[6][0]  ( .D(n1208), .CLK(clk), .Q(\reg_mem[6][0] ) );
  DFFPOSX1 \reg_mem_reg[5][0]  ( .D(n1209), .CLK(clk), .Q(\reg_mem[5][0] ) );
  DFFPOSX1 \reg_mem_reg[4][0]  ( .D(n1210), .CLK(clk), .Q(\reg_mem[4][0] ) );
  DFFPOSX1 \reg_mem_reg[3][0]  ( .D(n1211), .CLK(clk), .Q(\reg_mem[3][0] ) );
  DFFPOSX1 \reg_mem_reg[2][0]  ( .D(n1212), .CLK(clk), .Q(\reg_mem[2][0] ) );
  DFFPOSX1 \reg_mem_reg[1][0]  ( .D(n1213), .CLK(clk), .Q(\reg_mem[1][0] ) );
  DFFPOSX1 \reg_mem_reg[0][0]  ( .D(n1214), .CLK(clk), .Q(\reg_mem[0][0] ) );
  DFFPOSX1 \reg_mem_reg[63][0]  ( .D(n1215), .CLK(clk), .Q(\reg_mem[63][0] )
         );
  DFFPOSX1 \reg_mem_reg[62][1]  ( .D(n1088), .CLK(clk), .Q(\reg_mem[62][1] )
         );
  DFFPOSX1 \reg_mem_reg[61][1]  ( .D(n1089), .CLK(clk), .Q(\reg_mem[61][1] )
         );
  DFFPOSX1 \reg_mem_reg[60][1]  ( .D(n1090), .CLK(clk), .Q(\reg_mem[60][1] )
         );
  DFFPOSX1 \reg_mem_reg[59][1]  ( .D(n1091), .CLK(clk), .Q(\reg_mem[59][1] )
         );
  DFFPOSX1 \reg_mem_reg[58][1]  ( .D(n1092), .CLK(clk), .Q(\reg_mem[58][1] )
         );
  DFFPOSX1 \reg_mem_reg[57][1]  ( .D(n1093), .CLK(clk), .Q(\reg_mem[57][1] )
         );
  DFFPOSX1 \reg_mem_reg[56][1]  ( .D(n1094), .CLK(clk), .Q(\reg_mem[56][1] )
         );
  DFFPOSX1 \reg_mem_reg[55][1]  ( .D(n1095), .CLK(clk), .Q(\reg_mem[55][1] )
         );
  DFFPOSX1 \reg_mem_reg[54][1]  ( .D(n1096), .CLK(clk), .Q(\reg_mem[54][1] )
         );
  DFFPOSX1 \reg_mem_reg[53][1]  ( .D(n1097), .CLK(clk), .Q(\reg_mem[53][1] )
         );
  DFFPOSX1 \reg_mem_reg[52][1]  ( .D(n1098), .CLK(clk), .Q(\reg_mem[52][1] )
         );
  DFFPOSX1 \reg_mem_reg[51][1]  ( .D(n1099), .CLK(clk), .Q(\reg_mem[51][1] )
         );
  DFFPOSX1 \reg_mem_reg[50][1]  ( .D(n1100), .CLK(clk), .Q(\reg_mem[50][1] )
         );
  DFFPOSX1 \reg_mem_reg[49][1]  ( .D(n1101), .CLK(clk), .Q(\reg_mem[49][1] )
         );
  DFFPOSX1 \reg_mem_reg[48][1]  ( .D(n1102), .CLK(clk), .Q(\reg_mem[48][1] )
         );
  DFFPOSX1 \reg_mem_reg[47][1]  ( .D(n1103), .CLK(clk), .Q(\reg_mem[47][1] )
         );
  DFFPOSX1 \reg_mem_reg[46][1]  ( .D(n1104), .CLK(clk), .Q(\reg_mem[46][1] )
         );
  DFFPOSX1 \reg_mem_reg[45][1]  ( .D(n1105), .CLK(clk), .Q(\reg_mem[45][1] )
         );
  DFFPOSX1 \reg_mem_reg[44][1]  ( .D(n1106), .CLK(clk), .Q(\reg_mem[44][1] )
         );
  DFFPOSX1 \reg_mem_reg[43][1]  ( .D(n1107), .CLK(clk), .Q(\reg_mem[43][1] )
         );
  DFFPOSX1 \reg_mem_reg[42][1]  ( .D(n1108), .CLK(clk), .Q(\reg_mem[42][1] )
         );
  DFFPOSX1 \reg_mem_reg[41][1]  ( .D(n1109), .CLK(clk), .Q(\reg_mem[41][1] )
         );
  DFFPOSX1 \reg_mem_reg[40][1]  ( .D(n1110), .CLK(clk), .Q(\reg_mem[40][1] )
         );
  DFFPOSX1 \reg_mem_reg[39][1]  ( .D(n1111), .CLK(clk), .Q(\reg_mem[39][1] )
         );
  DFFPOSX1 \reg_mem_reg[38][1]  ( .D(n1112), .CLK(clk), .Q(\reg_mem[38][1] )
         );
  DFFPOSX1 \reg_mem_reg[37][1]  ( .D(n1113), .CLK(clk), .Q(\reg_mem[37][1] )
         );
  DFFPOSX1 \reg_mem_reg[36][1]  ( .D(n1114), .CLK(clk), .Q(\reg_mem[36][1] )
         );
  DFFPOSX1 \reg_mem_reg[35][1]  ( .D(n1115), .CLK(clk), .Q(\reg_mem[35][1] )
         );
  DFFPOSX1 \reg_mem_reg[34][1]  ( .D(n1116), .CLK(clk), .Q(\reg_mem[34][1] )
         );
  DFFPOSX1 \reg_mem_reg[33][1]  ( .D(n1117), .CLK(clk), .Q(\reg_mem[33][1] )
         );
  DFFPOSX1 \reg_mem_reg[32][1]  ( .D(n1118), .CLK(clk), .Q(\reg_mem[32][1] )
         );
  DFFPOSX1 \reg_mem_reg[31][1]  ( .D(n1119), .CLK(clk), .Q(\reg_mem[31][1] )
         );
  DFFPOSX1 \reg_mem_reg[30][1]  ( .D(n1120), .CLK(clk), .Q(\reg_mem[30][1] )
         );
  DFFPOSX1 \reg_mem_reg[29][1]  ( .D(n1121), .CLK(clk), .Q(\reg_mem[29][1] )
         );
  DFFPOSX1 \reg_mem_reg[28][1]  ( .D(n1122), .CLK(clk), .Q(\reg_mem[28][1] )
         );
  DFFPOSX1 \reg_mem_reg[27][1]  ( .D(n1123), .CLK(clk), .Q(\reg_mem[27][1] )
         );
  DFFPOSX1 \reg_mem_reg[26][1]  ( .D(n1124), .CLK(clk), .Q(\reg_mem[26][1] )
         );
  DFFPOSX1 \reg_mem_reg[25][1]  ( .D(n1125), .CLK(clk), .Q(\reg_mem[25][1] )
         );
  DFFPOSX1 \reg_mem_reg[24][1]  ( .D(n1126), .CLK(clk), .Q(\reg_mem[24][1] )
         );
  DFFPOSX1 \reg_mem_reg[23][1]  ( .D(n1127), .CLK(clk), .Q(\reg_mem[23][1] )
         );
  DFFPOSX1 \reg_mem_reg[22][1]  ( .D(n1128), .CLK(clk), .Q(\reg_mem[22][1] )
         );
  DFFPOSX1 \reg_mem_reg[21][1]  ( .D(n1129), .CLK(clk), .Q(\reg_mem[21][1] )
         );
  DFFPOSX1 \reg_mem_reg[20][1]  ( .D(n1130), .CLK(clk), .Q(\reg_mem[20][1] )
         );
  DFFPOSX1 \reg_mem_reg[19][1]  ( .D(n1131), .CLK(clk), .Q(\reg_mem[19][1] )
         );
  DFFPOSX1 \reg_mem_reg[18][1]  ( .D(n1132), .CLK(clk), .Q(\reg_mem[18][1] )
         );
  DFFPOSX1 \reg_mem_reg[17][1]  ( .D(n1133), .CLK(clk), .Q(\reg_mem[17][1] )
         );
  DFFPOSX1 \reg_mem_reg[16][1]  ( .D(n1134), .CLK(clk), .Q(\reg_mem[16][1] )
         );
  DFFPOSX1 \reg_mem_reg[15][1]  ( .D(n1135), .CLK(clk), .Q(\reg_mem[15][1] )
         );
  DFFPOSX1 \reg_mem_reg[14][1]  ( .D(n1136), .CLK(clk), .Q(\reg_mem[14][1] )
         );
  DFFPOSX1 \reg_mem_reg[13][1]  ( .D(n1137), .CLK(clk), .Q(\reg_mem[13][1] )
         );
  DFFPOSX1 \reg_mem_reg[12][1]  ( .D(n1138), .CLK(clk), .Q(\reg_mem[12][1] )
         );
  DFFPOSX1 \reg_mem_reg[11][1]  ( .D(n1139), .CLK(clk), .Q(\reg_mem[11][1] )
         );
  DFFPOSX1 \reg_mem_reg[10][1]  ( .D(n1140), .CLK(clk), .Q(\reg_mem[10][1] )
         );
  DFFPOSX1 \reg_mem_reg[9][1]  ( .D(n1141), .CLK(clk), .Q(\reg_mem[9][1] ) );
  DFFPOSX1 \reg_mem_reg[8][1]  ( .D(n1142), .CLK(clk), .Q(\reg_mem[8][1] ) );
  DFFPOSX1 \reg_mem_reg[7][1]  ( .D(n1143), .CLK(clk), .Q(\reg_mem[7][1] ) );
  DFFPOSX1 \reg_mem_reg[6][1]  ( .D(n1144), .CLK(clk), .Q(\reg_mem[6][1] ) );
  DFFPOSX1 \reg_mem_reg[5][1]  ( .D(n1145), .CLK(clk), .Q(\reg_mem[5][1] ) );
  DFFPOSX1 \reg_mem_reg[4][1]  ( .D(n1146), .CLK(clk), .Q(\reg_mem[4][1] ) );
  DFFPOSX1 \reg_mem_reg[3][1]  ( .D(n1147), .CLK(clk), .Q(\reg_mem[3][1] ) );
  DFFPOSX1 \reg_mem_reg[2][1]  ( .D(n1148), .CLK(clk), .Q(\reg_mem[2][1] ) );
  DFFPOSX1 \reg_mem_reg[1][1]  ( .D(n1149), .CLK(clk), .Q(\reg_mem[1][1] ) );
  DFFPOSX1 \reg_mem_reg[0][1]  ( .D(n1150), .CLK(clk), .Q(\reg_mem[0][1] ) );
  DFFPOSX1 \reg_mem_reg[63][1]  ( .D(n1151), .CLK(clk), .Q(\reg_mem[63][1] )
         );
  DFFPOSX1 \reg_mem_reg[62][2]  ( .D(n1024), .CLK(clk), .Q(\reg_mem[62][2] )
         );
  DFFPOSX1 \reg_mem_reg[61][2]  ( .D(n1025), .CLK(clk), .Q(\reg_mem[61][2] )
         );
  DFFPOSX1 \reg_mem_reg[60][2]  ( .D(n1026), .CLK(clk), .Q(\reg_mem[60][2] )
         );
  DFFPOSX1 \reg_mem_reg[59][2]  ( .D(n1027), .CLK(clk), .Q(\reg_mem[59][2] )
         );
  DFFPOSX1 \reg_mem_reg[58][2]  ( .D(n1028), .CLK(clk), .Q(\reg_mem[58][2] )
         );
  DFFPOSX1 \reg_mem_reg[57][2]  ( .D(n1029), .CLK(clk), .Q(\reg_mem[57][2] )
         );
  DFFPOSX1 \reg_mem_reg[56][2]  ( .D(n1030), .CLK(clk), .Q(\reg_mem[56][2] )
         );
  DFFPOSX1 \reg_mem_reg[55][2]  ( .D(n1031), .CLK(clk), .Q(\reg_mem[55][2] )
         );
  DFFPOSX1 \reg_mem_reg[54][2]  ( .D(n1032), .CLK(clk), .Q(\reg_mem[54][2] )
         );
  DFFPOSX1 \reg_mem_reg[53][2]  ( .D(n1033), .CLK(clk), .Q(\reg_mem[53][2] )
         );
  DFFPOSX1 \reg_mem_reg[52][2]  ( .D(n1034), .CLK(clk), .Q(\reg_mem[52][2] )
         );
  DFFPOSX1 \reg_mem_reg[51][2]  ( .D(n1035), .CLK(clk), .Q(\reg_mem[51][2] )
         );
  DFFPOSX1 \reg_mem_reg[50][2]  ( .D(n1036), .CLK(clk), .Q(\reg_mem[50][2] )
         );
  DFFPOSX1 \reg_mem_reg[49][2]  ( .D(n1037), .CLK(clk), .Q(\reg_mem[49][2] )
         );
  DFFPOSX1 \reg_mem_reg[48][2]  ( .D(n1038), .CLK(clk), .Q(\reg_mem[48][2] )
         );
  DFFPOSX1 \reg_mem_reg[47][2]  ( .D(n1039), .CLK(clk), .Q(\reg_mem[47][2] )
         );
  DFFPOSX1 \reg_mem_reg[46][2]  ( .D(n1040), .CLK(clk), .Q(\reg_mem[46][2] )
         );
  DFFPOSX1 \reg_mem_reg[45][2]  ( .D(n1041), .CLK(clk), .Q(\reg_mem[45][2] )
         );
  DFFPOSX1 \reg_mem_reg[44][2]  ( .D(n1042), .CLK(clk), .Q(\reg_mem[44][2] )
         );
  DFFPOSX1 \reg_mem_reg[43][2]  ( .D(n1043), .CLK(clk), .Q(\reg_mem[43][2] )
         );
  DFFPOSX1 \reg_mem_reg[42][2]  ( .D(n1044), .CLK(clk), .Q(\reg_mem[42][2] )
         );
  DFFPOSX1 \reg_mem_reg[41][2]  ( .D(n1045), .CLK(clk), .Q(\reg_mem[41][2] )
         );
  DFFPOSX1 \reg_mem_reg[40][2]  ( .D(n1046), .CLK(clk), .Q(\reg_mem[40][2] )
         );
  DFFPOSX1 \reg_mem_reg[39][2]  ( .D(n1047), .CLK(clk), .Q(\reg_mem[39][2] )
         );
  DFFPOSX1 \reg_mem_reg[38][2]  ( .D(n1048), .CLK(clk), .Q(\reg_mem[38][2] )
         );
  DFFPOSX1 \reg_mem_reg[37][2]  ( .D(n1049), .CLK(clk), .Q(\reg_mem[37][2] )
         );
  DFFPOSX1 \reg_mem_reg[36][2]  ( .D(n1050), .CLK(clk), .Q(\reg_mem[36][2] )
         );
  DFFPOSX1 \reg_mem_reg[35][2]  ( .D(n1051), .CLK(clk), .Q(\reg_mem[35][2] )
         );
  DFFPOSX1 \reg_mem_reg[34][2]  ( .D(n1052), .CLK(clk), .Q(\reg_mem[34][2] )
         );
  DFFPOSX1 \reg_mem_reg[33][2]  ( .D(n1053), .CLK(clk), .Q(\reg_mem[33][2] )
         );
  DFFPOSX1 \reg_mem_reg[32][2]  ( .D(n1054), .CLK(clk), .Q(\reg_mem[32][2] )
         );
  DFFPOSX1 \reg_mem_reg[31][2]  ( .D(n1055), .CLK(clk), .Q(\reg_mem[31][2] )
         );
  DFFPOSX1 \reg_mem_reg[30][2]  ( .D(n1056), .CLK(clk), .Q(\reg_mem[30][2] )
         );
  DFFPOSX1 \reg_mem_reg[29][2]  ( .D(n1057), .CLK(clk), .Q(\reg_mem[29][2] )
         );
  DFFPOSX1 \reg_mem_reg[28][2]  ( .D(n1058), .CLK(clk), .Q(\reg_mem[28][2] )
         );
  DFFPOSX1 \reg_mem_reg[27][2]  ( .D(n1059), .CLK(clk), .Q(\reg_mem[27][2] )
         );
  DFFPOSX1 \reg_mem_reg[26][2]  ( .D(n1060), .CLK(clk), .Q(\reg_mem[26][2] )
         );
  DFFPOSX1 \reg_mem_reg[25][2]  ( .D(n1061), .CLK(clk), .Q(\reg_mem[25][2] )
         );
  DFFPOSX1 \reg_mem_reg[24][2]  ( .D(n1062), .CLK(clk), .Q(\reg_mem[24][2] )
         );
  DFFPOSX1 \reg_mem_reg[23][2]  ( .D(n1063), .CLK(clk), .Q(\reg_mem[23][2] )
         );
  DFFPOSX1 \reg_mem_reg[22][2]  ( .D(n1064), .CLK(clk), .Q(\reg_mem[22][2] )
         );
  DFFPOSX1 \reg_mem_reg[21][2]  ( .D(n1065), .CLK(clk), .Q(\reg_mem[21][2] )
         );
  DFFPOSX1 \reg_mem_reg[20][2]  ( .D(n1066), .CLK(clk), .Q(\reg_mem[20][2] )
         );
  DFFPOSX1 \reg_mem_reg[19][2]  ( .D(n1067), .CLK(clk), .Q(\reg_mem[19][2] )
         );
  DFFPOSX1 \reg_mem_reg[18][2]  ( .D(n1068), .CLK(clk), .Q(\reg_mem[18][2] )
         );
  DFFPOSX1 \reg_mem_reg[17][2]  ( .D(n1069), .CLK(clk), .Q(\reg_mem[17][2] )
         );
  DFFPOSX1 \reg_mem_reg[16][2]  ( .D(n1070), .CLK(clk), .Q(\reg_mem[16][2] )
         );
  DFFPOSX1 \reg_mem_reg[15][2]  ( .D(n1071), .CLK(clk), .Q(\reg_mem[15][2] )
         );
  DFFPOSX1 \reg_mem_reg[14][2]  ( .D(n1072), .CLK(clk), .Q(\reg_mem[14][2] )
         );
  DFFPOSX1 \reg_mem_reg[13][2]  ( .D(n1073), .CLK(clk), .Q(\reg_mem[13][2] )
         );
  DFFPOSX1 \reg_mem_reg[12][2]  ( .D(n1074), .CLK(clk), .Q(\reg_mem[12][2] )
         );
  DFFPOSX1 \reg_mem_reg[11][2]  ( .D(n1075), .CLK(clk), .Q(\reg_mem[11][2] )
         );
  DFFPOSX1 \reg_mem_reg[10][2]  ( .D(n1076), .CLK(clk), .Q(\reg_mem[10][2] )
         );
  DFFPOSX1 \reg_mem_reg[9][2]  ( .D(n1077), .CLK(clk), .Q(\reg_mem[9][2] ) );
  DFFPOSX1 \reg_mem_reg[8][2]  ( .D(n1078), .CLK(clk), .Q(\reg_mem[8][2] ) );
  DFFPOSX1 \reg_mem_reg[7][2]  ( .D(n1079), .CLK(clk), .Q(\reg_mem[7][2] ) );
  DFFPOSX1 \reg_mem_reg[6][2]  ( .D(n1080), .CLK(clk), .Q(\reg_mem[6][2] ) );
  DFFPOSX1 \reg_mem_reg[5][2]  ( .D(n1081), .CLK(clk), .Q(\reg_mem[5][2] ) );
  DFFPOSX1 \reg_mem_reg[4][2]  ( .D(n1082), .CLK(clk), .Q(\reg_mem[4][2] ) );
  DFFPOSX1 \reg_mem_reg[3][2]  ( .D(n1083), .CLK(clk), .Q(\reg_mem[3][2] ) );
  DFFPOSX1 \reg_mem_reg[2][2]  ( .D(n1084), .CLK(clk), .Q(\reg_mem[2][2] ) );
  DFFPOSX1 \reg_mem_reg[1][2]  ( .D(n1085), .CLK(clk), .Q(\reg_mem[1][2] ) );
  DFFPOSX1 \reg_mem_reg[0][2]  ( .D(n1086), .CLK(clk), .Q(\reg_mem[0][2] ) );
  DFFPOSX1 \reg_mem_reg[63][2]  ( .D(n1087), .CLK(clk), .Q(\reg_mem[63][2] )
         );
  DFFPOSX1 \reg_mem_reg[62][3]  ( .D(n960), .CLK(clk), .Q(\reg_mem[62][3] ) );
  DFFPOSX1 \reg_mem_reg[61][3]  ( .D(n961), .CLK(clk), .Q(\reg_mem[61][3] ) );
  DFFPOSX1 \reg_mem_reg[60][3]  ( .D(n962), .CLK(clk), .Q(\reg_mem[60][3] ) );
  DFFPOSX1 \reg_mem_reg[59][3]  ( .D(n963), .CLK(clk), .Q(\reg_mem[59][3] ) );
  DFFPOSX1 \reg_mem_reg[58][3]  ( .D(n964), .CLK(clk), .Q(\reg_mem[58][3] ) );
  DFFPOSX1 \reg_mem_reg[57][3]  ( .D(n965), .CLK(clk), .Q(\reg_mem[57][3] ) );
  DFFPOSX1 \reg_mem_reg[56][3]  ( .D(n966), .CLK(clk), .Q(\reg_mem[56][3] ) );
  DFFPOSX1 \reg_mem_reg[55][3]  ( .D(n967), .CLK(clk), .Q(\reg_mem[55][3] ) );
  DFFPOSX1 \reg_mem_reg[54][3]  ( .D(n968), .CLK(clk), .Q(\reg_mem[54][3] ) );
  DFFPOSX1 \reg_mem_reg[53][3]  ( .D(n969), .CLK(clk), .Q(\reg_mem[53][3] ) );
  DFFPOSX1 \reg_mem_reg[52][3]  ( .D(n970), .CLK(clk), .Q(\reg_mem[52][3] ) );
  DFFPOSX1 \reg_mem_reg[51][3]  ( .D(n971), .CLK(clk), .Q(\reg_mem[51][3] ) );
  DFFPOSX1 \reg_mem_reg[50][3]  ( .D(n972), .CLK(clk), .Q(\reg_mem[50][3] ) );
  DFFPOSX1 \reg_mem_reg[49][3]  ( .D(n973), .CLK(clk), .Q(\reg_mem[49][3] ) );
  DFFPOSX1 \reg_mem_reg[48][3]  ( .D(n974), .CLK(clk), .Q(\reg_mem[48][3] ) );
  DFFPOSX1 \reg_mem_reg[47][3]  ( .D(n975), .CLK(clk), .Q(\reg_mem[47][3] ) );
  DFFPOSX1 \reg_mem_reg[46][3]  ( .D(n976), .CLK(clk), .Q(\reg_mem[46][3] ) );
  DFFPOSX1 \reg_mem_reg[45][3]  ( .D(n977), .CLK(clk), .Q(\reg_mem[45][3] ) );
  DFFPOSX1 \reg_mem_reg[44][3]  ( .D(n978), .CLK(clk), .Q(\reg_mem[44][3] ) );
  DFFPOSX1 \reg_mem_reg[43][3]  ( .D(n979), .CLK(clk), .Q(\reg_mem[43][3] ) );
  DFFPOSX1 \reg_mem_reg[42][3]  ( .D(n980), .CLK(clk), .Q(\reg_mem[42][3] ) );
  DFFPOSX1 \reg_mem_reg[41][3]  ( .D(n981), .CLK(clk), .Q(\reg_mem[41][3] ) );
  DFFPOSX1 \reg_mem_reg[40][3]  ( .D(n982), .CLK(clk), .Q(\reg_mem[40][3] ) );
  DFFPOSX1 \reg_mem_reg[39][3]  ( .D(n983), .CLK(clk), .Q(\reg_mem[39][3] ) );
  DFFPOSX1 \reg_mem_reg[38][3]  ( .D(n984), .CLK(clk), .Q(\reg_mem[38][3] ) );
  DFFPOSX1 \reg_mem_reg[37][3]  ( .D(n985), .CLK(clk), .Q(\reg_mem[37][3] ) );
  DFFPOSX1 \reg_mem_reg[36][3]  ( .D(n986), .CLK(clk), .Q(\reg_mem[36][3] ) );
  DFFPOSX1 \reg_mem_reg[35][3]  ( .D(n987), .CLK(clk), .Q(\reg_mem[35][3] ) );
  DFFPOSX1 \reg_mem_reg[34][3]  ( .D(n988), .CLK(clk), .Q(\reg_mem[34][3] ) );
  DFFPOSX1 \reg_mem_reg[33][3]  ( .D(n989), .CLK(clk), .Q(\reg_mem[33][3] ) );
  DFFPOSX1 \reg_mem_reg[32][3]  ( .D(n990), .CLK(clk), .Q(\reg_mem[32][3] ) );
  DFFPOSX1 \reg_mem_reg[31][3]  ( .D(n991), .CLK(clk), .Q(\reg_mem[31][3] ) );
  DFFPOSX1 \reg_mem_reg[30][3]  ( .D(n992), .CLK(clk), .Q(\reg_mem[30][3] ) );
  DFFPOSX1 \reg_mem_reg[29][3]  ( .D(n993), .CLK(clk), .Q(\reg_mem[29][3] ) );
  DFFPOSX1 \reg_mem_reg[28][3]  ( .D(n994), .CLK(clk), .Q(\reg_mem[28][3] ) );
  DFFPOSX1 \reg_mem_reg[27][3]  ( .D(n995), .CLK(clk), .Q(\reg_mem[27][3] ) );
  DFFPOSX1 \reg_mem_reg[26][3]  ( .D(n996), .CLK(clk), .Q(\reg_mem[26][3] ) );
  DFFPOSX1 \reg_mem_reg[25][3]  ( .D(n997), .CLK(clk), .Q(\reg_mem[25][3] ) );
  DFFPOSX1 \reg_mem_reg[24][3]  ( .D(n998), .CLK(clk), .Q(\reg_mem[24][3] ) );
  DFFPOSX1 \reg_mem_reg[23][3]  ( .D(n999), .CLK(clk), .Q(\reg_mem[23][3] ) );
  DFFPOSX1 \reg_mem_reg[22][3]  ( .D(n1000), .CLK(clk), .Q(\reg_mem[22][3] )
         );
  DFFPOSX1 \reg_mem_reg[21][3]  ( .D(n1001), .CLK(clk), .Q(\reg_mem[21][3] )
         );
  DFFPOSX1 \reg_mem_reg[20][3]  ( .D(n1002), .CLK(clk), .Q(\reg_mem[20][3] )
         );
  DFFPOSX1 \reg_mem_reg[19][3]  ( .D(n1003), .CLK(clk), .Q(\reg_mem[19][3] )
         );
  DFFPOSX1 \reg_mem_reg[18][3]  ( .D(n1004), .CLK(clk), .Q(\reg_mem[18][3] )
         );
  DFFPOSX1 \reg_mem_reg[17][3]  ( .D(n1005), .CLK(clk), .Q(\reg_mem[17][3] )
         );
  DFFPOSX1 \reg_mem_reg[16][3]  ( .D(n1006), .CLK(clk), .Q(\reg_mem[16][3] )
         );
  DFFPOSX1 \reg_mem_reg[15][3]  ( .D(n1007), .CLK(clk), .Q(\reg_mem[15][3] )
         );
  DFFPOSX1 \reg_mem_reg[14][3]  ( .D(n1008), .CLK(clk), .Q(\reg_mem[14][3] )
         );
  DFFPOSX1 \reg_mem_reg[13][3]  ( .D(n1009), .CLK(clk), .Q(\reg_mem[13][3] )
         );
  DFFPOSX1 \reg_mem_reg[12][3]  ( .D(n1010), .CLK(clk), .Q(\reg_mem[12][3] )
         );
  DFFPOSX1 \reg_mem_reg[11][3]  ( .D(n1011), .CLK(clk), .Q(\reg_mem[11][3] )
         );
  DFFPOSX1 \reg_mem_reg[10][3]  ( .D(n1012), .CLK(clk), .Q(\reg_mem[10][3] )
         );
  DFFPOSX1 \reg_mem_reg[9][3]  ( .D(n1013), .CLK(clk), .Q(\reg_mem[9][3] ) );
  DFFPOSX1 \reg_mem_reg[8][3]  ( .D(n1014), .CLK(clk), .Q(\reg_mem[8][3] ) );
  DFFPOSX1 \reg_mem_reg[7][3]  ( .D(n1015), .CLK(clk), .Q(\reg_mem[7][3] ) );
  DFFPOSX1 \reg_mem_reg[6][3]  ( .D(n1016), .CLK(clk), .Q(\reg_mem[6][3] ) );
  DFFPOSX1 \reg_mem_reg[5][3]  ( .D(n1017), .CLK(clk), .Q(\reg_mem[5][3] ) );
  DFFPOSX1 \reg_mem_reg[4][3]  ( .D(n1018), .CLK(clk), .Q(\reg_mem[4][3] ) );
  DFFPOSX1 \reg_mem_reg[3][3]  ( .D(n1019), .CLK(clk), .Q(\reg_mem[3][3] ) );
  DFFPOSX1 \reg_mem_reg[2][3]  ( .D(n1020), .CLK(clk), .Q(\reg_mem[2][3] ) );
  DFFPOSX1 \reg_mem_reg[1][3]  ( .D(n1021), .CLK(clk), .Q(\reg_mem[1][3] ) );
  DFFPOSX1 \reg_mem_reg[0][3]  ( .D(n1022), .CLK(clk), .Q(\reg_mem[0][3] ) );
  DFFPOSX1 \reg_mem_reg[63][3]  ( .D(n1023), .CLK(clk), .Q(\reg_mem[63][3] )
         );
  DFFPOSX1 \reg_mem_reg[62][4]  ( .D(n896), .CLK(clk), .Q(\reg_mem[62][4] ) );
  DFFPOSX1 \reg_mem_reg[61][4]  ( .D(n897), .CLK(clk), .Q(\reg_mem[61][4] ) );
  DFFPOSX1 \reg_mem_reg[60][4]  ( .D(n898), .CLK(clk), .Q(\reg_mem[60][4] ) );
  DFFPOSX1 \reg_mem_reg[59][4]  ( .D(n899), .CLK(clk), .Q(\reg_mem[59][4] ) );
  DFFPOSX1 \reg_mem_reg[58][4]  ( .D(n900), .CLK(clk), .Q(\reg_mem[58][4] ) );
  DFFPOSX1 \reg_mem_reg[57][4]  ( .D(n901), .CLK(clk), .Q(\reg_mem[57][4] ) );
  DFFPOSX1 \reg_mem_reg[56][4]  ( .D(n902), .CLK(clk), .Q(\reg_mem[56][4] ) );
  DFFPOSX1 \reg_mem_reg[55][4]  ( .D(n903), .CLK(clk), .Q(\reg_mem[55][4] ) );
  DFFPOSX1 \reg_mem_reg[54][4]  ( .D(n904), .CLK(clk), .Q(\reg_mem[54][4] ) );
  DFFPOSX1 \reg_mem_reg[53][4]  ( .D(n905), .CLK(clk), .Q(\reg_mem[53][4] ) );
  DFFPOSX1 \reg_mem_reg[52][4]  ( .D(n906), .CLK(clk), .Q(\reg_mem[52][4] ) );
  DFFPOSX1 \reg_mem_reg[51][4]  ( .D(n907), .CLK(clk), .Q(\reg_mem[51][4] ) );
  DFFPOSX1 \reg_mem_reg[50][4]  ( .D(n908), .CLK(clk), .Q(\reg_mem[50][4] ) );
  DFFPOSX1 \reg_mem_reg[49][4]  ( .D(n909), .CLK(clk), .Q(\reg_mem[49][4] ) );
  DFFPOSX1 \reg_mem_reg[48][4]  ( .D(n910), .CLK(clk), .Q(\reg_mem[48][4] ) );
  DFFPOSX1 \reg_mem_reg[47][4]  ( .D(n911), .CLK(clk), .Q(\reg_mem[47][4] ) );
  DFFPOSX1 \reg_mem_reg[46][4]  ( .D(n912), .CLK(clk), .Q(\reg_mem[46][4] ) );
  DFFPOSX1 \reg_mem_reg[45][4]  ( .D(n913), .CLK(clk), .Q(\reg_mem[45][4] ) );
  DFFPOSX1 \reg_mem_reg[44][4]  ( .D(n914), .CLK(clk), .Q(\reg_mem[44][4] ) );
  DFFPOSX1 \reg_mem_reg[43][4]  ( .D(n915), .CLK(clk), .Q(\reg_mem[43][4] ) );
  DFFPOSX1 \reg_mem_reg[42][4]  ( .D(n916), .CLK(clk), .Q(\reg_mem[42][4] ) );
  DFFPOSX1 \reg_mem_reg[41][4]  ( .D(n917), .CLK(clk), .Q(\reg_mem[41][4] ) );
  DFFPOSX1 \reg_mem_reg[40][4]  ( .D(n918), .CLK(clk), .Q(\reg_mem[40][4] ) );
  DFFPOSX1 \reg_mem_reg[39][4]  ( .D(n919), .CLK(clk), .Q(\reg_mem[39][4] ) );
  DFFPOSX1 \reg_mem_reg[38][4]  ( .D(n920), .CLK(clk), .Q(\reg_mem[38][4] ) );
  DFFPOSX1 \reg_mem_reg[37][4]  ( .D(n921), .CLK(clk), .Q(\reg_mem[37][4] ) );
  DFFPOSX1 \reg_mem_reg[36][4]  ( .D(n922), .CLK(clk), .Q(\reg_mem[36][4] ) );
  DFFPOSX1 \reg_mem_reg[35][4]  ( .D(n923), .CLK(clk), .Q(\reg_mem[35][4] ) );
  DFFPOSX1 \reg_mem_reg[34][4]  ( .D(n924), .CLK(clk), .Q(\reg_mem[34][4] ) );
  DFFPOSX1 \reg_mem_reg[33][4]  ( .D(n925), .CLK(clk), .Q(\reg_mem[33][4] ) );
  DFFPOSX1 \reg_mem_reg[32][4]  ( .D(n926), .CLK(clk), .Q(\reg_mem[32][4] ) );
  DFFPOSX1 \reg_mem_reg[31][4]  ( .D(n927), .CLK(clk), .Q(\reg_mem[31][4] ) );
  DFFPOSX1 \reg_mem_reg[30][4]  ( .D(n928), .CLK(clk), .Q(\reg_mem[30][4] ) );
  DFFPOSX1 \reg_mem_reg[29][4]  ( .D(n929), .CLK(clk), .Q(\reg_mem[29][4] ) );
  DFFPOSX1 \reg_mem_reg[28][4]  ( .D(n930), .CLK(clk), .Q(\reg_mem[28][4] ) );
  DFFPOSX1 \reg_mem_reg[27][4]  ( .D(n931), .CLK(clk), .Q(\reg_mem[27][4] ) );
  DFFPOSX1 \reg_mem_reg[26][4]  ( .D(n932), .CLK(clk), .Q(\reg_mem[26][4] ) );
  DFFPOSX1 \reg_mem_reg[25][4]  ( .D(n933), .CLK(clk), .Q(\reg_mem[25][4] ) );
  DFFPOSX1 \reg_mem_reg[24][4]  ( .D(n934), .CLK(clk), .Q(\reg_mem[24][4] ) );
  DFFPOSX1 \reg_mem_reg[23][4]  ( .D(n935), .CLK(clk), .Q(\reg_mem[23][4] ) );
  DFFPOSX1 \reg_mem_reg[22][4]  ( .D(n936), .CLK(clk), .Q(\reg_mem[22][4] ) );
  DFFPOSX1 \reg_mem_reg[21][4]  ( .D(n937), .CLK(clk), .Q(\reg_mem[21][4] ) );
  DFFPOSX1 \reg_mem_reg[20][4]  ( .D(n938), .CLK(clk), .Q(\reg_mem[20][4] ) );
  DFFPOSX1 \reg_mem_reg[19][4]  ( .D(n939), .CLK(clk), .Q(\reg_mem[19][4] ) );
  DFFPOSX1 \reg_mem_reg[18][4]  ( .D(n940), .CLK(clk), .Q(\reg_mem[18][4] ) );
  DFFPOSX1 \reg_mem_reg[17][4]  ( .D(n941), .CLK(clk), .Q(\reg_mem[17][4] ) );
  DFFPOSX1 \reg_mem_reg[16][4]  ( .D(n942), .CLK(clk), .Q(\reg_mem[16][4] ) );
  DFFPOSX1 \reg_mem_reg[15][4]  ( .D(n943), .CLK(clk), .Q(\reg_mem[15][4] ) );
  DFFPOSX1 \reg_mem_reg[14][4]  ( .D(n944), .CLK(clk), .Q(\reg_mem[14][4] ) );
  DFFPOSX1 \reg_mem_reg[13][4]  ( .D(n945), .CLK(clk), .Q(\reg_mem[13][4] ) );
  DFFPOSX1 \reg_mem_reg[12][4]  ( .D(n946), .CLK(clk), .Q(\reg_mem[12][4] ) );
  DFFPOSX1 \reg_mem_reg[11][4]  ( .D(n947), .CLK(clk), .Q(\reg_mem[11][4] ) );
  DFFPOSX1 \reg_mem_reg[10][4]  ( .D(n948), .CLK(clk), .Q(\reg_mem[10][4] ) );
  DFFPOSX1 \reg_mem_reg[9][4]  ( .D(n949), .CLK(clk), .Q(\reg_mem[9][4] ) );
  DFFPOSX1 \reg_mem_reg[8][4]  ( .D(n950), .CLK(clk), .Q(\reg_mem[8][4] ) );
  DFFPOSX1 \reg_mem_reg[7][4]  ( .D(n951), .CLK(clk), .Q(\reg_mem[7][4] ) );
  DFFPOSX1 \reg_mem_reg[6][4]  ( .D(n952), .CLK(clk), .Q(\reg_mem[6][4] ) );
  DFFPOSX1 \reg_mem_reg[5][4]  ( .D(n953), .CLK(clk), .Q(\reg_mem[5][4] ) );
  DFFPOSX1 \reg_mem_reg[4][4]  ( .D(n954), .CLK(clk), .Q(\reg_mem[4][4] ) );
  DFFPOSX1 \reg_mem_reg[3][4]  ( .D(n955), .CLK(clk), .Q(\reg_mem[3][4] ) );
  DFFPOSX1 \reg_mem_reg[2][4]  ( .D(n956), .CLK(clk), .Q(\reg_mem[2][4] ) );
  DFFPOSX1 \reg_mem_reg[1][4]  ( .D(n957), .CLK(clk), .Q(\reg_mem[1][4] ) );
  DFFPOSX1 \reg_mem_reg[0][4]  ( .D(n958), .CLK(clk), .Q(\reg_mem[0][4] ) );
  DFFPOSX1 \reg_mem_reg[63][4]  ( .D(n959), .CLK(clk), .Q(\reg_mem[63][4] ) );
  DFFPOSX1 \reg_mem_reg[62][5]  ( .D(n832), .CLK(clk), .Q(\reg_mem[62][5] ) );
  DFFPOSX1 \reg_mem_reg[61][5]  ( .D(n833), .CLK(clk), .Q(\reg_mem[61][5] ) );
  DFFPOSX1 \reg_mem_reg[60][5]  ( .D(n834), .CLK(clk), .Q(\reg_mem[60][5] ) );
  DFFPOSX1 \reg_mem_reg[59][5]  ( .D(n835), .CLK(clk), .Q(\reg_mem[59][5] ) );
  DFFPOSX1 \reg_mem_reg[58][5]  ( .D(n836), .CLK(clk), .Q(\reg_mem[58][5] ) );
  DFFPOSX1 \reg_mem_reg[57][5]  ( .D(n837), .CLK(clk), .Q(\reg_mem[57][5] ) );
  DFFPOSX1 \reg_mem_reg[56][5]  ( .D(n838), .CLK(clk), .Q(\reg_mem[56][5] ) );
  DFFPOSX1 \reg_mem_reg[55][5]  ( .D(n839), .CLK(clk), .Q(\reg_mem[55][5] ) );
  DFFPOSX1 \reg_mem_reg[54][5]  ( .D(n840), .CLK(clk), .Q(\reg_mem[54][5] ) );
  DFFPOSX1 \reg_mem_reg[53][5]  ( .D(n841), .CLK(clk), .Q(\reg_mem[53][5] ) );
  DFFPOSX1 \reg_mem_reg[52][5]  ( .D(n842), .CLK(clk), .Q(\reg_mem[52][5] ) );
  DFFPOSX1 \reg_mem_reg[51][5]  ( .D(n843), .CLK(clk), .Q(\reg_mem[51][5] ) );
  DFFPOSX1 \reg_mem_reg[50][5]  ( .D(n844), .CLK(clk), .Q(\reg_mem[50][5] ) );
  DFFPOSX1 \reg_mem_reg[49][5]  ( .D(n845), .CLK(clk), .Q(\reg_mem[49][5] ) );
  DFFPOSX1 \reg_mem_reg[48][5]  ( .D(n846), .CLK(clk), .Q(\reg_mem[48][5] ) );
  DFFPOSX1 \reg_mem_reg[47][5]  ( .D(n847), .CLK(clk), .Q(\reg_mem[47][5] ) );
  DFFPOSX1 \reg_mem_reg[46][5]  ( .D(n848), .CLK(clk), .Q(\reg_mem[46][5] ) );
  DFFPOSX1 \reg_mem_reg[45][5]  ( .D(n849), .CLK(clk), .Q(\reg_mem[45][5] ) );
  DFFPOSX1 \reg_mem_reg[44][5]  ( .D(n850), .CLK(clk), .Q(\reg_mem[44][5] ) );
  DFFPOSX1 \reg_mem_reg[43][5]  ( .D(n851), .CLK(clk), .Q(\reg_mem[43][5] ) );
  DFFPOSX1 \reg_mem_reg[42][5]  ( .D(n852), .CLK(clk), .Q(\reg_mem[42][5] ) );
  DFFPOSX1 \reg_mem_reg[41][5]  ( .D(n853), .CLK(clk), .Q(\reg_mem[41][5] ) );
  DFFPOSX1 \reg_mem_reg[40][5]  ( .D(n854), .CLK(clk), .Q(\reg_mem[40][5] ) );
  DFFPOSX1 \reg_mem_reg[39][5]  ( .D(n855), .CLK(clk), .Q(\reg_mem[39][5] ) );
  DFFPOSX1 \reg_mem_reg[38][5]  ( .D(n856), .CLK(clk), .Q(\reg_mem[38][5] ) );
  DFFPOSX1 \reg_mem_reg[37][5]  ( .D(n857), .CLK(clk), .Q(\reg_mem[37][5] ) );
  DFFPOSX1 \reg_mem_reg[36][5]  ( .D(n858), .CLK(clk), .Q(\reg_mem[36][5] ) );
  DFFPOSX1 \reg_mem_reg[35][5]  ( .D(n859), .CLK(clk), .Q(\reg_mem[35][5] ) );
  DFFPOSX1 \reg_mem_reg[34][5]  ( .D(n860), .CLK(clk), .Q(\reg_mem[34][5] ) );
  DFFPOSX1 \reg_mem_reg[33][5]  ( .D(n861), .CLK(clk), .Q(\reg_mem[33][5] ) );
  DFFPOSX1 \reg_mem_reg[32][5]  ( .D(n862), .CLK(clk), .Q(\reg_mem[32][5] ) );
  DFFPOSX1 \reg_mem_reg[31][5]  ( .D(n863), .CLK(clk), .Q(\reg_mem[31][5] ) );
  DFFPOSX1 \reg_mem_reg[30][5]  ( .D(n864), .CLK(clk), .Q(\reg_mem[30][5] ) );
  DFFPOSX1 \reg_mem_reg[29][5]  ( .D(n865), .CLK(clk), .Q(\reg_mem[29][5] ) );
  DFFPOSX1 \reg_mem_reg[28][5]  ( .D(n866), .CLK(clk), .Q(\reg_mem[28][5] ) );
  DFFPOSX1 \reg_mem_reg[27][5]  ( .D(n867), .CLK(clk), .Q(\reg_mem[27][5] ) );
  DFFPOSX1 \reg_mem_reg[26][5]  ( .D(n868), .CLK(clk), .Q(\reg_mem[26][5] ) );
  DFFPOSX1 \reg_mem_reg[25][5]  ( .D(n869), .CLK(clk), .Q(\reg_mem[25][5] ) );
  DFFPOSX1 \reg_mem_reg[24][5]  ( .D(n870), .CLK(clk), .Q(\reg_mem[24][5] ) );
  DFFPOSX1 \reg_mem_reg[23][5]  ( .D(n871), .CLK(clk), .Q(\reg_mem[23][5] ) );
  DFFPOSX1 \reg_mem_reg[22][5]  ( .D(n872), .CLK(clk), .Q(\reg_mem[22][5] ) );
  DFFPOSX1 \reg_mem_reg[21][5]  ( .D(n873), .CLK(clk), .Q(\reg_mem[21][5] ) );
  DFFPOSX1 \reg_mem_reg[20][5]  ( .D(n874), .CLK(clk), .Q(\reg_mem[20][5] ) );
  DFFPOSX1 \reg_mem_reg[19][5]  ( .D(n875), .CLK(clk), .Q(\reg_mem[19][5] ) );
  DFFPOSX1 \reg_mem_reg[18][5]  ( .D(n876), .CLK(clk), .Q(\reg_mem[18][5] ) );
  DFFPOSX1 \reg_mem_reg[17][5]  ( .D(n877), .CLK(clk), .Q(\reg_mem[17][5] ) );
  DFFPOSX1 \reg_mem_reg[16][5]  ( .D(n878), .CLK(clk), .Q(\reg_mem[16][5] ) );
  DFFPOSX1 \reg_mem_reg[15][5]  ( .D(n879), .CLK(clk), .Q(\reg_mem[15][5] ) );
  DFFPOSX1 \reg_mem_reg[14][5]  ( .D(n880), .CLK(clk), .Q(\reg_mem[14][5] ) );
  DFFPOSX1 \reg_mem_reg[13][5]  ( .D(n881), .CLK(clk), .Q(\reg_mem[13][5] ) );
  DFFPOSX1 \reg_mem_reg[12][5]  ( .D(n882), .CLK(clk), .Q(\reg_mem[12][5] ) );
  DFFPOSX1 \reg_mem_reg[11][5]  ( .D(n883), .CLK(clk), .Q(\reg_mem[11][5] ) );
  DFFPOSX1 \reg_mem_reg[10][5]  ( .D(n884), .CLK(clk), .Q(\reg_mem[10][5] ) );
  DFFPOSX1 \reg_mem_reg[9][5]  ( .D(n885), .CLK(clk), .Q(\reg_mem[9][5] ) );
  DFFPOSX1 \reg_mem_reg[8][5]  ( .D(n886), .CLK(clk), .Q(\reg_mem[8][5] ) );
  DFFPOSX1 \reg_mem_reg[7][5]  ( .D(n887), .CLK(clk), .Q(\reg_mem[7][5] ) );
  DFFPOSX1 \reg_mem_reg[6][5]  ( .D(n888), .CLK(clk), .Q(\reg_mem[6][5] ) );
  DFFPOSX1 \reg_mem_reg[5][5]  ( .D(n889), .CLK(clk), .Q(\reg_mem[5][5] ) );
  DFFPOSX1 \reg_mem_reg[4][5]  ( .D(n890), .CLK(clk), .Q(\reg_mem[4][5] ) );
  DFFPOSX1 \reg_mem_reg[3][5]  ( .D(n891), .CLK(clk), .Q(\reg_mem[3][5] ) );
  DFFPOSX1 \reg_mem_reg[2][5]  ( .D(n892), .CLK(clk), .Q(\reg_mem[2][5] ) );
  DFFPOSX1 \reg_mem_reg[1][5]  ( .D(n893), .CLK(clk), .Q(\reg_mem[1][5] ) );
  DFFPOSX1 \reg_mem_reg[0][5]  ( .D(n894), .CLK(clk), .Q(\reg_mem[0][5] ) );
  DFFPOSX1 \reg_mem_reg[63][5]  ( .D(n895), .CLK(clk), .Q(\reg_mem[63][5] ) );
  DFFPOSX1 \reg_mem_reg[62][6]  ( .D(n768), .CLK(clk), .Q(\reg_mem[62][6] ) );
  DFFPOSX1 \reg_mem_reg[61][6]  ( .D(n769), .CLK(clk), .Q(\reg_mem[61][6] ) );
  DFFPOSX1 \reg_mem_reg[60][6]  ( .D(n770), .CLK(clk), .Q(\reg_mem[60][6] ) );
  DFFPOSX1 \reg_mem_reg[59][6]  ( .D(n771), .CLK(clk), .Q(\reg_mem[59][6] ) );
  DFFPOSX1 \reg_mem_reg[58][6]  ( .D(n772), .CLK(clk), .Q(\reg_mem[58][6] ) );
  DFFPOSX1 \reg_mem_reg[57][6]  ( .D(n773), .CLK(clk), .Q(\reg_mem[57][6] ) );
  DFFPOSX1 \reg_mem_reg[56][6]  ( .D(n774), .CLK(clk), .Q(\reg_mem[56][6] ) );
  DFFPOSX1 \reg_mem_reg[55][6]  ( .D(n775), .CLK(clk), .Q(\reg_mem[55][6] ) );
  DFFPOSX1 \reg_mem_reg[54][6]  ( .D(n776), .CLK(clk), .Q(\reg_mem[54][6] ) );
  DFFPOSX1 \reg_mem_reg[53][6]  ( .D(n777), .CLK(clk), .Q(\reg_mem[53][6] ) );
  DFFPOSX1 \reg_mem_reg[52][6]  ( .D(n778), .CLK(clk), .Q(\reg_mem[52][6] ) );
  DFFPOSX1 \reg_mem_reg[51][6]  ( .D(n779), .CLK(clk), .Q(\reg_mem[51][6] ) );
  DFFPOSX1 \reg_mem_reg[50][6]  ( .D(n780), .CLK(clk), .Q(\reg_mem[50][6] ) );
  DFFPOSX1 \reg_mem_reg[49][6]  ( .D(n781), .CLK(clk), .Q(\reg_mem[49][6] ) );
  DFFPOSX1 \reg_mem_reg[48][6]  ( .D(n782), .CLK(clk), .Q(\reg_mem[48][6] ) );
  DFFPOSX1 \reg_mem_reg[47][6]  ( .D(n783), .CLK(clk), .Q(\reg_mem[47][6] ) );
  DFFPOSX1 \reg_mem_reg[46][6]  ( .D(n784), .CLK(clk), .Q(\reg_mem[46][6] ) );
  DFFPOSX1 \reg_mem_reg[45][6]  ( .D(n785), .CLK(clk), .Q(\reg_mem[45][6] ) );
  DFFPOSX1 \reg_mem_reg[44][6]  ( .D(n786), .CLK(clk), .Q(\reg_mem[44][6] ) );
  DFFPOSX1 \reg_mem_reg[43][6]  ( .D(n787), .CLK(clk), .Q(\reg_mem[43][6] ) );
  DFFPOSX1 \reg_mem_reg[42][6]  ( .D(n788), .CLK(clk), .Q(\reg_mem[42][6] ) );
  DFFPOSX1 \reg_mem_reg[41][6]  ( .D(n789), .CLK(clk), .Q(\reg_mem[41][6] ) );
  DFFPOSX1 \reg_mem_reg[40][6]  ( .D(n790), .CLK(clk), .Q(\reg_mem[40][6] ) );
  DFFPOSX1 \reg_mem_reg[39][6]  ( .D(n791), .CLK(clk), .Q(\reg_mem[39][6] ) );
  DFFPOSX1 \reg_mem_reg[38][6]  ( .D(n792), .CLK(clk), .Q(\reg_mem[38][6] ) );
  DFFPOSX1 \reg_mem_reg[37][6]  ( .D(n793), .CLK(clk), .Q(\reg_mem[37][6] ) );
  DFFPOSX1 \reg_mem_reg[36][6]  ( .D(n794), .CLK(clk), .Q(\reg_mem[36][6] ) );
  DFFPOSX1 \reg_mem_reg[35][6]  ( .D(n795), .CLK(clk), .Q(\reg_mem[35][6] ) );
  DFFPOSX1 \reg_mem_reg[34][6]  ( .D(n796), .CLK(clk), .Q(\reg_mem[34][6] ) );
  DFFPOSX1 \reg_mem_reg[33][6]  ( .D(n797), .CLK(clk), .Q(\reg_mem[33][6] ) );
  DFFPOSX1 \reg_mem_reg[32][6]  ( .D(n798), .CLK(clk), .Q(\reg_mem[32][6] ) );
  DFFPOSX1 \reg_mem_reg[31][6]  ( .D(n799), .CLK(clk), .Q(\reg_mem[31][6] ) );
  DFFPOSX1 \reg_mem_reg[30][6]  ( .D(n800), .CLK(clk), .Q(\reg_mem[30][6] ) );
  DFFPOSX1 \reg_mem_reg[29][6]  ( .D(n801), .CLK(clk), .Q(\reg_mem[29][6] ) );
  DFFPOSX1 \reg_mem_reg[28][6]  ( .D(n802), .CLK(clk), .Q(\reg_mem[28][6] ) );
  DFFPOSX1 \reg_mem_reg[27][6]  ( .D(n803), .CLK(clk), .Q(\reg_mem[27][6] ) );
  DFFPOSX1 \reg_mem_reg[26][6]  ( .D(n804), .CLK(clk), .Q(\reg_mem[26][6] ) );
  DFFPOSX1 \reg_mem_reg[25][6]  ( .D(n805), .CLK(clk), .Q(\reg_mem[25][6] ) );
  DFFPOSX1 \reg_mem_reg[24][6]  ( .D(n806), .CLK(clk), .Q(\reg_mem[24][6] ) );
  DFFPOSX1 \reg_mem_reg[23][6]  ( .D(n807), .CLK(clk), .Q(\reg_mem[23][6] ) );
  DFFPOSX1 \reg_mem_reg[22][6]  ( .D(n808), .CLK(clk), .Q(\reg_mem[22][6] ) );
  DFFPOSX1 \reg_mem_reg[21][6]  ( .D(n809), .CLK(clk), .Q(\reg_mem[21][6] ) );
  DFFPOSX1 \reg_mem_reg[20][6]  ( .D(n810), .CLK(clk), .Q(\reg_mem[20][6] ) );
  DFFPOSX1 \reg_mem_reg[19][6]  ( .D(n811), .CLK(clk), .Q(\reg_mem[19][6] ) );
  DFFPOSX1 \reg_mem_reg[18][6]  ( .D(n812), .CLK(clk), .Q(\reg_mem[18][6] ) );
  DFFPOSX1 \reg_mem_reg[17][6]  ( .D(n813), .CLK(clk), .Q(\reg_mem[17][6] ) );
  DFFPOSX1 \reg_mem_reg[16][6]  ( .D(n814), .CLK(clk), .Q(\reg_mem[16][6] ) );
  DFFPOSX1 \reg_mem_reg[15][6]  ( .D(n815), .CLK(clk), .Q(\reg_mem[15][6] ) );
  DFFPOSX1 \reg_mem_reg[14][6]  ( .D(n816), .CLK(clk), .Q(\reg_mem[14][6] ) );
  DFFPOSX1 \reg_mem_reg[13][6]  ( .D(n817), .CLK(clk), .Q(\reg_mem[13][6] ) );
  DFFPOSX1 \reg_mem_reg[12][6]  ( .D(n818), .CLK(clk), .Q(\reg_mem[12][6] ) );
  DFFPOSX1 \reg_mem_reg[11][6]  ( .D(n819), .CLK(clk), .Q(\reg_mem[11][6] ) );
  DFFPOSX1 \reg_mem_reg[10][6]  ( .D(n820), .CLK(clk), .Q(\reg_mem[10][6] ) );
  DFFPOSX1 \reg_mem_reg[9][6]  ( .D(n821), .CLK(clk), .Q(\reg_mem[9][6] ) );
  DFFPOSX1 \reg_mem_reg[8][6]  ( .D(n822), .CLK(clk), .Q(\reg_mem[8][6] ) );
  DFFPOSX1 \reg_mem_reg[7][6]  ( .D(n823), .CLK(clk), .Q(\reg_mem[7][6] ) );
  DFFPOSX1 \reg_mem_reg[6][6]  ( .D(n824), .CLK(clk), .Q(\reg_mem[6][6] ) );
  DFFPOSX1 \reg_mem_reg[5][6]  ( .D(n825), .CLK(clk), .Q(\reg_mem[5][6] ) );
  DFFPOSX1 \reg_mem_reg[4][6]  ( .D(n826), .CLK(clk), .Q(\reg_mem[4][6] ) );
  DFFPOSX1 \reg_mem_reg[3][6]  ( .D(n827), .CLK(clk), .Q(\reg_mem[3][6] ) );
  DFFPOSX1 \reg_mem_reg[2][6]  ( .D(n828), .CLK(clk), .Q(\reg_mem[2][6] ) );
  DFFPOSX1 \reg_mem_reg[1][6]  ( .D(n829), .CLK(clk), .Q(\reg_mem[1][6] ) );
  DFFPOSX1 \reg_mem_reg[0][6]  ( .D(n830), .CLK(clk), .Q(\reg_mem[0][6] ) );
  DFFPOSX1 \reg_mem_reg[63][6]  ( .D(n831), .CLK(clk), .Q(\reg_mem[63][6] ) );
  DFFPOSX1 \reg_mem_reg[62][7]  ( .D(n704), .CLK(clk), .Q(\reg_mem[62][7] ) );
  DFFPOSX1 \reg_mem_reg[61][7]  ( .D(n705), .CLK(clk), .Q(\reg_mem[61][7] ) );
  DFFPOSX1 \reg_mem_reg[60][7]  ( .D(n706), .CLK(clk), .Q(\reg_mem[60][7] ) );
  DFFPOSX1 \reg_mem_reg[59][7]  ( .D(n707), .CLK(clk), .Q(\reg_mem[59][7] ) );
  DFFPOSX1 \reg_mem_reg[58][7]  ( .D(n708), .CLK(clk), .Q(\reg_mem[58][7] ) );
  DFFPOSX1 \reg_mem_reg[57][7]  ( .D(n709), .CLK(clk), .Q(\reg_mem[57][7] ) );
  DFFPOSX1 \reg_mem_reg[56][7]  ( .D(n710), .CLK(clk), .Q(\reg_mem[56][7] ) );
  DFFPOSX1 \reg_mem_reg[55][7]  ( .D(n711), .CLK(clk), .Q(\reg_mem[55][7] ) );
  DFFPOSX1 \reg_mem_reg[54][7]  ( .D(n712), .CLK(clk), .Q(\reg_mem[54][7] ) );
  DFFPOSX1 \reg_mem_reg[53][7]  ( .D(n713), .CLK(clk), .Q(\reg_mem[53][7] ) );
  DFFPOSX1 \reg_mem_reg[52][7]  ( .D(n714), .CLK(clk), .Q(\reg_mem[52][7] ) );
  DFFPOSX1 \reg_mem_reg[51][7]  ( .D(n715), .CLK(clk), .Q(\reg_mem[51][7] ) );
  DFFPOSX1 \reg_mem_reg[50][7]  ( .D(n716), .CLK(clk), .Q(\reg_mem[50][7] ) );
  DFFPOSX1 \reg_mem_reg[49][7]  ( .D(n717), .CLK(clk), .Q(\reg_mem[49][7] ) );
  DFFPOSX1 \reg_mem_reg[48][7]  ( .D(n718), .CLK(clk), .Q(\reg_mem[48][7] ) );
  DFFPOSX1 \reg_mem_reg[47][7]  ( .D(n719), .CLK(clk), .Q(\reg_mem[47][7] ) );
  DFFPOSX1 \reg_mem_reg[46][7]  ( .D(n720), .CLK(clk), .Q(\reg_mem[46][7] ) );
  DFFPOSX1 \reg_mem_reg[45][7]  ( .D(n721), .CLK(clk), .Q(\reg_mem[45][7] ) );
  DFFPOSX1 \reg_mem_reg[44][7]  ( .D(n722), .CLK(clk), .Q(\reg_mem[44][7] ) );
  DFFPOSX1 \reg_mem_reg[43][7]  ( .D(n723), .CLK(clk), .Q(\reg_mem[43][7] ) );
  DFFPOSX1 \reg_mem_reg[42][7]  ( .D(n724), .CLK(clk), .Q(\reg_mem[42][7] ) );
  DFFPOSX1 \reg_mem_reg[41][7]  ( .D(n725), .CLK(clk), .Q(\reg_mem[41][7] ) );
  DFFPOSX1 \reg_mem_reg[40][7]  ( .D(n726), .CLK(clk), .Q(\reg_mem[40][7] ) );
  DFFPOSX1 \reg_mem_reg[39][7]  ( .D(n727), .CLK(clk), .Q(\reg_mem[39][7] ) );
  DFFPOSX1 \reg_mem_reg[38][7]  ( .D(n728), .CLK(clk), .Q(\reg_mem[38][7] ) );
  DFFPOSX1 \reg_mem_reg[37][7]  ( .D(n729), .CLK(clk), .Q(\reg_mem[37][7] ) );
  DFFPOSX1 \reg_mem_reg[36][7]  ( .D(n730), .CLK(clk), .Q(\reg_mem[36][7] ) );
  DFFPOSX1 \reg_mem_reg[35][7]  ( .D(n731), .CLK(clk), .Q(\reg_mem[35][7] ) );
  DFFPOSX1 \reg_mem_reg[34][7]  ( .D(n732), .CLK(clk), .Q(\reg_mem[34][7] ) );
  DFFPOSX1 \reg_mem_reg[33][7]  ( .D(n733), .CLK(clk), .Q(\reg_mem[33][7] ) );
  DFFPOSX1 \reg_mem_reg[32][7]  ( .D(n734), .CLK(clk), .Q(\reg_mem[32][7] ) );
  DFFPOSX1 \reg_mem_reg[31][7]  ( .D(n735), .CLK(clk), .Q(\reg_mem[31][7] ) );
  DFFPOSX1 \reg_mem_reg[30][7]  ( .D(n736), .CLK(clk), .Q(\reg_mem[30][7] ) );
  DFFPOSX1 \reg_mem_reg[29][7]  ( .D(n737), .CLK(clk), .Q(\reg_mem[29][7] ) );
  DFFPOSX1 \reg_mem_reg[28][7]  ( .D(n738), .CLK(clk), .Q(\reg_mem[28][7] ) );
  DFFPOSX1 \reg_mem_reg[27][7]  ( .D(n739), .CLK(clk), .Q(\reg_mem[27][7] ) );
  DFFPOSX1 \reg_mem_reg[26][7]  ( .D(n740), .CLK(clk), .Q(\reg_mem[26][7] ) );
  DFFPOSX1 \reg_mem_reg[25][7]  ( .D(n741), .CLK(clk), .Q(\reg_mem[25][7] ) );
  DFFPOSX1 \reg_mem_reg[24][7]  ( .D(n742), .CLK(clk), .Q(\reg_mem[24][7] ) );
  DFFPOSX1 \reg_mem_reg[23][7]  ( .D(n743), .CLK(clk), .Q(\reg_mem[23][7] ) );
  DFFPOSX1 \reg_mem_reg[22][7]  ( .D(n744), .CLK(clk), .Q(\reg_mem[22][7] ) );
  DFFPOSX1 \reg_mem_reg[21][7]  ( .D(n745), .CLK(clk), .Q(\reg_mem[21][7] ) );
  DFFPOSX1 \reg_mem_reg[20][7]  ( .D(n746), .CLK(clk), .Q(\reg_mem[20][7] ) );
  DFFPOSX1 \reg_mem_reg[19][7]  ( .D(n747), .CLK(clk), .Q(\reg_mem[19][7] ) );
  DFFPOSX1 \reg_mem_reg[18][7]  ( .D(n748), .CLK(clk), .Q(\reg_mem[18][7] ) );
  DFFPOSX1 \reg_mem_reg[17][7]  ( .D(n749), .CLK(clk), .Q(\reg_mem[17][7] ) );
  DFFPOSX1 \reg_mem_reg[16][7]  ( .D(n750), .CLK(clk), .Q(\reg_mem[16][7] ) );
  DFFPOSX1 \reg_mem_reg[15][7]  ( .D(n751), .CLK(clk), .Q(\reg_mem[15][7] ) );
  DFFPOSX1 \reg_mem_reg[14][7]  ( .D(n752), .CLK(clk), .Q(\reg_mem[14][7] ) );
  DFFPOSX1 \reg_mem_reg[13][7]  ( .D(n753), .CLK(clk), .Q(\reg_mem[13][7] ) );
  DFFPOSX1 \reg_mem_reg[12][7]  ( .D(n754), .CLK(clk), .Q(\reg_mem[12][7] ) );
  DFFPOSX1 \reg_mem_reg[11][7]  ( .D(n755), .CLK(clk), .Q(\reg_mem[11][7] ) );
  DFFPOSX1 \reg_mem_reg[10][7]  ( .D(n756), .CLK(clk), .Q(\reg_mem[10][7] ) );
  DFFPOSX1 \reg_mem_reg[9][7]  ( .D(n757), .CLK(clk), .Q(\reg_mem[9][7] ) );
  DFFPOSX1 \reg_mem_reg[8][7]  ( .D(n758), .CLK(clk), .Q(\reg_mem[8][7] ) );
  DFFPOSX1 \reg_mem_reg[7][7]  ( .D(n759), .CLK(clk), .Q(\reg_mem[7][7] ) );
  DFFPOSX1 \reg_mem_reg[6][7]  ( .D(n760), .CLK(clk), .Q(\reg_mem[6][7] ) );
  DFFPOSX1 \reg_mem_reg[5][7]  ( .D(n761), .CLK(clk), .Q(\reg_mem[5][7] ) );
  DFFPOSX1 \reg_mem_reg[4][7]  ( .D(n762), .CLK(clk), .Q(\reg_mem[4][7] ) );
  DFFPOSX1 \reg_mem_reg[3][7]  ( .D(n763), .CLK(clk), .Q(\reg_mem[3][7] ) );
  DFFPOSX1 \reg_mem_reg[2][7]  ( .D(n764), .CLK(clk), .Q(\reg_mem[2][7] ) );
  DFFPOSX1 \reg_mem_reg[1][7]  ( .D(n765), .CLK(clk), .Q(\reg_mem[1][7] ) );
  DFFPOSX1 \reg_mem_reg[0][7]  ( .D(n766), .CLK(clk), .Q(\reg_mem[0][7] ) );
  DFFPOSX1 \reg_mem_reg[63][7]  ( .D(n767), .CLK(clk), .Q(\reg_mem[63][7] ) );
  data_buffer_DW01_inc_1 add_46 ( .A(buffer_occupancy), .SUM({N42, N41, N40, 
        N39, N38, N37, N36}) );
  AND2X2 U1243 ( .A(n1263), .B(n1838), .Y(n1228) );
  AND2X2 U1244 ( .A(n1267), .B(N19), .Y(n1229) );
  AND2X2 U1245 ( .A(n1263), .B(N19), .Y(n1230) );
  AND2X2 U1246 ( .A(n1267), .B(n1838), .Y(n1231) );
  AND2X2 U1247 ( .A(n1262), .B(N19), .Y(n1232) );
  AND2X2 U1248 ( .A(n1266), .B(n1838), .Y(n1233) );
  AND2X2 U1249 ( .A(N19), .B(n1266), .Y(n1234) );
  AND2X2 U1250 ( .A(n1262), .B(n1838), .Y(n1235) );
  INVX4 U1251 ( .A(n1228), .Y(n1236) );
  INVX1 U1252 ( .A(n1951), .Y(n1237) );
  INVX8 U1253 ( .A(n1237), .Y(n1238) );
  INVX1 U1254 ( .A(n2042), .Y(n1239) );
  INVX8 U1255 ( .A(n1239), .Y(n1240) );
  INVX1 U1256 ( .A(n2107), .Y(n1241) );
  INVX8 U1257 ( .A(n1241), .Y(n1242) );
  INVX1 U1258 ( .A(n2172), .Y(n1243) );
  INVX8 U1259 ( .A(n1243), .Y(n1244) );
  INVX1 U1260 ( .A(n2282), .Y(n1245) );
  INVX8 U1261 ( .A(n1245), .Y(n1246) );
  INVX1 U1262 ( .A(n2347), .Y(n1247) );
  INVX8 U1263 ( .A(n1247), .Y(n1248) );
  INVX1 U1264 ( .A(n2412), .Y(n1249) );
  INVX8 U1265 ( .A(n1249), .Y(n1250) );
  INVX1 U1266 ( .A(n1870), .Y(n1251) );
  INVX8 U1267 ( .A(n1251), .Y(n1252) );
  INVX8 U1268 ( .A(n1235), .Y(n1253) );
  INVX8 U1269 ( .A(n1234), .Y(n1254) );
  INVX8 U1270 ( .A(n1232), .Y(n1255) );
  INVX8 U1271 ( .A(n1233), .Y(n1256) );
  INVX8 U1272 ( .A(n1230), .Y(n1257) );
  INVX8 U1273 ( .A(n1229), .Y(n1258) );
  INVX8 U1274 ( .A(n1231), .Y(n1259) );
  INVX1 U1275 ( .A(n1788), .Y(n1835) );
  INVX1 U1276 ( .A(n1796), .Y(n1832) );
  NOR2X1 U1277 ( .A(n1837), .B(N21), .Y(n1262) );
  NOR2X1 U1278 ( .A(N20), .B(N21), .Y(n1263) );
  OAI22X1 U1279 ( .A(\reg_mem[35][0] ), .B(n1255), .C(\reg_mem[33][0] ), .D(
        n1257), .Y(n1261) );
  AND2X1 U1280 ( .A(N21), .B(N20), .Y(n1266) );
  AND2X1 U1281 ( .A(N21), .B(n1837), .Y(n1267) );
  OAI22X1 U1282 ( .A(\reg_mem[39][0] ), .B(n1254), .C(\reg_mem[37][0] ), .D(
        n1258), .Y(n1260) );
  NOR2X1 U1283 ( .A(n1261), .B(n1260), .Y(n1279) );
  NAND2X1 U1284 ( .A(N24), .B(n2252), .Y(n1788) );
  NOR2X1 U1285 ( .A(\reg_mem[32][0] ), .B(n1236), .Y(n1264) );
  NOR2X1 U1286 ( .A(n1788), .B(n1264), .Y(n1265) );
  OAI21X1 U1287 ( .A(\reg_mem[34][0] ), .B(n1253), .C(n1265), .Y(n1269) );
  OAI22X1 U1288 ( .A(\reg_mem[38][0] ), .B(n1256), .C(\reg_mem[36][0] ), .D(
        n1259), .Y(n1268) );
  NOR2X1 U1289 ( .A(n1269), .B(n1268), .Y(n1278) );
  OAI22X1 U1290 ( .A(\reg_mem[51][0] ), .B(n1255), .C(\reg_mem[49][0] ), .D(
        n1257), .Y(n1271) );
  OAI22X1 U1291 ( .A(\reg_mem[55][0] ), .B(n1254), .C(\reg_mem[53][0] ), .D(
        n1258), .Y(n1270) );
  NOR2X1 U1292 ( .A(n1271), .B(n1270), .Y(n1277) );
  NAND2X1 U1293 ( .A(N24), .B(N23), .Y(n1796) );
  NOR2X1 U1294 ( .A(\reg_mem[48][0] ), .B(n1236), .Y(n1272) );
  NOR2X1 U1295 ( .A(n1796), .B(n1272), .Y(n1273) );
  OAI21X1 U1296 ( .A(\reg_mem[50][0] ), .B(n1253), .C(n1273), .Y(n1275) );
  OAI22X1 U1297 ( .A(\reg_mem[54][0] ), .B(n1256), .C(\reg_mem[52][0] ), .D(
        n1259), .Y(n1274) );
  NOR2X1 U1298 ( .A(n1275), .B(n1274), .Y(n1276) );
  AOI22X1 U1299 ( .A(n1279), .B(n1278), .C(n1277), .D(n1276), .Y(n1297) );
  OAI22X1 U1300 ( .A(\reg_mem[3][0] ), .B(n1255), .C(\reg_mem[1][0] ), .D(
        n1257), .Y(n1281) );
  OAI22X1 U1301 ( .A(\reg_mem[7][0] ), .B(n1254), .C(\reg_mem[5][0] ), .D(
        n1258), .Y(n1280) );
  NOR2X1 U1302 ( .A(n1281), .B(n1280), .Y(n1295) );
  NOR2X1 U1303 ( .A(N23), .B(N24), .Y(n1808) );
  NOR2X1 U1304 ( .A(\reg_mem[0][0] ), .B(n1236), .Y(n1282) );
  NOR2X1 U1305 ( .A(n1833), .B(n1282), .Y(n1283) );
  OAI21X1 U1306 ( .A(\reg_mem[2][0] ), .B(n1253), .C(n1283), .Y(n1285) );
  OAI22X1 U1307 ( .A(\reg_mem[6][0] ), .B(n1256), .C(\reg_mem[4][0] ), .D(
        n1259), .Y(n1284) );
  NOR2X1 U1308 ( .A(n1285), .B(n1284), .Y(n1294) );
  OAI22X1 U1309 ( .A(\reg_mem[19][0] ), .B(n1255), .C(\reg_mem[17][0] ), .D(
        n1257), .Y(n1287) );
  OAI22X1 U1310 ( .A(\reg_mem[23][0] ), .B(n1254), .C(\reg_mem[21][0] ), .D(
        n1258), .Y(n1286) );
  NOR2X1 U1311 ( .A(n1287), .B(n1286), .Y(n1293) );
  NOR2X1 U1312 ( .A(n2252), .B(N24), .Y(n1816) );
  NOR2X1 U1313 ( .A(\reg_mem[16][0] ), .B(n1236), .Y(n1288) );
  NOR2X1 U1314 ( .A(n1834), .B(n1288), .Y(n1289) );
  OAI21X1 U1315 ( .A(\reg_mem[18][0] ), .B(n1253), .C(n1289), .Y(n1291) );
  OAI22X1 U1316 ( .A(\reg_mem[22][0] ), .B(n1256), .C(\reg_mem[20][0] ), .D(
        n1259), .Y(n1290) );
  NOR2X1 U1317 ( .A(n1291), .B(n1290), .Y(n1292) );
  AOI22X1 U1318 ( .A(n1295), .B(n1294), .C(n1293), .D(n1292), .Y(n1296) );
  AOI21X1 U1319 ( .A(n1297), .B(n1296), .C(N22), .Y(n1333) );
  OAI22X1 U1320 ( .A(\reg_mem[43][0] ), .B(n1255), .C(\reg_mem[41][0] ), .D(
        n1257), .Y(n1299) );
  OAI22X1 U1321 ( .A(\reg_mem[47][0] ), .B(n1254), .C(\reg_mem[45][0] ), .D(
        n1258), .Y(n1298) );
  NOR2X1 U1322 ( .A(n1299), .B(n1298), .Y(n1313) );
  NOR2X1 U1323 ( .A(\reg_mem[40][0] ), .B(n1236), .Y(n1300) );
  NOR2X1 U1324 ( .A(n1788), .B(n1300), .Y(n1301) );
  OAI21X1 U1325 ( .A(\reg_mem[42][0] ), .B(n1253), .C(n1301), .Y(n1303) );
  OAI22X1 U1326 ( .A(\reg_mem[46][0] ), .B(n1256), .C(\reg_mem[44][0] ), .D(
        n1259), .Y(n1302) );
  NOR2X1 U1327 ( .A(n1303), .B(n1302), .Y(n1312) );
  OAI22X1 U1328 ( .A(\reg_mem[59][0] ), .B(n1255), .C(\reg_mem[57][0] ), .D(
        n1257), .Y(n1305) );
  OAI22X1 U1329 ( .A(\reg_mem[63][0] ), .B(n1254), .C(\reg_mem[61][0] ), .D(
        n1258), .Y(n1304) );
  NOR2X1 U1330 ( .A(n1305), .B(n1304), .Y(n1311) );
  NOR2X1 U1331 ( .A(\reg_mem[56][0] ), .B(n1236), .Y(n1306) );
  NOR2X1 U1332 ( .A(n1796), .B(n1306), .Y(n1307) );
  OAI21X1 U1333 ( .A(\reg_mem[58][0] ), .B(n1253), .C(n1307), .Y(n1309) );
  OAI22X1 U1334 ( .A(\reg_mem[62][0] ), .B(n1256), .C(\reg_mem[60][0] ), .D(
        n1259), .Y(n1308) );
  NOR2X1 U1335 ( .A(n1309), .B(n1308), .Y(n1310) );
  AOI22X1 U1336 ( .A(n1313), .B(n1312), .C(n1311), .D(n1310), .Y(n1331) );
  OAI22X1 U1337 ( .A(\reg_mem[11][0] ), .B(n1255), .C(\reg_mem[9][0] ), .D(
        n1257), .Y(n1315) );
  OAI22X1 U1338 ( .A(\reg_mem[15][0] ), .B(n1254), .C(\reg_mem[13][0] ), .D(
        n1258), .Y(n1314) );
  NOR2X1 U1339 ( .A(n1315), .B(n1314), .Y(n1329) );
  NOR2X1 U1340 ( .A(\reg_mem[8][0] ), .B(n1236), .Y(n1316) );
  NOR2X1 U1341 ( .A(n1833), .B(n1316), .Y(n1317) );
  OAI21X1 U1342 ( .A(\reg_mem[10][0] ), .B(n1253), .C(n1317), .Y(n1319) );
  OAI22X1 U1343 ( .A(\reg_mem[14][0] ), .B(n1256), .C(\reg_mem[12][0] ), .D(
        n1259), .Y(n1318) );
  NOR2X1 U1344 ( .A(n1319), .B(n1318), .Y(n1328) );
  OAI22X1 U1345 ( .A(\reg_mem[27][0] ), .B(n1255), .C(\reg_mem[25][0] ), .D(
        n1257), .Y(n1321) );
  OAI22X1 U1346 ( .A(\reg_mem[31][0] ), .B(n1254), .C(\reg_mem[29][0] ), .D(
        n1258), .Y(n1320) );
  NOR2X1 U1347 ( .A(n1321), .B(n1320), .Y(n1327) );
  NOR2X1 U1348 ( .A(\reg_mem[24][0] ), .B(n1236), .Y(n1322) );
  NOR2X1 U1349 ( .A(n1834), .B(n1322), .Y(n1323) );
  OAI21X1 U1350 ( .A(\reg_mem[26][0] ), .B(n1253), .C(n1323), .Y(n1325) );
  OAI22X1 U1351 ( .A(\reg_mem[30][0] ), .B(n1256), .C(\reg_mem[28][0] ), .D(
        n1259), .Y(n1324) );
  NOR2X1 U1352 ( .A(n1325), .B(n1324), .Y(n1326) );
  AOI22X1 U1353 ( .A(n1329), .B(n1328), .C(n1327), .D(n1326), .Y(n1330) );
  AOI21X1 U1354 ( .A(n1331), .B(n1330), .C(n1836), .Y(n1332) );
  OR2X1 U1355 ( .A(n1333), .B(n1332), .Y(tx_packet_data[0]) );
  OAI22X1 U1356 ( .A(\reg_mem[35][1] ), .B(n1255), .C(\reg_mem[33][1] ), .D(
        n1257), .Y(n1335) );
  OAI22X1 U1357 ( .A(\reg_mem[39][1] ), .B(n1254), .C(\reg_mem[37][1] ), .D(
        n1258), .Y(n1334) );
  NOR2X1 U1358 ( .A(n1335), .B(n1334), .Y(n1349) );
  NOR2X1 U1359 ( .A(\reg_mem[32][1] ), .B(n1236), .Y(n1336) );
  NOR2X1 U1360 ( .A(n1788), .B(n1336), .Y(n1337) );
  OAI21X1 U1361 ( .A(\reg_mem[34][1] ), .B(n1253), .C(n1337), .Y(n1339) );
  OAI22X1 U1362 ( .A(\reg_mem[38][1] ), .B(n1256), .C(\reg_mem[36][1] ), .D(
        n1259), .Y(n1338) );
  NOR2X1 U1363 ( .A(n1339), .B(n1338), .Y(n1348) );
  OAI22X1 U1364 ( .A(\reg_mem[51][1] ), .B(n1255), .C(\reg_mem[49][1] ), .D(
        n1257), .Y(n1341) );
  OAI22X1 U1365 ( .A(\reg_mem[55][1] ), .B(n1254), .C(\reg_mem[53][1] ), .D(
        n1258), .Y(n1340) );
  NOR2X1 U1366 ( .A(n1341), .B(n1340), .Y(n1347) );
  NOR2X1 U1367 ( .A(\reg_mem[48][1] ), .B(n1236), .Y(n1342) );
  NOR2X1 U1368 ( .A(n1796), .B(n1342), .Y(n1343) );
  OAI21X1 U1369 ( .A(\reg_mem[50][1] ), .B(n1253), .C(n1343), .Y(n1345) );
  OAI22X1 U1370 ( .A(\reg_mem[54][1] ), .B(n1256), .C(\reg_mem[52][1] ), .D(
        n1259), .Y(n1344) );
  NOR2X1 U1371 ( .A(n1345), .B(n1344), .Y(n1346) );
  AOI22X1 U1372 ( .A(n1349), .B(n1348), .C(n1347), .D(n1346), .Y(n1367) );
  OAI22X1 U1373 ( .A(\reg_mem[3][1] ), .B(n1255), .C(\reg_mem[1][1] ), .D(
        n1257), .Y(n1351) );
  OAI22X1 U1374 ( .A(\reg_mem[7][1] ), .B(n1254), .C(\reg_mem[5][1] ), .D(
        n1258), .Y(n1350) );
  NOR2X1 U1375 ( .A(n1351), .B(n1350), .Y(n1365) );
  NOR2X1 U1376 ( .A(\reg_mem[0][1] ), .B(n1236), .Y(n1352) );
  NOR2X1 U1377 ( .A(n1833), .B(n1352), .Y(n1353) );
  OAI21X1 U1378 ( .A(\reg_mem[2][1] ), .B(n1253), .C(n1353), .Y(n1355) );
  OAI22X1 U1379 ( .A(\reg_mem[6][1] ), .B(n1256), .C(\reg_mem[4][1] ), .D(
        n1259), .Y(n1354) );
  NOR2X1 U1380 ( .A(n1355), .B(n1354), .Y(n1364) );
  OAI22X1 U1381 ( .A(\reg_mem[19][1] ), .B(n1255), .C(\reg_mem[17][1] ), .D(
        n1257), .Y(n1357) );
  OAI22X1 U1382 ( .A(\reg_mem[23][1] ), .B(n1254), .C(\reg_mem[21][1] ), .D(
        n1258), .Y(n1356) );
  NOR2X1 U1383 ( .A(n1357), .B(n1356), .Y(n1363) );
  NOR2X1 U1384 ( .A(\reg_mem[16][1] ), .B(n1236), .Y(n1358) );
  NOR2X1 U1385 ( .A(n1834), .B(n1358), .Y(n1359) );
  OAI21X1 U1386 ( .A(\reg_mem[18][1] ), .B(n1253), .C(n1359), .Y(n1361) );
  OAI22X1 U1387 ( .A(\reg_mem[22][1] ), .B(n1256), .C(\reg_mem[20][1] ), .D(
        n1259), .Y(n1360) );
  NOR2X1 U1388 ( .A(n1361), .B(n1360), .Y(n1362) );
  AOI22X1 U1389 ( .A(n1365), .B(n1364), .C(n1363), .D(n1362), .Y(n1366) );
  AOI21X1 U1390 ( .A(n1367), .B(n1366), .C(N22), .Y(n1403) );
  OAI22X1 U1391 ( .A(\reg_mem[43][1] ), .B(n1255), .C(\reg_mem[41][1] ), .D(
        n1257), .Y(n1369) );
  OAI22X1 U1392 ( .A(\reg_mem[47][1] ), .B(n1254), .C(\reg_mem[45][1] ), .D(
        n1258), .Y(n1368) );
  NOR2X1 U1393 ( .A(n1369), .B(n1368), .Y(n1383) );
  NOR2X1 U1394 ( .A(\reg_mem[40][1] ), .B(n1236), .Y(n1370) );
  NOR2X1 U1395 ( .A(n1788), .B(n1370), .Y(n1371) );
  OAI21X1 U1396 ( .A(\reg_mem[42][1] ), .B(n1253), .C(n1371), .Y(n1373) );
  OAI22X1 U1397 ( .A(\reg_mem[46][1] ), .B(n1256), .C(\reg_mem[44][1] ), .D(
        n1259), .Y(n1372) );
  NOR2X1 U1398 ( .A(n1373), .B(n1372), .Y(n1382) );
  OAI22X1 U1399 ( .A(\reg_mem[59][1] ), .B(n1255), .C(\reg_mem[57][1] ), .D(
        n1257), .Y(n1375) );
  OAI22X1 U1400 ( .A(\reg_mem[63][1] ), .B(n1254), .C(\reg_mem[61][1] ), .D(
        n1258), .Y(n1374) );
  NOR2X1 U1401 ( .A(n1375), .B(n1374), .Y(n1381) );
  NOR2X1 U1402 ( .A(\reg_mem[56][1] ), .B(n1236), .Y(n1376) );
  NOR2X1 U1403 ( .A(n1796), .B(n1376), .Y(n1377) );
  OAI21X1 U1404 ( .A(\reg_mem[58][1] ), .B(n1253), .C(n1377), .Y(n1379) );
  OAI22X1 U1405 ( .A(\reg_mem[62][1] ), .B(n1256), .C(\reg_mem[60][1] ), .D(
        n1259), .Y(n1378) );
  NOR2X1 U1406 ( .A(n1379), .B(n1378), .Y(n1380) );
  AOI22X1 U1407 ( .A(n1383), .B(n1382), .C(n1381), .D(n1380), .Y(n1401) );
  OAI22X1 U1408 ( .A(\reg_mem[11][1] ), .B(n1255), .C(\reg_mem[9][1] ), .D(
        n1257), .Y(n1385) );
  OAI22X1 U1409 ( .A(\reg_mem[15][1] ), .B(n1254), .C(\reg_mem[13][1] ), .D(
        n1258), .Y(n1384) );
  NOR2X1 U1410 ( .A(n1385), .B(n1384), .Y(n1399) );
  NOR2X1 U1411 ( .A(\reg_mem[8][1] ), .B(n1236), .Y(n1386) );
  NOR2X1 U1412 ( .A(n1833), .B(n1386), .Y(n1387) );
  OAI21X1 U1413 ( .A(\reg_mem[10][1] ), .B(n1253), .C(n1387), .Y(n1389) );
  OAI22X1 U1414 ( .A(\reg_mem[14][1] ), .B(n1256), .C(\reg_mem[12][1] ), .D(
        n1259), .Y(n1388) );
  NOR2X1 U1415 ( .A(n1389), .B(n1388), .Y(n1398) );
  OAI22X1 U1416 ( .A(\reg_mem[27][1] ), .B(n1255), .C(\reg_mem[25][1] ), .D(
        n1257), .Y(n1391) );
  OAI22X1 U1417 ( .A(\reg_mem[31][1] ), .B(n1254), .C(\reg_mem[29][1] ), .D(
        n1258), .Y(n1390) );
  NOR2X1 U1418 ( .A(n1391), .B(n1390), .Y(n1397) );
  NOR2X1 U1419 ( .A(\reg_mem[24][1] ), .B(n1236), .Y(n1392) );
  NOR2X1 U1420 ( .A(n1834), .B(n1392), .Y(n1393) );
  OAI21X1 U1421 ( .A(\reg_mem[26][1] ), .B(n1253), .C(n1393), .Y(n1395) );
  OAI22X1 U1422 ( .A(\reg_mem[30][1] ), .B(n1256), .C(\reg_mem[28][1] ), .D(
        n1259), .Y(n1394) );
  NOR2X1 U1423 ( .A(n1395), .B(n1394), .Y(n1396) );
  AOI22X1 U1424 ( .A(n1399), .B(n1398), .C(n1397), .D(n1396), .Y(n1400) );
  AOI21X1 U1425 ( .A(n1401), .B(n1400), .C(n1836), .Y(n1402) );
  OR2X1 U1426 ( .A(n1403), .B(n1402), .Y(tx_packet_data[1]) );
  OAI22X1 U1427 ( .A(\reg_mem[35][2] ), .B(n1255), .C(\reg_mem[33][2] ), .D(
        n1257), .Y(n1405) );
  OAI22X1 U1428 ( .A(\reg_mem[39][2] ), .B(n1254), .C(\reg_mem[37][2] ), .D(
        n1258), .Y(n1404) );
  NOR2X1 U1429 ( .A(n1405), .B(n1404), .Y(n1419) );
  NOR2X1 U1430 ( .A(\reg_mem[32][2] ), .B(n1236), .Y(n1406) );
  NOR2X1 U1431 ( .A(n1788), .B(n1406), .Y(n1407) );
  OAI21X1 U1432 ( .A(\reg_mem[34][2] ), .B(n1253), .C(n1407), .Y(n1409) );
  OAI22X1 U1433 ( .A(\reg_mem[38][2] ), .B(n1256), .C(\reg_mem[36][2] ), .D(
        n1259), .Y(n1408) );
  NOR2X1 U1434 ( .A(n1409), .B(n1408), .Y(n1418) );
  OAI22X1 U1435 ( .A(\reg_mem[51][2] ), .B(n1255), .C(\reg_mem[49][2] ), .D(
        n1257), .Y(n1411) );
  OAI22X1 U1436 ( .A(\reg_mem[55][2] ), .B(n1254), .C(\reg_mem[53][2] ), .D(
        n1258), .Y(n1410) );
  NOR2X1 U1437 ( .A(n1411), .B(n1410), .Y(n1417) );
  NOR2X1 U1438 ( .A(\reg_mem[48][2] ), .B(n1236), .Y(n1412) );
  NOR2X1 U1439 ( .A(n1796), .B(n1412), .Y(n1413) );
  OAI21X1 U1440 ( .A(\reg_mem[50][2] ), .B(n1253), .C(n1413), .Y(n1415) );
  OAI22X1 U1441 ( .A(\reg_mem[54][2] ), .B(n1256), .C(\reg_mem[52][2] ), .D(
        n1259), .Y(n1414) );
  NOR2X1 U1442 ( .A(n1415), .B(n1414), .Y(n1416) );
  AOI22X1 U1443 ( .A(n1419), .B(n1418), .C(n1417), .D(n1416), .Y(n1437) );
  OAI22X1 U1444 ( .A(\reg_mem[3][2] ), .B(n1255), .C(\reg_mem[1][2] ), .D(
        n1257), .Y(n1421) );
  OAI22X1 U1445 ( .A(\reg_mem[7][2] ), .B(n1254), .C(\reg_mem[5][2] ), .D(
        n1258), .Y(n1420) );
  NOR2X1 U1446 ( .A(n1421), .B(n1420), .Y(n1435) );
  NOR2X1 U1447 ( .A(\reg_mem[0][2] ), .B(n1236), .Y(n1422) );
  NOR2X1 U1448 ( .A(n1833), .B(n1422), .Y(n1423) );
  OAI21X1 U1449 ( .A(\reg_mem[2][2] ), .B(n1253), .C(n1423), .Y(n1425) );
  OAI22X1 U1450 ( .A(\reg_mem[6][2] ), .B(n1256), .C(\reg_mem[4][2] ), .D(
        n1259), .Y(n1424) );
  NOR2X1 U1451 ( .A(n1425), .B(n1424), .Y(n1434) );
  OAI22X1 U1452 ( .A(\reg_mem[19][2] ), .B(n1255), .C(\reg_mem[17][2] ), .D(
        n1257), .Y(n1427) );
  OAI22X1 U1453 ( .A(\reg_mem[23][2] ), .B(n1254), .C(\reg_mem[21][2] ), .D(
        n1258), .Y(n1426) );
  NOR2X1 U1454 ( .A(n1427), .B(n1426), .Y(n1433) );
  NOR2X1 U1455 ( .A(\reg_mem[16][2] ), .B(n1236), .Y(n1428) );
  NOR2X1 U1456 ( .A(n1834), .B(n1428), .Y(n1429) );
  OAI21X1 U1457 ( .A(\reg_mem[18][2] ), .B(n1253), .C(n1429), .Y(n1431) );
  OAI22X1 U1458 ( .A(\reg_mem[22][2] ), .B(n1256), .C(\reg_mem[20][2] ), .D(
        n1259), .Y(n1430) );
  NOR2X1 U1459 ( .A(n1431), .B(n1430), .Y(n1432) );
  AOI22X1 U1460 ( .A(n1435), .B(n1434), .C(n1433), .D(n1432), .Y(n1436) );
  AOI21X1 U1461 ( .A(n1437), .B(n1436), .C(N22), .Y(n1473) );
  OAI22X1 U1462 ( .A(\reg_mem[43][2] ), .B(n1255), .C(\reg_mem[41][2] ), .D(
        n1257), .Y(n1439) );
  OAI22X1 U1463 ( .A(\reg_mem[47][2] ), .B(n1254), .C(\reg_mem[45][2] ), .D(
        n1258), .Y(n1438) );
  NOR2X1 U1464 ( .A(n1439), .B(n1438), .Y(n1453) );
  NOR2X1 U1465 ( .A(\reg_mem[40][2] ), .B(n1236), .Y(n1440) );
  NOR2X1 U1466 ( .A(n1788), .B(n1440), .Y(n1441) );
  OAI21X1 U1467 ( .A(\reg_mem[42][2] ), .B(n1253), .C(n1441), .Y(n1443) );
  OAI22X1 U1468 ( .A(\reg_mem[46][2] ), .B(n1256), .C(\reg_mem[44][2] ), .D(
        n1259), .Y(n1442) );
  NOR2X1 U1469 ( .A(n1443), .B(n1442), .Y(n1452) );
  OAI22X1 U1470 ( .A(\reg_mem[59][2] ), .B(n1255), .C(\reg_mem[57][2] ), .D(
        n1257), .Y(n1445) );
  OAI22X1 U1471 ( .A(\reg_mem[63][2] ), .B(n1254), .C(\reg_mem[61][2] ), .D(
        n1258), .Y(n1444) );
  NOR2X1 U1472 ( .A(n1445), .B(n1444), .Y(n1451) );
  NOR2X1 U1473 ( .A(\reg_mem[56][2] ), .B(n1236), .Y(n1446) );
  NOR2X1 U1474 ( .A(n1796), .B(n1446), .Y(n1447) );
  OAI21X1 U1475 ( .A(\reg_mem[58][2] ), .B(n1253), .C(n1447), .Y(n1449) );
  OAI22X1 U1476 ( .A(\reg_mem[62][2] ), .B(n1256), .C(\reg_mem[60][2] ), .D(
        n1259), .Y(n1448) );
  NOR2X1 U1477 ( .A(n1449), .B(n1448), .Y(n1450) );
  AOI22X1 U1478 ( .A(n1453), .B(n1452), .C(n1451), .D(n1450), .Y(n1471) );
  OAI22X1 U1479 ( .A(\reg_mem[11][2] ), .B(n1255), .C(\reg_mem[9][2] ), .D(
        n1257), .Y(n1455) );
  OAI22X1 U1480 ( .A(\reg_mem[15][2] ), .B(n1254), .C(\reg_mem[13][2] ), .D(
        n1258), .Y(n1454) );
  NOR2X1 U1481 ( .A(n1455), .B(n1454), .Y(n1469) );
  NOR2X1 U1482 ( .A(\reg_mem[8][2] ), .B(n1236), .Y(n1456) );
  NOR2X1 U1483 ( .A(n1833), .B(n1456), .Y(n1457) );
  OAI21X1 U1484 ( .A(\reg_mem[10][2] ), .B(n1253), .C(n1457), .Y(n1459) );
  OAI22X1 U1485 ( .A(\reg_mem[14][2] ), .B(n1256), .C(\reg_mem[12][2] ), .D(
        n1259), .Y(n1458) );
  NOR2X1 U1486 ( .A(n1459), .B(n1458), .Y(n1468) );
  OAI22X1 U1487 ( .A(\reg_mem[27][2] ), .B(n1255), .C(\reg_mem[25][2] ), .D(
        n1257), .Y(n1461) );
  OAI22X1 U1488 ( .A(\reg_mem[31][2] ), .B(n1254), .C(\reg_mem[29][2] ), .D(
        n1258), .Y(n1460) );
  NOR2X1 U1489 ( .A(n1461), .B(n1460), .Y(n1467) );
  NOR2X1 U1490 ( .A(\reg_mem[24][2] ), .B(n1236), .Y(n1462) );
  NOR2X1 U1491 ( .A(n1834), .B(n1462), .Y(n1463) );
  OAI21X1 U1492 ( .A(\reg_mem[26][2] ), .B(n1253), .C(n1463), .Y(n1465) );
  OAI22X1 U1493 ( .A(\reg_mem[30][2] ), .B(n1256), .C(\reg_mem[28][2] ), .D(
        n1259), .Y(n1464) );
  NOR2X1 U1494 ( .A(n1465), .B(n1464), .Y(n1466) );
  AOI22X1 U1495 ( .A(n1469), .B(n1468), .C(n1467), .D(n1466), .Y(n1470) );
  AOI21X1 U1496 ( .A(n1471), .B(n1470), .C(n1836), .Y(n1472) );
  OR2X1 U1497 ( .A(n1473), .B(n1472), .Y(tx_packet_data[2]) );
  OAI22X1 U1498 ( .A(\reg_mem[35][3] ), .B(n1255), .C(\reg_mem[33][3] ), .D(
        n1257), .Y(n1475) );
  OAI22X1 U1499 ( .A(\reg_mem[39][3] ), .B(n1254), .C(\reg_mem[37][3] ), .D(
        n1258), .Y(n1474) );
  NOR2X1 U1500 ( .A(n1475), .B(n1474), .Y(n1489) );
  NOR2X1 U1501 ( .A(\reg_mem[32][3] ), .B(n1236), .Y(n1476) );
  NOR2X1 U1502 ( .A(n1788), .B(n1476), .Y(n1477) );
  OAI21X1 U1503 ( .A(\reg_mem[34][3] ), .B(n1253), .C(n1477), .Y(n1479) );
  OAI22X1 U1504 ( .A(\reg_mem[38][3] ), .B(n1256), .C(\reg_mem[36][3] ), .D(
        n1259), .Y(n1478) );
  NOR2X1 U1505 ( .A(n1479), .B(n1478), .Y(n1488) );
  OAI22X1 U1506 ( .A(\reg_mem[51][3] ), .B(n1255), .C(\reg_mem[49][3] ), .D(
        n1257), .Y(n1481) );
  OAI22X1 U1507 ( .A(\reg_mem[55][3] ), .B(n1254), .C(\reg_mem[53][3] ), .D(
        n1258), .Y(n1480) );
  NOR2X1 U1508 ( .A(n1481), .B(n1480), .Y(n1487) );
  NOR2X1 U1509 ( .A(\reg_mem[48][3] ), .B(n1236), .Y(n1482) );
  NOR2X1 U1510 ( .A(n1796), .B(n1482), .Y(n1483) );
  OAI21X1 U1511 ( .A(\reg_mem[50][3] ), .B(n1253), .C(n1483), .Y(n1485) );
  OAI22X1 U1512 ( .A(\reg_mem[54][3] ), .B(n1256), .C(\reg_mem[52][3] ), .D(
        n1259), .Y(n1484) );
  NOR2X1 U1513 ( .A(n1485), .B(n1484), .Y(n1486) );
  AOI22X1 U1514 ( .A(n1489), .B(n1488), .C(n1487), .D(n1486), .Y(n1507) );
  OAI22X1 U1515 ( .A(\reg_mem[3][3] ), .B(n1255), .C(\reg_mem[1][3] ), .D(
        n1257), .Y(n1491) );
  OAI22X1 U1516 ( .A(\reg_mem[7][3] ), .B(n1254), .C(\reg_mem[5][3] ), .D(
        n1258), .Y(n1490) );
  NOR2X1 U1517 ( .A(n1491), .B(n1490), .Y(n1505) );
  NOR2X1 U1518 ( .A(\reg_mem[0][3] ), .B(n1236), .Y(n1492) );
  NOR2X1 U1519 ( .A(n1833), .B(n1492), .Y(n1493) );
  OAI21X1 U1520 ( .A(\reg_mem[2][3] ), .B(n1253), .C(n1493), .Y(n1495) );
  OAI22X1 U1521 ( .A(\reg_mem[6][3] ), .B(n1256), .C(\reg_mem[4][3] ), .D(
        n1259), .Y(n1494) );
  NOR2X1 U1522 ( .A(n1495), .B(n1494), .Y(n1504) );
  OAI22X1 U1523 ( .A(\reg_mem[19][3] ), .B(n1255), .C(\reg_mem[17][3] ), .D(
        n1257), .Y(n1497) );
  OAI22X1 U1524 ( .A(\reg_mem[23][3] ), .B(n1254), .C(\reg_mem[21][3] ), .D(
        n1258), .Y(n1496) );
  NOR2X1 U1525 ( .A(n1497), .B(n1496), .Y(n1503) );
  NOR2X1 U1526 ( .A(\reg_mem[16][3] ), .B(n1236), .Y(n1498) );
  NOR2X1 U1527 ( .A(n1834), .B(n1498), .Y(n1499) );
  OAI21X1 U1528 ( .A(\reg_mem[18][3] ), .B(n1253), .C(n1499), .Y(n1501) );
  OAI22X1 U1529 ( .A(\reg_mem[22][3] ), .B(n1256), .C(\reg_mem[20][3] ), .D(
        n1259), .Y(n1500) );
  NOR2X1 U1530 ( .A(n1501), .B(n1500), .Y(n1502) );
  AOI22X1 U1531 ( .A(n1505), .B(n1504), .C(n1503), .D(n1502), .Y(n1506) );
  AOI21X1 U1532 ( .A(n1507), .B(n1506), .C(N22), .Y(n1543) );
  OAI22X1 U1533 ( .A(\reg_mem[43][3] ), .B(n1255), .C(\reg_mem[41][3] ), .D(
        n1257), .Y(n1509) );
  OAI22X1 U1534 ( .A(\reg_mem[47][3] ), .B(n1254), .C(\reg_mem[45][3] ), .D(
        n1258), .Y(n1508) );
  NOR2X1 U1535 ( .A(n1509), .B(n1508), .Y(n1523) );
  NOR2X1 U1536 ( .A(\reg_mem[40][3] ), .B(n1236), .Y(n1510) );
  NOR2X1 U1537 ( .A(n1788), .B(n1510), .Y(n1511) );
  OAI21X1 U1538 ( .A(\reg_mem[42][3] ), .B(n1253), .C(n1511), .Y(n1513) );
  OAI22X1 U1539 ( .A(\reg_mem[46][3] ), .B(n1256), .C(\reg_mem[44][3] ), .D(
        n1259), .Y(n1512) );
  NOR2X1 U1540 ( .A(n1513), .B(n1512), .Y(n1522) );
  OAI22X1 U1541 ( .A(\reg_mem[59][3] ), .B(n1255), .C(\reg_mem[57][3] ), .D(
        n1257), .Y(n1515) );
  OAI22X1 U1542 ( .A(\reg_mem[63][3] ), .B(n1254), .C(\reg_mem[61][3] ), .D(
        n1258), .Y(n1514) );
  NOR2X1 U1543 ( .A(n1515), .B(n1514), .Y(n1521) );
  NOR2X1 U1544 ( .A(\reg_mem[56][3] ), .B(n1236), .Y(n1516) );
  NOR2X1 U1545 ( .A(n1796), .B(n1516), .Y(n1517) );
  OAI21X1 U1546 ( .A(\reg_mem[58][3] ), .B(n1253), .C(n1517), .Y(n1519) );
  OAI22X1 U1547 ( .A(\reg_mem[62][3] ), .B(n1256), .C(\reg_mem[60][3] ), .D(
        n1259), .Y(n1518) );
  NOR2X1 U1548 ( .A(n1519), .B(n1518), .Y(n1520) );
  AOI22X1 U1549 ( .A(n1523), .B(n1522), .C(n1521), .D(n1520), .Y(n1541) );
  OAI22X1 U1550 ( .A(\reg_mem[11][3] ), .B(n1255), .C(\reg_mem[9][3] ), .D(
        n1257), .Y(n1525) );
  OAI22X1 U1551 ( .A(\reg_mem[15][3] ), .B(n1254), .C(\reg_mem[13][3] ), .D(
        n1258), .Y(n1524) );
  NOR2X1 U1552 ( .A(n1525), .B(n1524), .Y(n1539) );
  NOR2X1 U1553 ( .A(\reg_mem[8][3] ), .B(n1236), .Y(n1526) );
  NOR2X1 U1554 ( .A(n1833), .B(n1526), .Y(n1527) );
  OAI21X1 U1555 ( .A(\reg_mem[10][3] ), .B(n1253), .C(n1527), .Y(n1529) );
  OAI22X1 U1556 ( .A(\reg_mem[14][3] ), .B(n1256), .C(\reg_mem[12][3] ), .D(
        n1259), .Y(n1528) );
  NOR2X1 U1557 ( .A(n1529), .B(n1528), .Y(n1538) );
  OAI22X1 U1558 ( .A(\reg_mem[27][3] ), .B(n1255), .C(\reg_mem[25][3] ), .D(
        n1257), .Y(n1531) );
  OAI22X1 U1559 ( .A(\reg_mem[31][3] ), .B(n1254), .C(\reg_mem[29][3] ), .D(
        n1258), .Y(n1530) );
  NOR2X1 U1560 ( .A(n1531), .B(n1530), .Y(n1537) );
  NOR2X1 U1561 ( .A(\reg_mem[24][3] ), .B(n1236), .Y(n1532) );
  NOR2X1 U1562 ( .A(n1834), .B(n1532), .Y(n1533) );
  OAI21X1 U1563 ( .A(\reg_mem[26][3] ), .B(n1253), .C(n1533), .Y(n1535) );
  OAI22X1 U1564 ( .A(\reg_mem[30][3] ), .B(n1256), .C(\reg_mem[28][3] ), .D(
        n1259), .Y(n1534) );
  NOR2X1 U1565 ( .A(n1535), .B(n1534), .Y(n1536) );
  AOI22X1 U1566 ( .A(n1539), .B(n1538), .C(n1537), .D(n1536), .Y(n1540) );
  AOI21X1 U1567 ( .A(n1541), .B(n1540), .C(n1836), .Y(n1542) );
  OR2X1 U1568 ( .A(n1543), .B(n1542), .Y(tx_packet_data[3]) );
  OAI22X1 U1569 ( .A(\reg_mem[35][4] ), .B(n1255), .C(\reg_mem[33][4] ), .D(
        n1257), .Y(n1545) );
  OAI22X1 U1570 ( .A(\reg_mem[39][4] ), .B(n1254), .C(\reg_mem[37][4] ), .D(
        n1258), .Y(n1544) );
  NOR2X1 U1571 ( .A(n1545), .B(n1544), .Y(n1559) );
  NOR2X1 U1572 ( .A(\reg_mem[32][4] ), .B(n1236), .Y(n1546) );
  NOR2X1 U1573 ( .A(n1788), .B(n1546), .Y(n1547) );
  OAI21X1 U1574 ( .A(\reg_mem[34][4] ), .B(n1253), .C(n1547), .Y(n1549) );
  OAI22X1 U1575 ( .A(\reg_mem[38][4] ), .B(n1256), .C(\reg_mem[36][4] ), .D(
        n1259), .Y(n1548) );
  NOR2X1 U1576 ( .A(n1549), .B(n1548), .Y(n1558) );
  OAI22X1 U1577 ( .A(\reg_mem[51][4] ), .B(n1255), .C(\reg_mem[49][4] ), .D(
        n1257), .Y(n1551) );
  OAI22X1 U1578 ( .A(\reg_mem[55][4] ), .B(n1254), .C(\reg_mem[53][4] ), .D(
        n1258), .Y(n1550) );
  NOR2X1 U1579 ( .A(n1551), .B(n1550), .Y(n1557) );
  NOR2X1 U1580 ( .A(\reg_mem[48][4] ), .B(n1236), .Y(n1552) );
  NOR2X1 U1581 ( .A(n1796), .B(n1552), .Y(n1553) );
  OAI21X1 U1582 ( .A(\reg_mem[50][4] ), .B(n1253), .C(n1553), .Y(n1555) );
  OAI22X1 U1583 ( .A(\reg_mem[54][4] ), .B(n1256), .C(\reg_mem[52][4] ), .D(
        n1259), .Y(n1554) );
  NOR2X1 U1584 ( .A(n1555), .B(n1554), .Y(n1556) );
  AOI22X1 U1585 ( .A(n1559), .B(n1558), .C(n1557), .D(n1556), .Y(n1577) );
  OAI22X1 U1586 ( .A(\reg_mem[3][4] ), .B(n1255), .C(\reg_mem[1][4] ), .D(
        n1257), .Y(n1561) );
  OAI22X1 U1587 ( .A(\reg_mem[7][4] ), .B(n1254), .C(\reg_mem[5][4] ), .D(
        n1258), .Y(n1560) );
  NOR2X1 U1588 ( .A(n1561), .B(n1560), .Y(n1575) );
  NOR2X1 U1589 ( .A(\reg_mem[0][4] ), .B(n1236), .Y(n1562) );
  NOR2X1 U1590 ( .A(n1833), .B(n1562), .Y(n1563) );
  OAI21X1 U1591 ( .A(\reg_mem[2][4] ), .B(n1253), .C(n1563), .Y(n1565) );
  OAI22X1 U1592 ( .A(\reg_mem[6][4] ), .B(n1256), .C(\reg_mem[4][4] ), .D(
        n1259), .Y(n1564) );
  NOR2X1 U1593 ( .A(n1565), .B(n1564), .Y(n1574) );
  OAI22X1 U1594 ( .A(\reg_mem[19][4] ), .B(n1255), .C(\reg_mem[17][4] ), .D(
        n1257), .Y(n1567) );
  OAI22X1 U1595 ( .A(\reg_mem[23][4] ), .B(n1254), .C(\reg_mem[21][4] ), .D(
        n1258), .Y(n1566) );
  NOR2X1 U1596 ( .A(n1567), .B(n1566), .Y(n1573) );
  NOR2X1 U1597 ( .A(\reg_mem[16][4] ), .B(n1236), .Y(n1568) );
  NOR2X1 U1598 ( .A(n1834), .B(n1568), .Y(n1569) );
  OAI21X1 U1599 ( .A(\reg_mem[18][4] ), .B(n1253), .C(n1569), .Y(n1571) );
  OAI22X1 U1600 ( .A(\reg_mem[22][4] ), .B(n1256), .C(\reg_mem[20][4] ), .D(
        n1259), .Y(n1570) );
  NOR2X1 U1601 ( .A(n1571), .B(n1570), .Y(n1572) );
  AOI22X1 U1602 ( .A(n1575), .B(n1574), .C(n1573), .D(n1572), .Y(n1576) );
  AOI21X1 U1603 ( .A(n1577), .B(n1576), .C(N22), .Y(n1613) );
  OAI22X1 U1604 ( .A(\reg_mem[43][4] ), .B(n1255), .C(\reg_mem[41][4] ), .D(
        n1257), .Y(n1579) );
  OAI22X1 U1605 ( .A(\reg_mem[47][4] ), .B(n1254), .C(\reg_mem[45][4] ), .D(
        n1258), .Y(n1578) );
  NOR2X1 U1606 ( .A(n1579), .B(n1578), .Y(n1593) );
  NOR2X1 U1607 ( .A(\reg_mem[40][4] ), .B(n1236), .Y(n1580) );
  NOR2X1 U1608 ( .A(n1788), .B(n1580), .Y(n1581) );
  OAI21X1 U1609 ( .A(\reg_mem[42][4] ), .B(n1253), .C(n1581), .Y(n1583) );
  OAI22X1 U1610 ( .A(\reg_mem[46][4] ), .B(n1256), .C(\reg_mem[44][4] ), .D(
        n1259), .Y(n1582) );
  NOR2X1 U1611 ( .A(n1583), .B(n1582), .Y(n1592) );
  OAI22X1 U1612 ( .A(\reg_mem[59][4] ), .B(n1255), .C(\reg_mem[57][4] ), .D(
        n1257), .Y(n1585) );
  OAI22X1 U1613 ( .A(\reg_mem[63][4] ), .B(n1254), .C(\reg_mem[61][4] ), .D(
        n1258), .Y(n1584) );
  NOR2X1 U1614 ( .A(n1585), .B(n1584), .Y(n1591) );
  NOR2X1 U1615 ( .A(\reg_mem[56][4] ), .B(n1236), .Y(n1586) );
  NOR2X1 U1616 ( .A(n1796), .B(n1586), .Y(n1587) );
  OAI21X1 U1617 ( .A(\reg_mem[58][4] ), .B(n1253), .C(n1587), .Y(n1589) );
  OAI22X1 U1618 ( .A(\reg_mem[62][4] ), .B(n1256), .C(\reg_mem[60][4] ), .D(
        n1259), .Y(n1588) );
  NOR2X1 U1619 ( .A(n1589), .B(n1588), .Y(n1590) );
  AOI22X1 U1620 ( .A(n1593), .B(n1592), .C(n1591), .D(n1590), .Y(n1611) );
  OAI22X1 U1621 ( .A(\reg_mem[11][4] ), .B(n1255), .C(\reg_mem[9][4] ), .D(
        n1257), .Y(n1595) );
  OAI22X1 U1622 ( .A(\reg_mem[15][4] ), .B(n1254), .C(\reg_mem[13][4] ), .D(
        n1258), .Y(n1594) );
  NOR2X1 U1623 ( .A(n1595), .B(n1594), .Y(n1609) );
  NOR2X1 U1624 ( .A(\reg_mem[8][4] ), .B(n1236), .Y(n1596) );
  NOR2X1 U1625 ( .A(n1833), .B(n1596), .Y(n1597) );
  OAI21X1 U1626 ( .A(\reg_mem[10][4] ), .B(n1253), .C(n1597), .Y(n1599) );
  OAI22X1 U1627 ( .A(\reg_mem[14][4] ), .B(n1256), .C(\reg_mem[12][4] ), .D(
        n1259), .Y(n1598) );
  NOR2X1 U1628 ( .A(n1599), .B(n1598), .Y(n1608) );
  OAI22X1 U1629 ( .A(\reg_mem[27][4] ), .B(n1255), .C(\reg_mem[25][4] ), .D(
        n1257), .Y(n1601) );
  OAI22X1 U1630 ( .A(\reg_mem[31][4] ), .B(n1254), .C(\reg_mem[29][4] ), .D(
        n1258), .Y(n1600) );
  NOR2X1 U1631 ( .A(n1601), .B(n1600), .Y(n1607) );
  NOR2X1 U1632 ( .A(\reg_mem[24][4] ), .B(n1236), .Y(n1602) );
  NOR2X1 U1633 ( .A(n1834), .B(n1602), .Y(n1603) );
  OAI21X1 U1634 ( .A(\reg_mem[26][4] ), .B(n1253), .C(n1603), .Y(n1605) );
  OAI22X1 U1635 ( .A(\reg_mem[30][4] ), .B(n1256), .C(\reg_mem[28][4] ), .D(
        n1259), .Y(n1604) );
  NOR2X1 U1636 ( .A(n1605), .B(n1604), .Y(n1606) );
  AOI22X1 U1637 ( .A(n1609), .B(n1608), .C(n1607), .D(n1606), .Y(n1610) );
  AOI21X1 U1638 ( .A(n1611), .B(n1610), .C(n1836), .Y(n1612) );
  OR2X1 U1639 ( .A(n1613), .B(n1612), .Y(tx_packet_data[4]) );
  OAI22X1 U1640 ( .A(\reg_mem[35][5] ), .B(n1255), .C(\reg_mem[33][5] ), .D(
        n1257), .Y(n1615) );
  OAI22X1 U1641 ( .A(\reg_mem[39][5] ), .B(n1254), .C(\reg_mem[37][5] ), .D(
        n1258), .Y(n1614) );
  NOR2X1 U1642 ( .A(n1615), .B(n1614), .Y(n1629) );
  NOR2X1 U1643 ( .A(\reg_mem[32][5] ), .B(n1236), .Y(n1616) );
  NOR2X1 U1644 ( .A(n1788), .B(n1616), .Y(n1617) );
  OAI21X1 U1645 ( .A(\reg_mem[34][5] ), .B(n1253), .C(n1617), .Y(n1619) );
  OAI22X1 U1646 ( .A(\reg_mem[38][5] ), .B(n1256), .C(\reg_mem[36][5] ), .D(
        n1259), .Y(n1618) );
  NOR2X1 U1647 ( .A(n1619), .B(n1618), .Y(n1628) );
  OAI22X1 U1648 ( .A(\reg_mem[51][5] ), .B(n1255), .C(\reg_mem[49][5] ), .D(
        n1257), .Y(n1621) );
  OAI22X1 U1649 ( .A(\reg_mem[55][5] ), .B(n1254), .C(\reg_mem[53][5] ), .D(
        n1258), .Y(n1620) );
  NOR2X1 U1650 ( .A(n1621), .B(n1620), .Y(n1627) );
  NOR2X1 U1651 ( .A(\reg_mem[48][5] ), .B(n1236), .Y(n1622) );
  NOR2X1 U1652 ( .A(n1796), .B(n1622), .Y(n1623) );
  OAI21X1 U1653 ( .A(\reg_mem[50][5] ), .B(n1253), .C(n1623), .Y(n1625) );
  OAI22X1 U1654 ( .A(\reg_mem[54][5] ), .B(n1256), .C(\reg_mem[52][5] ), .D(
        n1259), .Y(n1624) );
  NOR2X1 U1655 ( .A(n1625), .B(n1624), .Y(n1626) );
  AOI22X1 U1656 ( .A(n1629), .B(n1628), .C(n1627), .D(n1626), .Y(n1647) );
  OAI22X1 U1657 ( .A(\reg_mem[3][5] ), .B(n1255), .C(\reg_mem[1][5] ), .D(
        n1257), .Y(n1631) );
  OAI22X1 U1658 ( .A(\reg_mem[7][5] ), .B(n1254), .C(\reg_mem[5][5] ), .D(
        n1258), .Y(n1630) );
  NOR2X1 U1659 ( .A(n1631), .B(n1630), .Y(n1645) );
  NOR2X1 U1660 ( .A(\reg_mem[0][5] ), .B(n1236), .Y(n1632) );
  NOR2X1 U1661 ( .A(n1833), .B(n1632), .Y(n1633) );
  OAI21X1 U1662 ( .A(\reg_mem[2][5] ), .B(n1253), .C(n1633), .Y(n1635) );
  OAI22X1 U1663 ( .A(\reg_mem[6][5] ), .B(n1256), .C(\reg_mem[4][5] ), .D(
        n1259), .Y(n1634) );
  NOR2X1 U1664 ( .A(n1635), .B(n1634), .Y(n1644) );
  OAI22X1 U1665 ( .A(\reg_mem[19][5] ), .B(n1255), .C(\reg_mem[17][5] ), .D(
        n1257), .Y(n1637) );
  OAI22X1 U1666 ( .A(\reg_mem[23][5] ), .B(n1254), .C(\reg_mem[21][5] ), .D(
        n1258), .Y(n1636) );
  NOR2X1 U1667 ( .A(n1637), .B(n1636), .Y(n1643) );
  NOR2X1 U1668 ( .A(\reg_mem[16][5] ), .B(n1236), .Y(n1638) );
  NOR2X1 U1669 ( .A(n1834), .B(n1638), .Y(n1639) );
  OAI21X1 U1670 ( .A(\reg_mem[18][5] ), .B(n1253), .C(n1639), .Y(n1641) );
  OAI22X1 U1671 ( .A(\reg_mem[22][5] ), .B(n1256), .C(\reg_mem[20][5] ), .D(
        n1259), .Y(n1640) );
  NOR2X1 U1672 ( .A(n1641), .B(n1640), .Y(n1642) );
  AOI22X1 U1673 ( .A(n1645), .B(n1644), .C(n1643), .D(n1642), .Y(n1646) );
  AOI21X1 U1674 ( .A(n1647), .B(n1646), .C(N22), .Y(n1683) );
  OAI22X1 U1675 ( .A(\reg_mem[43][5] ), .B(n1255), .C(\reg_mem[41][5] ), .D(
        n1257), .Y(n1649) );
  OAI22X1 U1676 ( .A(\reg_mem[47][5] ), .B(n1254), .C(\reg_mem[45][5] ), .D(
        n1258), .Y(n1648) );
  NOR2X1 U1677 ( .A(n1649), .B(n1648), .Y(n1663) );
  NOR2X1 U1678 ( .A(\reg_mem[40][5] ), .B(n1236), .Y(n1650) );
  NOR2X1 U1679 ( .A(n1788), .B(n1650), .Y(n1651) );
  OAI21X1 U1680 ( .A(\reg_mem[42][5] ), .B(n1253), .C(n1651), .Y(n1653) );
  OAI22X1 U1681 ( .A(\reg_mem[46][5] ), .B(n1256), .C(\reg_mem[44][5] ), .D(
        n1259), .Y(n1652) );
  NOR2X1 U1682 ( .A(n1653), .B(n1652), .Y(n1662) );
  OAI22X1 U1683 ( .A(\reg_mem[59][5] ), .B(n1255), .C(\reg_mem[57][5] ), .D(
        n1257), .Y(n1655) );
  OAI22X1 U1684 ( .A(\reg_mem[63][5] ), .B(n1254), .C(\reg_mem[61][5] ), .D(
        n1258), .Y(n1654) );
  NOR2X1 U1685 ( .A(n1655), .B(n1654), .Y(n1661) );
  NOR2X1 U1686 ( .A(\reg_mem[56][5] ), .B(n1236), .Y(n1656) );
  NOR2X1 U1687 ( .A(n1796), .B(n1656), .Y(n1657) );
  OAI21X1 U1688 ( .A(\reg_mem[58][5] ), .B(n1253), .C(n1657), .Y(n1659) );
  OAI22X1 U1689 ( .A(\reg_mem[62][5] ), .B(n1256), .C(\reg_mem[60][5] ), .D(
        n1259), .Y(n1658) );
  NOR2X1 U1690 ( .A(n1659), .B(n1658), .Y(n1660) );
  AOI22X1 U1691 ( .A(n1663), .B(n1662), .C(n1661), .D(n1660), .Y(n1681) );
  OAI22X1 U1692 ( .A(\reg_mem[11][5] ), .B(n1255), .C(\reg_mem[9][5] ), .D(
        n1257), .Y(n1665) );
  OAI22X1 U1693 ( .A(\reg_mem[15][5] ), .B(n1254), .C(\reg_mem[13][5] ), .D(
        n1258), .Y(n1664) );
  NOR2X1 U1694 ( .A(n1665), .B(n1664), .Y(n1679) );
  NOR2X1 U1695 ( .A(\reg_mem[8][5] ), .B(n1236), .Y(n1666) );
  NOR2X1 U1696 ( .A(n1833), .B(n1666), .Y(n1667) );
  OAI21X1 U1697 ( .A(\reg_mem[10][5] ), .B(n1253), .C(n1667), .Y(n1669) );
  OAI22X1 U1698 ( .A(\reg_mem[14][5] ), .B(n1256), .C(\reg_mem[12][5] ), .D(
        n1259), .Y(n1668) );
  NOR2X1 U1699 ( .A(n1669), .B(n1668), .Y(n1678) );
  OAI22X1 U1700 ( .A(\reg_mem[27][5] ), .B(n1255), .C(\reg_mem[25][5] ), .D(
        n1257), .Y(n1671) );
  OAI22X1 U1701 ( .A(\reg_mem[31][5] ), .B(n1254), .C(\reg_mem[29][5] ), .D(
        n1258), .Y(n1670) );
  NOR2X1 U1702 ( .A(n1671), .B(n1670), .Y(n1677) );
  NOR2X1 U1703 ( .A(\reg_mem[24][5] ), .B(n1236), .Y(n1672) );
  NOR2X1 U1704 ( .A(n1834), .B(n1672), .Y(n1673) );
  OAI21X1 U1705 ( .A(\reg_mem[26][5] ), .B(n1253), .C(n1673), .Y(n1675) );
  OAI22X1 U1706 ( .A(\reg_mem[30][5] ), .B(n1256), .C(\reg_mem[28][5] ), .D(
        n1259), .Y(n1674) );
  NOR2X1 U1707 ( .A(n1675), .B(n1674), .Y(n1676) );
  AOI22X1 U1708 ( .A(n1679), .B(n1678), .C(n1677), .D(n1676), .Y(n1680) );
  AOI21X1 U1709 ( .A(n1681), .B(n1680), .C(n1836), .Y(n1682) );
  OR2X1 U1710 ( .A(n1683), .B(n1682), .Y(tx_packet_data[5]) );
  OAI22X1 U1711 ( .A(\reg_mem[35][6] ), .B(n1255), .C(\reg_mem[33][6] ), .D(
        n1257), .Y(n1685) );
  OAI22X1 U1712 ( .A(\reg_mem[39][6] ), .B(n1254), .C(\reg_mem[37][6] ), .D(
        n1258), .Y(n1684) );
  NOR2X1 U1713 ( .A(n1685), .B(n1684), .Y(n1699) );
  NOR2X1 U1714 ( .A(\reg_mem[32][6] ), .B(n1236), .Y(n1686) );
  NOR2X1 U1715 ( .A(n1788), .B(n1686), .Y(n1687) );
  OAI21X1 U1716 ( .A(\reg_mem[34][6] ), .B(n1253), .C(n1687), .Y(n1689) );
  OAI22X1 U1717 ( .A(\reg_mem[38][6] ), .B(n1256), .C(\reg_mem[36][6] ), .D(
        n1259), .Y(n1688) );
  NOR2X1 U1718 ( .A(n1689), .B(n1688), .Y(n1698) );
  OAI22X1 U1719 ( .A(\reg_mem[51][6] ), .B(n1255), .C(\reg_mem[49][6] ), .D(
        n1257), .Y(n1691) );
  OAI22X1 U1720 ( .A(\reg_mem[55][6] ), .B(n1254), .C(\reg_mem[53][6] ), .D(
        n1258), .Y(n1690) );
  NOR2X1 U1721 ( .A(n1691), .B(n1690), .Y(n1697) );
  NOR2X1 U1722 ( .A(\reg_mem[48][6] ), .B(n1236), .Y(n1692) );
  NOR2X1 U1723 ( .A(n1796), .B(n1692), .Y(n1693) );
  OAI21X1 U1724 ( .A(\reg_mem[50][6] ), .B(n1253), .C(n1693), .Y(n1695) );
  OAI22X1 U1725 ( .A(\reg_mem[54][6] ), .B(n1256), .C(\reg_mem[52][6] ), .D(
        n1259), .Y(n1694) );
  NOR2X1 U1726 ( .A(n1695), .B(n1694), .Y(n1696) );
  AOI22X1 U1727 ( .A(n1699), .B(n1698), .C(n1697), .D(n1696), .Y(n1717) );
  OAI22X1 U1728 ( .A(\reg_mem[3][6] ), .B(n1255), .C(\reg_mem[1][6] ), .D(
        n1257), .Y(n1701) );
  OAI22X1 U1729 ( .A(\reg_mem[7][6] ), .B(n1254), .C(\reg_mem[5][6] ), .D(
        n1258), .Y(n1700) );
  NOR2X1 U1730 ( .A(n1701), .B(n1700), .Y(n1715) );
  NOR2X1 U1731 ( .A(\reg_mem[0][6] ), .B(n1236), .Y(n1702) );
  NOR2X1 U1732 ( .A(n1833), .B(n1702), .Y(n1703) );
  OAI21X1 U1733 ( .A(\reg_mem[2][6] ), .B(n1253), .C(n1703), .Y(n1705) );
  OAI22X1 U1734 ( .A(\reg_mem[6][6] ), .B(n1256), .C(\reg_mem[4][6] ), .D(
        n1259), .Y(n1704) );
  NOR2X1 U1735 ( .A(n1705), .B(n1704), .Y(n1714) );
  OAI22X1 U1736 ( .A(\reg_mem[19][6] ), .B(n1255), .C(\reg_mem[17][6] ), .D(
        n1257), .Y(n1707) );
  OAI22X1 U1737 ( .A(\reg_mem[23][6] ), .B(n1254), .C(\reg_mem[21][6] ), .D(
        n1258), .Y(n1706) );
  NOR2X1 U1738 ( .A(n1707), .B(n1706), .Y(n1713) );
  NOR2X1 U1739 ( .A(\reg_mem[16][6] ), .B(n1236), .Y(n1708) );
  NOR2X1 U1740 ( .A(n1834), .B(n1708), .Y(n1709) );
  OAI21X1 U1741 ( .A(\reg_mem[18][6] ), .B(n1253), .C(n1709), .Y(n1711) );
  OAI22X1 U1742 ( .A(\reg_mem[22][6] ), .B(n1256), .C(\reg_mem[20][6] ), .D(
        n1259), .Y(n1710) );
  NOR2X1 U1743 ( .A(n1711), .B(n1710), .Y(n1712) );
  AOI22X1 U1744 ( .A(n1715), .B(n1714), .C(n1713), .D(n1712), .Y(n1716) );
  AOI21X1 U1745 ( .A(n1717), .B(n1716), .C(N22), .Y(n1753) );
  OAI22X1 U1746 ( .A(\reg_mem[43][6] ), .B(n1255), .C(\reg_mem[41][6] ), .D(
        n1257), .Y(n1719) );
  OAI22X1 U1747 ( .A(\reg_mem[47][6] ), .B(n1254), .C(\reg_mem[45][6] ), .D(
        n1258), .Y(n1718) );
  NOR2X1 U1748 ( .A(n1719), .B(n1718), .Y(n1733) );
  NOR2X1 U1749 ( .A(\reg_mem[40][6] ), .B(n1236), .Y(n1720) );
  NOR2X1 U1750 ( .A(n1788), .B(n1720), .Y(n1721) );
  OAI21X1 U1751 ( .A(\reg_mem[42][6] ), .B(n1253), .C(n1721), .Y(n1723) );
  OAI22X1 U1752 ( .A(\reg_mem[46][6] ), .B(n1256), .C(\reg_mem[44][6] ), .D(
        n1259), .Y(n1722) );
  NOR2X1 U1753 ( .A(n1723), .B(n1722), .Y(n1732) );
  OAI22X1 U1754 ( .A(\reg_mem[59][6] ), .B(n1255), .C(\reg_mem[57][6] ), .D(
        n1257), .Y(n1725) );
  OAI22X1 U1755 ( .A(\reg_mem[63][6] ), .B(n1254), .C(\reg_mem[61][6] ), .D(
        n1258), .Y(n1724) );
  NOR2X1 U1756 ( .A(n1725), .B(n1724), .Y(n1731) );
  NOR2X1 U1757 ( .A(\reg_mem[56][6] ), .B(n1236), .Y(n1726) );
  NOR2X1 U1758 ( .A(n1796), .B(n1726), .Y(n1727) );
  OAI21X1 U1759 ( .A(\reg_mem[58][6] ), .B(n1253), .C(n1727), .Y(n1729) );
  OAI22X1 U1760 ( .A(\reg_mem[62][6] ), .B(n1256), .C(\reg_mem[60][6] ), .D(
        n1259), .Y(n1728) );
  NOR2X1 U1761 ( .A(n1729), .B(n1728), .Y(n1730) );
  AOI22X1 U1762 ( .A(n1733), .B(n1732), .C(n1731), .D(n1730), .Y(n1751) );
  OAI22X1 U1763 ( .A(\reg_mem[11][6] ), .B(n1255), .C(\reg_mem[9][6] ), .D(
        n1257), .Y(n1735) );
  OAI22X1 U1764 ( .A(\reg_mem[15][6] ), .B(n1254), .C(\reg_mem[13][6] ), .D(
        n1258), .Y(n1734) );
  NOR2X1 U1765 ( .A(n1735), .B(n1734), .Y(n1749) );
  NOR2X1 U1766 ( .A(\reg_mem[8][6] ), .B(n1236), .Y(n1736) );
  NOR2X1 U1767 ( .A(n1833), .B(n1736), .Y(n1737) );
  OAI21X1 U1768 ( .A(\reg_mem[10][6] ), .B(n1253), .C(n1737), .Y(n1739) );
  OAI22X1 U1769 ( .A(\reg_mem[14][6] ), .B(n1256), .C(\reg_mem[12][6] ), .D(
        n1259), .Y(n1738) );
  NOR2X1 U1770 ( .A(n1739), .B(n1738), .Y(n1748) );
  OAI22X1 U1771 ( .A(\reg_mem[27][6] ), .B(n1255), .C(\reg_mem[25][6] ), .D(
        n1257), .Y(n1741) );
  OAI22X1 U1772 ( .A(\reg_mem[31][6] ), .B(n1254), .C(\reg_mem[29][6] ), .D(
        n1258), .Y(n1740) );
  NOR2X1 U1773 ( .A(n1741), .B(n1740), .Y(n1747) );
  NOR2X1 U1774 ( .A(\reg_mem[24][6] ), .B(n1236), .Y(n1742) );
  NOR2X1 U1775 ( .A(n1834), .B(n1742), .Y(n1743) );
  OAI21X1 U1776 ( .A(\reg_mem[26][6] ), .B(n1253), .C(n1743), .Y(n1745) );
  OAI22X1 U1777 ( .A(\reg_mem[30][6] ), .B(n1256), .C(\reg_mem[28][6] ), .D(
        n1259), .Y(n1744) );
  NOR2X1 U1778 ( .A(n1745), .B(n1744), .Y(n1746) );
  AOI22X1 U1779 ( .A(n1749), .B(n1748), .C(n1747), .D(n1746), .Y(n1750) );
  AOI21X1 U1780 ( .A(n1751), .B(n1750), .C(n1836), .Y(n1752) );
  OR2X1 U1781 ( .A(n1753), .B(n1752), .Y(tx_packet_data[6]) );
  OAI22X1 U1782 ( .A(\reg_mem[35][7] ), .B(n1255), .C(\reg_mem[33][7] ), .D(
        n1257), .Y(n1755) );
  OAI22X1 U1783 ( .A(\reg_mem[39][7] ), .B(n1254), .C(\reg_mem[37][7] ), .D(
        n1258), .Y(n1754) );
  NOR2X1 U1784 ( .A(n1755), .B(n1754), .Y(n1769) );
  NOR2X1 U1785 ( .A(\reg_mem[32][7] ), .B(n1236), .Y(n1756) );
  NOR2X1 U1786 ( .A(n1788), .B(n1756), .Y(n1757) );
  OAI21X1 U1787 ( .A(\reg_mem[34][7] ), .B(n1253), .C(n1757), .Y(n1759) );
  OAI22X1 U1788 ( .A(\reg_mem[38][7] ), .B(n1256), .C(\reg_mem[36][7] ), .D(
        n1259), .Y(n1758) );
  NOR2X1 U1789 ( .A(n1759), .B(n1758), .Y(n1768) );
  OAI22X1 U1790 ( .A(\reg_mem[51][7] ), .B(n1255), .C(\reg_mem[49][7] ), .D(
        n1257), .Y(n1761) );
  OAI22X1 U1791 ( .A(\reg_mem[55][7] ), .B(n1254), .C(\reg_mem[53][7] ), .D(
        n1258), .Y(n1760) );
  NOR2X1 U1792 ( .A(n1761), .B(n1760), .Y(n1767) );
  NOR2X1 U1793 ( .A(\reg_mem[48][7] ), .B(n1236), .Y(n1762) );
  NOR2X1 U1794 ( .A(n1796), .B(n1762), .Y(n1763) );
  OAI21X1 U1795 ( .A(\reg_mem[50][7] ), .B(n1253), .C(n1763), .Y(n1765) );
  OAI22X1 U1796 ( .A(\reg_mem[54][7] ), .B(n1256), .C(\reg_mem[52][7] ), .D(
        n1259), .Y(n1764) );
  NOR2X1 U1797 ( .A(n1765), .B(n1764), .Y(n1766) );
  AOI22X1 U1798 ( .A(n1769), .B(n1768), .C(n1767), .D(n1766), .Y(n1787) );
  OAI22X1 U1799 ( .A(\reg_mem[3][7] ), .B(n1255), .C(\reg_mem[1][7] ), .D(
        n1257), .Y(n1771) );
  OAI22X1 U1800 ( .A(\reg_mem[7][7] ), .B(n1254), .C(\reg_mem[5][7] ), .D(
        n1258), .Y(n1770) );
  NOR2X1 U1801 ( .A(n1771), .B(n1770), .Y(n1785) );
  NOR2X1 U1802 ( .A(\reg_mem[0][7] ), .B(n1236), .Y(n1772) );
  NOR2X1 U1803 ( .A(n1833), .B(n1772), .Y(n1773) );
  OAI21X1 U1804 ( .A(\reg_mem[2][7] ), .B(n1253), .C(n1773), .Y(n1775) );
  OAI22X1 U1805 ( .A(\reg_mem[6][7] ), .B(n1256), .C(\reg_mem[4][7] ), .D(
        n1259), .Y(n1774) );
  NOR2X1 U1806 ( .A(n1775), .B(n1774), .Y(n1784) );
  OAI22X1 U1807 ( .A(\reg_mem[19][7] ), .B(n1255), .C(\reg_mem[17][7] ), .D(
        n1257), .Y(n1777) );
  OAI22X1 U1808 ( .A(\reg_mem[23][7] ), .B(n1254), .C(\reg_mem[21][7] ), .D(
        n1258), .Y(n1776) );
  NOR2X1 U1809 ( .A(n1777), .B(n1776), .Y(n1783) );
  NOR2X1 U1810 ( .A(\reg_mem[16][7] ), .B(n1236), .Y(n1778) );
  NOR2X1 U1811 ( .A(n1834), .B(n1778), .Y(n1779) );
  OAI21X1 U1812 ( .A(\reg_mem[18][7] ), .B(n1253), .C(n1779), .Y(n1781) );
  OAI22X1 U1813 ( .A(\reg_mem[22][7] ), .B(n1256), .C(\reg_mem[20][7] ), .D(
        n1259), .Y(n1780) );
  NOR2X1 U1814 ( .A(n1781), .B(n1780), .Y(n1782) );
  AOI22X1 U1815 ( .A(n1785), .B(n1784), .C(n1783), .D(n1782), .Y(n1786) );
  AOI21X1 U1816 ( .A(n1787), .B(n1786), .C(N22), .Y(n1831) );
  OAI22X1 U1817 ( .A(\reg_mem[45][7] ), .B(n1258), .C(\reg_mem[43][7] ), .D(
        n1255), .Y(n1790) );
  OAI21X1 U1818 ( .A(\reg_mem[47][7] ), .B(n1254), .C(n1835), .Y(n1789) );
  NOR2X1 U1819 ( .A(n1790), .B(n1789), .Y(n1807) );
  NOR2X1 U1820 ( .A(\reg_mem[40][7] ), .B(n1236), .Y(n1792) );
  NOR2X1 U1821 ( .A(\reg_mem[42][7] ), .B(n1253), .Y(n1791) );
  NOR2X1 U1822 ( .A(n1792), .B(n1791), .Y(n1793) );
  OAI21X1 U1823 ( .A(\reg_mem[44][7] ), .B(n1259), .C(n1793), .Y(n1795) );
  OAI22X1 U1824 ( .A(\reg_mem[41][7] ), .B(n1257), .C(\reg_mem[46][7] ), .D(
        n1256), .Y(n1794) );
  NOR2X1 U1825 ( .A(n1795), .B(n1794), .Y(n1806) );
  OAI22X1 U1826 ( .A(\reg_mem[61][7] ), .B(n1258), .C(\reg_mem[59][7] ), .D(
        n1255), .Y(n1798) );
  OAI21X1 U1827 ( .A(\reg_mem[63][7] ), .B(n1254), .C(n1832), .Y(n1797) );
  NOR2X1 U1828 ( .A(n1798), .B(n1797), .Y(n1805) );
  NOR2X1 U1829 ( .A(\reg_mem[56][7] ), .B(n1236), .Y(n1800) );
  NOR2X1 U1830 ( .A(\reg_mem[58][7] ), .B(n1253), .Y(n1799) );
  NOR2X1 U1831 ( .A(n1800), .B(n1799), .Y(n1801) );
  OAI21X1 U1832 ( .A(\reg_mem[60][7] ), .B(n1259), .C(n1801), .Y(n1803) );
  OAI22X1 U1833 ( .A(\reg_mem[57][7] ), .B(n1257), .C(\reg_mem[62][7] ), .D(
        n1256), .Y(n1802) );
  NOR2X1 U1834 ( .A(n1803), .B(n1802), .Y(n1804) );
  AOI22X1 U1835 ( .A(n1807), .B(n1806), .C(n1805), .D(n1804), .Y(n1829) );
  OAI22X1 U1836 ( .A(\reg_mem[13][7] ), .B(n1258), .C(\reg_mem[11][7] ), .D(
        n1255), .Y(n1810) );
  OAI21X1 U1837 ( .A(\reg_mem[15][7] ), .B(n1254), .C(n1808), .Y(n1809) );
  NOR2X1 U1838 ( .A(n1810), .B(n1809), .Y(n1827) );
  NOR2X1 U1839 ( .A(\reg_mem[8][7] ), .B(n1236), .Y(n1812) );
  NOR2X1 U1840 ( .A(\reg_mem[10][7] ), .B(n1253), .Y(n1811) );
  NOR2X1 U1841 ( .A(n1812), .B(n1811), .Y(n1813) );
  OAI21X1 U1842 ( .A(\reg_mem[12][7] ), .B(n1259), .C(n1813), .Y(n1815) );
  OAI22X1 U1843 ( .A(\reg_mem[9][7] ), .B(n1257), .C(\reg_mem[14][7] ), .D(
        n1256), .Y(n1814) );
  NOR2X1 U1844 ( .A(n1815), .B(n1814), .Y(n1826) );
  OAI22X1 U1845 ( .A(\reg_mem[29][7] ), .B(n1258), .C(\reg_mem[27][7] ), .D(
        n1255), .Y(n1818) );
  OAI21X1 U1846 ( .A(\reg_mem[31][7] ), .B(n1254), .C(n1816), .Y(n1817) );
  NOR2X1 U1847 ( .A(n1818), .B(n1817), .Y(n1825) );
  NOR2X1 U1848 ( .A(\reg_mem[24][7] ), .B(n1236), .Y(n1820) );
  NOR2X1 U1849 ( .A(\reg_mem[26][7] ), .B(n1253), .Y(n1819) );
  NOR2X1 U1850 ( .A(n1820), .B(n1819), .Y(n1821) );
  OAI21X1 U1851 ( .A(\reg_mem[28][7] ), .B(n1259), .C(n1821), .Y(n1823) );
  OAI22X1 U1852 ( .A(\reg_mem[25][7] ), .B(n1257), .C(\reg_mem[30][7] ), .D(
        n1256), .Y(n1822) );
  NOR2X1 U1853 ( .A(n1823), .B(n1822), .Y(n1824) );
  AOI22X1 U1854 ( .A(n1827), .B(n1826), .C(n1825), .D(n1824), .Y(n1828) );
  AOI21X1 U1855 ( .A(n1829), .B(n1828), .C(n1836), .Y(n1830) );
  OR2X1 U1856 ( .A(n1831), .B(n1830), .Y(tx_packet_data[7]) );
  INVX2 U1857 ( .A(n1808), .Y(n1833) );
  INVX2 U1858 ( .A(n1816), .Y(n1834) );
  INVX2 U1859 ( .A(N22), .Y(n1836) );
  INVX2 U1860 ( .A(N20), .Y(n1837) );
  INVX2 U1861 ( .A(N19), .Y(n1838) );
  NOR2X1 U1862 ( .A(n1839), .B(n1840), .Y(next_counter[6]) );
  XOR2X1 U1863 ( .A(n1841), .B(n1842), .Y(n1839) );
  NOR2X1 U1864 ( .A(n1843), .B(n1844), .Y(n1842) );
  MUX2X1 U1865 ( .B(N42), .A(buffer_occupancy[6]), .S(n1845), .Y(n1841) );
  NOR2X1 U1866 ( .A(n1846), .B(n1840), .Y(next_counter[5]) );
  INVX1 U1867 ( .A(n1847), .Y(n1840) );
  XOR2X1 U1868 ( .A(n1843), .B(n1844), .Y(n1846) );
  INVX1 U1869 ( .A(n1848), .Y(n1843) );
  MUX2X1 U1870 ( .B(N41), .A(buffer_occupancy[5]), .S(n1845), .Y(n1848) );
  AND2X1 U1871 ( .A(n1847), .B(n1849), .Y(next_counter[4]) );
  OAI21X1 U1872 ( .A(n1850), .B(n1851), .C(n1844), .Y(n1849) );
  NAND2X1 U1873 ( .A(n1850), .B(n1851), .Y(n1844) );
  MUX2X1 U1874 ( .B(N40), .A(buffer_occupancy[4]), .S(n1845), .Y(n1851) );
  INVX1 U1875 ( .A(n1852), .Y(n1850) );
  AND2X1 U1876 ( .A(n1847), .B(n1853), .Y(next_counter[3]) );
  OAI21X1 U1877 ( .A(n1854), .B(n1855), .C(n1852), .Y(n1853) );
  NAND2X1 U1878 ( .A(n1854), .B(n1855), .Y(n1852) );
  MUX2X1 U1879 ( .B(N39), .A(buffer_occupancy[3]), .S(n1845), .Y(n1855) );
  INVX1 U1880 ( .A(n1856), .Y(n1854) );
  AND2X1 U1881 ( .A(n1847), .B(n1857), .Y(next_counter[2]) );
  OAI21X1 U1882 ( .A(n1858), .B(n1859), .C(n1856), .Y(n1857) );
  NAND2X1 U1883 ( .A(n1858), .B(n1859), .Y(n1856) );
  MUX2X1 U1884 ( .B(N38), .A(buffer_occupancy[2]), .S(n1845), .Y(n1859) );
  INVX1 U1885 ( .A(n1860), .Y(n1858) );
  OAI21X1 U1886 ( .A(n1861), .B(n1862), .C(n1863), .Y(next_counter[1]) );
  NAND2X1 U1887 ( .A(n1847), .B(n1864), .Y(n1863) );
  OAI21X1 U1888 ( .A(n1861), .B(n1865), .C(n1860), .Y(n1864) );
  NAND3X1 U1889 ( .A(n1861), .B(n1865), .C(n1866), .Y(n1860) );
  MUX2X1 U1890 ( .B(N37), .A(buffer_occupancy[1]), .S(n1845), .Y(n1861) );
  MUX2X1 U1891 ( .B(n1862), .A(n1867), .S(n1865), .Y(next_counter[0]) );
  MUX2X1 U1892 ( .B(N36), .A(buffer_occupancy[0]), .S(n1845), .Y(n1865) );
  NAND2X1 U1893 ( .A(n1847), .B(n1866), .Y(n1867) );
  INVX1 U1894 ( .A(n1868), .Y(n1866) );
  MUX2X1 U1895 ( .B(n1869), .A(n1252), .S(n1871), .Y(n999) );
  INVX1 U1896 ( .A(\reg_mem[23][3] ), .Y(n1869) );
  MUX2X1 U1897 ( .B(n1872), .A(n1252), .S(n1873), .Y(n998) );
  INVX1 U1898 ( .A(\reg_mem[24][3] ), .Y(n1872) );
  MUX2X1 U1899 ( .B(n1874), .A(n1252), .S(n1875), .Y(n997) );
  INVX1 U1900 ( .A(\reg_mem[25][3] ), .Y(n1874) );
  MUX2X1 U1901 ( .B(n1876), .A(n1252), .S(n1877), .Y(n996) );
  INVX1 U1902 ( .A(\reg_mem[26][3] ), .Y(n1876) );
  MUX2X1 U1903 ( .B(n1878), .A(n1252), .S(n1879), .Y(n995) );
  INVX1 U1904 ( .A(\reg_mem[27][3] ), .Y(n1878) );
  MUX2X1 U1905 ( .B(n1880), .A(n1252), .S(n1881), .Y(n994) );
  INVX1 U1906 ( .A(\reg_mem[28][3] ), .Y(n1880) );
  MUX2X1 U1907 ( .B(n1882), .A(n1252), .S(n1883), .Y(n993) );
  INVX1 U1908 ( .A(\reg_mem[29][3] ), .Y(n1882) );
  MUX2X1 U1909 ( .B(n1884), .A(n1252), .S(n1885), .Y(n992) );
  INVX1 U1910 ( .A(\reg_mem[30][3] ), .Y(n1884) );
  MUX2X1 U1911 ( .B(n1886), .A(n1252), .S(n1887), .Y(n991) );
  INVX1 U1912 ( .A(\reg_mem[31][3] ), .Y(n1886) );
  MUX2X1 U1913 ( .B(n1888), .A(n1252), .S(n1889), .Y(n990) );
  INVX1 U1914 ( .A(\reg_mem[32][3] ), .Y(n1888) );
  MUX2X1 U1915 ( .B(n1890), .A(n1252), .S(n1891), .Y(n989) );
  INVX1 U1916 ( .A(\reg_mem[33][3] ), .Y(n1890) );
  MUX2X1 U1917 ( .B(n1892), .A(n1252), .S(n1893), .Y(n988) );
  INVX1 U1918 ( .A(\reg_mem[34][3] ), .Y(n1892) );
  MUX2X1 U1919 ( .B(n1894), .A(n1252), .S(n1895), .Y(n987) );
  INVX1 U1920 ( .A(\reg_mem[35][3] ), .Y(n1894) );
  MUX2X1 U1921 ( .B(n1896), .A(n1252), .S(n1897), .Y(n986) );
  INVX1 U1922 ( .A(\reg_mem[36][3] ), .Y(n1896) );
  MUX2X1 U1923 ( .B(n1898), .A(n1252), .S(n1899), .Y(n985) );
  INVX1 U1924 ( .A(\reg_mem[37][3] ), .Y(n1898) );
  MUX2X1 U1925 ( .B(n1900), .A(n1252), .S(n1901), .Y(n984) );
  INVX1 U1926 ( .A(\reg_mem[38][3] ), .Y(n1900) );
  MUX2X1 U1927 ( .B(n1902), .A(n1252), .S(n1903), .Y(n983) );
  INVX1 U1928 ( .A(\reg_mem[39][3] ), .Y(n1902) );
  MUX2X1 U1929 ( .B(n1904), .A(n1252), .S(n1905), .Y(n982) );
  INVX1 U1930 ( .A(\reg_mem[40][3] ), .Y(n1904) );
  MUX2X1 U1931 ( .B(n1906), .A(n1252), .S(n1907), .Y(n981) );
  INVX1 U1932 ( .A(\reg_mem[41][3] ), .Y(n1906) );
  MUX2X1 U1933 ( .B(n1908), .A(n1252), .S(n1909), .Y(n980) );
  INVX1 U1934 ( .A(\reg_mem[42][3] ), .Y(n1908) );
  MUX2X1 U1935 ( .B(n1910), .A(n1252), .S(n1911), .Y(n979) );
  INVX1 U1936 ( .A(\reg_mem[43][3] ), .Y(n1910) );
  MUX2X1 U1937 ( .B(n1912), .A(n1252), .S(n1913), .Y(n978) );
  INVX1 U1938 ( .A(\reg_mem[44][3] ), .Y(n1912) );
  MUX2X1 U1939 ( .B(n1914), .A(n1252), .S(n1915), .Y(n977) );
  INVX1 U1940 ( .A(\reg_mem[45][3] ), .Y(n1914) );
  MUX2X1 U1941 ( .B(n1916), .A(n1252), .S(n1917), .Y(n976) );
  INVX1 U1942 ( .A(\reg_mem[46][3] ), .Y(n1916) );
  MUX2X1 U1943 ( .B(n1918), .A(n1252), .S(n1919), .Y(n975) );
  INVX1 U1944 ( .A(\reg_mem[47][3] ), .Y(n1918) );
  MUX2X1 U1945 ( .B(n1920), .A(n1252), .S(n1921), .Y(n974) );
  INVX1 U1946 ( .A(\reg_mem[48][3] ), .Y(n1920) );
  MUX2X1 U1947 ( .B(n1922), .A(n1252), .S(n1923), .Y(n973) );
  INVX1 U1948 ( .A(\reg_mem[49][3] ), .Y(n1922) );
  MUX2X1 U1949 ( .B(n1924), .A(n1252), .S(n1925), .Y(n972) );
  INVX1 U1950 ( .A(\reg_mem[50][3] ), .Y(n1924) );
  MUX2X1 U1951 ( .B(n1926), .A(n1252), .S(n1927), .Y(n971) );
  INVX1 U1952 ( .A(\reg_mem[51][3] ), .Y(n1926) );
  MUX2X1 U1953 ( .B(n1928), .A(n1252), .S(n1929), .Y(n970) );
  INVX1 U1954 ( .A(\reg_mem[52][3] ), .Y(n1928) );
  MUX2X1 U1955 ( .B(n1930), .A(n1252), .S(n1931), .Y(n969) );
  INVX1 U1956 ( .A(\reg_mem[53][3] ), .Y(n1930) );
  MUX2X1 U1957 ( .B(n1932), .A(n1252), .S(n1933), .Y(n968) );
  INVX1 U1958 ( .A(\reg_mem[54][3] ), .Y(n1932) );
  MUX2X1 U1959 ( .B(n1934), .A(n1252), .S(n1935), .Y(n967) );
  INVX1 U1960 ( .A(\reg_mem[55][3] ), .Y(n1934) );
  MUX2X1 U1961 ( .B(n1936), .A(n1252), .S(n1937), .Y(n966) );
  INVX1 U1962 ( .A(\reg_mem[56][3] ), .Y(n1936) );
  MUX2X1 U1963 ( .B(n1938), .A(n1252), .S(n1939), .Y(n965) );
  INVX1 U1964 ( .A(\reg_mem[57][3] ), .Y(n1938) );
  MUX2X1 U1965 ( .B(n1940), .A(n1252), .S(n1941), .Y(n964) );
  INVX1 U1966 ( .A(\reg_mem[58][3] ), .Y(n1940) );
  MUX2X1 U1967 ( .B(n1942), .A(n1252), .S(n1943), .Y(n963) );
  INVX1 U1968 ( .A(\reg_mem[59][3] ), .Y(n1942) );
  MUX2X1 U1969 ( .B(n1944), .A(n1252), .S(n1945), .Y(n962) );
  INVX1 U1970 ( .A(\reg_mem[60][3] ), .Y(n1944) );
  MUX2X1 U1971 ( .B(n1946), .A(n1252), .S(n1947), .Y(n961) );
  INVX1 U1972 ( .A(\reg_mem[61][3] ), .Y(n1946) );
  MUX2X1 U1973 ( .B(n1948), .A(n1252), .S(n1949), .Y(n960) );
  INVX1 U1974 ( .A(\reg_mem[62][3] ), .Y(n1948) );
  MUX2X1 U1975 ( .B(n1950), .A(n1238), .S(n1952), .Y(n959) );
  INVX1 U1976 ( .A(\reg_mem[63][4] ), .Y(n1950) );
  MUX2X1 U1977 ( .B(n1953), .A(n1238), .S(n1954), .Y(n958) );
  INVX1 U1978 ( .A(\reg_mem[0][4] ), .Y(n1953) );
  MUX2X1 U1979 ( .B(n1955), .A(n1238), .S(n1956), .Y(n957) );
  INVX1 U1980 ( .A(\reg_mem[1][4] ), .Y(n1955) );
  MUX2X1 U1981 ( .B(n1957), .A(n1238), .S(n1958), .Y(n956) );
  INVX1 U1982 ( .A(\reg_mem[2][4] ), .Y(n1957) );
  MUX2X1 U1983 ( .B(n1959), .A(n1238), .S(n1960), .Y(n955) );
  INVX1 U1984 ( .A(\reg_mem[3][4] ), .Y(n1959) );
  MUX2X1 U1985 ( .B(n1961), .A(n1238), .S(n1962), .Y(n954) );
  INVX1 U1986 ( .A(\reg_mem[4][4] ), .Y(n1961) );
  MUX2X1 U1987 ( .B(n1963), .A(n1238), .S(n1964), .Y(n953) );
  INVX1 U1988 ( .A(\reg_mem[5][4] ), .Y(n1963) );
  MUX2X1 U1989 ( .B(n1965), .A(n1238), .S(n1966), .Y(n952) );
  INVX1 U1990 ( .A(\reg_mem[6][4] ), .Y(n1965) );
  MUX2X1 U1991 ( .B(n1967), .A(n1238), .S(n1968), .Y(n951) );
  INVX1 U1992 ( .A(\reg_mem[7][4] ), .Y(n1967) );
  MUX2X1 U1993 ( .B(n1969), .A(n1238), .S(n1970), .Y(n950) );
  INVX1 U1994 ( .A(\reg_mem[8][4] ), .Y(n1969) );
  MUX2X1 U1995 ( .B(n1971), .A(n1238), .S(n1972), .Y(n949) );
  INVX1 U1996 ( .A(\reg_mem[9][4] ), .Y(n1971) );
  MUX2X1 U1997 ( .B(n1973), .A(n1238), .S(n1974), .Y(n948) );
  INVX1 U1998 ( .A(\reg_mem[10][4] ), .Y(n1973) );
  MUX2X1 U1999 ( .B(n1975), .A(n1238), .S(n1976), .Y(n947) );
  INVX1 U2000 ( .A(\reg_mem[11][4] ), .Y(n1975) );
  MUX2X1 U2001 ( .B(n1977), .A(n1238), .S(n1978), .Y(n946) );
  INVX1 U2002 ( .A(\reg_mem[12][4] ), .Y(n1977) );
  MUX2X1 U2003 ( .B(n1979), .A(n1238), .S(n1980), .Y(n945) );
  INVX1 U2004 ( .A(\reg_mem[13][4] ), .Y(n1979) );
  MUX2X1 U2005 ( .B(n1981), .A(n1238), .S(n1982), .Y(n944) );
  INVX1 U2006 ( .A(\reg_mem[14][4] ), .Y(n1981) );
  MUX2X1 U2007 ( .B(n1983), .A(n1238), .S(n1984), .Y(n943) );
  INVX1 U2008 ( .A(\reg_mem[15][4] ), .Y(n1983) );
  MUX2X1 U2009 ( .B(n1985), .A(n1238), .S(n1986), .Y(n942) );
  INVX1 U2010 ( .A(\reg_mem[16][4] ), .Y(n1985) );
  MUX2X1 U2011 ( .B(n1987), .A(n1238), .S(n1988), .Y(n941) );
  INVX1 U2012 ( .A(\reg_mem[17][4] ), .Y(n1987) );
  MUX2X1 U2013 ( .B(n1989), .A(n1238), .S(n1990), .Y(n940) );
  INVX1 U2014 ( .A(\reg_mem[18][4] ), .Y(n1989) );
  MUX2X1 U2015 ( .B(n1991), .A(n1238), .S(n1992), .Y(n939) );
  INVX1 U2016 ( .A(\reg_mem[19][4] ), .Y(n1991) );
  MUX2X1 U2017 ( .B(n1993), .A(n1238), .S(n1994), .Y(n938) );
  INVX1 U2018 ( .A(\reg_mem[20][4] ), .Y(n1993) );
  MUX2X1 U2019 ( .B(n1995), .A(n1238), .S(n1996), .Y(n937) );
  INVX1 U2020 ( .A(\reg_mem[21][4] ), .Y(n1995) );
  MUX2X1 U2021 ( .B(n1997), .A(n1238), .S(n1998), .Y(n936) );
  INVX1 U2022 ( .A(\reg_mem[22][4] ), .Y(n1997) );
  MUX2X1 U2023 ( .B(n1999), .A(n1238), .S(n1871), .Y(n935) );
  INVX1 U2024 ( .A(\reg_mem[23][4] ), .Y(n1999) );
  MUX2X1 U2025 ( .B(n2000), .A(n1238), .S(n1873), .Y(n934) );
  INVX1 U2026 ( .A(\reg_mem[24][4] ), .Y(n2000) );
  MUX2X1 U2027 ( .B(n2001), .A(n1238), .S(n1875), .Y(n933) );
  INVX1 U2028 ( .A(\reg_mem[25][4] ), .Y(n2001) );
  MUX2X1 U2029 ( .B(n2002), .A(n1238), .S(n1877), .Y(n932) );
  INVX1 U2030 ( .A(\reg_mem[26][4] ), .Y(n2002) );
  MUX2X1 U2031 ( .B(n2003), .A(n1238), .S(n1879), .Y(n931) );
  INVX1 U2032 ( .A(\reg_mem[27][4] ), .Y(n2003) );
  MUX2X1 U2033 ( .B(n2004), .A(n1238), .S(n1881), .Y(n930) );
  INVX1 U2034 ( .A(\reg_mem[28][4] ), .Y(n2004) );
  MUX2X1 U2035 ( .B(n2005), .A(n1238), .S(n1883), .Y(n929) );
  INVX1 U2036 ( .A(\reg_mem[29][4] ), .Y(n2005) );
  MUX2X1 U2037 ( .B(n2006), .A(n1238), .S(n1885), .Y(n928) );
  INVX1 U2038 ( .A(\reg_mem[30][4] ), .Y(n2006) );
  MUX2X1 U2039 ( .B(n2007), .A(n1238), .S(n1887), .Y(n927) );
  INVX1 U2040 ( .A(\reg_mem[31][4] ), .Y(n2007) );
  MUX2X1 U2041 ( .B(n2008), .A(n1238), .S(n1889), .Y(n926) );
  INVX1 U2042 ( .A(\reg_mem[32][4] ), .Y(n2008) );
  MUX2X1 U2043 ( .B(n2009), .A(n1238), .S(n1891), .Y(n925) );
  INVX1 U2044 ( .A(\reg_mem[33][4] ), .Y(n2009) );
  MUX2X1 U2045 ( .B(n2010), .A(n1238), .S(n1893), .Y(n924) );
  INVX1 U2046 ( .A(\reg_mem[34][4] ), .Y(n2010) );
  MUX2X1 U2047 ( .B(n2011), .A(n1238), .S(n1895), .Y(n923) );
  INVX1 U2048 ( .A(\reg_mem[35][4] ), .Y(n2011) );
  MUX2X1 U2049 ( .B(n2012), .A(n1238), .S(n1897), .Y(n922) );
  INVX1 U2050 ( .A(\reg_mem[36][4] ), .Y(n2012) );
  MUX2X1 U2051 ( .B(n2013), .A(n1238), .S(n1899), .Y(n921) );
  INVX1 U2052 ( .A(\reg_mem[37][4] ), .Y(n2013) );
  MUX2X1 U2053 ( .B(n2014), .A(n1238), .S(n1901), .Y(n920) );
  INVX1 U2054 ( .A(\reg_mem[38][4] ), .Y(n2014) );
  MUX2X1 U2055 ( .B(n2015), .A(n1238), .S(n1903), .Y(n919) );
  INVX1 U2056 ( .A(\reg_mem[39][4] ), .Y(n2015) );
  MUX2X1 U2057 ( .B(n2016), .A(n1238), .S(n1905), .Y(n918) );
  INVX1 U2058 ( .A(\reg_mem[40][4] ), .Y(n2016) );
  MUX2X1 U2059 ( .B(n2017), .A(n1238), .S(n1907), .Y(n917) );
  INVX1 U2060 ( .A(\reg_mem[41][4] ), .Y(n2017) );
  MUX2X1 U2061 ( .B(n2018), .A(n1238), .S(n1909), .Y(n916) );
  INVX1 U2062 ( .A(\reg_mem[42][4] ), .Y(n2018) );
  MUX2X1 U2063 ( .B(n2019), .A(n1238), .S(n1911), .Y(n915) );
  INVX1 U2064 ( .A(\reg_mem[43][4] ), .Y(n2019) );
  MUX2X1 U2065 ( .B(n2020), .A(n1238), .S(n1913), .Y(n914) );
  INVX1 U2066 ( .A(\reg_mem[44][4] ), .Y(n2020) );
  MUX2X1 U2067 ( .B(n2021), .A(n1238), .S(n1915), .Y(n913) );
  INVX1 U2068 ( .A(\reg_mem[45][4] ), .Y(n2021) );
  MUX2X1 U2069 ( .B(n2022), .A(n1238), .S(n1917), .Y(n912) );
  INVX1 U2070 ( .A(\reg_mem[46][4] ), .Y(n2022) );
  MUX2X1 U2071 ( .B(n2023), .A(n1238), .S(n1919), .Y(n911) );
  INVX1 U2072 ( .A(\reg_mem[47][4] ), .Y(n2023) );
  MUX2X1 U2073 ( .B(n2024), .A(n1238), .S(n1921), .Y(n910) );
  INVX1 U2074 ( .A(\reg_mem[48][4] ), .Y(n2024) );
  MUX2X1 U2075 ( .B(n2025), .A(n1238), .S(n1923), .Y(n909) );
  INVX1 U2076 ( .A(\reg_mem[49][4] ), .Y(n2025) );
  MUX2X1 U2077 ( .B(n2026), .A(n1238), .S(n1925), .Y(n908) );
  INVX1 U2078 ( .A(\reg_mem[50][4] ), .Y(n2026) );
  MUX2X1 U2079 ( .B(n2027), .A(n1238), .S(n1927), .Y(n907) );
  INVX1 U2080 ( .A(\reg_mem[51][4] ), .Y(n2027) );
  MUX2X1 U2081 ( .B(n2028), .A(n1238), .S(n1929), .Y(n906) );
  INVX1 U2082 ( .A(\reg_mem[52][4] ), .Y(n2028) );
  MUX2X1 U2083 ( .B(n2029), .A(n1238), .S(n1931), .Y(n905) );
  INVX1 U2084 ( .A(\reg_mem[53][4] ), .Y(n2029) );
  MUX2X1 U2085 ( .B(n2030), .A(n1238), .S(n1933), .Y(n904) );
  INVX1 U2086 ( .A(\reg_mem[54][4] ), .Y(n2030) );
  MUX2X1 U2087 ( .B(n2031), .A(n1238), .S(n1935), .Y(n903) );
  INVX1 U2088 ( .A(\reg_mem[55][4] ), .Y(n2031) );
  MUX2X1 U2089 ( .B(n2032), .A(n1238), .S(n1937), .Y(n902) );
  INVX1 U2090 ( .A(\reg_mem[56][4] ), .Y(n2032) );
  MUX2X1 U2091 ( .B(n2033), .A(n1238), .S(n1939), .Y(n901) );
  INVX1 U2092 ( .A(\reg_mem[57][4] ), .Y(n2033) );
  MUX2X1 U2093 ( .B(n2034), .A(n1238), .S(n1941), .Y(n900) );
  INVX1 U2094 ( .A(\reg_mem[58][4] ), .Y(n2034) );
  MUX2X1 U2095 ( .B(n2035), .A(n1238), .S(n1943), .Y(n899) );
  INVX1 U2096 ( .A(\reg_mem[59][4] ), .Y(n2035) );
  MUX2X1 U2097 ( .B(n2036), .A(n1238), .S(n1945), .Y(n898) );
  INVX1 U2098 ( .A(\reg_mem[60][4] ), .Y(n2036) );
  MUX2X1 U2099 ( .B(n2037), .A(n1238), .S(n1947), .Y(n897) );
  INVX1 U2100 ( .A(\reg_mem[61][4] ), .Y(n2037) );
  MUX2X1 U2101 ( .B(n2038), .A(n1238), .S(n1949), .Y(n896) );
  AOI22X1 U2102 ( .A(rx_packet_data[4]), .B(n2039), .C(tx_data[4]), .D(n2040), 
        .Y(n1951) );
  INVX1 U2103 ( .A(\reg_mem[62][4] ), .Y(n2038) );
  MUX2X1 U2104 ( .B(n2041), .A(n1240), .S(n1952), .Y(n895) );
  INVX1 U2105 ( .A(\reg_mem[63][5] ), .Y(n2041) );
  MUX2X1 U2106 ( .B(n2043), .A(n1240), .S(n1954), .Y(n894) );
  INVX1 U2107 ( .A(\reg_mem[0][5] ), .Y(n2043) );
  MUX2X1 U2108 ( .B(n2044), .A(n1240), .S(n1956), .Y(n893) );
  INVX1 U2109 ( .A(\reg_mem[1][5] ), .Y(n2044) );
  MUX2X1 U2110 ( .B(n2045), .A(n1240), .S(n1958), .Y(n892) );
  INVX1 U2111 ( .A(\reg_mem[2][5] ), .Y(n2045) );
  MUX2X1 U2112 ( .B(n2046), .A(n1240), .S(n1960), .Y(n891) );
  INVX1 U2113 ( .A(\reg_mem[3][5] ), .Y(n2046) );
  MUX2X1 U2114 ( .B(n2047), .A(n1240), .S(n1962), .Y(n890) );
  INVX1 U2115 ( .A(\reg_mem[4][5] ), .Y(n2047) );
  MUX2X1 U2116 ( .B(n2048), .A(n1240), .S(n1964), .Y(n889) );
  INVX1 U2117 ( .A(\reg_mem[5][5] ), .Y(n2048) );
  MUX2X1 U2118 ( .B(n2049), .A(n1240), .S(n1966), .Y(n888) );
  INVX1 U2119 ( .A(\reg_mem[6][5] ), .Y(n2049) );
  MUX2X1 U2120 ( .B(n2050), .A(n1240), .S(n1968), .Y(n887) );
  INVX1 U2121 ( .A(\reg_mem[7][5] ), .Y(n2050) );
  MUX2X1 U2122 ( .B(n2051), .A(n1240), .S(n1970), .Y(n886) );
  INVX1 U2123 ( .A(\reg_mem[8][5] ), .Y(n2051) );
  MUX2X1 U2124 ( .B(n2052), .A(n1240), .S(n1972), .Y(n885) );
  INVX1 U2125 ( .A(\reg_mem[9][5] ), .Y(n2052) );
  MUX2X1 U2126 ( .B(n2053), .A(n1240), .S(n1974), .Y(n884) );
  INVX1 U2127 ( .A(\reg_mem[10][5] ), .Y(n2053) );
  MUX2X1 U2128 ( .B(n2054), .A(n1240), .S(n1976), .Y(n883) );
  INVX1 U2129 ( .A(\reg_mem[11][5] ), .Y(n2054) );
  MUX2X1 U2130 ( .B(n2055), .A(n1240), .S(n1978), .Y(n882) );
  INVX1 U2131 ( .A(\reg_mem[12][5] ), .Y(n2055) );
  MUX2X1 U2132 ( .B(n2056), .A(n1240), .S(n1980), .Y(n881) );
  INVX1 U2133 ( .A(\reg_mem[13][5] ), .Y(n2056) );
  MUX2X1 U2134 ( .B(n2057), .A(n1240), .S(n1982), .Y(n880) );
  INVX1 U2135 ( .A(\reg_mem[14][5] ), .Y(n2057) );
  MUX2X1 U2136 ( .B(n2058), .A(n1240), .S(n1984), .Y(n879) );
  INVX1 U2137 ( .A(\reg_mem[15][5] ), .Y(n2058) );
  MUX2X1 U2138 ( .B(n2059), .A(n1240), .S(n1986), .Y(n878) );
  INVX1 U2139 ( .A(\reg_mem[16][5] ), .Y(n2059) );
  MUX2X1 U2140 ( .B(n2060), .A(n1240), .S(n1988), .Y(n877) );
  INVX1 U2141 ( .A(\reg_mem[17][5] ), .Y(n2060) );
  MUX2X1 U2142 ( .B(n2061), .A(n1240), .S(n1990), .Y(n876) );
  INVX1 U2143 ( .A(\reg_mem[18][5] ), .Y(n2061) );
  MUX2X1 U2144 ( .B(n2062), .A(n1240), .S(n1992), .Y(n875) );
  INVX1 U2145 ( .A(\reg_mem[19][5] ), .Y(n2062) );
  MUX2X1 U2146 ( .B(n2063), .A(n1240), .S(n1994), .Y(n874) );
  INVX1 U2147 ( .A(\reg_mem[20][5] ), .Y(n2063) );
  MUX2X1 U2148 ( .B(n2064), .A(n1240), .S(n1996), .Y(n873) );
  INVX1 U2149 ( .A(\reg_mem[21][5] ), .Y(n2064) );
  MUX2X1 U2150 ( .B(n2065), .A(n1240), .S(n1998), .Y(n872) );
  INVX1 U2151 ( .A(\reg_mem[22][5] ), .Y(n2065) );
  MUX2X1 U2152 ( .B(n2066), .A(n1240), .S(n1871), .Y(n871) );
  INVX1 U2153 ( .A(\reg_mem[23][5] ), .Y(n2066) );
  MUX2X1 U2154 ( .B(n2067), .A(n1240), .S(n1873), .Y(n870) );
  INVX1 U2155 ( .A(\reg_mem[24][5] ), .Y(n2067) );
  MUX2X1 U2156 ( .B(n2068), .A(n1240), .S(n1875), .Y(n869) );
  INVX1 U2157 ( .A(\reg_mem[25][5] ), .Y(n2068) );
  MUX2X1 U2158 ( .B(n2069), .A(n1240), .S(n1877), .Y(n868) );
  INVX1 U2159 ( .A(\reg_mem[26][5] ), .Y(n2069) );
  MUX2X1 U2160 ( .B(n2070), .A(n1240), .S(n1879), .Y(n867) );
  INVX1 U2161 ( .A(\reg_mem[27][5] ), .Y(n2070) );
  MUX2X1 U2162 ( .B(n2071), .A(n1240), .S(n1881), .Y(n866) );
  INVX1 U2163 ( .A(\reg_mem[28][5] ), .Y(n2071) );
  MUX2X1 U2164 ( .B(n2072), .A(n1240), .S(n1883), .Y(n865) );
  INVX1 U2165 ( .A(\reg_mem[29][5] ), .Y(n2072) );
  MUX2X1 U2166 ( .B(n2073), .A(n1240), .S(n1885), .Y(n864) );
  INVX1 U2167 ( .A(\reg_mem[30][5] ), .Y(n2073) );
  MUX2X1 U2168 ( .B(n2074), .A(n1240), .S(n1887), .Y(n863) );
  INVX1 U2169 ( .A(\reg_mem[31][5] ), .Y(n2074) );
  MUX2X1 U2170 ( .B(n2075), .A(n1240), .S(n1889), .Y(n862) );
  INVX1 U2171 ( .A(\reg_mem[32][5] ), .Y(n2075) );
  MUX2X1 U2172 ( .B(n2076), .A(n1240), .S(n1891), .Y(n861) );
  INVX1 U2173 ( .A(\reg_mem[33][5] ), .Y(n2076) );
  MUX2X1 U2174 ( .B(n2077), .A(n1240), .S(n1893), .Y(n860) );
  INVX1 U2175 ( .A(\reg_mem[34][5] ), .Y(n2077) );
  MUX2X1 U2176 ( .B(n2078), .A(n1240), .S(n1895), .Y(n859) );
  INVX1 U2177 ( .A(\reg_mem[35][5] ), .Y(n2078) );
  MUX2X1 U2178 ( .B(n2079), .A(n1240), .S(n1897), .Y(n858) );
  INVX1 U2179 ( .A(\reg_mem[36][5] ), .Y(n2079) );
  MUX2X1 U2180 ( .B(n2080), .A(n1240), .S(n1899), .Y(n857) );
  INVX1 U2181 ( .A(\reg_mem[37][5] ), .Y(n2080) );
  MUX2X1 U2182 ( .B(n2081), .A(n1240), .S(n1901), .Y(n856) );
  INVX1 U2183 ( .A(\reg_mem[38][5] ), .Y(n2081) );
  MUX2X1 U2184 ( .B(n2082), .A(n1240), .S(n1903), .Y(n855) );
  INVX1 U2185 ( .A(\reg_mem[39][5] ), .Y(n2082) );
  MUX2X1 U2186 ( .B(n2083), .A(n1240), .S(n1905), .Y(n854) );
  INVX1 U2187 ( .A(\reg_mem[40][5] ), .Y(n2083) );
  MUX2X1 U2188 ( .B(n2084), .A(n1240), .S(n1907), .Y(n853) );
  INVX1 U2189 ( .A(\reg_mem[41][5] ), .Y(n2084) );
  MUX2X1 U2190 ( .B(n2085), .A(n1240), .S(n1909), .Y(n852) );
  INVX1 U2191 ( .A(\reg_mem[42][5] ), .Y(n2085) );
  MUX2X1 U2192 ( .B(n2086), .A(n1240), .S(n1911), .Y(n851) );
  INVX1 U2193 ( .A(\reg_mem[43][5] ), .Y(n2086) );
  MUX2X1 U2194 ( .B(n2087), .A(n1240), .S(n1913), .Y(n850) );
  INVX1 U2195 ( .A(\reg_mem[44][5] ), .Y(n2087) );
  MUX2X1 U2196 ( .B(n2088), .A(n1240), .S(n1915), .Y(n849) );
  INVX1 U2197 ( .A(\reg_mem[45][5] ), .Y(n2088) );
  MUX2X1 U2198 ( .B(n2089), .A(n1240), .S(n1917), .Y(n848) );
  INVX1 U2199 ( .A(\reg_mem[46][5] ), .Y(n2089) );
  MUX2X1 U2200 ( .B(n2090), .A(n1240), .S(n1919), .Y(n847) );
  INVX1 U2201 ( .A(\reg_mem[47][5] ), .Y(n2090) );
  MUX2X1 U2202 ( .B(n2091), .A(n1240), .S(n1921), .Y(n846) );
  INVX1 U2203 ( .A(\reg_mem[48][5] ), .Y(n2091) );
  MUX2X1 U2204 ( .B(n2092), .A(n1240), .S(n1923), .Y(n845) );
  INVX1 U2205 ( .A(\reg_mem[49][5] ), .Y(n2092) );
  MUX2X1 U2206 ( .B(n2093), .A(n1240), .S(n1925), .Y(n844) );
  INVX1 U2207 ( .A(\reg_mem[50][5] ), .Y(n2093) );
  MUX2X1 U2208 ( .B(n2094), .A(n1240), .S(n1927), .Y(n843) );
  INVX1 U2209 ( .A(\reg_mem[51][5] ), .Y(n2094) );
  MUX2X1 U2210 ( .B(n2095), .A(n1240), .S(n1929), .Y(n842) );
  INVX1 U2211 ( .A(\reg_mem[52][5] ), .Y(n2095) );
  MUX2X1 U2212 ( .B(n2096), .A(n1240), .S(n1931), .Y(n841) );
  INVX1 U2213 ( .A(\reg_mem[53][5] ), .Y(n2096) );
  MUX2X1 U2214 ( .B(n2097), .A(n1240), .S(n1933), .Y(n840) );
  INVX1 U2215 ( .A(\reg_mem[54][5] ), .Y(n2097) );
  MUX2X1 U2216 ( .B(n2098), .A(n1240), .S(n1935), .Y(n839) );
  INVX1 U2217 ( .A(\reg_mem[55][5] ), .Y(n2098) );
  MUX2X1 U2218 ( .B(n2099), .A(n1240), .S(n1937), .Y(n838) );
  INVX1 U2219 ( .A(\reg_mem[56][5] ), .Y(n2099) );
  MUX2X1 U2220 ( .B(n2100), .A(n1240), .S(n1939), .Y(n837) );
  INVX1 U2221 ( .A(\reg_mem[57][5] ), .Y(n2100) );
  MUX2X1 U2222 ( .B(n2101), .A(n1240), .S(n1941), .Y(n836) );
  INVX1 U2223 ( .A(\reg_mem[58][5] ), .Y(n2101) );
  MUX2X1 U2224 ( .B(n2102), .A(n1240), .S(n1943), .Y(n835) );
  INVX1 U2225 ( .A(\reg_mem[59][5] ), .Y(n2102) );
  MUX2X1 U2226 ( .B(n2103), .A(n1240), .S(n1945), .Y(n834) );
  INVX1 U2227 ( .A(\reg_mem[60][5] ), .Y(n2103) );
  MUX2X1 U2228 ( .B(n2104), .A(n1240), .S(n1947), .Y(n833) );
  INVX1 U2229 ( .A(\reg_mem[61][5] ), .Y(n2104) );
  MUX2X1 U2230 ( .B(n2105), .A(n1240), .S(n1949), .Y(n832) );
  AOI22X1 U2231 ( .A(rx_packet_data[5]), .B(n2039), .C(tx_data[5]), .D(n2040), 
        .Y(n2042) );
  INVX1 U2232 ( .A(\reg_mem[62][5] ), .Y(n2105) );
  MUX2X1 U2233 ( .B(n2106), .A(n1242), .S(n1952), .Y(n831) );
  INVX1 U2234 ( .A(\reg_mem[63][6] ), .Y(n2106) );
  MUX2X1 U2235 ( .B(n2108), .A(n1242), .S(n1954), .Y(n830) );
  INVX1 U2236 ( .A(\reg_mem[0][6] ), .Y(n2108) );
  MUX2X1 U2237 ( .B(n2109), .A(n1242), .S(n1956), .Y(n829) );
  INVX1 U2238 ( .A(\reg_mem[1][6] ), .Y(n2109) );
  MUX2X1 U2239 ( .B(n2110), .A(n1242), .S(n1958), .Y(n828) );
  INVX1 U2240 ( .A(\reg_mem[2][6] ), .Y(n2110) );
  MUX2X1 U2241 ( .B(n2111), .A(n1242), .S(n1960), .Y(n827) );
  INVX1 U2242 ( .A(\reg_mem[3][6] ), .Y(n2111) );
  MUX2X1 U2243 ( .B(n2112), .A(n1242), .S(n1962), .Y(n826) );
  INVX1 U2244 ( .A(\reg_mem[4][6] ), .Y(n2112) );
  MUX2X1 U2245 ( .B(n2113), .A(n1242), .S(n1964), .Y(n825) );
  INVX1 U2246 ( .A(\reg_mem[5][6] ), .Y(n2113) );
  MUX2X1 U2247 ( .B(n2114), .A(n1242), .S(n1966), .Y(n824) );
  INVX1 U2248 ( .A(\reg_mem[6][6] ), .Y(n2114) );
  MUX2X1 U2249 ( .B(n2115), .A(n1242), .S(n1968), .Y(n823) );
  INVX1 U2250 ( .A(\reg_mem[7][6] ), .Y(n2115) );
  MUX2X1 U2251 ( .B(n2116), .A(n1242), .S(n1970), .Y(n822) );
  INVX1 U2252 ( .A(\reg_mem[8][6] ), .Y(n2116) );
  MUX2X1 U2253 ( .B(n2117), .A(n1242), .S(n1972), .Y(n821) );
  INVX1 U2254 ( .A(\reg_mem[9][6] ), .Y(n2117) );
  MUX2X1 U2255 ( .B(n2118), .A(n1242), .S(n1974), .Y(n820) );
  INVX1 U2256 ( .A(\reg_mem[10][6] ), .Y(n2118) );
  MUX2X1 U2257 ( .B(n2119), .A(n1242), .S(n1976), .Y(n819) );
  INVX1 U2258 ( .A(\reg_mem[11][6] ), .Y(n2119) );
  MUX2X1 U2259 ( .B(n2120), .A(n1242), .S(n1978), .Y(n818) );
  INVX1 U2260 ( .A(\reg_mem[12][6] ), .Y(n2120) );
  MUX2X1 U2261 ( .B(n2121), .A(n1242), .S(n1980), .Y(n817) );
  INVX1 U2262 ( .A(\reg_mem[13][6] ), .Y(n2121) );
  MUX2X1 U2263 ( .B(n2122), .A(n1242), .S(n1982), .Y(n816) );
  INVX1 U2264 ( .A(\reg_mem[14][6] ), .Y(n2122) );
  MUX2X1 U2265 ( .B(n2123), .A(n1242), .S(n1984), .Y(n815) );
  INVX1 U2266 ( .A(\reg_mem[15][6] ), .Y(n2123) );
  MUX2X1 U2267 ( .B(n2124), .A(n1242), .S(n1986), .Y(n814) );
  INVX1 U2268 ( .A(\reg_mem[16][6] ), .Y(n2124) );
  MUX2X1 U2269 ( .B(n2125), .A(n1242), .S(n1988), .Y(n813) );
  INVX1 U2270 ( .A(\reg_mem[17][6] ), .Y(n2125) );
  MUX2X1 U2271 ( .B(n2126), .A(n1242), .S(n1990), .Y(n812) );
  INVX1 U2272 ( .A(\reg_mem[18][6] ), .Y(n2126) );
  MUX2X1 U2273 ( .B(n2127), .A(n1242), .S(n1992), .Y(n811) );
  INVX1 U2274 ( .A(\reg_mem[19][6] ), .Y(n2127) );
  MUX2X1 U2275 ( .B(n2128), .A(n1242), .S(n1994), .Y(n810) );
  INVX1 U2276 ( .A(\reg_mem[20][6] ), .Y(n2128) );
  MUX2X1 U2277 ( .B(n2129), .A(n1242), .S(n1996), .Y(n809) );
  INVX1 U2278 ( .A(\reg_mem[21][6] ), .Y(n2129) );
  MUX2X1 U2279 ( .B(n2130), .A(n1242), .S(n1998), .Y(n808) );
  INVX1 U2280 ( .A(\reg_mem[22][6] ), .Y(n2130) );
  MUX2X1 U2281 ( .B(n2131), .A(n1242), .S(n1871), .Y(n807) );
  INVX1 U2282 ( .A(\reg_mem[23][6] ), .Y(n2131) );
  MUX2X1 U2283 ( .B(n2132), .A(n1242), .S(n1873), .Y(n806) );
  INVX1 U2284 ( .A(\reg_mem[24][6] ), .Y(n2132) );
  MUX2X1 U2285 ( .B(n2133), .A(n1242), .S(n1875), .Y(n805) );
  INVX1 U2286 ( .A(\reg_mem[25][6] ), .Y(n2133) );
  MUX2X1 U2287 ( .B(n2134), .A(n1242), .S(n1877), .Y(n804) );
  INVX1 U2288 ( .A(\reg_mem[26][6] ), .Y(n2134) );
  MUX2X1 U2289 ( .B(n2135), .A(n1242), .S(n1879), .Y(n803) );
  INVX1 U2290 ( .A(\reg_mem[27][6] ), .Y(n2135) );
  MUX2X1 U2291 ( .B(n2136), .A(n1242), .S(n1881), .Y(n802) );
  INVX1 U2292 ( .A(\reg_mem[28][6] ), .Y(n2136) );
  MUX2X1 U2293 ( .B(n2137), .A(n1242), .S(n1883), .Y(n801) );
  INVX1 U2294 ( .A(\reg_mem[29][6] ), .Y(n2137) );
  MUX2X1 U2295 ( .B(n2138), .A(n1242), .S(n1885), .Y(n800) );
  INVX1 U2296 ( .A(\reg_mem[30][6] ), .Y(n2138) );
  MUX2X1 U2297 ( .B(n2139), .A(n1242), .S(n1887), .Y(n799) );
  INVX1 U2298 ( .A(\reg_mem[31][6] ), .Y(n2139) );
  MUX2X1 U2299 ( .B(n2140), .A(n1242), .S(n1889), .Y(n798) );
  INVX1 U2300 ( .A(\reg_mem[32][6] ), .Y(n2140) );
  MUX2X1 U2301 ( .B(n2141), .A(n1242), .S(n1891), .Y(n797) );
  INVX1 U2302 ( .A(\reg_mem[33][6] ), .Y(n2141) );
  MUX2X1 U2303 ( .B(n2142), .A(n1242), .S(n1893), .Y(n796) );
  INVX1 U2304 ( .A(\reg_mem[34][6] ), .Y(n2142) );
  MUX2X1 U2305 ( .B(n2143), .A(n1242), .S(n1895), .Y(n795) );
  INVX1 U2306 ( .A(\reg_mem[35][6] ), .Y(n2143) );
  MUX2X1 U2307 ( .B(n2144), .A(n1242), .S(n1897), .Y(n794) );
  INVX1 U2308 ( .A(\reg_mem[36][6] ), .Y(n2144) );
  MUX2X1 U2309 ( .B(n2145), .A(n1242), .S(n1899), .Y(n793) );
  INVX1 U2310 ( .A(\reg_mem[37][6] ), .Y(n2145) );
  MUX2X1 U2311 ( .B(n2146), .A(n1242), .S(n1901), .Y(n792) );
  INVX1 U2312 ( .A(\reg_mem[38][6] ), .Y(n2146) );
  MUX2X1 U2313 ( .B(n2147), .A(n1242), .S(n1903), .Y(n791) );
  INVX1 U2314 ( .A(\reg_mem[39][6] ), .Y(n2147) );
  MUX2X1 U2315 ( .B(n2148), .A(n1242), .S(n1905), .Y(n790) );
  INVX1 U2316 ( .A(\reg_mem[40][6] ), .Y(n2148) );
  MUX2X1 U2317 ( .B(n2149), .A(n1242), .S(n1907), .Y(n789) );
  INVX1 U2318 ( .A(\reg_mem[41][6] ), .Y(n2149) );
  MUX2X1 U2319 ( .B(n2150), .A(n1242), .S(n1909), .Y(n788) );
  INVX1 U2320 ( .A(\reg_mem[42][6] ), .Y(n2150) );
  MUX2X1 U2321 ( .B(n2151), .A(n1242), .S(n1911), .Y(n787) );
  INVX1 U2322 ( .A(\reg_mem[43][6] ), .Y(n2151) );
  MUX2X1 U2323 ( .B(n2152), .A(n1242), .S(n1913), .Y(n786) );
  INVX1 U2324 ( .A(\reg_mem[44][6] ), .Y(n2152) );
  MUX2X1 U2325 ( .B(n2153), .A(n1242), .S(n1915), .Y(n785) );
  INVX1 U2326 ( .A(\reg_mem[45][6] ), .Y(n2153) );
  MUX2X1 U2327 ( .B(n2154), .A(n1242), .S(n1917), .Y(n784) );
  INVX1 U2328 ( .A(\reg_mem[46][6] ), .Y(n2154) );
  MUX2X1 U2329 ( .B(n2155), .A(n1242), .S(n1919), .Y(n783) );
  INVX1 U2330 ( .A(\reg_mem[47][6] ), .Y(n2155) );
  MUX2X1 U2331 ( .B(n2156), .A(n1242), .S(n1921), .Y(n782) );
  INVX1 U2332 ( .A(\reg_mem[48][6] ), .Y(n2156) );
  MUX2X1 U2333 ( .B(n2157), .A(n1242), .S(n1923), .Y(n781) );
  INVX1 U2334 ( .A(\reg_mem[49][6] ), .Y(n2157) );
  MUX2X1 U2335 ( .B(n2158), .A(n1242), .S(n1925), .Y(n780) );
  INVX1 U2336 ( .A(\reg_mem[50][6] ), .Y(n2158) );
  MUX2X1 U2337 ( .B(n2159), .A(n1242), .S(n1927), .Y(n779) );
  INVX1 U2338 ( .A(\reg_mem[51][6] ), .Y(n2159) );
  MUX2X1 U2339 ( .B(n2160), .A(n1242), .S(n1929), .Y(n778) );
  INVX1 U2340 ( .A(\reg_mem[52][6] ), .Y(n2160) );
  MUX2X1 U2341 ( .B(n2161), .A(n1242), .S(n1931), .Y(n777) );
  INVX1 U2342 ( .A(\reg_mem[53][6] ), .Y(n2161) );
  MUX2X1 U2343 ( .B(n2162), .A(n1242), .S(n1933), .Y(n776) );
  INVX1 U2344 ( .A(\reg_mem[54][6] ), .Y(n2162) );
  MUX2X1 U2345 ( .B(n2163), .A(n1242), .S(n1935), .Y(n775) );
  INVX1 U2346 ( .A(\reg_mem[55][6] ), .Y(n2163) );
  MUX2X1 U2347 ( .B(n2164), .A(n1242), .S(n1937), .Y(n774) );
  INVX1 U2348 ( .A(\reg_mem[56][6] ), .Y(n2164) );
  MUX2X1 U2349 ( .B(n2165), .A(n1242), .S(n1939), .Y(n773) );
  INVX1 U2350 ( .A(\reg_mem[57][6] ), .Y(n2165) );
  MUX2X1 U2351 ( .B(n2166), .A(n1242), .S(n1941), .Y(n772) );
  INVX1 U2352 ( .A(\reg_mem[58][6] ), .Y(n2166) );
  MUX2X1 U2353 ( .B(n2167), .A(n1242), .S(n1943), .Y(n771) );
  INVX1 U2354 ( .A(\reg_mem[59][6] ), .Y(n2167) );
  MUX2X1 U2355 ( .B(n2168), .A(n1242), .S(n1945), .Y(n770) );
  INVX1 U2356 ( .A(\reg_mem[60][6] ), .Y(n2168) );
  MUX2X1 U2357 ( .B(n2169), .A(n1242), .S(n1947), .Y(n769) );
  INVX1 U2358 ( .A(\reg_mem[61][6] ), .Y(n2169) );
  MUX2X1 U2359 ( .B(n2170), .A(n1242), .S(n1949), .Y(n768) );
  AOI22X1 U2360 ( .A(rx_packet_data[6]), .B(n2039), .C(tx_data[6]), .D(n2040), 
        .Y(n2107) );
  INVX1 U2361 ( .A(\reg_mem[62][6] ), .Y(n2170) );
  MUX2X1 U2362 ( .B(n2171), .A(n1244), .S(n1952), .Y(n767) );
  INVX1 U2363 ( .A(\reg_mem[63][7] ), .Y(n2171) );
  MUX2X1 U2364 ( .B(n2173), .A(n1244), .S(n1954), .Y(n766) );
  INVX1 U2365 ( .A(\reg_mem[0][7] ), .Y(n2173) );
  MUX2X1 U2366 ( .B(n2174), .A(n1244), .S(n1956), .Y(n765) );
  INVX1 U2367 ( .A(\reg_mem[1][7] ), .Y(n2174) );
  MUX2X1 U2368 ( .B(n2175), .A(n1244), .S(n1958), .Y(n764) );
  INVX1 U2369 ( .A(\reg_mem[2][7] ), .Y(n2175) );
  MUX2X1 U2370 ( .B(n2176), .A(n1244), .S(n1960), .Y(n763) );
  INVX1 U2371 ( .A(\reg_mem[3][7] ), .Y(n2176) );
  MUX2X1 U2372 ( .B(n2177), .A(n1244), .S(n1962), .Y(n762) );
  INVX1 U2373 ( .A(\reg_mem[4][7] ), .Y(n2177) );
  MUX2X1 U2374 ( .B(n2178), .A(n1244), .S(n1964), .Y(n761) );
  INVX1 U2375 ( .A(\reg_mem[5][7] ), .Y(n2178) );
  MUX2X1 U2376 ( .B(n2179), .A(n1244), .S(n1966), .Y(n760) );
  INVX1 U2377 ( .A(\reg_mem[6][7] ), .Y(n2179) );
  MUX2X1 U2378 ( .B(n2180), .A(n1244), .S(n1968), .Y(n759) );
  INVX1 U2379 ( .A(\reg_mem[7][7] ), .Y(n2180) );
  MUX2X1 U2380 ( .B(n2181), .A(n1244), .S(n1970), .Y(n758) );
  INVX1 U2381 ( .A(\reg_mem[8][7] ), .Y(n2181) );
  MUX2X1 U2382 ( .B(n2182), .A(n1244), .S(n1972), .Y(n757) );
  INVX1 U2383 ( .A(\reg_mem[9][7] ), .Y(n2182) );
  MUX2X1 U2384 ( .B(n2183), .A(n1244), .S(n1974), .Y(n756) );
  INVX1 U2385 ( .A(\reg_mem[10][7] ), .Y(n2183) );
  MUX2X1 U2386 ( .B(n2184), .A(n1244), .S(n1976), .Y(n755) );
  INVX1 U2387 ( .A(\reg_mem[11][7] ), .Y(n2184) );
  MUX2X1 U2388 ( .B(n2185), .A(n1244), .S(n1978), .Y(n754) );
  INVX1 U2389 ( .A(\reg_mem[12][7] ), .Y(n2185) );
  MUX2X1 U2390 ( .B(n2186), .A(n1244), .S(n1980), .Y(n753) );
  INVX1 U2391 ( .A(\reg_mem[13][7] ), .Y(n2186) );
  MUX2X1 U2392 ( .B(n2187), .A(n1244), .S(n1982), .Y(n752) );
  INVX1 U2393 ( .A(\reg_mem[14][7] ), .Y(n2187) );
  MUX2X1 U2394 ( .B(n2188), .A(n1244), .S(n1984), .Y(n751) );
  INVX1 U2395 ( .A(\reg_mem[15][7] ), .Y(n2188) );
  MUX2X1 U2396 ( .B(n2189), .A(n1244), .S(n1986), .Y(n750) );
  INVX1 U2397 ( .A(\reg_mem[16][7] ), .Y(n2189) );
  MUX2X1 U2398 ( .B(n2190), .A(n1244), .S(n1988), .Y(n749) );
  INVX1 U2399 ( .A(\reg_mem[17][7] ), .Y(n2190) );
  MUX2X1 U2400 ( .B(n2191), .A(n1244), .S(n1990), .Y(n748) );
  INVX1 U2401 ( .A(\reg_mem[18][7] ), .Y(n2191) );
  MUX2X1 U2402 ( .B(n2192), .A(n1244), .S(n1992), .Y(n747) );
  INVX1 U2403 ( .A(\reg_mem[19][7] ), .Y(n2192) );
  MUX2X1 U2404 ( .B(n2193), .A(n1244), .S(n1994), .Y(n746) );
  INVX1 U2405 ( .A(\reg_mem[20][7] ), .Y(n2193) );
  MUX2X1 U2406 ( .B(n2194), .A(n1244), .S(n1996), .Y(n745) );
  INVX1 U2407 ( .A(\reg_mem[21][7] ), .Y(n2194) );
  MUX2X1 U2408 ( .B(n2195), .A(n1244), .S(n1998), .Y(n744) );
  INVX1 U2409 ( .A(\reg_mem[22][7] ), .Y(n2195) );
  MUX2X1 U2410 ( .B(n2196), .A(n1244), .S(n1871), .Y(n743) );
  INVX1 U2411 ( .A(\reg_mem[23][7] ), .Y(n2196) );
  MUX2X1 U2412 ( .B(n2197), .A(n1244), .S(n1873), .Y(n742) );
  INVX1 U2413 ( .A(\reg_mem[24][7] ), .Y(n2197) );
  MUX2X1 U2414 ( .B(n2198), .A(n1244), .S(n1875), .Y(n741) );
  INVX1 U2415 ( .A(\reg_mem[25][7] ), .Y(n2198) );
  MUX2X1 U2416 ( .B(n2199), .A(n1244), .S(n1877), .Y(n740) );
  INVX1 U2417 ( .A(\reg_mem[26][7] ), .Y(n2199) );
  MUX2X1 U2418 ( .B(n2200), .A(n1244), .S(n1879), .Y(n739) );
  INVX1 U2419 ( .A(\reg_mem[27][7] ), .Y(n2200) );
  MUX2X1 U2420 ( .B(n2201), .A(n1244), .S(n1881), .Y(n738) );
  INVX1 U2421 ( .A(\reg_mem[28][7] ), .Y(n2201) );
  MUX2X1 U2422 ( .B(n2202), .A(n1244), .S(n1883), .Y(n737) );
  INVX1 U2423 ( .A(\reg_mem[29][7] ), .Y(n2202) );
  MUX2X1 U2424 ( .B(n2203), .A(n1244), .S(n1885), .Y(n736) );
  INVX1 U2425 ( .A(\reg_mem[30][7] ), .Y(n2203) );
  MUX2X1 U2426 ( .B(n2204), .A(n1244), .S(n1887), .Y(n735) );
  INVX1 U2427 ( .A(\reg_mem[31][7] ), .Y(n2204) );
  MUX2X1 U2428 ( .B(n2205), .A(n1244), .S(n1889), .Y(n734) );
  INVX1 U2429 ( .A(\reg_mem[32][7] ), .Y(n2205) );
  MUX2X1 U2430 ( .B(n2206), .A(n1244), .S(n1891), .Y(n733) );
  INVX1 U2431 ( .A(\reg_mem[33][7] ), .Y(n2206) );
  MUX2X1 U2432 ( .B(n2207), .A(n1244), .S(n1893), .Y(n732) );
  INVX1 U2433 ( .A(\reg_mem[34][7] ), .Y(n2207) );
  MUX2X1 U2434 ( .B(n2208), .A(n1244), .S(n1895), .Y(n731) );
  INVX1 U2435 ( .A(\reg_mem[35][7] ), .Y(n2208) );
  MUX2X1 U2436 ( .B(n2209), .A(n1244), .S(n1897), .Y(n730) );
  INVX1 U2437 ( .A(\reg_mem[36][7] ), .Y(n2209) );
  MUX2X1 U2438 ( .B(n2210), .A(n1244), .S(n1899), .Y(n729) );
  INVX1 U2439 ( .A(\reg_mem[37][7] ), .Y(n2210) );
  MUX2X1 U2440 ( .B(n2211), .A(n1244), .S(n1901), .Y(n728) );
  INVX1 U2441 ( .A(\reg_mem[38][7] ), .Y(n2211) );
  MUX2X1 U2442 ( .B(n2212), .A(n1244), .S(n1903), .Y(n727) );
  INVX1 U2443 ( .A(\reg_mem[39][7] ), .Y(n2212) );
  MUX2X1 U2444 ( .B(n2213), .A(n1244), .S(n1905), .Y(n726) );
  INVX1 U2445 ( .A(\reg_mem[40][7] ), .Y(n2213) );
  MUX2X1 U2446 ( .B(n2214), .A(n1244), .S(n1907), .Y(n725) );
  INVX1 U2447 ( .A(\reg_mem[41][7] ), .Y(n2214) );
  MUX2X1 U2448 ( .B(n2215), .A(n1244), .S(n1909), .Y(n724) );
  INVX1 U2449 ( .A(\reg_mem[42][7] ), .Y(n2215) );
  MUX2X1 U2450 ( .B(n2216), .A(n1244), .S(n1911), .Y(n723) );
  INVX1 U2451 ( .A(\reg_mem[43][7] ), .Y(n2216) );
  MUX2X1 U2452 ( .B(n2217), .A(n1244), .S(n1913), .Y(n722) );
  INVX1 U2453 ( .A(\reg_mem[44][7] ), .Y(n2217) );
  MUX2X1 U2454 ( .B(n2218), .A(n1244), .S(n1915), .Y(n721) );
  INVX1 U2455 ( .A(\reg_mem[45][7] ), .Y(n2218) );
  MUX2X1 U2456 ( .B(n2219), .A(n1244), .S(n1917), .Y(n720) );
  INVX1 U2457 ( .A(\reg_mem[46][7] ), .Y(n2219) );
  MUX2X1 U2458 ( .B(n2220), .A(n1244), .S(n1919), .Y(n719) );
  INVX1 U2459 ( .A(\reg_mem[47][7] ), .Y(n2220) );
  MUX2X1 U2460 ( .B(n2221), .A(n1244), .S(n1921), .Y(n718) );
  INVX1 U2461 ( .A(\reg_mem[48][7] ), .Y(n2221) );
  MUX2X1 U2462 ( .B(n2222), .A(n1244), .S(n1923), .Y(n717) );
  INVX1 U2463 ( .A(\reg_mem[49][7] ), .Y(n2222) );
  MUX2X1 U2464 ( .B(n2223), .A(n1244), .S(n1925), .Y(n716) );
  INVX1 U2465 ( .A(\reg_mem[50][7] ), .Y(n2223) );
  MUX2X1 U2466 ( .B(n2224), .A(n1244), .S(n1927), .Y(n715) );
  INVX1 U2467 ( .A(\reg_mem[51][7] ), .Y(n2224) );
  MUX2X1 U2468 ( .B(n2225), .A(n1244), .S(n1929), .Y(n714) );
  INVX1 U2469 ( .A(\reg_mem[52][7] ), .Y(n2225) );
  MUX2X1 U2470 ( .B(n2226), .A(n1244), .S(n1931), .Y(n713) );
  INVX1 U2471 ( .A(\reg_mem[53][7] ), .Y(n2226) );
  MUX2X1 U2472 ( .B(n2227), .A(n1244), .S(n1933), .Y(n712) );
  INVX1 U2473 ( .A(\reg_mem[54][7] ), .Y(n2227) );
  MUX2X1 U2474 ( .B(n2228), .A(n1244), .S(n1935), .Y(n711) );
  INVX1 U2475 ( .A(\reg_mem[55][7] ), .Y(n2228) );
  MUX2X1 U2476 ( .B(n2229), .A(n1244), .S(n1937), .Y(n710) );
  INVX1 U2477 ( .A(\reg_mem[56][7] ), .Y(n2229) );
  MUX2X1 U2478 ( .B(n2230), .A(n1244), .S(n1939), .Y(n709) );
  INVX1 U2479 ( .A(\reg_mem[57][7] ), .Y(n2230) );
  MUX2X1 U2480 ( .B(n2231), .A(n1244), .S(n1941), .Y(n708) );
  INVX1 U2481 ( .A(\reg_mem[58][7] ), .Y(n2231) );
  MUX2X1 U2482 ( .B(n2232), .A(n1244), .S(n1943), .Y(n707) );
  INVX1 U2483 ( .A(\reg_mem[59][7] ), .Y(n2232) );
  MUX2X1 U2484 ( .B(n2233), .A(n1244), .S(n1945), .Y(n706) );
  INVX1 U2485 ( .A(\reg_mem[60][7] ), .Y(n2233) );
  MUX2X1 U2486 ( .B(n2234), .A(n1244), .S(n1947), .Y(n705) );
  INVX1 U2487 ( .A(\reg_mem[61][7] ), .Y(n2234) );
  MUX2X1 U2488 ( .B(n2235), .A(n1244), .S(n1949), .Y(n704) );
  AOI22X1 U2489 ( .A(rx_packet_data[7]), .B(n2039), .C(tx_data[7]), .D(n2040), 
        .Y(n2172) );
  INVX1 U2490 ( .A(\reg_mem[62][7] ), .Y(n2235) );
  MUX2X1 U2491 ( .B(n2236), .A(n1862), .S(N19), .Y(n1227) );
  MUX2X1 U2492 ( .B(n2237), .A(n2238), .S(N20), .Y(n1226) );
  NAND2X1 U2493 ( .A(n2239), .B(N19), .Y(n2237) );
  MUX2X1 U2494 ( .B(n2240), .A(n2241), .S(N21), .Y(n1225) );
  INVX1 U2495 ( .A(n2242), .Y(n2241) );
  OAI21X1 U2496 ( .A(n2236), .B(N20), .C(n2238), .Y(n2242) );
  INVX1 U2497 ( .A(n2243), .Y(n2238) );
  OAI21X1 U2498 ( .A(N19), .B(n2236), .C(n1862), .Y(n2243) );
  NAND3X1 U2499 ( .A(n2239), .B(N19), .C(N20), .Y(n2240) );
  MUX2X1 U2500 ( .B(n2244), .A(n2245), .S(N22), .Y(n1224) );
  NAND2X1 U2501 ( .A(n2246), .B(n2239), .Y(n2244) );
  INVX1 U2502 ( .A(n2247), .Y(n1223) );
  MUX2X1 U2503 ( .B(n2248), .A(n2249), .S(N23), .Y(n2247) );
  MUX2X1 U2504 ( .B(n2250), .A(n2251), .S(N24), .Y(n1222) );
  AOI21X1 U2505 ( .A(n2239), .B(n2252), .C(n2249), .Y(n2251) );
  OAI21X1 U2506 ( .A(N22), .B(n2236), .C(n2245), .Y(n2249) );
  INVX1 U2507 ( .A(n2253), .Y(n2245) );
  OAI21X1 U2508 ( .A(n2246), .B(n2236), .C(n1862), .Y(n2253) );
  INVX1 U2509 ( .A(N23), .Y(n2252) );
  NAND2X1 U2510 ( .A(n2248), .B(N23), .Y(n2250) );
  INVX1 U2511 ( .A(n2254), .Y(n2248) );
  NAND3X1 U2512 ( .A(n2246), .B(n2239), .C(N22), .Y(n2254) );
  INVX1 U2513 ( .A(n2236), .Y(n2239) );
  NAND2X1 U2514 ( .A(n1847), .B(n1862), .Y(n2236) );
  NAND2X1 U2515 ( .A(n1847), .B(n1868), .Y(n1862) );
  OAI22X1 U2516 ( .A(get_tx_packet_data), .B(get_rx_data), .C(
        buffer_occupancy[6]), .D(n2255), .Y(n1868) );
  INVX1 U2517 ( .A(n2256), .Y(n2246) );
  NAND3X1 U2518 ( .A(N20), .B(N19), .C(N21), .Y(n2256) );
  MUX2X1 U2519 ( .B(n2257), .A(n2258), .S(write_ptr[0]), .Y(n1221) );
  MUX2X1 U2520 ( .B(n2259), .A(n2260), .S(write_ptr[1]), .Y(n1220) );
  NAND2X1 U2521 ( .A(n2261), .B(write_ptr[0]), .Y(n2259) );
  OAI21X1 U2522 ( .A(n2262), .B(n2257), .C(n2263), .Y(n1219) );
  NAND2X1 U2523 ( .A(write_ptr[2]), .B(n2264), .Y(n2263) );
  OAI21X1 U2524 ( .A(write_ptr[1]), .B(n2257), .C(n2260), .Y(n2264) );
  INVX1 U2525 ( .A(n2265), .Y(n2260) );
  OAI21X1 U2526 ( .A(write_ptr[0]), .B(n2257), .C(n2258), .Y(n2265) );
  INVX1 U2527 ( .A(n2266), .Y(n1218) );
  MUX2X1 U2528 ( .B(n2267), .A(n2268), .S(write_ptr[3]), .Y(n2266) );
  MUX2X1 U2529 ( .B(n2269), .A(n2270), .S(write_ptr[4]), .Y(n1217) );
  NAND2X1 U2530 ( .A(n2267), .B(write_ptr[3]), .Y(n2269) );
  OAI21X1 U2531 ( .A(n2271), .B(n2272), .C(n2273), .Y(n1216) );
  NAND3X1 U2532 ( .A(n2274), .B(write_ptr[4]), .C(n2267), .Y(n2273) );
  NOR2X1 U2533 ( .A(n2257), .B(n2275), .Y(n2267) );
  INVX1 U2534 ( .A(n2276), .Y(n2271) );
  OAI21X1 U2535 ( .A(n2257), .B(write_ptr[4]), .C(n2270), .Y(n2276) );
  AOI21X1 U2536 ( .A(n2277), .B(n2261), .C(n2268), .Y(n2270) );
  OAI21X1 U2537 ( .A(n2278), .B(n2257), .C(n2258), .Y(n2268) );
  INVX1 U2538 ( .A(n2257), .Y(n2261) );
  NAND2X1 U2539 ( .A(n1847), .B(n2258), .Y(n2257) );
  NAND2X1 U2540 ( .A(n1847), .B(n1845), .Y(n2258) );
  NOR2X1 U2541 ( .A(n2279), .B(n2040), .Y(n1845) );
  INVX1 U2542 ( .A(n2280), .Y(n2279) );
  NOR2X1 U2543 ( .A(flush), .B(clear), .Y(n1847) );
  MUX2X1 U2544 ( .B(n2281), .A(n1246), .S(n1952), .Y(n1215) );
  INVX1 U2545 ( .A(\reg_mem[63][0] ), .Y(n2281) );
  MUX2X1 U2546 ( .B(n2283), .A(n1246), .S(n1954), .Y(n1214) );
  INVX1 U2547 ( .A(\reg_mem[0][0] ), .Y(n2283) );
  MUX2X1 U2548 ( .B(n2284), .A(n1246), .S(n1956), .Y(n1213) );
  INVX1 U2549 ( .A(\reg_mem[1][0] ), .Y(n2284) );
  MUX2X1 U2550 ( .B(n2285), .A(n1246), .S(n1958), .Y(n1212) );
  INVX1 U2551 ( .A(\reg_mem[2][0] ), .Y(n2285) );
  MUX2X1 U2552 ( .B(n2286), .A(n1246), .S(n1960), .Y(n1211) );
  INVX1 U2553 ( .A(\reg_mem[3][0] ), .Y(n2286) );
  MUX2X1 U2554 ( .B(n2287), .A(n1246), .S(n1962), .Y(n1210) );
  INVX1 U2555 ( .A(\reg_mem[4][0] ), .Y(n2287) );
  MUX2X1 U2556 ( .B(n2288), .A(n1246), .S(n1964), .Y(n1209) );
  INVX1 U2557 ( .A(\reg_mem[5][0] ), .Y(n2288) );
  MUX2X1 U2558 ( .B(n2289), .A(n1246), .S(n1966), .Y(n1208) );
  INVX1 U2559 ( .A(\reg_mem[6][0] ), .Y(n2289) );
  MUX2X1 U2560 ( .B(n2290), .A(n1246), .S(n1968), .Y(n1207) );
  INVX1 U2561 ( .A(\reg_mem[7][0] ), .Y(n2290) );
  MUX2X1 U2562 ( .B(n2291), .A(n1246), .S(n1970), .Y(n1206) );
  INVX1 U2563 ( .A(\reg_mem[8][0] ), .Y(n2291) );
  MUX2X1 U2564 ( .B(n2292), .A(n1246), .S(n1972), .Y(n1205) );
  INVX1 U2565 ( .A(\reg_mem[9][0] ), .Y(n2292) );
  MUX2X1 U2566 ( .B(n2293), .A(n1246), .S(n1974), .Y(n1204) );
  INVX1 U2567 ( .A(\reg_mem[10][0] ), .Y(n2293) );
  MUX2X1 U2568 ( .B(n2294), .A(n1246), .S(n1976), .Y(n1203) );
  INVX1 U2569 ( .A(\reg_mem[11][0] ), .Y(n2294) );
  MUX2X1 U2570 ( .B(n2295), .A(n1246), .S(n1978), .Y(n1202) );
  INVX1 U2571 ( .A(\reg_mem[12][0] ), .Y(n2295) );
  MUX2X1 U2572 ( .B(n2296), .A(n1246), .S(n1980), .Y(n1201) );
  INVX1 U2573 ( .A(\reg_mem[13][0] ), .Y(n2296) );
  MUX2X1 U2574 ( .B(n2297), .A(n1246), .S(n1982), .Y(n1200) );
  INVX1 U2575 ( .A(\reg_mem[14][0] ), .Y(n2297) );
  MUX2X1 U2576 ( .B(n2298), .A(n1246), .S(n1984), .Y(n1199) );
  INVX1 U2577 ( .A(\reg_mem[15][0] ), .Y(n2298) );
  MUX2X1 U2578 ( .B(n2299), .A(n1246), .S(n1986), .Y(n1198) );
  INVX1 U2579 ( .A(\reg_mem[16][0] ), .Y(n2299) );
  MUX2X1 U2580 ( .B(n2300), .A(n1246), .S(n1988), .Y(n1197) );
  INVX1 U2581 ( .A(\reg_mem[17][0] ), .Y(n2300) );
  MUX2X1 U2582 ( .B(n2301), .A(n1246), .S(n1990), .Y(n1196) );
  INVX1 U2583 ( .A(\reg_mem[18][0] ), .Y(n2301) );
  MUX2X1 U2584 ( .B(n2302), .A(n1246), .S(n1992), .Y(n1195) );
  INVX1 U2585 ( .A(\reg_mem[19][0] ), .Y(n2302) );
  MUX2X1 U2586 ( .B(n2303), .A(n1246), .S(n1994), .Y(n1194) );
  INVX1 U2587 ( .A(\reg_mem[20][0] ), .Y(n2303) );
  MUX2X1 U2588 ( .B(n2304), .A(n1246), .S(n1996), .Y(n1193) );
  INVX1 U2589 ( .A(\reg_mem[21][0] ), .Y(n2304) );
  MUX2X1 U2590 ( .B(n2305), .A(n1246), .S(n1998), .Y(n1192) );
  INVX1 U2591 ( .A(\reg_mem[22][0] ), .Y(n2305) );
  MUX2X1 U2592 ( .B(n2306), .A(n1246), .S(n1871), .Y(n1191) );
  INVX1 U2593 ( .A(\reg_mem[23][0] ), .Y(n2306) );
  MUX2X1 U2594 ( .B(n2307), .A(n1246), .S(n1873), .Y(n1190) );
  INVX1 U2595 ( .A(\reg_mem[24][0] ), .Y(n2307) );
  MUX2X1 U2596 ( .B(n2308), .A(n1246), .S(n1875), .Y(n1189) );
  INVX1 U2597 ( .A(\reg_mem[25][0] ), .Y(n2308) );
  MUX2X1 U2598 ( .B(n2309), .A(n1246), .S(n1877), .Y(n1188) );
  INVX1 U2599 ( .A(\reg_mem[26][0] ), .Y(n2309) );
  MUX2X1 U2600 ( .B(n2310), .A(n1246), .S(n1879), .Y(n1187) );
  INVX1 U2601 ( .A(\reg_mem[27][0] ), .Y(n2310) );
  MUX2X1 U2602 ( .B(n2311), .A(n1246), .S(n1881), .Y(n1186) );
  INVX1 U2603 ( .A(\reg_mem[28][0] ), .Y(n2311) );
  MUX2X1 U2604 ( .B(n2312), .A(n1246), .S(n1883), .Y(n1185) );
  INVX1 U2605 ( .A(\reg_mem[29][0] ), .Y(n2312) );
  MUX2X1 U2606 ( .B(n2313), .A(n1246), .S(n1885), .Y(n1184) );
  INVX1 U2607 ( .A(\reg_mem[30][0] ), .Y(n2313) );
  MUX2X1 U2608 ( .B(n2314), .A(n1246), .S(n1887), .Y(n1183) );
  INVX1 U2609 ( .A(\reg_mem[31][0] ), .Y(n2314) );
  MUX2X1 U2610 ( .B(n2315), .A(n1246), .S(n1889), .Y(n1182) );
  INVX1 U2611 ( .A(\reg_mem[32][0] ), .Y(n2315) );
  MUX2X1 U2612 ( .B(n2316), .A(n1246), .S(n1891), .Y(n1181) );
  INVX1 U2613 ( .A(\reg_mem[33][0] ), .Y(n2316) );
  MUX2X1 U2614 ( .B(n2317), .A(n1246), .S(n1893), .Y(n1180) );
  INVX1 U2615 ( .A(\reg_mem[34][0] ), .Y(n2317) );
  MUX2X1 U2616 ( .B(n2318), .A(n1246), .S(n1895), .Y(n1179) );
  INVX1 U2617 ( .A(\reg_mem[35][0] ), .Y(n2318) );
  MUX2X1 U2618 ( .B(n2319), .A(n1246), .S(n1897), .Y(n1178) );
  INVX1 U2619 ( .A(\reg_mem[36][0] ), .Y(n2319) );
  MUX2X1 U2620 ( .B(n2320), .A(n1246), .S(n1899), .Y(n1177) );
  INVX1 U2621 ( .A(\reg_mem[37][0] ), .Y(n2320) );
  MUX2X1 U2622 ( .B(n2321), .A(n1246), .S(n1901), .Y(n1176) );
  INVX1 U2623 ( .A(\reg_mem[38][0] ), .Y(n2321) );
  MUX2X1 U2624 ( .B(n2322), .A(n1246), .S(n1903), .Y(n1175) );
  INVX1 U2625 ( .A(\reg_mem[39][0] ), .Y(n2322) );
  MUX2X1 U2626 ( .B(n2323), .A(n1246), .S(n1905), .Y(n1174) );
  INVX1 U2627 ( .A(\reg_mem[40][0] ), .Y(n2323) );
  MUX2X1 U2628 ( .B(n2324), .A(n1246), .S(n1907), .Y(n1173) );
  INVX1 U2629 ( .A(\reg_mem[41][0] ), .Y(n2324) );
  MUX2X1 U2630 ( .B(n2325), .A(n1246), .S(n1909), .Y(n1172) );
  INVX1 U2631 ( .A(\reg_mem[42][0] ), .Y(n2325) );
  MUX2X1 U2632 ( .B(n2326), .A(n1246), .S(n1911), .Y(n1171) );
  INVX1 U2633 ( .A(\reg_mem[43][0] ), .Y(n2326) );
  MUX2X1 U2634 ( .B(n2327), .A(n1246), .S(n1913), .Y(n1170) );
  INVX1 U2635 ( .A(\reg_mem[44][0] ), .Y(n2327) );
  MUX2X1 U2636 ( .B(n2328), .A(n1246), .S(n1915), .Y(n1169) );
  INVX1 U2637 ( .A(\reg_mem[45][0] ), .Y(n2328) );
  MUX2X1 U2638 ( .B(n2329), .A(n1246), .S(n1917), .Y(n1168) );
  INVX1 U2639 ( .A(\reg_mem[46][0] ), .Y(n2329) );
  MUX2X1 U2640 ( .B(n2330), .A(n1246), .S(n1919), .Y(n1167) );
  INVX1 U2641 ( .A(\reg_mem[47][0] ), .Y(n2330) );
  MUX2X1 U2642 ( .B(n2331), .A(n1246), .S(n1921), .Y(n1166) );
  INVX1 U2643 ( .A(\reg_mem[48][0] ), .Y(n2331) );
  MUX2X1 U2644 ( .B(n2332), .A(n1246), .S(n1923), .Y(n1165) );
  INVX1 U2645 ( .A(\reg_mem[49][0] ), .Y(n2332) );
  MUX2X1 U2646 ( .B(n2333), .A(n1246), .S(n1925), .Y(n1164) );
  INVX1 U2647 ( .A(\reg_mem[50][0] ), .Y(n2333) );
  MUX2X1 U2648 ( .B(n2334), .A(n1246), .S(n1927), .Y(n1163) );
  INVX1 U2649 ( .A(\reg_mem[51][0] ), .Y(n2334) );
  MUX2X1 U2650 ( .B(n2335), .A(n1246), .S(n1929), .Y(n1162) );
  INVX1 U2651 ( .A(\reg_mem[52][0] ), .Y(n2335) );
  MUX2X1 U2652 ( .B(n2336), .A(n1246), .S(n1931), .Y(n1161) );
  INVX1 U2653 ( .A(\reg_mem[53][0] ), .Y(n2336) );
  MUX2X1 U2654 ( .B(n2337), .A(n1246), .S(n1933), .Y(n1160) );
  INVX1 U2655 ( .A(\reg_mem[54][0] ), .Y(n2337) );
  MUX2X1 U2656 ( .B(n2338), .A(n1246), .S(n1935), .Y(n1159) );
  INVX1 U2657 ( .A(\reg_mem[55][0] ), .Y(n2338) );
  MUX2X1 U2658 ( .B(n2339), .A(n1246), .S(n1937), .Y(n1158) );
  INVX1 U2659 ( .A(\reg_mem[56][0] ), .Y(n2339) );
  MUX2X1 U2660 ( .B(n2340), .A(n1246), .S(n1939), .Y(n1157) );
  INVX1 U2661 ( .A(\reg_mem[57][0] ), .Y(n2340) );
  MUX2X1 U2662 ( .B(n2341), .A(n1246), .S(n1941), .Y(n1156) );
  INVX1 U2663 ( .A(\reg_mem[58][0] ), .Y(n2341) );
  MUX2X1 U2664 ( .B(n2342), .A(n1246), .S(n1943), .Y(n1155) );
  INVX1 U2665 ( .A(\reg_mem[59][0] ), .Y(n2342) );
  MUX2X1 U2666 ( .B(n2343), .A(n1246), .S(n1945), .Y(n1154) );
  INVX1 U2667 ( .A(\reg_mem[60][0] ), .Y(n2343) );
  MUX2X1 U2668 ( .B(n2344), .A(n1246), .S(n1947), .Y(n1153) );
  INVX1 U2669 ( .A(\reg_mem[61][0] ), .Y(n2344) );
  MUX2X1 U2670 ( .B(n2345), .A(n1246), .S(n1949), .Y(n1152) );
  AOI22X1 U2671 ( .A(rx_packet_data[0]), .B(n2039), .C(tx_data[0]), .D(n2040), 
        .Y(n2282) );
  INVX1 U2672 ( .A(\reg_mem[62][0] ), .Y(n2345) );
  MUX2X1 U2673 ( .B(n2346), .A(n1248), .S(n1952), .Y(n1151) );
  INVX1 U2674 ( .A(\reg_mem[63][1] ), .Y(n2346) );
  MUX2X1 U2675 ( .B(n2348), .A(n1248), .S(n1954), .Y(n1150) );
  INVX1 U2676 ( .A(\reg_mem[0][1] ), .Y(n2348) );
  MUX2X1 U2677 ( .B(n2349), .A(n1248), .S(n1956), .Y(n1149) );
  INVX1 U2678 ( .A(\reg_mem[1][1] ), .Y(n2349) );
  MUX2X1 U2679 ( .B(n2350), .A(n1248), .S(n1958), .Y(n1148) );
  INVX1 U2680 ( .A(\reg_mem[2][1] ), .Y(n2350) );
  MUX2X1 U2681 ( .B(n2351), .A(n1248), .S(n1960), .Y(n1147) );
  INVX1 U2682 ( .A(\reg_mem[3][1] ), .Y(n2351) );
  MUX2X1 U2683 ( .B(n2352), .A(n1248), .S(n1962), .Y(n1146) );
  INVX1 U2684 ( .A(\reg_mem[4][1] ), .Y(n2352) );
  MUX2X1 U2685 ( .B(n2353), .A(n1248), .S(n1964), .Y(n1145) );
  INVX1 U2686 ( .A(\reg_mem[5][1] ), .Y(n2353) );
  MUX2X1 U2687 ( .B(n2354), .A(n1248), .S(n1966), .Y(n1144) );
  INVX1 U2688 ( .A(\reg_mem[6][1] ), .Y(n2354) );
  MUX2X1 U2689 ( .B(n2355), .A(n1248), .S(n1968), .Y(n1143) );
  INVX1 U2690 ( .A(\reg_mem[7][1] ), .Y(n2355) );
  MUX2X1 U2691 ( .B(n2356), .A(n1248), .S(n1970), .Y(n1142) );
  INVX1 U2692 ( .A(\reg_mem[8][1] ), .Y(n2356) );
  MUX2X1 U2693 ( .B(n2357), .A(n1248), .S(n1972), .Y(n1141) );
  INVX1 U2694 ( .A(\reg_mem[9][1] ), .Y(n2357) );
  MUX2X1 U2695 ( .B(n2358), .A(n1248), .S(n1974), .Y(n1140) );
  INVX1 U2696 ( .A(\reg_mem[10][1] ), .Y(n2358) );
  MUX2X1 U2697 ( .B(n2359), .A(n1248), .S(n1976), .Y(n1139) );
  INVX1 U2698 ( .A(\reg_mem[11][1] ), .Y(n2359) );
  MUX2X1 U2699 ( .B(n2360), .A(n1248), .S(n1978), .Y(n1138) );
  INVX1 U2700 ( .A(\reg_mem[12][1] ), .Y(n2360) );
  MUX2X1 U2701 ( .B(n2361), .A(n1248), .S(n1980), .Y(n1137) );
  INVX1 U2702 ( .A(\reg_mem[13][1] ), .Y(n2361) );
  MUX2X1 U2703 ( .B(n2362), .A(n1248), .S(n1982), .Y(n1136) );
  INVX1 U2704 ( .A(\reg_mem[14][1] ), .Y(n2362) );
  MUX2X1 U2705 ( .B(n2363), .A(n1248), .S(n1984), .Y(n1135) );
  INVX1 U2706 ( .A(\reg_mem[15][1] ), .Y(n2363) );
  MUX2X1 U2707 ( .B(n2364), .A(n1248), .S(n1986), .Y(n1134) );
  INVX1 U2708 ( .A(\reg_mem[16][1] ), .Y(n2364) );
  MUX2X1 U2709 ( .B(n2365), .A(n1248), .S(n1988), .Y(n1133) );
  INVX1 U2710 ( .A(\reg_mem[17][1] ), .Y(n2365) );
  MUX2X1 U2711 ( .B(n2366), .A(n1248), .S(n1990), .Y(n1132) );
  INVX1 U2712 ( .A(\reg_mem[18][1] ), .Y(n2366) );
  MUX2X1 U2713 ( .B(n2367), .A(n1248), .S(n1992), .Y(n1131) );
  INVX1 U2714 ( .A(\reg_mem[19][1] ), .Y(n2367) );
  MUX2X1 U2715 ( .B(n2368), .A(n1248), .S(n1994), .Y(n1130) );
  INVX1 U2716 ( .A(\reg_mem[20][1] ), .Y(n2368) );
  MUX2X1 U2717 ( .B(n2369), .A(n1248), .S(n1996), .Y(n1129) );
  INVX1 U2718 ( .A(\reg_mem[21][1] ), .Y(n2369) );
  MUX2X1 U2719 ( .B(n2370), .A(n1248), .S(n1998), .Y(n1128) );
  INVX1 U2720 ( .A(\reg_mem[22][1] ), .Y(n2370) );
  MUX2X1 U2721 ( .B(n2371), .A(n1248), .S(n1871), .Y(n1127) );
  INVX1 U2722 ( .A(\reg_mem[23][1] ), .Y(n2371) );
  MUX2X1 U2723 ( .B(n2372), .A(n1248), .S(n1873), .Y(n1126) );
  INVX1 U2724 ( .A(\reg_mem[24][1] ), .Y(n2372) );
  MUX2X1 U2725 ( .B(n2373), .A(n1248), .S(n1875), .Y(n1125) );
  INVX1 U2726 ( .A(\reg_mem[25][1] ), .Y(n2373) );
  MUX2X1 U2727 ( .B(n2374), .A(n1248), .S(n1877), .Y(n1124) );
  INVX1 U2728 ( .A(\reg_mem[26][1] ), .Y(n2374) );
  MUX2X1 U2729 ( .B(n2375), .A(n1248), .S(n1879), .Y(n1123) );
  INVX1 U2730 ( .A(\reg_mem[27][1] ), .Y(n2375) );
  MUX2X1 U2731 ( .B(n2376), .A(n1248), .S(n1881), .Y(n1122) );
  INVX1 U2732 ( .A(\reg_mem[28][1] ), .Y(n2376) );
  MUX2X1 U2733 ( .B(n2377), .A(n1248), .S(n1883), .Y(n1121) );
  INVX1 U2734 ( .A(\reg_mem[29][1] ), .Y(n2377) );
  MUX2X1 U2735 ( .B(n2378), .A(n1248), .S(n1885), .Y(n1120) );
  INVX1 U2736 ( .A(\reg_mem[30][1] ), .Y(n2378) );
  MUX2X1 U2737 ( .B(n2379), .A(n1248), .S(n1887), .Y(n1119) );
  INVX1 U2738 ( .A(\reg_mem[31][1] ), .Y(n2379) );
  MUX2X1 U2739 ( .B(n2380), .A(n1248), .S(n1889), .Y(n1118) );
  INVX1 U2740 ( .A(\reg_mem[32][1] ), .Y(n2380) );
  MUX2X1 U2741 ( .B(n2381), .A(n1248), .S(n1891), .Y(n1117) );
  INVX1 U2742 ( .A(\reg_mem[33][1] ), .Y(n2381) );
  MUX2X1 U2743 ( .B(n2382), .A(n1248), .S(n1893), .Y(n1116) );
  INVX1 U2744 ( .A(\reg_mem[34][1] ), .Y(n2382) );
  MUX2X1 U2745 ( .B(n2383), .A(n1248), .S(n1895), .Y(n1115) );
  INVX1 U2746 ( .A(\reg_mem[35][1] ), .Y(n2383) );
  MUX2X1 U2747 ( .B(n2384), .A(n1248), .S(n1897), .Y(n1114) );
  INVX1 U2748 ( .A(\reg_mem[36][1] ), .Y(n2384) );
  MUX2X1 U2749 ( .B(n2385), .A(n1248), .S(n1899), .Y(n1113) );
  INVX1 U2750 ( .A(\reg_mem[37][1] ), .Y(n2385) );
  MUX2X1 U2751 ( .B(n2386), .A(n1248), .S(n1901), .Y(n1112) );
  INVX1 U2752 ( .A(\reg_mem[38][1] ), .Y(n2386) );
  MUX2X1 U2753 ( .B(n2387), .A(n1248), .S(n1903), .Y(n1111) );
  INVX1 U2754 ( .A(\reg_mem[39][1] ), .Y(n2387) );
  MUX2X1 U2755 ( .B(n2388), .A(n1248), .S(n1905), .Y(n1110) );
  INVX1 U2756 ( .A(\reg_mem[40][1] ), .Y(n2388) );
  MUX2X1 U2757 ( .B(n2389), .A(n1248), .S(n1907), .Y(n1109) );
  INVX1 U2758 ( .A(\reg_mem[41][1] ), .Y(n2389) );
  MUX2X1 U2759 ( .B(n2390), .A(n1248), .S(n1909), .Y(n1108) );
  INVX1 U2760 ( .A(\reg_mem[42][1] ), .Y(n2390) );
  MUX2X1 U2761 ( .B(n2391), .A(n1248), .S(n1911), .Y(n1107) );
  INVX1 U2762 ( .A(\reg_mem[43][1] ), .Y(n2391) );
  MUX2X1 U2763 ( .B(n2392), .A(n1248), .S(n1913), .Y(n1106) );
  INVX1 U2764 ( .A(\reg_mem[44][1] ), .Y(n2392) );
  MUX2X1 U2765 ( .B(n2393), .A(n1248), .S(n1915), .Y(n1105) );
  INVX1 U2766 ( .A(\reg_mem[45][1] ), .Y(n2393) );
  MUX2X1 U2767 ( .B(n2394), .A(n1248), .S(n1917), .Y(n1104) );
  INVX1 U2768 ( .A(\reg_mem[46][1] ), .Y(n2394) );
  MUX2X1 U2769 ( .B(n2395), .A(n1248), .S(n1919), .Y(n1103) );
  INVX1 U2770 ( .A(\reg_mem[47][1] ), .Y(n2395) );
  MUX2X1 U2771 ( .B(n2396), .A(n1248), .S(n1921), .Y(n1102) );
  INVX1 U2772 ( .A(\reg_mem[48][1] ), .Y(n2396) );
  MUX2X1 U2773 ( .B(n2397), .A(n1248), .S(n1923), .Y(n1101) );
  INVX1 U2774 ( .A(\reg_mem[49][1] ), .Y(n2397) );
  MUX2X1 U2775 ( .B(n2398), .A(n1248), .S(n1925), .Y(n1100) );
  INVX1 U2776 ( .A(\reg_mem[50][1] ), .Y(n2398) );
  MUX2X1 U2777 ( .B(n2399), .A(n1248), .S(n1927), .Y(n1099) );
  INVX1 U2778 ( .A(\reg_mem[51][1] ), .Y(n2399) );
  MUX2X1 U2779 ( .B(n2400), .A(n1248), .S(n1929), .Y(n1098) );
  INVX1 U2780 ( .A(\reg_mem[52][1] ), .Y(n2400) );
  MUX2X1 U2781 ( .B(n2401), .A(n1248), .S(n1931), .Y(n1097) );
  INVX1 U2782 ( .A(\reg_mem[53][1] ), .Y(n2401) );
  MUX2X1 U2783 ( .B(n2402), .A(n1248), .S(n1933), .Y(n1096) );
  INVX1 U2784 ( .A(\reg_mem[54][1] ), .Y(n2402) );
  MUX2X1 U2785 ( .B(n2403), .A(n1248), .S(n1935), .Y(n1095) );
  INVX1 U2786 ( .A(\reg_mem[55][1] ), .Y(n2403) );
  MUX2X1 U2787 ( .B(n2404), .A(n1248), .S(n1937), .Y(n1094) );
  INVX1 U2788 ( .A(\reg_mem[56][1] ), .Y(n2404) );
  MUX2X1 U2789 ( .B(n2405), .A(n1248), .S(n1939), .Y(n1093) );
  INVX1 U2790 ( .A(\reg_mem[57][1] ), .Y(n2405) );
  MUX2X1 U2791 ( .B(n2406), .A(n1248), .S(n1941), .Y(n1092) );
  INVX1 U2792 ( .A(\reg_mem[58][1] ), .Y(n2406) );
  MUX2X1 U2793 ( .B(n2407), .A(n1248), .S(n1943), .Y(n1091) );
  INVX1 U2794 ( .A(\reg_mem[59][1] ), .Y(n2407) );
  MUX2X1 U2795 ( .B(n2408), .A(n1248), .S(n1945), .Y(n1090) );
  INVX1 U2796 ( .A(\reg_mem[60][1] ), .Y(n2408) );
  MUX2X1 U2797 ( .B(n2409), .A(n1248), .S(n1947), .Y(n1089) );
  INVX1 U2798 ( .A(\reg_mem[61][1] ), .Y(n2409) );
  MUX2X1 U2799 ( .B(n2410), .A(n1248), .S(n1949), .Y(n1088) );
  AOI22X1 U2800 ( .A(rx_packet_data[1]), .B(n2039), .C(tx_data[1]), .D(n2040), 
        .Y(n2347) );
  INVX1 U2801 ( .A(\reg_mem[62][1] ), .Y(n2410) );
  MUX2X1 U2802 ( .B(n2411), .A(n1250), .S(n1952), .Y(n1087) );
  INVX1 U2803 ( .A(\reg_mem[63][2] ), .Y(n2411) );
  MUX2X1 U2804 ( .B(n2413), .A(n1250), .S(n1954), .Y(n1086) );
  INVX1 U2805 ( .A(\reg_mem[0][2] ), .Y(n2413) );
  MUX2X1 U2806 ( .B(n2414), .A(n1250), .S(n1956), .Y(n1085) );
  INVX1 U2807 ( .A(\reg_mem[1][2] ), .Y(n2414) );
  MUX2X1 U2808 ( .B(n2415), .A(n1250), .S(n1958), .Y(n1084) );
  INVX1 U2809 ( .A(\reg_mem[2][2] ), .Y(n2415) );
  MUX2X1 U2810 ( .B(n2416), .A(n1250), .S(n1960), .Y(n1083) );
  INVX1 U2811 ( .A(\reg_mem[3][2] ), .Y(n2416) );
  MUX2X1 U2812 ( .B(n2417), .A(n1250), .S(n1962), .Y(n1082) );
  INVX1 U2813 ( .A(\reg_mem[4][2] ), .Y(n2417) );
  MUX2X1 U2814 ( .B(n2418), .A(n1250), .S(n1964), .Y(n1081) );
  INVX1 U2815 ( .A(\reg_mem[5][2] ), .Y(n2418) );
  MUX2X1 U2816 ( .B(n2419), .A(n1250), .S(n1966), .Y(n1080) );
  INVX1 U2817 ( .A(\reg_mem[6][2] ), .Y(n2419) );
  MUX2X1 U2818 ( .B(n2420), .A(n1250), .S(n1968), .Y(n1079) );
  INVX1 U2819 ( .A(\reg_mem[7][2] ), .Y(n2420) );
  MUX2X1 U2820 ( .B(n2421), .A(n1250), .S(n1970), .Y(n1078) );
  INVX1 U2821 ( .A(\reg_mem[8][2] ), .Y(n2421) );
  MUX2X1 U2822 ( .B(n2422), .A(n1250), .S(n1972), .Y(n1077) );
  INVX1 U2823 ( .A(\reg_mem[9][2] ), .Y(n2422) );
  MUX2X1 U2824 ( .B(n2423), .A(n1250), .S(n1974), .Y(n1076) );
  INVX1 U2825 ( .A(\reg_mem[10][2] ), .Y(n2423) );
  MUX2X1 U2826 ( .B(n2424), .A(n1250), .S(n1976), .Y(n1075) );
  INVX1 U2827 ( .A(\reg_mem[11][2] ), .Y(n2424) );
  MUX2X1 U2828 ( .B(n2425), .A(n1250), .S(n1978), .Y(n1074) );
  INVX1 U2829 ( .A(\reg_mem[12][2] ), .Y(n2425) );
  MUX2X1 U2830 ( .B(n2426), .A(n1250), .S(n1980), .Y(n1073) );
  INVX1 U2831 ( .A(\reg_mem[13][2] ), .Y(n2426) );
  MUX2X1 U2832 ( .B(n2427), .A(n1250), .S(n1982), .Y(n1072) );
  INVX1 U2833 ( .A(\reg_mem[14][2] ), .Y(n2427) );
  MUX2X1 U2834 ( .B(n2428), .A(n1250), .S(n1984), .Y(n1071) );
  INVX1 U2835 ( .A(\reg_mem[15][2] ), .Y(n2428) );
  MUX2X1 U2836 ( .B(n2429), .A(n1250), .S(n1986), .Y(n1070) );
  INVX1 U2837 ( .A(\reg_mem[16][2] ), .Y(n2429) );
  MUX2X1 U2838 ( .B(n2430), .A(n1250), .S(n1988), .Y(n1069) );
  INVX1 U2839 ( .A(\reg_mem[17][2] ), .Y(n2430) );
  MUX2X1 U2840 ( .B(n2431), .A(n1250), .S(n1990), .Y(n1068) );
  INVX1 U2841 ( .A(\reg_mem[18][2] ), .Y(n2431) );
  MUX2X1 U2842 ( .B(n2432), .A(n1250), .S(n1992), .Y(n1067) );
  INVX1 U2843 ( .A(\reg_mem[19][2] ), .Y(n2432) );
  MUX2X1 U2844 ( .B(n2433), .A(n1250), .S(n1994), .Y(n1066) );
  INVX1 U2845 ( .A(\reg_mem[20][2] ), .Y(n2433) );
  MUX2X1 U2846 ( .B(n2434), .A(n1250), .S(n1996), .Y(n1065) );
  INVX1 U2847 ( .A(\reg_mem[21][2] ), .Y(n2434) );
  MUX2X1 U2848 ( .B(n2435), .A(n1250), .S(n1998), .Y(n1064) );
  INVX1 U2849 ( .A(\reg_mem[22][2] ), .Y(n2435) );
  MUX2X1 U2850 ( .B(n2436), .A(n1250), .S(n1871), .Y(n1063) );
  AND2X1 U2851 ( .A(n2437), .B(n2278), .Y(n1871) );
  INVX1 U2852 ( .A(\reg_mem[23][2] ), .Y(n2436) );
  MUX2X1 U2853 ( .B(n2438), .A(n1250), .S(n1873), .Y(n1062) );
  NOR2X1 U2854 ( .A(n2439), .B(n2440), .Y(n1873) );
  INVX1 U2855 ( .A(\reg_mem[24][2] ), .Y(n2438) );
  MUX2X1 U2856 ( .B(n2441), .A(n1250), .S(n1875), .Y(n1061) );
  NOR2X1 U2857 ( .A(n2442), .B(n2439), .Y(n1875) );
  INVX1 U2858 ( .A(\reg_mem[25][2] ), .Y(n2441) );
  MUX2X1 U2859 ( .B(n2443), .A(n1250), .S(n1877), .Y(n1060) );
  NOR2X1 U2860 ( .A(n2444), .B(n2439), .Y(n1877) );
  INVX1 U2861 ( .A(\reg_mem[26][2] ), .Y(n2443) );
  MUX2X1 U2862 ( .B(n2445), .A(n1250), .S(n1879), .Y(n1059) );
  NOR2X1 U2863 ( .A(n2262), .B(n2439), .Y(n1879) );
  INVX1 U2864 ( .A(\reg_mem[27][2] ), .Y(n2445) );
  MUX2X1 U2865 ( .B(n2446), .A(n1250), .S(n1881), .Y(n1058) );
  NOR2X1 U2866 ( .A(n2447), .B(n2439), .Y(n1881) );
  INVX1 U2867 ( .A(\reg_mem[28][2] ), .Y(n2446) );
  MUX2X1 U2868 ( .B(n2448), .A(n1250), .S(n1883), .Y(n1057) );
  NOR2X1 U2869 ( .A(n2449), .B(n2439), .Y(n1883) );
  INVX1 U2870 ( .A(\reg_mem[29][2] ), .Y(n2448) );
  MUX2X1 U2871 ( .B(n2450), .A(n1250), .S(n1885), .Y(n1056) );
  NOR2X1 U2872 ( .A(n2451), .B(n2439), .Y(n1885) );
  INVX1 U2873 ( .A(\reg_mem[30][2] ), .Y(n2450) );
  MUX2X1 U2874 ( .B(n2452), .A(n1250), .S(n1887), .Y(n1055) );
  NOR2X1 U2875 ( .A(n2439), .B(n2275), .Y(n1887) );
  NAND3X1 U2876 ( .A(write_ptr[4]), .B(n2453), .C(n2274), .Y(n2439) );
  INVX1 U2877 ( .A(\reg_mem[31][2] ), .Y(n2452) );
  MUX2X1 U2878 ( .B(n2454), .A(n1250), .S(n1889), .Y(n1054) );
  NOR2X1 U2879 ( .A(n2455), .B(n2440), .Y(n1889) );
  INVX1 U2880 ( .A(\reg_mem[32][2] ), .Y(n2454) );
  MUX2X1 U2881 ( .B(n2456), .A(n1250), .S(n1891), .Y(n1053) );
  NOR2X1 U2882 ( .A(n2455), .B(n2442), .Y(n1891) );
  INVX1 U2883 ( .A(\reg_mem[33][2] ), .Y(n2456) );
  MUX2X1 U2884 ( .B(n2457), .A(n1250), .S(n1893), .Y(n1052) );
  NOR2X1 U2885 ( .A(n2455), .B(n2444), .Y(n1893) );
  INVX1 U2886 ( .A(\reg_mem[34][2] ), .Y(n2457) );
  MUX2X1 U2887 ( .B(n2458), .A(n1250), .S(n1895), .Y(n1051) );
  NOR2X1 U2888 ( .A(n2455), .B(n2262), .Y(n1895) );
  INVX1 U2889 ( .A(\reg_mem[35][2] ), .Y(n2458) );
  MUX2X1 U2890 ( .B(n2459), .A(n1250), .S(n1897), .Y(n1050) );
  NOR2X1 U2891 ( .A(n2455), .B(n2447), .Y(n1897) );
  INVX1 U2892 ( .A(\reg_mem[36][2] ), .Y(n2459) );
  MUX2X1 U2893 ( .B(n2460), .A(n1250), .S(n1899), .Y(n1049) );
  NOR2X1 U2894 ( .A(n2455), .B(n2449), .Y(n1899) );
  INVX1 U2895 ( .A(\reg_mem[37][2] ), .Y(n2460) );
  MUX2X1 U2896 ( .B(n2461), .A(n1250), .S(n1901), .Y(n1048) );
  NOR2X1 U2897 ( .A(n2455), .B(n2451), .Y(n1901) );
  INVX1 U2898 ( .A(\reg_mem[38][2] ), .Y(n2461) );
  MUX2X1 U2899 ( .B(n2462), .A(n1250), .S(n1903), .Y(n1047) );
  NOR2X1 U2900 ( .A(n2455), .B(n2275), .Y(n1903) );
  NAND3X1 U2901 ( .A(write_ptr[5]), .B(n2453), .C(n2463), .Y(n2455) );
  NOR2X1 U2902 ( .A(write_ptr[4]), .B(write_ptr[3]), .Y(n2463) );
  INVX1 U2903 ( .A(\reg_mem[39][2] ), .Y(n2462) );
  MUX2X1 U2904 ( .B(n2464), .A(n1250), .S(n1905), .Y(n1046) );
  NOR2X1 U2905 ( .A(n2465), .B(n2440), .Y(n1905) );
  INVX1 U2906 ( .A(\reg_mem[40][2] ), .Y(n2464) );
  MUX2X1 U2907 ( .B(n2466), .A(n1250), .S(n1907), .Y(n1045) );
  NOR2X1 U2908 ( .A(n2465), .B(n2442), .Y(n1907) );
  INVX1 U2909 ( .A(\reg_mem[41][2] ), .Y(n2466) );
  MUX2X1 U2910 ( .B(n2467), .A(n1250), .S(n1909), .Y(n1044) );
  NOR2X1 U2911 ( .A(n2465), .B(n2444), .Y(n1909) );
  INVX1 U2912 ( .A(\reg_mem[42][2] ), .Y(n2467) );
  MUX2X1 U2913 ( .B(n2468), .A(n1250), .S(n1911), .Y(n1043) );
  NOR2X1 U2914 ( .A(n2465), .B(n2262), .Y(n1911) );
  INVX1 U2915 ( .A(\reg_mem[43][2] ), .Y(n2468) );
  MUX2X1 U2916 ( .B(n2469), .A(n1250), .S(n1913), .Y(n1042) );
  NOR2X1 U2917 ( .A(n2465), .B(n2447), .Y(n1913) );
  INVX1 U2918 ( .A(\reg_mem[44][2] ), .Y(n2469) );
  MUX2X1 U2919 ( .B(n2470), .A(n1250), .S(n1915), .Y(n1041) );
  NOR2X1 U2920 ( .A(n2465), .B(n2449), .Y(n1915) );
  INVX1 U2921 ( .A(\reg_mem[45][2] ), .Y(n2470) );
  MUX2X1 U2922 ( .B(n2471), .A(n1250), .S(n1917), .Y(n1040) );
  NOR2X1 U2923 ( .A(n2465), .B(n2451), .Y(n1917) );
  INVX1 U2924 ( .A(\reg_mem[46][2] ), .Y(n2471) );
  MUX2X1 U2925 ( .B(n2472), .A(n1250), .S(n1919), .Y(n1039) );
  NOR2X1 U2926 ( .A(n2465), .B(n2275), .Y(n1919) );
  NAND3X1 U2927 ( .A(n2453), .B(n2473), .C(n2474), .Y(n2465) );
  NOR2X1 U2928 ( .A(n2277), .B(n2272), .Y(n2474) );
  INVX1 U2929 ( .A(\reg_mem[47][2] ), .Y(n2472) );
  MUX2X1 U2930 ( .B(n2475), .A(n1250), .S(n1921), .Y(n1038) );
  AND2X1 U2931 ( .A(n2476), .B(n2477), .Y(n1921) );
  INVX1 U2932 ( .A(\reg_mem[48][2] ), .Y(n2475) );
  MUX2X1 U2933 ( .B(n2478), .A(n1250), .S(n1923), .Y(n1037) );
  AND2X1 U2934 ( .A(n2476), .B(n2479), .Y(n1923) );
  INVX1 U2935 ( .A(\reg_mem[49][2] ), .Y(n2478) );
  MUX2X1 U2936 ( .B(n2480), .A(n1250), .S(n1925), .Y(n1036) );
  AND2X1 U2937 ( .A(n2476), .B(n2481), .Y(n1925) );
  INVX1 U2938 ( .A(\reg_mem[50][2] ), .Y(n2480) );
  MUX2X1 U2939 ( .B(n2482), .A(n1250), .S(n1927), .Y(n1035) );
  AND2X1 U2940 ( .A(n2476), .B(n2483), .Y(n1927) );
  INVX1 U2941 ( .A(\reg_mem[51][2] ), .Y(n2482) );
  MUX2X1 U2942 ( .B(n2484), .A(n1250), .S(n1929), .Y(n1034) );
  AND2X1 U2943 ( .A(n2476), .B(n2485), .Y(n1929) );
  INVX1 U2944 ( .A(\reg_mem[52][2] ), .Y(n2484) );
  MUX2X1 U2945 ( .B(n2486), .A(n1250), .S(n1931), .Y(n1033) );
  AND2X1 U2946 ( .A(n2476), .B(n2487), .Y(n1931) );
  INVX1 U2947 ( .A(\reg_mem[53][2] ), .Y(n2486) );
  MUX2X1 U2948 ( .B(n2488), .A(n1250), .S(n1933), .Y(n1032) );
  AND2X1 U2949 ( .A(n2476), .B(n2489), .Y(n1933) );
  INVX1 U2950 ( .A(\reg_mem[54][2] ), .Y(n2488) );
  MUX2X1 U2951 ( .B(n2490), .A(n1250), .S(n1935), .Y(n1031) );
  AND2X1 U2952 ( .A(n2476), .B(n2278), .Y(n1935) );
  NOR2X1 U2953 ( .A(n2491), .B(write_ptr[3]), .Y(n2476) );
  INVX1 U2954 ( .A(\reg_mem[55][2] ), .Y(n2490) );
  MUX2X1 U2955 ( .B(n2492), .A(n1250), .S(n1937), .Y(n1030) );
  AND2X1 U2956 ( .A(n2493), .B(n2477), .Y(n1937) );
  INVX1 U2957 ( .A(\reg_mem[56][2] ), .Y(n2492) );
  MUX2X1 U2958 ( .B(n2494), .A(n1250), .S(n1939), .Y(n1029) );
  AND2X1 U2959 ( .A(n2493), .B(n2479), .Y(n1939) );
  INVX1 U2960 ( .A(\reg_mem[57][2] ), .Y(n2494) );
  MUX2X1 U2961 ( .B(n2495), .A(n1250), .S(n1941), .Y(n1028) );
  AND2X1 U2962 ( .A(n2493), .B(n2481), .Y(n1941) );
  INVX1 U2963 ( .A(\reg_mem[58][2] ), .Y(n2495) );
  MUX2X1 U2964 ( .B(n2496), .A(n1250), .S(n1943), .Y(n1027) );
  AND2X1 U2965 ( .A(n2493), .B(n2483), .Y(n1943) );
  INVX1 U2966 ( .A(\reg_mem[59][2] ), .Y(n2496) );
  MUX2X1 U2967 ( .B(n2497), .A(n1250), .S(n1945), .Y(n1026) );
  AND2X1 U2968 ( .A(n2493), .B(n2485), .Y(n1945) );
  INVX1 U2969 ( .A(\reg_mem[60][2] ), .Y(n2497) );
  MUX2X1 U2970 ( .B(n2498), .A(n1250), .S(n1947), .Y(n1025) );
  AND2X1 U2971 ( .A(n2493), .B(n2487), .Y(n1947) );
  INVX1 U2972 ( .A(\reg_mem[61][2] ), .Y(n2498) );
  MUX2X1 U2973 ( .B(n2499), .A(n1250), .S(n1949), .Y(n1024) );
  AND2X1 U2974 ( .A(n2493), .B(n2489), .Y(n1949) );
  AOI22X1 U2975 ( .A(rx_packet_data[2]), .B(n2039), .C(tx_data[2]), .D(n2040), 
        .Y(n2412) );
  INVX1 U2976 ( .A(\reg_mem[62][2] ), .Y(n2499) );
  MUX2X1 U2977 ( .B(n2500), .A(n1252), .S(n1952), .Y(n1023) );
  AND2X1 U2978 ( .A(n2493), .B(n2278), .Y(n1952) );
  NOR2X1 U2979 ( .A(n2491), .B(n2277), .Y(n2493) );
  NAND3X1 U2980 ( .A(write_ptr[4]), .B(n2453), .C(write_ptr[5]), .Y(n2491) );
  INVX1 U2981 ( .A(\reg_mem[63][3] ), .Y(n2500) );
  MUX2X1 U2982 ( .B(n2501), .A(n1252), .S(n1954), .Y(n1022) );
  AND2X1 U2983 ( .A(n2502), .B(n2477), .Y(n1954) );
  INVX1 U2984 ( .A(\reg_mem[0][3] ), .Y(n2501) );
  MUX2X1 U2985 ( .B(n2503), .A(n1252), .S(n1956), .Y(n1021) );
  AND2X1 U2986 ( .A(n2502), .B(n2479), .Y(n1956) );
  INVX1 U2987 ( .A(\reg_mem[1][3] ), .Y(n2503) );
  MUX2X1 U2988 ( .B(n2504), .A(n1252), .S(n1958), .Y(n1020) );
  AND2X1 U2989 ( .A(n2502), .B(n2481), .Y(n1958) );
  INVX1 U2990 ( .A(\reg_mem[2][3] ), .Y(n2504) );
  MUX2X1 U2991 ( .B(n2505), .A(n1252), .S(n1960), .Y(n1019) );
  AND2X1 U2992 ( .A(n2502), .B(n2483), .Y(n1960) );
  INVX1 U2993 ( .A(\reg_mem[3][3] ), .Y(n2505) );
  MUX2X1 U2994 ( .B(n2506), .A(n1252), .S(n1962), .Y(n1018) );
  AND2X1 U2995 ( .A(n2502), .B(n2485), .Y(n1962) );
  INVX1 U2996 ( .A(\reg_mem[4][3] ), .Y(n2506) );
  MUX2X1 U2997 ( .B(n2507), .A(n1252), .S(n1964), .Y(n1017) );
  AND2X1 U2998 ( .A(n2502), .B(n2487), .Y(n1964) );
  INVX1 U2999 ( .A(\reg_mem[5][3] ), .Y(n2507) );
  MUX2X1 U3000 ( .B(n2508), .A(n1252), .S(n1966), .Y(n1016) );
  AND2X1 U3001 ( .A(n2502), .B(n2489), .Y(n1966) );
  INVX1 U3002 ( .A(\reg_mem[6][3] ), .Y(n2508) );
  MUX2X1 U3003 ( .B(n2509), .A(n1252), .S(n1968), .Y(n1015) );
  AND2X1 U3004 ( .A(n2502), .B(n2278), .Y(n1968) );
  INVX1 U3005 ( .A(n2275), .Y(n2278) );
  NOR2X1 U3006 ( .A(n2510), .B(write_ptr[4]), .Y(n2502) );
  INVX1 U3007 ( .A(\reg_mem[7][3] ), .Y(n2509) );
  MUX2X1 U3008 ( .B(n2511), .A(n1252), .S(n1970), .Y(n1014) );
  NOR2X1 U3009 ( .A(n2512), .B(n2440), .Y(n1970) );
  INVX1 U3010 ( .A(\reg_mem[8][3] ), .Y(n2511) );
  MUX2X1 U3011 ( .B(n2513), .A(n1252), .S(n1972), .Y(n1013) );
  NOR2X1 U3012 ( .A(n2512), .B(n2442), .Y(n1972) );
  INVX1 U3013 ( .A(\reg_mem[9][3] ), .Y(n2513) );
  MUX2X1 U3014 ( .B(n2514), .A(n1252), .S(n1974), .Y(n1012) );
  NOR2X1 U3015 ( .A(n2512), .B(n2444), .Y(n1974) );
  INVX1 U3016 ( .A(\reg_mem[10][3] ), .Y(n2514) );
  MUX2X1 U3017 ( .B(n2515), .A(n1252), .S(n1976), .Y(n1011) );
  NOR2X1 U3018 ( .A(n2512), .B(n2262), .Y(n1976) );
  INVX1 U3019 ( .A(\reg_mem[11][3] ), .Y(n2515) );
  MUX2X1 U3020 ( .B(n2516), .A(n1252), .S(n1978), .Y(n1010) );
  NOR2X1 U3021 ( .A(n2512), .B(n2447), .Y(n1978) );
  INVX1 U3022 ( .A(\reg_mem[12][3] ), .Y(n2516) );
  MUX2X1 U3023 ( .B(n2517), .A(n1252), .S(n1980), .Y(n1009) );
  NOR2X1 U3024 ( .A(n2512), .B(n2449), .Y(n1980) );
  INVX1 U3025 ( .A(\reg_mem[13][3] ), .Y(n2517) );
  MUX2X1 U3026 ( .B(n2518), .A(n1252), .S(n1982), .Y(n1008) );
  NOR2X1 U3027 ( .A(n2512), .B(n2451), .Y(n1982) );
  INVX1 U3028 ( .A(\reg_mem[14][3] ), .Y(n2518) );
  MUX2X1 U3029 ( .B(n2519), .A(n1252), .S(n1984), .Y(n1007) );
  NOR2X1 U3030 ( .A(n2512), .B(n2275), .Y(n1984) );
  NAND3X1 U3031 ( .A(write_ptr[1]), .B(write_ptr[0]), .C(write_ptr[2]), .Y(
        n2275) );
  NAND3X1 U3032 ( .A(n2453), .B(n2473), .C(n2274), .Y(n2512) );
  NOR2X1 U3033 ( .A(n2277), .B(write_ptr[5]), .Y(n2274) );
  INVX1 U3034 ( .A(\reg_mem[15][3] ), .Y(n2519) );
  MUX2X1 U3035 ( .B(n2520), .A(n1252), .S(n1986), .Y(n1006) );
  AND2X1 U3036 ( .A(n2477), .B(n2437), .Y(n1986) );
  INVX1 U3037 ( .A(n2440), .Y(n2477) );
  NAND3X1 U3038 ( .A(n2521), .B(n2522), .C(n2523), .Y(n2440) );
  INVX1 U3039 ( .A(\reg_mem[16][3] ), .Y(n2520) );
  MUX2X1 U3040 ( .B(n2524), .A(n1252), .S(n1988), .Y(n1005) );
  AND2X1 U3041 ( .A(n2479), .B(n2437), .Y(n1988) );
  INVX1 U3042 ( .A(n2442), .Y(n2479) );
  NAND3X1 U3043 ( .A(n2521), .B(n2522), .C(write_ptr[0]), .Y(n2442) );
  INVX1 U3044 ( .A(\reg_mem[17][3] ), .Y(n2524) );
  MUX2X1 U3045 ( .B(n2525), .A(n1252), .S(n1990), .Y(n1004) );
  AND2X1 U3046 ( .A(n2481), .B(n2437), .Y(n1990) );
  INVX1 U3047 ( .A(n2444), .Y(n2481) );
  NAND3X1 U3048 ( .A(n2523), .B(n2522), .C(write_ptr[1]), .Y(n2444) );
  INVX1 U3049 ( .A(\reg_mem[18][3] ), .Y(n2525) );
  MUX2X1 U3050 ( .B(n2526), .A(n1252), .S(n1992), .Y(n1003) );
  AND2X1 U3051 ( .A(n2483), .B(n2437), .Y(n1992) );
  INVX1 U3052 ( .A(n2262), .Y(n2483) );
  NAND3X1 U3053 ( .A(write_ptr[0]), .B(n2522), .C(write_ptr[1]), .Y(n2262) );
  INVX1 U3054 ( .A(write_ptr[2]), .Y(n2522) );
  INVX1 U3055 ( .A(\reg_mem[19][3] ), .Y(n2526) );
  MUX2X1 U3056 ( .B(n2527), .A(n1252), .S(n1994), .Y(n1002) );
  AND2X1 U3057 ( .A(n2485), .B(n2437), .Y(n1994) );
  INVX1 U3058 ( .A(n2447), .Y(n2485) );
  NAND3X1 U3059 ( .A(n2523), .B(n2521), .C(write_ptr[2]), .Y(n2447) );
  INVX1 U3060 ( .A(\reg_mem[20][3] ), .Y(n2527) );
  MUX2X1 U3061 ( .B(n2528), .A(n1252), .S(n1996), .Y(n1001) );
  AND2X1 U3062 ( .A(n2487), .B(n2437), .Y(n1996) );
  INVX1 U3063 ( .A(n2449), .Y(n2487) );
  NAND3X1 U3064 ( .A(write_ptr[0]), .B(n2521), .C(write_ptr[2]), .Y(n2449) );
  INVX1 U3065 ( .A(write_ptr[1]), .Y(n2521) );
  INVX1 U3066 ( .A(\reg_mem[21][3] ), .Y(n2528) );
  MUX2X1 U3067 ( .B(n2529), .A(n1252), .S(n1998), .Y(n1000) );
  AND2X1 U3068 ( .A(n2489), .B(n2437), .Y(n1998) );
  NOR2X1 U3069 ( .A(n2473), .B(n2510), .Y(n2437) );
  NAND3X1 U3070 ( .A(n2277), .B(n2272), .C(n2453), .Y(n2510) );
  INVX1 U3071 ( .A(n2530), .Y(n2453) );
  OAI21X1 U3072 ( .A(n2040), .B(n2039), .C(n_rst), .Y(n2530) );
  INVX1 U3073 ( .A(write_ptr[5]), .Y(n2272) );
  INVX1 U3074 ( .A(write_ptr[3]), .Y(n2277) );
  INVX1 U3075 ( .A(write_ptr[4]), .Y(n2473) );
  INVX1 U3076 ( .A(n2451), .Y(n2489) );
  NAND3X1 U3077 ( .A(write_ptr[1]), .B(n2523), .C(write_ptr[2]), .Y(n2451) );
  INVX1 U3078 ( .A(write_ptr[0]), .Y(n2523) );
  AOI22X1 U3079 ( .A(rx_packet_data[3]), .B(n2039), .C(tx_data[3]), .D(n2040), 
        .Y(n1870) );
  NOR2X1 U3080 ( .A(n2280), .B(n2040), .Y(n2039) );
  AND2X1 U3081 ( .A(store_tx_data), .B(n2531), .Y(n2040) );
  NAND2X1 U3082 ( .A(store_rx_packet_data), .B(n2531), .Y(n2280) );
  NAND2X1 U3083 ( .A(buffer_occupancy[6]), .B(n2532), .Y(n2531) );
  INVX1 U3084 ( .A(n2255), .Y(n2532) );
  NAND2X1 U3085 ( .A(n2533), .B(n2534), .Y(n2255) );
  NOR3X1 U3086 ( .A(buffer_occupancy[1]), .B(buffer_occupancy[2]), .C(
        buffer_occupancy[0]), .Y(n2534) );
  NOR3X1 U3087 ( .A(buffer_occupancy[4]), .B(buffer_occupancy[5]), .C(
        buffer_occupancy[3]), .Y(n2533) );
  INVX1 U3088 ( .A(\reg_mem[22][3] ), .Y(n2529) );
endmodule

