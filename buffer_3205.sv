module buffer_3205(
    input i_clk,
    input  [7:0]    i_pure_disparity,
    input           i_homogeneity,
    input           i_pure_valid,
    output [7:0]    o_pure_disparity,
    output          o_homogeneity,
    output          o_pure_valid
);
logic [7:0] pure_disparity;
logic homogeneity, pure_valid;
buffer_640_8bit buffer3200_8(
    .clock(i_clk),
    .shiftin(i_pure_disparity),
    .shiftout(pure_disparity),
    .taps()
);

buffer_640_1bit buffer3200_11(
    .clock(i_clk),
    .shiftin(i_homogeneity),
    .shiftout(homogeneity),
    .taps()
);
buffer_640_1bit buffer3200_12(
    .clock(i_clk),
    .shiftin(i_pure_valid),
    .shiftout(pure_valid),
    .taps()
);

buffer_5_8bit buffer_5_8(
    .clock(i_clk),
    .shiftin(pure_disparity),
    .shiftout(o_pure_disparity),
    .taps()
);

buffer_5_1bit buffer5_11(
    .clock(i_clk),
    .shiftin(homogeneity),
    .shiftout(o_homogeneity),
    .taps()
);
buffer_5_1bit buffer5_12(
    .clock(i_clk),
    .shiftin(pure_valid),
    .shiftout(o_pure_valid),
    .taps()
);



endmodule