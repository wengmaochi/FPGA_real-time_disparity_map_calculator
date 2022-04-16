// --------------------- module ---------------------

module calculationCore(
    input           i_clk,
    input           i_rst_n,
    input           i_valid,  // valid for first vector
    input   [7:0]   i_first_vector_l[4:0][4:0],
    input   [7:0]   i_first_vector_r[4:0][4:0],
    

    // output          o_test_for_inconsistent,
    
    output          o_valid,    // final valid 
    output  [7:0]   o_pure_disparity,
    output  [7:0]   o_edge_disparity,
    output          o_homogeneity

);

// -- test for inconsistent

// assign test_for_inconsistent = fifo_valid ^ o_valid ; // == 1 means inconsistent


// -- wire

// to buff 
logic   [7:0]   left_edge_to_buf; // connect to second buffer 
logic   [7:0]   right_edge_to_buf; // connect to second buffer 


// from buff 
logic [39:0] vector_l_1;
logic [39:0] vector_l_2;
logic [39:0] vector_l_3;
logic [39:0] vector_l_4;
logic [39:0] vector_l_5;
logic [39:0] vector_r_1;
logic [39:0] vector_r_2;
logic [39:0] vector_r_3;
logic [39:0] vector_r_4;
logic [39:0] vector_r_5;


logic   [7:0]   vector_l_from_buf[4:0][4:0] ; // from second buffer
logic   [7:0]   vector_r_from_buf[4:0][4:0] ;  // from second buffer
logic           valid_from_buf;  // valid for second, come in with data in the buffer

// left
assign vector_l_from_buf[0][0] = vector_l_5[39:32] ; assign vector_l_from_buf[1][0] = vector_l_5[31:24] ; assign vector_l_from_buf[2][0] = vector_l_5[23:16] ; assign vector_l_from_buf[3][0] = vector_l_5[15:8] ; assign vector_l_from_buf[4][0] = vector_l_5[7:0] ;
assign vector_l_from_buf[0][1] = vector_l_4[39:32] ; assign vector_l_from_buf[1][1] = vector_l_4[31:24] ; assign vector_l_from_buf[2][1] = vector_l_4[23:16] ; assign vector_l_from_buf[3][1] = vector_l_4[15:8] ; assign vector_l_from_buf[4][1] = vector_l_4[7:0] ;
assign vector_l_from_buf[0][2] = vector_l_3[39:32] ; assign vector_l_from_buf[1][2] = vector_l_3[31:24] ; assign vector_l_from_buf[2][2] = vector_l_3[23:16] ; assign vector_l_from_buf[3][2] = vector_l_3[15:8] ; assign vector_l_from_buf[4][2] = vector_l_3[7:0] ;
assign vector_l_from_buf[0][3] = vector_l_2[39:32] ; assign vector_l_from_buf[1][3] = vector_l_2[31:24] ; assign vector_l_from_buf[2][3] = vector_l_2[23:16] ; assign vector_l_from_buf[3][3] = vector_l_2[15:8] ; assign vector_l_from_buf[4][3] = vector_l_2[7:0] ;
assign vector_l_from_buf[0][4] = vector_l_1[39:32] ; assign vector_l_from_buf[1][4] = vector_l_1[31:24] ; assign vector_l_from_buf[2][4] = vector_l_1[23:16] ; assign vector_l_from_buf[3][4] = vector_l_1[15:8] ; assign vector_l_from_buf[4][4] = vector_l_1[7:0] ;

//right
assign vector_r_from_buf[0][0] = vector_r_5[39:32] ; assign vector_r_from_buf[1][0] = vector_r_5[31:24] ; assign vector_r_from_buf[2][0] = vector_r_5[23:16] ; assign vector_r_from_buf[3][0] = vector_r_5[15:8] ; assign vector_r_from_buf[4][0] = vector_r_5[7:0] ;
assign vector_r_from_buf[0][1] = vector_r_4[39:32] ; assign vector_r_from_buf[1][1] = vector_r_4[31:24] ; assign vector_r_from_buf[2][1] = vector_r_4[23:16] ; assign vector_r_from_buf[3][1] = vector_r_4[15:8] ; assign vector_r_from_buf[4][1] = vector_r_4[7:0] ;
assign vector_r_from_buf[0][2] = vector_r_3[39:32] ; assign vector_r_from_buf[1][2] = vector_r_3[31:24] ; assign vector_r_from_buf[2][2] = vector_r_3[23:16] ; assign vector_r_from_buf[3][2] = vector_r_3[15:8] ; assign vector_r_from_buf[4][2] = vector_r_3[7:0] ;
assign vector_r_from_buf[0][3] = vector_r_2[39:32] ; assign vector_r_from_buf[1][3] = vector_r_2[31:24] ; assign vector_r_from_buf[2][3] = vector_r_2[23:16] ; assign vector_r_from_buf[3][3] = vector_r_2[15:8] ; assign vector_r_from_buf[4][3] = vector_r_2[7:0] ;
assign vector_r_from_buf[0][4] = vector_r_1[39:32] ; assign vector_r_from_buf[1][4] = vector_r_1[31:24] ; assign vector_r_from_buf[2][4] = vector_r_1[23:16] ; assign vector_r_from_buf[3][4] = vector_r_1[15:8] ; assign vector_r_from_buf[4][4] = vector_r_1[7:0] ;



// to fifo
logic edge_disparity_valid, pure_disparity_valid, homo_valid ;
logic homo_to_fifo ;
logic [7:0] pure_disparity_to_fifo ;
disparityMap disMap1(
    //for SAD1, homo, edge_l, edge_r 
        //in 
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_valid(i_valid),
        .i_vector_l(i_first_vector_l),
        .i_vector_r(i_first_vector_r),

        //out
        .o_valid_edge(edge_disparity_valid),
        .o_left_edge(left_edge_to_buf),
        .o_right_edge(right_edge_to_buf),

        .o_valid_homo(homo_valid),
        .o_homogeneity(homo_to_fifo),

        .o_valid_disparity(pure_disparity_valid),
        .o_minDisparity(pure_disparity_to_fifo)
);

// write a FIFO for SAD1, homo, edge valid 
// input: pure_disparity_valid, homo_to_fifo, pure_disparity_to_fifo
// output: o_pure_disparity, o_homogeneity, fifo_valid
// should check if fifo_valid arrives at the same time o_valid arrives
// 640 * 5 + 5 cycles 

buffer_3205 buf_3205(
        //in
        .i_clk(i_clk),
        .i_pure_disparity(pure_disparity_to_fifo),
        .i_homogeneity(homo_to_fifo),
        .i_pure_valid(pure_disparity_valid),
        //out
        .o_pure_disparity(o_pure_disparity),
        .o_homogeneity(o_homogeneity),
        .o_pure_valid(fifo_valid)
);


// stroage vector for edge
RAM buffer_edge(
    //input
    .i_clk(i_clk),
    .rst_n(i_rst_n),
    .i_start(1'b1),
    .i_en(edge_disparity_valid),
    .i_left_image(left_edge_to_buf),
    .i_right_image(right_edge_to_buf),

    //output
    .vector_l_1(vector_l_1),
    .vector_l_2(vector_l_2),
    .vector_l_3(vector_l_3),
    .vector_l_4(vector_l_4),
    .vector_l_5(vector_l_5),
    .vector_r_1(vector_r_1),
    .vector_r_2(vector_r_2),
    .vector_r_3(vector_r_3),
    .vector_r_4(vector_r_4),
    .vector_r_5(vector_r_5),
	.o_en(valid_from_buf)
);


logic       unused_edge_valid, unused_homo_valid, unused_homo ;
logic [7:0] unused_edgeL, unused_edgeR ;

// o_pure_disparity, o_homogeneity
// disparityMapEdge disMap2(
//     //for SAD2
//         //in 
//         .i_clk(i_clk),
//         .i_rst_n(i_rst_n),
//         .i_valid(valid_from_buf),
//         .i_vector_l(vector_l_from_buf),
//         .i_vector_r(vector_r_from_buf),

//         //out

//         .o_valid_disparity(o_valid),
//         .o_minDisparity(o_edge_disparity)
// );
disparityMap disMap2(
    //for SAD2
        //in 
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_valid(valid_from_buf),
        .i_vector_l(vector_l_from_buf),
        .i_vector_r(vector_r_from_buf),

        //out
        .o_valid_edge(),
        .o_left_edge(),
        .o_right_edge(),

        .o_valid_homo(),
        .o_homogeneity(),

        //out

        .o_valid_disparity(o_valid),
        .o_minDisparity(o_edge_disparity)
);
endmodule

