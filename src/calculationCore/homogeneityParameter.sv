

// --------------------- module ---------------------

module homogeneityParameter(
	input           i_clk,
                    i_rst_n,
                    i_valid,
    input   [7:0]   i_vector_l[4:0][4:0],
    input   [7:0]   i_vector_r[4:0][4:0],

    output          o_valid,
    output          o_homogeneity
);
// --------------------- parameter ---------------------

localparam N = 3'd5;
localparam LAMDA = 14'd35 ; //70  -> 40 
localparam LAMDA_MINUS = 14'd15 ; // true lamda = LAMDA - LAMDA_MINUS
integer i, j;

// --------------------- register ---------------------

logic           valid_w, valid_r ;
logic           homo_w, homo_r ;
logic  [7:0]    abs[4:0][4:0] ;

// --------------------- wire ---------------------
logic  [13:0]   sum ;
logic  [13:0]   cmp ;
// --------------------- debug ---------------------

// --------------------- output ---------------------

assign o_valid = valid_r ;
assign o_homogeneity = homo_r ;

// --------------------- combinational ---------------------
assign sum =    abs[0][0] + abs[0][1] + abs[0][2] + abs[0][3] + abs[0][4] +
                abs[1][0] + abs[1][1] + abs[1][2] + abs[1][3] + abs[1][4] + 
                abs[2][0] + abs[2][1] + abs[2][2] + abs[2][3] + abs[2][4] +
                abs[3][0] + abs[3][1] + abs[3][2] + abs[3][3] + abs[3][4] +
                abs[4][0] + abs[4][1] + abs[4][2] + abs[4][3] + abs[4][4] ;

assign cmp = sum + LAMDA_MINUS ;

always_comb begin
    valid_w = i_valid ;
    for( i = 0 ; i < N ; i = i + 1 )begin
        for( j = 0 ; j < N ; j = j + 1 )begin
            abs[i][j] = ( i_vector_l[i][j] > i_vector_r[i][j] ) ? i_vector_l[i][j] - i_vector_r[i][j] : i_vector_r[i][j] - i_vector_l[i][j] ; // abs
        end
    end
    if( cmp > LAMDA ) homo_w = 1'b1 ;
    else homo_w = 1'b0 ;
end

// --------------------- sequencial ---------------------
always_ff @( posedge i_clk, negedge i_rst_n  )  begin
    if( !i_rst_n ) begin
        valid_r <= 1'b0 ;
        homo_r  <= 1'b0 ;
    end
    else begin
        valid_r <= valid_w ;
        homo_r  <= homo_w ;
    end
end
endmodule


// --------- for buffer 32-cycle

module homoBuffer(
	input           i_clk,
                    i_rst_n,
                    i_valid,
    input           i_homo,

    output          o_valid,
    output          o_homo
);

// --------------------- parameter ---------------------


integer i;
// --------------------- register ---------------------

logic       valid_w[31:0] ;
logic       valid_r[31:0] ;
logic       homo_w[31:0] ;
logic       homo_r[31:0] ;

// --------------------- wire ---------------------

// --------------------- debug ---------------------

// --------------------- output ---------------------


assign o_valid = valid_r[31] ;
assign o_homo  = homo_r[31] ;

// --------------------- combinational ---------------------

always_comb begin
    valid_w[0]      = i_valid ;
    homo_w[0]       = i_homo ;
    for( i = 1 ; i < 32 ; i = i + 1 ) begin
        valid_w[i]      = valid_r[i - 1] ;
        homo_w[i]       = homo_r[i - 1] ;
    end
end

// --------------------- sequencial ---------------------
always_ff @( posedge i_clk, negedge i_rst_n  )  begin
    if( !i_rst_n ) begin

        valid_r[0] <= 1'b0 ; valid_r[5] <= 1'b0 ; valid_r[10] <= 1'b0 ; valid_r[15] <= 1'b0 ; valid_r[20] <= 1'b0 ; valid_r[25] <= 1'b0 ; valid_r[30] <= 1'b0 ;
        valid_r[1] <= 1'b0 ; valid_r[6] <= 1'b0 ; valid_r[11] <= 1'b0 ; valid_r[16] <= 1'b0 ; valid_r[21] <= 1'b0 ; valid_r[26] <= 1'b0 ; valid_r[31] <= 1'b0 ;
        valid_r[2] <= 1'b0 ; valid_r[7] <= 1'b0 ; valid_r[12] <= 1'b0 ; valid_r[17] <= 1'b0 ; valid_r[22] <= 1'b0 ; valid_r[27] <= 1'b0 ;
        valid_r[3] <= 1'b0 ; valid_r[8] <= 1'b0 ; valid_r[13] <= 1'b0 ; valid_r[18] <= 1'b0 ; valid_r[23] <= 1'b0 ; valid_r[28] <= 1'b0 ;
        valid_r[4] <= 1'b0 ; valid_r[9] <= 1'b0 ; valid_r[14] <= 1'b0 ; valid_r[19] <= 1'b0 ; valid_r[24] <= 1'b0 ; valid_r[29] <= 1'b0 ;

        homo_r[0] <= 1'b0 ; homo_r[5] <= 1'b0 ; homo_r[10] <= 1'b0 ; homo_r[15] <= 1'b0 ; homo_r[20] <= 1'b0 ; homo_r[25] <= 1'b0 ; homo_r[30] <= 1'b0 ;
        homo_r[1] <= 1'b0 ; homo_r[6] <= 1'b0 ; homo_r[11] <= 1'b0 ; homo_r[16] <= 1'b0 ; homo_r[21] <= 1'b0 ; homo_r[26] <= 1'b0 ; homo_r[31] <= 1'b0 ;
        homo_r[2] <= 1'b0 ; homo_r[7] <= 1'b0 ; homo_r[12] <= 1'b0 ; homo_r[17] <= 1'b0 ; homo_r[22] <= 1'b0 ; homo_r[27] <= 1'b0 ; 
        homo_r[3] <= 1'b0 ; homo_r[8] <= 1'b0 ; homo_r[13] <= 1'b0 ; homo_r[18] <= 1'b0 ; homo_r[23] <= 1'b0 ; homo_r[28] <= 1'b0 ;
        homo_r[4] <= 1'b0 ; homo_r[9] <= 1'b0 ; homo_r[14] <= 1'b0 ; homo_r[19] <= 1'b0 ; homo_r[24] <= 1'b0 ; homo_r[29] <= 1'b0 ;
        // for( i = 0 ; i < 32 ; i = i + 1 )begin
        //     valid_r[i]      <= 1'b0 ;
        //     homo_r[i]       <= 1'b0 ;
        // end 
    end
    else begin

        valid_r[0] <= valid_w[0] ; valid_r[5] <= valid_w[5] ; valid_r[10] <= valid_w[10] ; valid_r[15] <= valid_w[15] ; valid_r[20] <= valid_w[20] ; valid_r[25] <= valid_w[25] ; valid_r[30] <= valid_w[30] ; 
        valid_r[1] <= valid_w[1] ; valid_r[6] <= valid_w[6] ; valid_r[11] <= valid_w[11] ; valid_r[16] <= valid_w[16] ; valid_r[21] <= valid_w[21] ; valid_r[26] <= valid_w[26] ; valid_r[31] <= valid_w[31] ;
        valid_r[2] <= valid_w[2] ; valid_r[7] <= valid_w[7] ; valid_r[12] <= valid_w[12] ; valid_r[17] <= valid_w[17] ; valid_r[22] <= valid_w[22] ; valid_r[27] <= valid_w[27] ;
        valid_r[3] <= valid_w[3] ; valid_r[8] <= valid_w[8] ; valid_r[13] <= valid_w[13] ; valid_r[18] <= valid_w[18] ; valid_r[23] <= valid_w[23] ; valid_r[28] <= valid_w[28] ;
        valid_r[4] <= valid_w[4] ; valid_r[9] <= valid_w[9] ; valid_r[14] <= valid_w[14] ; valid_r[19] <= valid_w[19] ; valid_r[24] <= valid_w[24] ; valid_r[29] <= valid_w[29] ;

        homo_r[0] <= homo_w[0] ; homo_r[5] <= homo_w[5] ; homo_r[10] <= homo_w[10] ; homo_r[15] <= homo_w[15] ; homo_r[20] <= homo_w[20] ; homo_r[25] <= homo_w[25] ; homo_r[30] <= homo_w[30] ;
        homo_r[1] <= homo_w[1] ; homo_r[6] <= homo_w[6] ; homo_r[11] <= homo_w[11] ; homo_r[16] <= homo_w[16] ; homo_r[21] <= homo_w[21] ; homo_r[26] <= homo_w[26] ; homo_r[31] <= homo_w[31] ;
        homo_r[2] <= homo_w[2] ; homo_r[7] <= homo_w[7] ; homo_r[12] <= homo_w[12] ; homo_r[17] <= homo_w[17] ; homo_r[22] <= homo_w[22] ; homo_r[27] <= homo_w[27] ;
        homo_r[3] <= homo_w[3] ; homo_r[8] <= homo_w[8] ; homo_r[13] <= homo_w[13] ; homo_r[18] <= homo_w[18] ; homo_r[23] <= homo_w[23] ; homo_r[28] <= homo_w[28] ;
        homo_r[4] <= homo_w[4] ; homo_r[9] <= homo_w[9] ; homo_r[14] <= homo_w[14] ; homo_r[19] <= homo_w[19] ; homo_r[24] <= homo_w[24] ; homo_r[29] <= homo_w[29] ;

        // for( i = 0 ; i < 32 ; i = i + 1 )begin
        //     valid_r[i]      <= valid_w[i] ;
        //     homo_r[i]       <= homo_w[i] ;
        // end 
    end
end
endmodule
