module SIPO_vector(
    input           clk,
    // input           rst_n,
    input           en,
    input   [7:0]   i_line,
    output  [8*5-1:0] o_vector
);

logic [4:0] q0, q1, q2, q3, q4, q5, q6, q7;
logic [7:0] num0, num1, num2, num3, num4, num5, num6, num7, num8;

assign num0[7:0] = {q7[0], q6[0] ,q5[0], q4[0], q3[0], q2[0], q1[0], q0[0]};
assign num1[7:0] = {q7[1], q6[1] ,q5[1], q4[1], q3[1], q2[1], q1[1], q0[1]};
assign num2[7:0] = {q7[2], q6[2] ,q5[2], q4[2], q3[2], q2[2], q1[2], q0[2]};
assign num3[7:0] = {q7[3], q6[3] ,q5[3], q4[3], q3[3], q2[3], q1[3], q0[3]};
assign num4[7:0] = {q7[4], q6[4] ,q5[4], q4[4], q3[4], q2[4], q1[4], q0[4]};
assign o_vector = { num4[7:0], num3[7:0], num2[7:0], num1[7:0], num0[7:0]};
sipo bit0(
	.clock(clk),
	.enable(en),
	.shiftin(i_line[0]),
	.q(q0),
);
sipo bit1(
	.clock(clk),
	.enable(en),
	.shiftin(i_line[1]),
	.q(q1),
);
sipo bit2(
	.clock(clk),
	.enable(en),
	.shiftin(i_line[2]),
	.q(q2),
);
sipo bit3(
	.clock(clk),
	.enable(en),
	.shiftin(i_line[3]),
	.q(q3),
);
sipo bit4(
	.clock(clk),
	.enable(en),
	.shiftin(i_line[4]),
	.q(q4),
);
sipo bit5(
	.clock(clk),
	.enable(en),
	.shiftin(i_line[5]),
	.q(q5),
);
sipo bit6(
	.clock(clk),
	.enable(en),
	.shiftin(i_line[6]),
	.q(q6),
);
sipo bit7(
	.clock(clk),
	.enable(en),
	.shiftin(i_line[7]),
	.q(q7),
);

endmodule