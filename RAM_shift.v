// megafunction wizard: %Shift register (RAM-based)%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTSHIFT_TAPS 

// ============================================================
// File Name: RAM_shift.v
// Megafunction Name(s):
// 			ALTSHIFT_TAPS
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 15.0.0 Build 145 04/22/2015 SJ Full Version
// ************************************************************


//Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, the Altera Quartus II License Agreement,
//the Altera MegaCore Function License Agreement, or other 
//applicable license agreement, including, without limitation, 
//that your use is for the sole purpose of programming logic 
//devices manufactured by Altera and sold by Altera or its 
//authorized distributors.  Please refer to the applicable 
//agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module RAM_shift (
	aclr,
	clken,
	clock,
	shiftin,
	shiftout,
	taps0x,
	taps1x,
	taps2x,
	taps3x,
	taps4x);

	input	  aclr;
	input	  clken;
	input	  clock;
	input	[7:0]  shiftin;
	output	[7:0]  shiftout;
	output	[7:0]  taps0x;
	output	[7:0]  taps1x;
	output	[7:0]  taps2x;
	output	[7:0]  taps3x;
	output	[7:0]  taps4x;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1	  aclr;
	tri1	  clken;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire [7:0] sub_wire0;
	wire [39:0] sub_wire1;
	wire [7:0] shiftout = sub_wire0[7:0];
	wire [39:32] sub_wire9 = sub_wire1[39:32];
	wire [31:24] sub_wire8 = sub_wire1[31:24];
	wire [31:24] sub_wire7 = sub_wire8[31:24];
	wire [23:16] sub_wire6 = sub_wire1[23:16];
	wire [23:16] sub_wire5 = sub_wire6[23:16];
	wire [15:8] sub_wire4 = sub_wire1[15:8];
	wire [15:8] sub_wire3 = sub_wire4[15:8];
	wire [7:0] sub_wire2 = sub_wire1[7:0];
	wire [7:0] taps0x = sub_wire2[7:0];
	wire [7:0] taps1x = sub_wire3[15:8];
	wire [7:0] taps2x = sub_wire5[23:16];
	wire [7:0] taps3x = sub_wire7[31:24];
	wire [7:0] taps4x = sub_wire9[39:32];

	altshift_taps	ALTSHIFT_TAPS_component (
				.aclr (aclr),
				.clken (clken),
				.clock (clock),
				.shiftin (shiftin),
				.shiftout (sub_wire0),
				.taps (sub_wire1));
	defparam
		ALTSHIFT_TAPS_component.intended_device_family = "Cyclone IV E",
		ALTSHIFT_TAPS_component.lpm_hint = "RAM_BLOCK_TYPE=M9K",
		ALTSHIFT_TAPS_component.lpm_type = "altshift_taps",
		ALTSHIFT_TAPS_component.number_of_taps = 5,
		ALTSHIFT_TAPS_component.tap_distance = 640,
		ALTSHIFT_TAPS_component.width = 8;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: ACLR NUMERIC "1"
// Retrieval info: PRIVATE: CLKEN NUMERIC "1"
// Retrieval info: PRIVATE: GROUP_TAPS NUMERIC "1"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: PRIVATE: NUMBER_OF_TAPS NUMERIC "5"
// Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "1"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: TAP_DISTANCE NUMERIC "640"
// Retrieval info: PRIVATE: WIDTH NUMERIC "8"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: CONSTANT: LPM_HINT STRING "RAM_BLOCK_TYPE=M9K"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altshift_taps"
// Retrieval info: CONSTANT: NUMBER_OF_TAPS NUMERIC "5"
// Retrieval info: CONSTANT: TAP_DISTANCE NUMERIC "640"
// Retrieval info: CONSTANT: WIDTH NUMERIC "8"
// Retrieval info: USED_PORT: aclr 0 0 0 0 INPUT VCC "aclr"
// Retrieval info: USED_PORT: clken 0 0 0 0 INPUT VCC "clken"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: USED_PORT: shiftin 0 0 8 0 INPUT NODEFVAL "shiftin[7..0]"
// Retrieval info: USED_PORT: shiftout 0 0 8 0 OUTPUT NODEFVAL "shiftout[7..0]"
// Retrieval info: USED_PORT: taps0x 0 0 8 0 OUTPUT NODEFVAL "taps0x[7..0]"
// Retrieval info: USED_PORT: taps1x 0 0 8 0 OUTPUT NODEFVAL "taps1x[7..0]"
// Retrieval info: USED_PORT: taps2x 0 0 8 0 OUTPUT NODEFVAL "taps2x[7..0]"
// Retrieval info: USED_PORT: taps3x 0 0 8 0 OUTPUT NODEFVAL "taps3x[7..0]"
// Retrieval info: USED_PORT: taps4x 0 0 8 0 OUTPUT NODEFVAL "taps4x[7..0]"
// Retrieval info: CONNECT: @aclr 0 0 0 0 aclr 0 0 0 0
// Retrieval info: CONNECT: @clken 0 0 0 0 clken 0 0 0 0
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: @shiftin 0 0 8 0 shiftin 0 0 8 0
// Retrieval info: CONNECT: shiftout 0 0 8 0 @shiftout 0 0 8 0
// Retrieval info: CONNECT: taps0x 0 0 8 0 @taps 0 0 8 0
// Retrieval info: CONNECT: taps1x 0 0 8 0 @taps 0 0 8 8
// Retrieval info: CONNECT: taps2x 0 0 8 0 @taps 0 0 8 16
// Retrieval info: CONNECT: taps3x 0 0 8 0 @taps 0 0 8 24
// Retrieval info: CONNECT: taps4x 0 0 8 0 @taps 0 0 8 32
// Retrieval info: GEN_FILE: TYPE_NORMAL RAM_shift.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL RAM_shift.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL RAM_shift.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL RAM_shift.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL RAM_shift_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL RAM_shift_bb.v TRUE
// Retrieval info: LIB_FILE: altera_mf