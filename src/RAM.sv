module RAM(
    input         	    i_clk,
    input         	    rst_n,
    input         	    i_start,
	input 				i_en,
    input   [7:0] 	    i_left_image,
    input   [7:0] 	    i_right_image,
    output  [40-1:0] 	vector_l_1,
    output  [40-1:0] 	vector_l_2,
    output  [40-1:0] 	vector_l_3,
    output  [40-1:0] 	vector_l_4,
    output  [40-1:0] 	vector_l_5,
    output  [40-1:0] 	vector_r_1,
    output  [40-1:0] 	vector_r_2,
    output  [40-1:0] 	vector_r_3,
    output  [40-1:0] 	vector_r_4,
    output  [40-1:0] 	vector_r_5,
	output 				o_en

);
logic start_w, start_r ,aclr, en_w, en_r;
logic [7:0] left_image_w , left_image_r;
logic [7:0] right_image_w, right_image_r;
logic [7:0] line_l_1, line_r_1;
logic [7:0] line_l_2, line_r_2;
logic [7:0] line_l_3, line_r_3;
logic [7:0] line_l_4, line_r_4;
logic [7:0] line_l_5, line_r_5;

// logic [7:0] vector_l_1, vector_r_1;
// logic [7:0] vector_l_2, vector_r_2;
// logic [7:0] vector_l_3, vector_r_3;
// logic [7:0] vector_l_4, vector_r_4;
// logic [7:0] vector_l_5, vector_r_5;
assign aclr = 1'b0;
assign en_w = i_en;
assign left_image_w = i_left_image;
assign right_image_w = i_right_image;
assign start_w = i_start;
// taps0 -> line_l_1 -> vector_l_1

en_shift en_ram(
	.enable(1'b1),
	.clock(i_clk),
	.shiftin(en_r),
	.shiftout(o_en)
);


RAM_shift left_ram(
	.aclr(aclr),
	.clken(start_r),
	.clock(i_clk),
	.shiftin(left_image_r),
	.shiftout(),
	.taps0x(line_l_1),
	.taps1x(line_l_2),
	.taps2x(line_l_3),
	.taps3x(line_l_4),
	.taps4x(line_l_5),
);
RAM_shift right_ram(
	.aclr(aclr),
	.clken(start_r),
	.clock(i_clk),
	.shiftin(right_image_r),
	.shiftout(),
	.taps0x(line_r_1),
	.taps1x(line_r_2),
	.taps2x(line_r_3),
	.taps3x(line_r_4),
	.taps4x(line_r_5),       
);


SIPO_vector v_l_0( 
	.clk(i_clk),
	// .rst_n(),
	.en(start_r),
	.i_line(line_l_1),
	.o_vector(vector_l_1)
);
SIPO_vector v_l_1(
	.clk(i_clk),
	// .rst_n(),
	.en(start_r),
	.i_line(line_l_2),
	.o_vector(vector_l_2)
);
SIPO_vector v_l_2(
	.clk(i_clk),
	// .rst_n(),
	.en(start_r),
	.i_line(line_l_3),
	.o_vector(vector_l_3)
);
SIPO_vector v_l_3(
	.clk(i_clk),
	// .rst_n(),
	.en(start_r),
	.i_line(line_l_4),
	.o_vector(vector_l_4)
);
SIPO_vector v_l_4(
	.clk(i_clk),
	// .rst_n(),
	.en(start_r),
	.i_line(line_l_5),
	.o_vector(vector_l_5)
);
SIPO_vector v_r_0(
	.clk(i_clk),
	// .rst_n(),
	.en(start_r),
	.i_line(line_r_1),
	.o_vector(vector_r_1)
);
SIPO_vector v_r_1(
	.clk(i_clk),
	// .rst_n(),
	.en(start_r),
	.i_line(line_r_2),
	.o_vector(vector_r_2)
);

SIPO_vector v_r_2(
	.clk(i_clk),
	// .rst_n(),
	.en(start_r),
	.i_line(line_r_3),
	.o_vector(vector_r_3)
);

SIPO_vector v_r_3(
	.clk(i_clk),
	// .rst_n(),
	.en(start_r),
	.i_line(line_r_4),
	.o_vector(vector_r_4)
);

SIPO_vector v_r_4(
	.clk(i_clk),
	// .rst_n(),
	.en(start_r),
	.i_line(line_r_5),
	.o_vector(vector_r_5)
);



always @( posedge i_clk or negedge rst_n) begin
    if(!rst_n) begin
        left_image_r  <= '0;
        right_image_r <= '0;
        start_r <= '0;
		en_r <= '0;
    end
    else begin
        left_image_r <= left_image_w;
        right_image_r <= right_image_w;
        start_r <= start_w;
		en_r <= en_w;
    end
end
endmodule
