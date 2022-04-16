// megafunction wizard: %Shift register (RAM-based)%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTSHIFT_TAPS 

// ============================================================
// File Name: crlBuffer_48.v
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
module crlBuffer_48 (
	clock,
	shiftin,
	shiftout,
	taps);

	input	  clock;
	input	[21:0]  shiftin;
	output	[21:0]  shiftout;
	output	[21:0]  taps;

	wire [21:0] sub_wire0;
	wire [21:0] sub_wire1;
	wire [21:0] shiftout = sub_wire0[21:0];
	wire [21:0] taps = sub_wire1[21:0];

	altshift_taps	ALTSHIFT_TAPS_component (
				.clock (clock),
				.shiftin (shiftin),
				.shiftout (sub_wire0),
				.taps (sub_wire1)
				// synopsys translate_off
				,
				.aclr (),
				.clken ()
				// synopsys translate_on
				);
	defparam
		ALTSHIFT_TAPS_component.intended_device_family = "Cyclone IV E",
		ALTSHIFT_TAPS_component.lpm_hint = "RAM_BLOCK_TYPE=M9K",
		ALTSHIFT_TAPS_component.lpm_type = "altshift_taps",
		ALTSHIFT_TAPS_component.number_of_taps = 1,
		ALTSHIFT_TAPS_component.tap_distance = 48,
		ALTSHIFT_TAPS_component.width = 22;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: ACLR NUMERIC "0"
// Retrieval info: PRIVATE: CLKEN NUMERIC "0"
// Retrieval info: PRIVATE: GROUP_TAPS NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: PRIVATE: NUMBER_OF_TAPS NUMERIC "1"
// Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "1"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: TAP_DISTANCE NUMERIC "48"
// Retrieval info: PRIVATE: WIDTH NUMERIC "22"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: CONSTANT: LPM_HINT STRING "RAM_BLOCK_TYPE=M9K"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altshift_taps"
// Retrieval info: CONSTANT: NUMBER_OF_TAPS NUMERIC "1"
// Retrieval info: CONSTANT: TAP_DISTANCE NUMERIC "48"
// Retrieval info: CONSTANT: WIDTH NUMERIC "22"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: USED_PORT: shiftin 0 0 22 0 INPUT NODEFVAL "shiftin[21..0]"
// Retrieval info: USED_PORT: shiftout 0 0 22 0 OUTPUT NODEFVAL "shiftout[21..0]"
// Retrieval info: USED_PORT: taps 0 0 22 0 OUTPUT NODEFVAL "taps[21..0]"
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: @shiftin 0 0 22 0 shiftin 0 0 22 0
// Retrieval info: CONNECT: shiftout 0 0 22 0 @shiftout 0 0 22 0
// Retrieval info: CONNECT: taps 0 0 22 0 @taps 0 0 22 0
// Retrieval info: GEN_FILE: TYPE_NORMAL crlBuffer_48.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL crlBuffer_48.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL crlBuffer_48.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL crlBuffer_48.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL crlBuffer_48_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL crlBuffer_48_bb.v TRUE
// Retrieval info: LIB_FILE: altera_mf
