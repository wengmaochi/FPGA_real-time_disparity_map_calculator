// take input from storage vector
// generate output as disparity for each pixel
// top module for all the window modules

// --------------------- module ---------------------

module disparityMap(
	input           i_clk,
                    i_rst_n,
                    i_valid,
    input   [7:0]   i_vector_l[4:0][4:0],
    input   [7:0]   i_vector_r[4:0][4:0],
    
    output          o_valid_edge,
    output  [7:0]   o_left_edge,
    output  [7:0]   o_right_edge,

    output          o_valid_homo,
    output          o_homogeneity,

    output          o_valid_disparity,
    output  [7:0]   o_minDisparity
);
// --------------------- parameter ---------------------

localparam N = 3'd5 ;
localparam DMAX = 5'd31 ;

// --------------------- register ---------------------

// --------------------- wire ---------------------

//---disparity 

//abs part
    logic           valid[31:0] ;
    logic   [7:0]   vector_l[31:0][4:0][4:0] ; // not sure if this is correct
    logic   [7:0]   diff[31:0][4:0][4:0] ; // not sure if this is correct
// end

//adder part
    logic           a_valid[31:0] ;
    logic   [20:0]  crl[31:0] ;
//end

//buffer part
    logic   [20:0]  buffer_0[30:0] ; // according to DMAX
    logic   [20:0]  buffer_1[29:0] ;
    logic   [20:0]  buffer_2[28:0] ;
    logic   [20:0]  buffer_3[27:0] ;
    logic   [20:0]  buffer_4[26:0] ;
    logic   [20:0]  buffer_5[25:0] ;
    logic   [20:0]  buffer_6[24:0] ;
    logic   [20:0]  buffer_7[23:0] ;
    logic   [20:0]  buffer_8[22:0] ;
    logic   [20:0]  buffer_9[21:0] ;
    logic   [20:0]  buffer_10[20:0] ;
    logic   [20:0]  buffer_11[19:0] ;
    logic   [20:0]  buffer_12[18:0] ;
    logic   [20:0]  buffer_13[17:0] ;
    logic   [20:0]  buffer_14[16:0] ;
    logic   [20:0]  buffer_15[15:0] ;
    logic   [20:0]  buffer_16[14:0] ;
    logic   [20:0]  buffer_17[13:0] ;
    logic   [20:0]  buffer_18[12:0] ;
    logic   [20:0]  buffer_19[11:0] ;
    logic   [20:0]  buffer_20[10:0] ;
    logic   [20:0]  buffer_21[9:0] ;
    logic   [20:0]  buffer_22[8:0] ;
    logic   [20:0]  buffer_23[7:0] ;
    logic   [20:0]  buffer_24[6:0] ;
    logic   [20:0]  buffer_25[5:0] ;
    logic   [20:0]  buffer_26[4:0] ;
    logic   [20:0]  buffer_27[3:0] ;
    logic   [20:0]  buffer_28[2:0] ;
    logic   [20:0]  buffer_29[1:0] ;
    logic   [20:0]  buffer_30 ;

    logic     b_valid_0[30:0] ; // according to DMAX
    logic     b_valid_1[29:0] ;
    logic     b_valid_2[28:0] ;
    logic     b_valid_3[27:0] ;
    logic     b_valid_4[26:0] ;
    logic     b_valid_5[25:0] ;
    logic     b_valid_6[24:0] ;
    logic     b_valid_7[23:0] ;
    logic     b_valid_8[22:0] ;
    logic     b_valid_9[21:0] ;
    logic     b_valid_10[20:0] ;
    logic     b_valid_11[19:0] ;
    logic     b_valid_12[18:0] ;
    logic     b_valid_13[17:0] ;
    logic     b_valid_14[16:0] ;
    logic     b_valid_15[15:0] ;
    logic     b_valid_16[14:0] ;
    logic     b_valid_17[13:0] ;
    logic     b_valid_18[12:0] ;
    logic     b_valid_19[11:0] ;
    logic     b_valid_20[10:0] ;
    logic     b_valid_21[9:0] ;
    logic     b_valid_22[8:0] ;
    logic     b_valid_23[7:0] ;
    logic     b_valid_24[6:0] ;
    logic     b_valid_25[5:0] ;
    logic     b_valid_26[4:0] ;
    logic     b_valid_27[3:0] ;
    logic     b_valid_28[2:0] ;
    logic     b_valid_29[1:0] ;
    logic     b_valid_30 ;
//end

//min part
    logic [20:0] m_crl[31:0] ;
    logic m_valid ;
//end

//---edge distance
//edge part
    logic           e2b_valid ;
    logic [7:0]     distance_l, distance_r ;
//


//---homogeneity
//homo part
    logic           h2b_valid, homogeneity ;



// --------------------- debug ---------------------

// --------------------- output ---------------------

// --------------------- modules to connect ---------------------


//---disparity 

//abs
generate
    genvar gen ;
    for( gen = 0 ; gen < 32 ; gen = gen + 1 )begin : abs 
        if( gen == 0 ) begin
            windowAbsolute winAbs_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(i_valid),
                .i_vector_l(i_vector_l),
                .i_vector_r(i_vector_r),
                
                //out
                .o_valid(valid[gen]),
                .o_vector_l(vector_l[gen]),
                .o_diff(diff[gen])
            );
        end
        else begin
            windowAbsolute winAbs_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(valid[gen-1]),
                .i_vector_l(vector_l[gen-1]),
                .i_vector_r(i_vector_r),
                
                //out
                .o_valid(valid[gen]), // valid[31] and vector_l[31] are abandoned
                .o_vector_l(vector_l[gen]),
                .o_diff(diff[gen])
            );
        end
    end
endgenerate

//adder
generate
    //genvar gen ;
    for( gen = 0 ; gen < 32 ; gen = gen + 1 )begin : add
        windowAddCorrelation winAddCor_gen(
            //in
            .i_clk(i_clk),
            .i_rst_n(i_rst_n),
            .i_valid(valid[gen]),
            .i_diff(diff[gen]),
            
            //out
            .o_valid(a_valid[gen]),
            .o_crl(crl[gen])
        );
    end
endgenerate

//buffer
generate
    //genvar gen ;
    // d = 0 
    for( gen = 0 ; gen < 31 ; gen = gen + 1 )begin : buf0
        if( gen == 0 ) begin
            windowBuffer winBuf_0_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[0]),
                .i_crl(crl[0]),
                
                //out
                .o_valid(b_valid_0[gen]),
                .o_crl(buffer_0[gen])
            );
        end
        else begin
            windowBuffer winBuf_0_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_0[gen-1]),
                .i_crl(buffer_0[gen-1]),
                
                //out
                .o_valid(b_valid_0[gen]),
                .o_crl(buffer_0[gen])
            );
        end
    end

    // d = 1 
    for( gen = 0 ; gen < 30 ; gen = gen + 1 )begin : buf1
        if( gen == 0 ) begin
            windowBuffer winBuf_1_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[1]),
                .i_crl(crl[1]),
                
                //out
                .o_valid(b_valid_1[gen]),
                .o_crl(buffer_1[gen])
            );
        end
        else begin
            windowBuffer winBuf_1_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_1[gen-1]),
                .i_crl(buffer_1[gen-1]),
                
                //out
                .o_valid(b_valid_1[gen]),
                .o_crl(buffer_1[gen])
            );
        end
    end

    // d = 2 
    for( gen = 0 ; gen < 29 ; gen = gen + 1 )begin : buf2
        if( gen == 0 ) begin
            windowBuffer winBuf_2_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[2]),
                .i_crl(crl[2]),
                
                //out
                .o_valid(b_valid_2[gen]),
                .o_crl(buffer_2[gen])
            );
        end
        else begin
            windowBuffer winBuf_2_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_2[gen-1]),
                .i_crl(buffer_2[gen-1]),
                
                //out
                .o_valid(b_valid_2[gen]),
                .o_crl(buffer_2[gen])
            );
        end
    end

    // d = 3 
    for( gen = 0 ; gen < 28 ; gen = gen + 1 )begin : buf3
        if( gen == 0 ) begin
            windowBuffer winBuf_3_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[3]),
                .i_crl(crl[3]),
                
                //out
                .o_valid(b_valid_3[gen]),
                .o_crl(buffer_3[gen])
            );
        end
        else begin
            windowBuffer winBuf_3_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_3[gen-1]),
                .i_crl(buffer_3[gen-1]),
                
                //out
                .o_valid(b_valid_3[gen]),
                .o_crl(buffer_3[gen])
            );
        end
    end

    // d = 4 
    for( gen = 0 ; gen < 27 ; gen = gen + 1 )begin : buf4
        if( gen == 0 ) begin
            windowBuffer winBuf_4_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[4]),
                .i_crl(crl[4]),
                
                //out
                .o_valid(b_valid_4[gen]),
                .o_crl(buffer_4[gen])
            );
        end
        else begin
            windowBuffer winBuf_4_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_4[gen-1]),
                .i_crl(buffer_4[gen-1]),
                
                //out
                .o_valid(b_valid_4[gen]),
                .o_crl(buffer_4[gen])
            );
        end
    end

    // d = 5 
    for( gen = 0 ; gen < 26 ; gen = gen + 1 )begin : buf5
        if( gen == 0 ) begin
            windowBuffer winBuf_5_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[5]),
                .i_crl(crl[5]),
                
                //out
                .o_valid(b_valid_5[gen]),
                .o_crl(buffer_5[gen])
            );
        end
        else begin
            windowBuffer winBuf_5_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_5[gen-1]),
                .i_crl(buffer_5[gen-1]),
                
                //out
                .o_valid(b_valid_5[gen]),
                .o_crl(buffer_5[gen])
            );
        end
    end

    // d = 6
    for( gen = 0 ; gen < 25 ; gen = gen + 1 )begin : buf6
        if( gen == 0 ) begin
            windowBuffer winBuf_6_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[6]),
                .i_crl(crl[6]),
                
                //out
                .o_valid(b_valid_6[gen]),
                .o_crl(buffer_6[gen])
            );
        end
        else begin
            windowBuffer winBuf_6_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_6[gen-1]),
                .i_crl(buffer_6[gen-1]),
                
                //out
                .o_valid(b_valid_6[gen]),
                .o_crl(buffer_6[gen])
            );
        end
    end

    // d = 7 
    for( gen = 0 ; gen < 24 ; gen = gen + 1 )begin : buf7
        if( gen == 0 ) begin
            windowBuffer winBuf_7_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[7]),
                .i_crl(crl[7]),
                
                //out
                .o_valid(b_valid_7[gen]),
                .o_crl(buffer_7[gen])
            );
        end
        else begin
            windowBuffer winBuf_7_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_7[gen-1]),
                .i_crl(buffer_7[gen-1]),
                
                //out
                .o_valid(b_valid_7[gen]),
                .o_crl(buffer_7[gen])
            );
        end
    end

    // d = 8 
    for( gen = 0 ; gen < 23 ; gen = gen + 1 )begin : buf8
        if( gen == 0 ) begin
            windowBuffer winBuf_8_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[8]),
                .i_crl(crl[8]),
                
                //out
                .o_valid(b_valid_8[gen]),
                .o_crl(buffer_8[gen])
            );
        end
        else begin
            windowBuffer winBuf_8_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_8[gen-1]),
                .i_crl(buffer_8[gen-1]),
                
                //out
                .o_valid(b_valid_8[gen]),
                .o_crl(buffer_8[gen])
            );
        end
    end

    // d = 9 
    for( gen = 0 ; gen < 22 ; gen = gen + 1 )begin : buf9
        if( gen == 0 ) begin
            windowBuffer winBuf_9_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[9]),
                .i_crl(crl[9]),
                
                //out
                .o_valid(b_valid_9[gen]),
                .o_crl(buffer_9[gen])
            );
        end
        else begin
            windowBuffer winBuf_9_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_9[gen-1]),
                .i_crl(buffer_9[gen-1]),
                
                //out
                .o_valid(b_valid_9[gen]),
                .o_crl(buffer_9[gen])
            );
        end
    end

    // d = 10 
    for( gen = 0 ; gen < 21 ; gen = gen + 1 )begin : buf10
        if( gen == 0 ) begin
            windowBuffer winBuf_10_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[10]),
                .i_crl(crl[10]),
                
                //out
                .o_valid(b_valid_10[gen]),
                .o_crl(buffer_10[gen])
            );
        end
        else begin
            windowBuffer winBuf_10_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_10[gen-1]),
                .i_crl(buffer_10[gen-1]),
                
                //out
                .o_valid(b_valid_10[gen]),
                .o_crl(buffer_10[gen])
            );
        end
    end

    // d = 11 
    for( gen = 0 ; gen < 20 ; gen = gen + 1 )begin : buf11
        if( gen == 0 ) begin
            windowBuffer winBuf_11_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[11]),
                .i_crl(crl[11]),
                
                //out
                .o_valid(b_valid_11[gen]),
                .o_crl(buffer_11[gen])
            );
        end
        else begin
            windowBuffer winBuf_11_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_11[gen-1]),
                .i_crl(buffer_11[gen-1]),
                
                //out
                .o_valid(b_valid_11[gen]),
                .o_crl(buffer_11[gen])
            );
        end
    end

    // d = 12 
    for( gen = 0 ; gen < 19 ; gen = gen + 1 )begin : buf12
        if( gen == 0 ) begin
            windowBuffer winBuf_12_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[12]),
                .i_crl(crl[12]),
                
                //out
                .o_valid(b_valid_12[gen]),
                .o_crl(buffer_12[gen])
            );
        end
        else begin
            windowBuffer winBuf_12_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_12[gen-1]),
                .i_crl(buffer_12[gen-1]),
                
                //out
                .o_valid(b_valid_12[gen]),
                .o_crl(buffer_12[gen])
            );
        end
    end

    // d = 13 
    for( gen = 0 ; gen < 18 ; gen = gen + 1 )begin : buf13
        if( gen == 0 ) begin
            windowBuffer winBuf_13_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[13]),
                .i_crl(crl[13]),
                
                //out
                .o_valid(b_valid_13[gen]),
                .o_crl(buffer_13[gen])
            );
        end
        else begin
            windowBuffer winBuf_13_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_13[gen-1]),
                .i_crl(buffer_13[gen-1]),
                
                //out
                .o_valid(b_valid_13[gen]),
                .o_crl(buffer_13[gen])
            );
        end
    end

    // d = 14
    for( gen = 0 ; gen < 17 ; gen = gen + 1 )begin : buf14
        if( gen == 0 ) begin
            windowBuffer winBuf_14_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[14]),
                .i_crl(crl[14]),
                
                //out
                .o_valid(b_valid_14[gen]),
                .o_crl(buffer_14[gen])
            );
        end
        else begin
            windowBuffer winBuf_14_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_14[gen-1]),
                .i_crl(buffer_14[gen-1]),
                
                //out
                .o_valid(b_valid_14[gen]),
                .o_crl(buffer_14[gen])
            );
        end
    end

    // d = 15 
    for( gen = 0 ; gen < 16 ; gen = gen + 1 )begin : buf15
        if( gen == 0 ) begin
            windowBuffer winBuf_15_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[15]),
                .i_crl(crl[15]),
                
                //out
                .o_valid(b_valid_15[gen]),
                .o_crl(buffer_15[gen])
            );
        end
        else begin
            windowBuffer winBuf_15_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_15[gen-1]),
                .i_crl(buffer_15[gen-1]),
                
                //out
                .o_valid(b_valid_15[gen]),
                .o_crl(buffer_15[gen])
            );
        end
    end

    // d = 16 
    for( gen = 0 ; gen < 15 ; gen = gen + 1 )begin : buf16
        if( gen == 0 ) begin
            windowBuffer winBuf_16_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[16]),
                .i_crl(crl[16]),
                
                //out
                .o_valid(b_valid_16[gen]),
                .o_crl(buffer_16[gen])
            );
        end
        else begin
            windowBuffer winBuf_16_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_16[gen-1]),
                .i_crl(buffer_16[gen-1]),
                
                //out
                .o_valid(b_valid_16[gen]),
                .o_crl(buffer_16[gen])
            );
        end
    end

    // d = 17 
    for( gen = 0 ; gen < 14 ; gen = gen + 1 )begin : buf17
        if( gen == 0 ) begin
            windowBuffer winBuf_17_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[17]),
                .i_crl(crl[17]),
                
                //out
                .o_valid(b_valid_17[gen]),
                .o_crl(buffer_17[gen])
            );
        end
        else begin
            windowBuffer winBuf_17_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_17[gen-1]),
                .i_crl(buffer_17[gen-1]),
                
                //out
                .o_valid(b_valid_17[gen]),
                .o_crl(buffer_17[gen])
            );
        end
    end

    // d = 18 
    for( gen = 0 ; gen < 13 ; gen = gen + 1 )begin : buf18
        if( gen == 0 ) begin
            windowBuffer winBuf_18_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[18]),
                .i_crl(crl[18]),
                
                //out
                .o_valid(b_valid_18[gen]),
                .o_crl(buffer_18[gen])
            );
        end
        else begin
            windowBuffer winBuf_18_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_18[gen-1]),
                .i_crl(buffer_18[gen-1]),
                
                //out
                .o_valid(b_valid_18[gen]),
                .o_crl(buffer_18[gen])
            );
        end
    end

    // d = 19 
    for( gen = 0 ; gen < 12 ; gen = gen + 1 )begin : buf19
        if( gen == 0 ) begin
            windowBuffer winBuf_19_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[19]),
                .i_crl(crl[19]),
                
                //out
                .o_valid(b_valid_19[gen]),
                .o_crl(buffer_19[gen])
            );
        end
        else begin
            windowBuffer winBuf_19_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_19[gen-1]),
                .i_crl(buffer_19[gen-1]),
                
                //out
                .o_valid(b_valid_19[gen]),
                .o_crl(buffer_19[gen])
            );
        end
    end

    // d = 20 
    for( gen = 0 ; gen < 11 ; gen = gen + 1 )begin : buf20
        if( gen == 0 ) begin
            windowBuffer winBuf_20_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[20]),
                .i_crl(crl[20]),
                
                //out
                .o_valid(b_valid_20[gen]),
                .o_crl(buffer_20[gen])
            );
        end
        else begin
            windowBuffer winBuf_20_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_20[gen-1]),
                .i_crl(buffer_20[gen-1]),
                
                //out
                .o_valid(b_valid_20[gen]),
                .o_crl(buffer_20[gen])
            );
        end
    end

    // d = 21 
    for( gen = 0 ; gen < 10 ; gen = gen + 1 )begin : buf21
        if( gen == 0 ) begin
            windowBuffer winBuf_21_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[21]),
                .i_crl(crl[21]),
                
                //out
                .o_valid(b_valid_21[gen]),
                .o_crl(buffer_21[gen])
            );
        end
        else begin
            windowBuffer winBuf_21_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_21[gen-1]),
                .i_crl(buffer_21[gen-1]),
                
                //out
                .o_valid(b_valid_21[gen]),
                .o_crl(buffer_21[gen])
            );
        end
    end

    // d = 22 
    for( gen = 0 ; gen < 9 ; gen = gen + 1 )begin : buf22
        if( gen == 0 ) begin
            windowBuffer winBuf_22_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[22]),
                .i_crl(crl[22]),
                
                //out
                .o_valid(b_valid_22[gen]),
                .o_crl(buffer_22[gen])
            );
        end
        else begin
            windowBuffer winBuf_22_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_22[gen-1]),
                .i_crl(buffer_22[gen-1]),
                
                //out
                .o_valid(b_valid_22[gen]),
                .o_crl(buffer_22[gen])
            );
        end
    end

    // d = 23 
    for( gen = 0 ; gen < 8 ; gen = gen + 1 )begin : buf23
        if( gen == 0 ) begin
            windowBuffer winBuf_23_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[23]),
                .i_crl(crl[23]),
                
                //out
                .o_valid(b_valid_23[gen]),
                .o_crl(buffer_23[gen])
            );
        end
        else begin
            windowBuffer winBuf_23_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_23[gen-1]),
                .i_crl(buffer_23[gen-1]),
                
                //out
                .o_valid(b_valid_23[gen]),
                .o_crl(buffer_23[gen])
            );
        end
    end

    // d = 24 
    for( gen = 0 ; gen < 7 ; gen = gen + 1 )begin : buf24
        if( gen == 0 ) begin
            windowBuffer winBuf_24_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[24]),
                .i_crl(crl[24]),
                
                //out
                .o_valid(b_valid_24[gen]),
                .o_crl(buffer_24[gen])
            );
        end
        else begin
            windowBuffer winBuf_24_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_24[gen-1]),
                .i_crl(buffer_24[gen-1]),
                
                //out
                .o_valid(b_valid_24[gen]),
                .o_crl(buffer_24[gen])
            );
        end
    end

    // d = 25 
    for( gen = 0 ; gen < 6 ; gen = gen + 1 )begin : buf25
        if( gen == 0 ) begin
            windowBuffer winBuf_25_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[25]),
                .i_crl(crl[25]),
                
                //out
                .o_valid(b_valid_25[gen]),
                .o_crl(buffer_25[gen])
            );
        end
        else begin
            windowBuffer winBuf_25_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_25[gen-1]),
                .i_crl(buffer_25[gen-1]),
                
                //out
                .o_valid(b_valid_25[gen]),
                .o_crl(buffer_25[gen])
            );
        end
    end

    // d = 26 
    for( gen = 0 ; gen < 5 ; gen = gen + 1 )begin : buf26
        if( gen == 0 ) begin
            windowBuffer winBuf_26_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[26]),
                .i_crl(crl[26]),
                
                //out
                .o_valid(b_valid_26[gen]),
                .o_crl(buffer_26[gen])
            );
        end
        else begin
            windowBuffer winBuf_26_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_26[gen-1]),
                .i_crl(buffer_26[gen-1]),
                
                //out
                .o_valid(b_valid_26[gen]),
                .o_crl(buffer_26[gen])
            );
        end
    end

    // d = 27 
    for( gen = 0 ; gen < 4 ; gen = gen + 1 )begin : buf27
        if( gen == 0 ) begin
            windowBuffer winBuf_27_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[27]),
                .i_crl(crl[27]),
                
                //out
                .o_valid(b_valid_27[gen]),
                .o_crl(buffer_27[gen])
            );
        end
        else begin
            windowBuffer winBuf_27_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_27[gen-1]),
                .i_crl(buffer_27[gen-1]),
                
                //out
                .o_valid(b_valid_27[gen]),
                .o_crl(buffer_27[gen])
            );
        end
    end

    // d = 28 
    for( gen = 0 ; gen < 3 ; gen = gen + 1 )begin : buf28
        if( gen == 0 ) begin
            windowBuffer winBuf_28_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[28]),
                .i_crl(crl[28]),
                
                //out
                .o_valid(b_valid_28[gen]),
                .o_crl(buffer_28[gen])
            );
        end
        else begin
            windowBuffer winBuf_28_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_28[gen-1]),
                .i_crl(buffer_28[gen-1]),
                
                //out
                .o_valid(b_valid_28[gen]),
                .o_crl(buffer_28[gen])
            );
        end
    end

    // d = 29 
    for( gen = 0 ; gen < 2 ; gen = gen + 1 )begin : buf29
        if( gen == 0 ) begin
            windowBuffer winBuf_29_0(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(a_valid[29]),
                .i_crl(crl[29]),
                
                //out
                .o_valid(b_valid_29[gen]),
                .o_crl(buffer_29[gen])
            );
        end
        else begin
            windowBuffer winBuf_29_gen(
                //in
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_valid(b_valid_29[gen-1]),
                .i_crl(buffer_29[gen-1]),
                
                //out
                .o_valid(b_valid_29[gen]),
                .o_crl(buffer_29[gen])
            );
        end
    end

    // d = 30 
    windowBuffer winBuf_30_0(
        //in
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_valid(a_valid[30]),
        .i_crl(crl[30]),
        
        //out
        .o_valid(b_valid_30),
        .o_crl(buffer_30)
    );

endgenerate

//minDis
    assign m_crl[0] = buffer_0[30] ;
    assign m_crl[1] = buffer_1[29] ;
    assign m_crl[2] = buffer_2[28] ; 
    assign m_crl[3] = buffer_3[27] ; 
    assign m_crl[4] = buffer_4[26] ; 
    assign m_crl[5] = buffer_5[25] ; 
    assign m_crl[6] = buffer_6[24] ; 
    assign m_crl[7] = buffer_7[23] ; 
    assign m_crl[8] = buffer_8[22] ; 
    assign m_crl[9] = buffer_9[21] ; 
    assign m_crl[10] = buffer_10[20] ; 
    assign m_crl[11] = buffer_11[19] ; 
    assign m_crl[12] = buffer_12[18] ; 
    assign m_crl[13] = buffer_13[17] ; 
    assign m_crl[14] = buffer_14[16] ; 
    assign m_crl[15] = buffer_15[15] ; 
    assign m_crl[16] = buffer_16[14] ; 
    assign m_crl[17] = buffer_17[13] ; 
    assign m_crl[18] = buffer_18[12] ; 
    assign m_crl[19] = buffer_19[11] ; 
    assign m_crl[20] = buffer_20[10] ; 
    assign m_crl[21] = buffer_21[9] ; 
    assign m_crl[22] = buffer_22[8] ; 
    assign m_crl[23] = buffer_23[7] ; 
    assign m_crl[24] = buffer_24[6] ; 
    assign m_crl[25] = buffer_25[5] ; 
    assign m_crl[26] = buffer_26[4] ; 
    assign m_crl[27] = buffer_27[3] ; 
    assign m_crl[28] = buffer_28[2] ; 
    assign m_crl[29] = buffer_29[1] ; 
    assign m_crl[30] = buffer_30 ;
    assign m_crl[31] = crl[31] ; 

    windowMinDisparity winMinDis(
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_valid(b_valid_0[30]),
        .i_crl(m_crl),

        .o_valid(o_valid_disparity),
        .o_minDisparity(o_minDisparity)
    );
//


//---edge distance
    edgeDistance edgDis(
        //in
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_valid(i_valid),
        .i_vector_l(i_vector_l),
        .i_vector_r(i_vector_r),

        //out
        .o_valid(o_valid_edge),
        .o_distance_l(o_left_edge),
        .o_distance_r(o_right_edge)
    );
//

//---buffer 30 cycles for edge -- canceled
    // edgeBuffer edgBuf(
    //     //in
    //     .i_clk(i_clk),
    //     .i_rst_n(i_rst_n),
    //     .i_valid(e2b_valid),
    //     .i_distance_l(distance_l),
    //     .i_distance_r(distance_r),

    //     //out
    //     .o_valid(o_valid_edge),
    //     .o_distance_l(o_left_edge),
    //     .o_distance_r(o_right_edge)
    // );
//

//---homogeneity, connect left to first abs's output, right to vector_l here
    homogeneityParameter homPar(
        //in
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_valid(valid[0]),
        .i_vector_l(vector_l[0]),
        .i_vector_r(i_vector_l),

        //out
        .o_valid(h2b_valid),
        .o_homogeneity(homogeneity)
    );
//



//---buffer 29 cycles for homo
    homoBuffer homBuf(
        //in
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_valid(h2b_valid),
        .i_homo(homogeneity),

        //out
        .o_valid(o_valid_homo),
        .o_homo(o_homogeneity)
    );
//


endmodule