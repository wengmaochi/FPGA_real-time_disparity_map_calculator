
// --------------------- module ---------------------

module windowAbsolute(
	input           i_clk,
                    i_rst_n,
                    i_valid,
    input   [7:0]   i_vector_l[4:0][4:0],
    input   [7:0]   i_vector_r[4:0][4:0],

    output          o_valid,
    output  [7:0]   o_vector_l[4:0][4:0],
    output  [7:0]   o_diff[4:0][4:0]
);
// --------------------- parameter ---------------------

localparam N = 3'd5;
integer i, j;


// --------------------- register ---------------------

logic       valid_w, valid_r;
logic [7:0] vector_w[4:0][4:0] ;
logic [7:0] vector_r[4:0][4:0] ;
logic [7:0] diff_w[4:0][4:0] ;
logic [7:0] diff_r[4:0][4:0] ;



// --------------------- wire ---------------------

// --------------------- debug ---------------------
// logic [7:0] test_vector ;
// assign test_vector = vector_r[0][4] ;
// logic [7:0] test_diff_at_absolute ;
// assign test_diff_at_absolute = diff_r[0][4] ;
// --------------------- output ---------------------

// for( i = 0 ; i < 5 ; i = i + 1 )begin
//     for( j = 0 ; j < 5 ; j = j + 1 )begin
//         assign o_vector_l[i][j] = vector_r[i][j] ;
//         assign o_diff[i][j] = diff_r[i][j] ;
//     end
// end

assign o_vector_l[0][0] = vector_r[0][0] ; assign o_vector_l[1][0] = vector_r[1][0] ; assign o_vector_l[2][0] = vector_r[2][0] ; assign o_vector_l[3][0] = vector_r[3][0] ; assign o_vector_l[4][0] = vector_r[4][0] ;
assign o_vector_l[0][1] = vector_r[0][1] ; assign o_vector_l[1][1] = vector_r[1][1] ; assign o_vector_l[2][1] = vector_r[2][1] ; assign o_vector_l[3][1] = vector_r[3][1] ; assign o_vector_l[4][1] = vector_r[4][1] ;
assign o_vector_l[0][2] = vector_r[0][2] ; assign o_vector_l[1][2] = vector_r[1][2] ; assign o_vector_l[2][2] = vector_r[2][2] ; assign o_vector_l[3][2] = vector_r[3][2] ; assign o_vector_l[4][2] = vector_r[4][2] ;
assign o_vector_l[0][3] = vector_r[0][3] ; assign o_vector_l[1][3] = vector_r[1][3] ; assign o_vector_l[2][3] = vector_r[2][3] ; assign o_vector_l[3][3] = vector_r[3][3] ; assign o_vector_l[4][3] = vector_r[4][3] ;
assign o_vector_l[0][4] = vector_r[0][4] ; assign o_vector_l[1][4] = vector_r[1][4] ; assign o_vector_l[2][4] = vector_r[2][4] ; assign o_vector_l[3][4] = vector_r[3][4] ; assign o_vector_l[4][4] = vector_r[4][4] ;

assign o_diff[0][0] =  diff_r[0][0] ; assign o_diff[1][0] =  diff_r[1][0] ; assign o_diff[2][0] =  diff_r[2][0] ; assign o_diff[3][0] =  diff_r[3][0] ; assign o_diff[4][0] =  diff_r[4][0] ;
assign o_diff[0][1] =  diff_r[0][1] ; assign o_diff[1][1] =  diff_r[1][1] ; assign o_diff[2][1] =  diff_r[2][1] ; assign o_diff[3][1] =  diff_r[3][1] ; assign o_diff[4][1] =  diff_r[4][1] ;
assign o_diff[0][2] =  diff_r[0][2] ; assign o_diff[1][2] =  diff_r[1][2] ; assign o_diff[2][2] =  diff_r[2][2] ; assign o_diff[3][2] =  diff_r[3][2] ; assign o_diff[4][2] =  diff_r[4][2] ;
assign o_diff[0][3] =  diff_r[0][3] ; assign o_diff[1][3] =  diff_r[1][3] ; assign o_diff[2][3] =  diff_r[2][3] ; assign o_diff[3][3] =  diff_r[3][3] ; assign o_diff[4][3] =  diff_r[4][3] ;
assign o_diff[0][4] =  diff_r[0][4] ; assign o_diff[1][4] =  diff_r[1][4] ; assign o_diff[2][4] =  diff_r[2][4] ; assign o_diff[3][4] =  diff_r[3][4] ; assign o_diff[4][4] =  diff_r[4][4] ;
assign o_valid = valid_r ;



// --------------------- combinational ---------------------

always_comb begin
    valid_w = i_valid ;
    for( i = 0 ; i < 5 ; i = i + 1 )begin
        for( j = 0 ; j < 5 ; j = j + 1 )begin
            vector_w[i][j] = i_vector_l[i][j] ;
            diff_w[i][j] = ( i_vector_l[i][j] > i_vector_r[i][j] ) ? i_vector_l[i][j] - i_vector_r[i][j] : i_vector_r[i][j] - i_vector_l[i][j] ; // abs
        end
    end 
end

// --------------------- sequencial ---------------------
always_ff @( posedge i_clk, negedge i_rst_n  )  begin
    if( !i_rst_n ) begin
        valid_r <= 1'b0 ;

        vector_r[0][0] <= 8'b0 ;  vector_r[1][0] <= 8'b0 ;  vector_r[2][0] <= 8'b0 ;  vector_r[3][0] <= 8'b0 ;  vector_r[4][0] <= 8'b0 ;
        vector_r[0][1] <= 8'b0 ;  vector_r[1][1] <= 8'b0 ;  vector_r[2][1] <= 8'b0 ;  vector_r[3][1] <= 8'b0 ;  vector_r[4][1] <= 8'b0 ;
        vector_r[0][2] <= 8'b0 ;  vector_r[1][2] <= 8'b0 ;  vector_r[2][2] <= 8'b0 ;  vector_r[3][2] <= 8'b0 ;  vector_r[4][2] <= 8'b0 ;
        vector_r[0][3] <= 8'b0 ;  vector_r[1][3] <= 8'b0 ;  vector_r[2][3] <= 8'b0 ;  vector_r[3][3] <= 8'b0 ;  vector_r[4][3] <= 8'b0 ;
        vector_r[0][4] <= 8'b0 ;  vector_r[1][4] <= 8'b0 ;  vector_r[2][4] <= 8'b0 ;  vector_r[3][4] <= 8'b0 ;  vector_r[4][4] <= 8'b0 ;

        diff_r[0][0] <= 8'b0 ;  diff_r[1][0] <= 8'b0 ;  diff_r[2][0] <= 8'b0 ;  diff_r[3][0] <= 8'b0 ;  diff_r[4][0] <= 8'b0 ;
        diff_r[0][1] <= 8'b0 ;  diff_r[1][1] <= 8'b0 ;  diff_r[2][1] <= 8'b0 ;  diff_r[3][1] <= 8'b0 ;  diff_r[4][1] <= 8'b0 ;
        diff_r[0][2] <= 8'b0 ;  diff_r[1][2] <= 8'b0 ;  diff_r[2][2] <= 8'b0 ;  diff_r[3][2] <= 8'b0 ;  diff_r[4][2] <= 8'b0 ;
        diff_r[0][3] <= 8'b0 ;  diff_r[1][3] <= 8'b0 ;  diff_r[2][3] <= 8'b0 ;  diff_r[3][3] <= 8'b0 ;  diff_r[4][3] <= 8'b0 ;
        diff_r[0][4] <= 8'b0 ;  diff_r[1][4] <= 8'b0 ;  diff_r[2][4] <= 8'b0 ;  diff_r[3][4] <= 8'b0 ;  diff_r[4][4] <= 8'b0 ;

    end
    else begin
        valid_r <= valid_w ;

        vector_r[0][0] <= vector_w[0][0] ;  vector_r[1][0] <= vector_w[1][0] ;  vector_r[2][0] <= vector_w[2][0] ;  vector_r[3][0] <= vector_w[3][0] ;  vector_r[4][0] <= vector_w[4][0] ;
        vector_r[0][1] <= vector_w[0][1] ;  vector_r[1][1] <= vector_w[1][1] ;  vector_r[2][1] <= vector_w[2][1] ;  vector_r[3][1] <= vector_w[3][1] ;  vector_r[4][1] <= vector_w[4][1] ;
        vector_r[0][2] <= vector_w[0][2] ;  vector_r[1][2] <= vector_w[1][2] ;  vector_r[2][2] <= vector_w[2][2] ;  vector_r[3][2] <= vector_w[3][2] ;  vector_r[4][2] <= vector_w[4][2] ;
        vector_r[0][3] <= vector_w[0][3] ;  vector_r[1][3] <= vector_w[1][3] ;  vector_r[2][3] <= vector_w[2][3] ;  vector_r[3][3] <= vector_w[3][3] ;  vector_r[4][3] <= vector_w[4][3] ;
        vector_r[0][4] <= vector_w[0][4] ;  vector_r[1][4] <= vector_w[1][4] ;  vector_r[2][4] <= vector_w[2][4] ;  vector_r[3][4] <= vector_w[3][4] ;  vector_r[4][4] <= vector_w[4][4] ;

        diff_r[0][0] <= diff_w[0][0] ;  diff_r[1][0] <= diff_w[1][0] ;  diff_r[2][0] <= diff_w[2][0] ;  diff_r[3][0] <= diff_w[3][0] ;  diff_r[4][0] <= diff_w[4][0] ;
        diff_r[0][1] <= diff_w[0][1] ;  diff_r[1][1] <= diff_w[1][1] ;  diff_r[2][1] <= diff_w[2][1] ;  diff_r[3][1] <= diff_w[3][1] ;  diff_r[4][1] <= diff_w[4][1] ;
        diff_r[0][2] <= diff_w[0][2] ;  diff_r[1][2] <= diff_w[1][2] ;  diff_r[2][2] <= diff_w[2][2] ;  diff_r[3][2] <= diff_w[3][2] ;  diff_r[4][2] <= diff_w[4][2] ;
        diff_r[0][3] <= diff_w[0][3] ;  diff_r[1][3] <= diff_w[1][3] ;  diff_r[2][3] <= diff_w[2][3] ;  diff_r[3][3] <= diff_w[3][3] ;  diff_r[4][3] <= diff_w[4][3] ;
        diff_r[0][4] <= diff_w[0][4] ;  diff_r[1][4] <= diff_w[1][4] ;  diff_r[2][4] <= diff_w[2][4] ;  diff_r[3][4] <= diff_w[3][4] ;  diff_r[4][4] <= diff_w[4][4] ;
    end
    // for( i = 0 ; i < 5 ; i = i + 1 )begin
    //     for( j = 0 ; j < 5 ; j = j + 1 )begin
    //         vector_r[i][j] <= vector_w[i][j] ;
    //         diff_r[i][j] <= diff_w[i][j] ;
    //     end
    // end
        

end
endmodule

