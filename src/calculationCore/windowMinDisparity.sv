// if this module violates cycle time, cut into pipeline
// use the first valid to decide where to store the disparity value


// --------------------- module ---------------------

module windowMinDisparity(
	input           i_clk,
                    i_rst_n,
                    i_valid,
    input   [20:0]  i_crl[31:0],
    
    output          o_valid,
    output  [7:0]   o_minDisparity
);
// --------------------- parameter ---------------------
localparam DMAX = 5'd31 ;
integer i, j, k, l;

// --------------------- register ---------------------

logic          valid_w, valid_r ;
logic   [7:0]  minDis_w, minDis_r ;

// --------------------- wire ---------------------
logic [20:0] crl_4[15:0] ;
logic [20:0] crl_3[7:0] ;
logic [20:0] crl_2[3:0] ;
logic [20:0] crl_1[1:0] ;

logic [4:0] dis_4[15:0] ;
logic [4:0] dis_3[7:0] ;
logic [4:0] dis_2[3:0] ;
logic [4:0] dis_1[1:0] ;
logic [4:0] dis_0 ;

// --------------------- debug ---------------------
// logic [20:0] min0, min1, min2, min3, min4, min5, min6, min7, min8, min9, min10, min23, min27, min30, min31 ;
// assign min0 = i_crl[0] ;
// assign min1 = i_crl[1] ;
// assign min2 = i_crl[2] ;
// assign min3 = i_crl[3] ;
// assign min4 = i_crl[4] ;
// assign min5 = i_crl[5] ;
// assign min6 = i_crl[6] ;
// assign min7 = i_crl[7] ;
// assign min8 = i_crl[8] ;
// assign min9 = i_crl[9] ;
// assign min10 = i_crl[10] ;
// assign min23 = i_crl[23] ;
// assign min27 = i_crl[27] ;
// assign min30 = i_crl[30] ;
// assign min31 = i_crl[31] ;

// --------------------- output ---------------------
// adjust when N is modified, looking for built-in adder 

assign o_minDisparity   = minDis_r ;
assign o_valid          = valid_r ;

// --------------------- combinational ---------------------



always_comb begin
    //stage 4
    for( i = 0 ; i < 16 ; i ++ ) begin
        crl_4[i] = ( i_crl[2*i] <= i_crl[2*i+1] ) ? i_crl[2*i] : i_crl[2*i+1] ;
        dis_4[i] = ( i_crl[2*i] <= i_crl[2*i+1] ) ? 2*i : 2*i + 1 ;
    end

    //stage 3
    for( j = 0 ; j < 8 ; j ++) begin
        crl_3[j] = ( crl_4[2*j] <= crl_4[2*j+1] ) ? crl_4[2*j] : crl_4[2*j+1] ;
        dis_3[j] = ( crl_4[2*j] <= crl_4[2*j+1] ) ? dis_4[2*j] : dis_4[2*j+1] ;
    end

    //stage 2
    for( k = 0 ; k < 4 ; k ++) begin
        crl_2[k] = ( crl_3[2*k] <= crl_3[2*k+1] ) ? crl_3[2*k] : crl_3[2*k+1] ;
        dis_2[k] = ( crl_3[2*k] <= crl_3[2*k+1] ) ? dis_3[2*k] : dis_3[2*k+1] ;
    end

    //stage 1
    for( l = 0 ; l < 2 ; l ++) begin
        crl_1[l] = ( crl_2[2*l] <= crl_2[2*l+1] ) ? crl_2[2*l] : crl_2[2*l+1] ;
        dis_1[l] = ( crl_2[2*l] <= crl_2[2*l+1] ) ? dis_2[2*l] : dis_2[2*l+1] ;
    end

    //stage 0
    dis_0 = ( crl_1[0] <= crl_1[1] ) ? dis_1[0] : dis_1[1] ;

    minDis_w = {dis_0, 3'b0} ; // if too white, use {1'b0, dis_0, 2'b0} instead
    valid_w = i_valid ;
end

// --------------------- sequencial ---------------------
always_ff @( posedge i_clk, negedge i_rst_n  )  begin
    if( !i_rst_n ) begin
        valid_r     <= 1'b0 ;
        minDis_r    <= 8'b0 ;
    end
    else begin
        valid_r     <= valid_w ;
        minDis_r    <= minDis_w ;
    end
end
endmodule

