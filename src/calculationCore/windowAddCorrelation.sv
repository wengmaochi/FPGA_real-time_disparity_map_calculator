// --------------------- module ---------------------

module windowAddCorrelation(
	input           i_clk,
                    i_rst_n,
                    i_valid,
    input   [7:0]   i_diff[4:0][4:0],

    output          o_valid,
    output  [20:0]  o_crl
);
// --------------------- parameter ---------------------

localparam N = 3'd5;
// --------------------- register ---------------------

logic         valid_w, valid_r ;
logic [20:0]  crl_w, crl_r ;

// --------------------- wire ---------------------

// --------------------- debug ---------------------
// logic [7:0] test_diff1, test_diff2, test_diff3, test_diff4, test_diff5  ;
// assign test_diff1 = i_diff[0][4] ;
// assign test_diff2 = i_diff[1][4] ;
// assign test_diff3 = i_diff[2][4] ;
// assign test_diff4 = i_diff[3][4] ;
// assign test_diff5 = i_diff[4][4] ;






// --------------------- output ---------------------
// adjust when N is modified, looking for built-in adder 

assign o_crl   = crl_r ;
assign o_valid = valid_r ;

// --------------------- combinational ---------------------

always_comb begin
    valid_w = i_valid ;
    crl_w = i_diff[0][0] + i_diff[0][1] + i_diff[0][2] + i_diff[0][3] + i_diff[0][4] +
            i_diff[1][0] + i_diff[1][1] + i_diff[1][2] + i_diff[1][3] + i_diff[1][4] + 
            i_diff[2][0] + i_diff[2][1] + i_diff[2][2] + i_diff[2][3] + i_diff[2][4] +
            i_diff[3][0] + i_diff[3][1] + i_diff[3][2] + i_diff[3][3] + i_diff[3][4] +
            i_diff[4][0] + i_diff[4][1] + i_diff[4][2] + i_diff[4][3] + i_diff[4][4] ;
end

// --------------------- sequencial ---------------------
always_ff @( posedge i_clk, negedge i_rst_n  )  begin
    if( !i_rst_n ) begin
        valid_r <= 1'b0 ;
        crl_r   <= 21'b0 ;
    end
    else begin
        valid_r <= valid_w ;
        crl_r   <= crl_w ;
    end
end
endmodule

