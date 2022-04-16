// used to construct pipeline
// send [20:0] crl only

// --------------------- parameter ---------------------

// --------------------- module ---------------------

module windowBuffer(
	input           i_clk,
                    i_rst_n,
                    i_valid,
    input   [20:0]  i_crl,
    
    output          o_valid,
    output  [20:0]  o_crl
);

// --------------------- register ---------------------

logic           valid_w, valid_r ;
logic   [20:0]  crl_w, crl_r ;

// --------------------- wire ---------------------

// --------------------- debug ---------------------
// logic [20:0] test_crl ;
// assign test_crl = crl_w ; 
// --------------------- output ---------------------
// adjust when N is modified, looking for built-in adder 

assign o_valid  = valid_r ;
assign o_crl    = crl_r ;

// --------------------- combinational ---------------------

always_comb begin
    valid_w = i_valid ;
    crl_w = i_crl ;
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

