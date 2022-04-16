//lpm_shiftreg CBX_SINGLE_OUTPUT_FILE="ON" LPM_DIRECTION="LEFT" LPM_TYPE="LPM_SHIFTREG" LPM_WIDTH=2 clock data enable load shiftout sset
//VERSION_BEGIN 15.0 cbx_mgl 2015:04:22:18:06:50:SJ cbx_stratixii 2015:04:22:18:04:08:SJ cbx_util_mgl 2015:04:22:18:04:08:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, the Altera Quartus II License Agreement,
//  the Altera MegaCore Function License Agreement, or other 
//  applicable license agreement, including, without limitation, 
//  that your use is for the sole purpose of programming logic 
//  devices manufactured by Altera and sold by Altera or its 
//  authorized distributors.  Please refer to the applicable 
//  agreement for further details.



//synthesis_resources = lpm_shiftreg 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mgcjc
	( 
	clock,
	data,
	enable,
	load,
	shiftout,
	sset) /* synthesis synthesis_clearbox=1 */;
	input   clock;
	input   [1:0]  data;
	input   enable;
	input   load;
	output   shiftout;
	input   sset;

	wire  wire_mgl_prim1_shiftout;

	lpm_shiftreg   mgl_prim1
	( 
	.clock(clock),
	.data(data),
	.enable(enable),
	.load(load),
	.shiftout(wire_mgl_prim1_shiftout),
	.sset(sset));
	defparam
		mgl_prim1.lpm_direction = "LEFT",
		mgl_prim1.lpm_type = "LPM_SHIFTREG",
		mgl_prim1.lpm_width = 2;
	assign
		shiftout = wire_mgl_prim1_shiftout;
endmodule //mgcjc
//VALID FILE
