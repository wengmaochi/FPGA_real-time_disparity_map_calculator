module rgb2gray_2(
    input           clk,
    input           rst_n,
    input           i_DVAL,
    input   [7:0]   i_Green,
    input   [7:0]   i_Red,
    input   [7:0]   i_Blue,
    output          o_DVAL,
    output  [7:0]   o_gray
);



logic [7:0] gray_w, gray_r;
logic en_w, en_r;
logic [7:0] R_value, G_value, B_value, R_2, R_5, G_1, G_4, B_4, B_5;
logic [7:0] R, G, B;
assign R = i_Red;
assign G = i_Green;
assign B = i_Blue;
// assign R_2 = {2'b0, R[4:0], 1'b0};
// assign R_5 = {5'b0, R[4:2]};
// assign G_1 = {1'b0, G[5:0], 1'b0};
// assign G_4 = {4'b0, G[5:2]};
// assign B_4 = {4'b0, B[4:1]};
// assign B_5 = {5'b0, B[4:2]};
assign R_2 = {2'b0, R[7:3], 1'b0};
assign R_5 = {5'b0, R[7:5]};
assign G_1 = {1'b0, G[7:2], 1'b0};
assign G_4 = {4'b0, G[7:4]};
assign B_4 = {4'b0, B[7:4]};
assign B_5 = {5'b0, B[7:5]};
assign o_gray = gray_r;
assign o_DVAL = en_r;
always_comb begin 
    gray_w = R_2 + R_5 + G_1 + G_4 + B_4 + B_5;
    en_w   = i_DVAL;
end
always_ff @( posedge clk or negedge rst_n ) begin 
    if(!rst_n) begin
        gray_r <= '0;
        en_r   <= '0;
    end
    else begin
        gray_r <= gray_w;
        en_r   <= en_w;
    end
end

endmodule
