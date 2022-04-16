
// --------------------- module ---------------------

module edgeDistance(
	input           i_clk,
                    i_rst_n,
                    i_valid,
    input   [7:0]   i_vector_l[4:0][4:0],
    input   [7:0]   i_vector_r[4:0][4:0],

    output          o_valid,
    output  [7:0]   o_distance_l, o_distance_r
);
// --------------------- parameter ---------------------
localparam N = 3'd5;
localparam BETA = 5'd40 ; //60 -> 45 -> 35 -> 40 -> 45
integer i ;

// --------------------- register ---------------------

logic       valid_w, valid_r;
logic [7:0] distance_l_w, distance_l_r, distance_r_w, distance_r_r ;

// --------------------- wire ---------------------

logic [7:0] abs_l, abs_r ;
// --------------------- debug ---------------------
logic [7:0] test_edge_left_00, test_edge_left_10 ;
logic [7:0] test_edge_right_00, test_edge_right_10 ;

assign test_edge_left_00 = i_vector_l[0][0] ;
assign test_edge_left_10 = i_vector_l[1][0] ;

assign test_edge_right_00 = i_vector_r[0][0] ;
assign test_edge_right_10 = i_vector_r[1][0] ;

// --------------------- output ---------------------


assign o_valid = valid_r ;
assign o_distance_l = distance_l_r ;
assign o_distance_r = distance_r_r ;

// --------------------- combinational ---------------------

assign abs_l = ( i_vector_l[0][0] > i_vector_l[1][0] ) ? i_vector_l[0][0] - i_vector_l[1][0] : i_vector_l[1][0] - i_vector_l[0][0] ;
assign abs_r = ( i_vector_r[0][0] > i_vector_r[1][0] ) ? i_vector_r[0][0] - i_vector_r[1][0] : i_vector_r[1][0] - i_vector_r[0][0] ;

always_comb begin
    valid_w = i_valid ;
    if( i_valid )begin
        if( abs_l > {3'b0, BETA} ) distance_l_w = 8'b0 ;
        else if( distance_l_r == 8'd255 ) distance_l_w = distance_l_r ;
        else distance_l_w = distance_l_r + 1'b1 ;

        if( abs_r > {3'b0, BETA} ) distance_r_w = 8'b0 ;
        else if( distance_r_r == 8'd255 ) distance_r_w = distance_r_r ;
        else distance_r_w = distance_r_r + 1'b1 ;
    end
    else begin
        distance_l_w = 8'b0 ;
        distance_r_w = 8'b0 ;
    end
end

// --------------------- sequencial ---------------------
always_ff @( posedge i_clk, negedge i_rst_n  )  begin
    if( !i_rst_n ) begin
        valid_r <= 1'b0 ;
        distance_l_r <= 8'b0 ;
        distance_r_r <= 8'b0 ;
    end
    else begin
        valid_r <= valid_w ;
        distance_l_r <= distance_l_w ;
        distance_r_r <= distance_r_w ;
    end
end
endmodule


// // --------- for buffer 33-cycle

// module edgeBuffer(
// 	input           i_clk,
//                     i_rst_n,
//                     i_valid,
//     input   [7:0]   i_distance_l,
//     input   [7:0]   i_distance_r,

//     output          o_valid,
//     output  [7:0]   o_distance_l, o_distance_r 
// );
// // --------------------- parameter ---------------------
// localparam N = 3'd5;
// localparam BETA = 5'd22 ;
// integer i ;

// // --------------------- register ---------------------

// logic       valid_w[32:0] ;
// logic       valid_r[32:0] ;
// logic [7:0] distance_l_w[32:0] ;
// logic [7:0] distance_l_r[32:0] ;
// logic [7:0] distance_r_w[32:0] ;
// logic [7:0] distance_r_r[32:0] ;

// // --------------------- wire ---------------------

// // --------------------- debug ---------------------

// // --------------------- output ---------------------


// assign o_valid = valid_r[32] ;
// assign o_distance_l = distance_l_r[32] ;
// assign o_distance_r = distance_r_r[32] ;

// // --------------------- combinational ---------------------

// always_comb begin
//     valid_w[0]      = i_valid ;
//     distance_l_w[0] = i_distance_l ;
//     distance_r_w[0] = i_distance_r ;
//     for( i = 1 ; i < 33 ; i = i + 1 ) begin
//         valid_w[i]      = valid_r[i - 1] ;
//         distance_l_w[i] = distance_l_r[i - 1] ;
//         distance_r_w[i] = distance_r_r[i - 1] ;
//     end
// end

// // --------------------- sequencial ---------------------
// always_ff @( posedge i_clk, negedge i_rst_n  )  begin
//     if( !i_rst_n ) begin
//         valid_r[0] <= 1'b0 ; valid_r[5] <= 1'b0 ; valid_r[10] <= 1'b0 ; valid_r[15] <= 1'b0 ; valid_r[20] <= 1'b0 ; valid_r[25] <= 1'b0 ; valid_r[30] <= 1'b0 ;
//         valid_r[1] <= 1'b0 ; valid_r[6] <= 1'b0 ; valid_r[11] <= 1'b0 ; valid_r[16] <= 1'b0 ; valid_r[21] <= 1'b0 ; valid_r[26] <= 1'b0 ; valid_r[31] <= 1'b0 ;
//         valid_r[2] <= 1'b0 ; valid_r[7] <= 1'b0 ; valid_r[12] <= 1'b0 ; valid_r[17] <= 1'b0 ; valid_r[22] <= 1'b0 ; valid_r[27] <= 1'b0 ; valid_r[32] <= 1'b0 ;
//         valid_r[3] <= 1'b0 ; valid_r[8] <= 1'b0 ; valid_r[13] <= 1'b0 ; valid_r[18] <= 1'b0 ; valid_r[23] <= 1'b0 ; valid_r[28] <= 1'b0 ;
//         valid_r[4] <= 1'b0 ; valid_r[9] <= 1'b0 ; valid_r[14] <= 1'b0 ; valid_r[19] <= 1'b0 ; valid_r[24] <= 1'b0 ; valid_r[29] <= 1'b0 ;

//         distance_l_r[0] <= 1'b0 ; distance_l_r[5] <= 1'b0 ; distance_l_r[10] <= 1'b0 ; distance_l_r[15] <= 1'b0 ; distance_l_r[20] <= 1'b0 ; distance_l_r[25] <= 1'b0 ; distance_l_r[30] <= 1'b0 ;
//         distance_l_r[1] <= 1'b0 ; distance_l_r[6] <= 1'b0 ; distance_l_r[11] <= 1'b0 ; distance_l_r[16] <= 1'b0 ; distance_l_r[21] <= 1'b0 ; distance_l_r[26] <= 1'b0 ; distance_l_r[31] <= 1'b0 ;
//         distance_l_r[2] <= 1'b0 ; distance_l_r[7] <= 1'b0 ; distance_l_r[12] <= 1'b0 ; distance_l_r[17] <= 1'b0 ; distance_l_r[22] <= 1'b0 ; distance_l_r[27] <= 1'b0 ; distance_l_r[32] <= 1'b0 ;
//         distance_l_r[3] <= 1'b0 ; distance_l_r[8] <= 1'b0 ; distance_l_r[13] <= 1'b0 ; distance_l_r[18] <= 1'b0 ; distance_l_r[23] <= 1'b0 ; distance_l_r[28] <= 1'b0 ;
//         distance_l_r[4] <= 1'b0 ; distance_l_r[9] <= 1'b0 ; distance_l_r[14] <= 1'b0 ; distance_l_r[19] <= 1'b0 ; distance_l_r[24] <= 1'b0 ; distance_l_r[29] <= 1'b0 ;

//         distance_r_r[0] <= 1'b0 ; distance_r_r[5] <= 1'b0 ; distance_r_r[10] <= 1'b0 ; distance_r_r[15] <= 1'b0 ; distance_r_r[20] <= 1'b0 ; distance_r_r[25] <= 1'b0 ; distance_r_r[30] <= 1'b0 ;
//         distance_r_r[1] <= 1'b0 ; distance_r_r[6] <= 1'b0 ; distance_r_r[11] <= 1'b0 ; distance_r_r[16] <= 1'b0 ; distance_r_r[21] <= 1'b0 ; distance_r_r[26] <= 1'b0 ; distance_r_r[31] <= 1'b0 ;
//         distance_r_r[2] <= 1'b0 ; distance_r_r[7] <= 1'b0 ; distance_r_r[12] <= 1'b0 ; distance_r_r[17] <= 1'b0 ; distance_r_r[22] <= 1'b0 ; distance_r_r[27] <= 1'b0 ; distance_r_r[32] <= 1'b0 ;
//         distance_r_r[3] <= 1'b0 ; distance_r_r[8] <= 1'b0 ; distance_r_r[13] <= 1'b0 ; distance_r_r[18] <= 1'b0 ; distance_r_r[23] <= 1'b0 ; distance_r_r[28] <= 1'b0 ;
//         distance_r_r[4] <= 1'b0 ; distance_r_r[9] <= 1'b0 ; distance_r_r[14] <= 1'b0 ; distance_r_r[19] <= 1'b0 ; distance_r_r[24] <= 1'b0 ; distance_r_r[29] <= 1'b0 ;
//         // for( i = 0 ; i < 33 ; i = i + 1 )begin
//         //     valid_r[i]      <= 1'b0 ;
//         //     distance_l_r[i] <= 8'b0 ;
//         //     distance_r_r[i] <= 8'b0 ;
//         // end 
//     end
//     else begin

//         valid_r[0] <= valid_w[0] ; valid_r[5] <= valid_w[5] ; valid_r[10] <= valid_w[10] ; valid_r[15] <= valid_w[15] ; valid_r[20] <= valid_w[20] ; valid_r[25] <= valid_w[25] ; valid_r[30] <= valid_w[30] ;
//         valid_r[1] <= valid_w[1] ; valid_r[6] <= valid_w[6] ; valid_r[11] <= valid_w[11] ; valid_r[16] <= valid_w[16] ; valid_r[21] <= valid_w[21] ; valid_r[26] <= valid_w[26] ; valid_r[31] <= valid_w[31] ;
//         valid_r[2] <= valid_w[2] ; valid_r[7] <= valid_w[7] ; valid_r[12] <= valid_w[12] ; valid_r[17] <= valid_w[17] ; valid_r[22] <= valid_w[22] ; valid_r[27] <= valid_w[27] ; valid_r[32] <= valid_w[32] ;
//         valid_r[3] <= valid_w[3] ; valid_r[8] <= valid_w[8] ; valid_r[13] <= valid_w[13] ; valid_r[18] <= valid_w[18] ; valid_r[23] <= valid_w[23] ; valid_r[28] <= valid_w[28] ;
//         valid_r[4] <= valid_w[4] ; valid_r[9] <= valid_w[9] ; valid_r[14] <= valid_w[14] ; valid_r[19] <= valid_w[19] ; valid_r[24] <= valid_w[24] ; valid_r[29] <= valid_w[29] ;

//         distance_l_r[0] <= distance_l_w[0] ; distance_l_r[5] <= distance_l_w[5] ; distance_l_r[10] <= distance_l_w[10] ; distance_l_r[15] <= distance_l_w[15] ; distance_l_r[20] <= distance_l_w[20] ; distance_l_r[25] <= distance_l_w[25] ; distance_l_r[30] <= distance_l_w[30] ;
//         distance_l_r[1] <= distance_l_w[1] ; distance_l_r[6] <= distance_l_w[6] ; distance_l_r[11] <= distance_l_w[11] ; distance_l_r[16] <= distance_l_w[16] ; distance_l_r[21] <= distance_l_w[21] ; distance_l_r[26] <= distance_l_w[26] ; distance_l_r[31] <= distance_l_w[31] ;
//         distance_l_r[2] <= distance_l_w[2] ; distance_l_r[7] <= distance_l_w[7] ; distance_l_r[12] <= distance_l_w[12] ; distance_l_r[17] <= distance_l_w[17] ; distance_l_r[22] <= distance_l_w[22] ; distance_l_r[27] <= distance_l_w[27] ; distance_l_r[32] <= distance_l_w[32] ;
//         distance_l_r[3] <= distance_l_w[3] ; distance_l_r[8] <= distance_l_w[8] ; distance_l_r[13] <= distance_l_w[13] ; distance_l_r[18] <= distance_l_w[18] ; distance_l_r[23] <= distance_l_w[23] ; distance_l_r[28] <= distance_l_w[28] ;
//         distance_l_r[4] <= distance_l_w[4] ; distance_l_r[9] <= distance_l_w[9] ; distance_l_r[14] <= distance_l_w[14] ; distance_l_r[19] <= distance_l_w[19] ; distance_l_r[24] <= distance_l_w[24] ; distance_l_r[29] <= distance_l_w[29] ;

//         distance_r_r[0] <= distance_r_w[0] ; distance_r_r[5] <= distance_r_w[5] ; distance_r_r[10] <= distance_r_w[10] ; distance_r_r[15] <= distance_r_w[15] ; distance_r_r[20] <= distance_r_w[20] ; distance_r_r[25] <= distance_r_w[25] ; distance_r_r[30] <= distance_r_w[30] ;
//         distance_r_r[1] <= distance_r_w[1] ; distance_r_r[6] <= distance_r_w[6] ; distance_r_r[11] <= distance_r_w[11] ; distance_r_r[16] <= distance_r_w[16] ; distance_r_r[21] <= distance_r_w[21] ; distance_r_r[26] <= distance_r_w[26] ; distance_r_r[31] <= distance_r_w[31] ;
//         distance_r_r[2] <= distance_r_w[2] ; distance_r_r[7] <= distance_r_w[7] ; distance_r_r[12] <= distance_r_w[12] ; distance_r_r[17] <= distance_r_w[17] ; distance_r_r[22] <= distance_r_w[22] ; distance_r_r[27] <= distance_r_w[27] ; distance_r_r[32] <= distance_r_w[32] ;
//         distance_r_r[3] <= distance_r_w[3] ; distance_r_r[8] <= distance_r_w[8] ; distance_r_r[13] <= distance_r_w[13] ; distance_r_r[18] <= distance_r_w[18] ; distance_r_r[23] <= distance_r_w[23] ; distance_r_r[28] <= distance_r_w[28] ;
//         distance_r_r[4] <= distance_r_w[4] ; distance_r_r[9] <= distance_r_w[9] ; distance_r_r[14] <= distance_r_w[14] ; distance_r_r[19] <= distance_r_w[19] ; distance_r_r[24] <= distance_r_w[24] ; distance_r_r[29] <= distance_r_w[29] ;
//         // for( i = 0 ; i < 33 ; i = i + 1 )begin
//         //     valid_r[i]      <= valid_w[i] ;
//         //     distance_l_r[i] <= distance_l_w[i] ;
//         //     distance_r_r[i] <= distance_r_w[i] ;
//         // end 
//     end
// end
// endmodule

