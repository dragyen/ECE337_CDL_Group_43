module eop_detector(
    input logic dm_in, dp_in,
    output logic eop_det
);

assign eop_det = (dm_in == 0) && (dp_in == 0);

endmodule