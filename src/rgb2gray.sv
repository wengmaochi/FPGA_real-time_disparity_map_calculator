module rgb2gray_1(
    input           clk, 
    input           rst_n,
    input   [7:0]   i_Green,
    input   [7:0]   i_Red,
    input   [7:0]   i_Blue,
    input           i_DVAL,
    output  [7:0]   o_gray,
    output          o_DVAL
);

logic [23:0] gray_w, gray_r, red_mul, green_mul, blue_mul;
logic en_w, en_r, en_r_w, en_r_r;
logic [7:0]  green_w, green_r, red_w, red_r, blue_w, blue_r;
assign red_mul[23:0] = red_r * 24'd19589;
assign green_mul[23:0] = green_r * 24'd38469;
assign blue_mul[23:0]  =  blue_r * 24'd7472;
assign o_gray[7:0]     = gray_r[23:16];
assign o_DVAL          = en_r_r;
//  gray <= 19589 * red + 38469 * green + 7471 * blue;
always_comb begin 
    red_w   = i_Red;
    green_w = i_Green;
    blue_w  = i_Blue;
    en_w    = i_DVAL;
    gray_w  = red_mul + green_mul + blue_mul;
    en_r_w  = en_r;
end


always_ff @( posedge clk or negedge rst_n ) begin 
    if(!rst_n) begin
        gray_r  <= '0;
        red_r   <= '0;
        green_r <= '0;
        blue_r  <= '0;
        en_r    <= '0;
        en_r_r  <= '0;
    end
    else begin
        gray_r <= gray_w;
        red_r   <= red_w;
        green_r <= green_w;
        blue_r  <= blue_w;
        en_r    <= en_w;
        en_r_r  <= en_r_w;
    end
end




endmodule
