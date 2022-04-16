`include "./VGA_Param.h" 

module DE2_115 (
	input CLOCK_50,
	input CLOCK2_50,
	input CLOCK3_50,
	input ENETCLK_25,
	input SMA_CLKIN,
	output SMA_CLKOUT,
	output [8:0] LEDG,
	output [17:0] LEDR,
	input [3:0] KEY,
	input [17:0] SW,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7,
	output LCD_BLON,
	inout [7:0] LCD_DATA,
	output LCD_EN,
	output LCD_ON,
	output LCD_RS,
	output LCD_RW,
	output UART_CTS,
	input UART_RTS,
	input UART_RXD,
	output UART_TXD,
	inout PS2_CLK,
	inout PS2_DAT,
	inout PS2_CLK2,
	inout PS2_DAT2,
	output SD_CLK,
	inout SD_CMD,
	inout [3:0] SD_DAT,
	input SD_WP_N,
	output [7:0] VGA_B,
	output VGA_BLANK_N,
	output VGA_CLK,
	output [7:0] VGA_G,
	output VGA_HS,
	output [7:0] VGA_R,
	output VGA_SYNC_N,
	output VGA_VS,
	input AUD_ADCDAT,
	inout AUD_ADCLRCK,
	inout AUD_BCLK,
	output AUD_DACDAT,
	inout AUD_DACLRCK,
	output AUD_XCK,
	output EEP_I2C_SCLK,
	inout EEP_I2C_SDAT,
	output I2C_SCLK,
	inout I2C_SDAT,
	output ENET0_GTX_CLK,
	input ENET0_INT_N,
	output ENET0_MDC,
	input ENET0_MDIO,
	output ENET0_RST_N,
	input ENET0_RX_CLK,
	input ENET0_RX_COL,
	input ENET0_RX_CRS,
	input [3:0] ENET0_RX_DATA,
	input ENET0_RX_DV,
	input ENET0_RX_ER,
	input ENET0_TX_CLK,
	output [3:0] ENET0_TX_DATA,
	output ENET0_TX_EN,
	output ENET0_TX_ER,
	input ENET0_LINK100,
	output ENET1_GTX_CLK,
	input ENET1_INT_N,
	output ENET1_MDC,
	input ENET1_MDIO,
	output ENET1_RST_N,
	input ENET1_RX_CLK,
	input ENET1_RX_COL,
	input ENET1_RX_CRS,
	input [3:0] ENET1_RX_DATA,
	input ENET1_RX_DV,
	input ENET1_RX_ER,
	input ENET1_TX_CLK,
	output [3:0] ENET1_TX_DATA,
	output ENET1_TX_EN,
	output ENET1_TX_ER,
	input ENET1_LINK100,
	input TD_CLK27,
	input [7:0] TD_DATA,
	input TD_HS,
	output TD_RESET_N,
	input TD_VS,
	inout [15:0] OTG_DATA,
	output [1:0] OTG_ADDR,
	output OTG_CS_N,
	output OTG_WR_N,
	output OTG_RD_N,
	input OTG_INT,
	output OTG_RST_N,
	input IRDA_RXD,
	output [12:0] DRAM_ADDR,
	output [1:0] DRAM_BA,
	output DRAM_CAS_N,
	output DRAM_CKE,
	output DRAM_CLK,
	output DRAM_CS_N,
	inout [31:0] DRAM_DQ,
	output [3:0] DRAM_DQM,
	output DRAM_RAS_N,
	output DRAM_WE_N,
	output [19:0] SRAM_ADDR,
	output SRAM_CE_N,
	inout [15:0] SRAM_DQ,
	output SRAM_LB_N,
	output SRAM_OE_N,
	output SRAM_UB_N,
	output SRAM_WE_N,
	output [22:0] FL_ADDR,
	output FL_CE_N,
	inout [7:0] FL_DQ,
	output FL_OE_N,
	output FL_RST_N,
	input FL_RY,
	output FL_WE_N,
	output FL_WP_N,
	inout [35:0] GPIO,
	input HSMC_CLKIN_P1,
	input HSMC_CLKIN_P2,
	input HSMC_CLKIN0,
	output HSMC_CLKOUT_P1,
	output HSMC_CLKOUT_P2,
	output HSMC_CLKOUT0,
	inout [3:0] HSMC_D,
	input [16:0] HSMC_RX_D_P,
	output [16:0] HSMC_TX_D_P,
	inout [6:0] EX_IO
);

logic key0down, key1down, key2down, key3down;
logic CLK_25M, CLK_24M, CLK_100K, CLK_800K, CLK_100M, CLK_100M_1;
logic [7:0] rgb1, rgb2; 
logic [5:0] stateeee1;
logic [5:0] stateeee2;
logic [5:0] stateeee3;
logic [5:0] stateeee4;
logic vsync_sig;
logic start_sig;

logic [ 7:0] cmos_data1, cmos_data2;
logic [15:0] cmos2fifo_wr_data1, cmos2fifo_wr_data2;
logic 		 cmos2fifo_wr_en1, cmos2fifo_wr_en2;
logic 		 cmos2fifo_wr_clk1, cmos2fifo_wr_clk2;

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire	[15:0]	Read_DATA1;
wire	[15:0]	Read_DATA2;

wire	[11:0]	mCCD_DATA;
wire			mCCD_DVAL;
wire			mCCD_DVAL_d;
wire	[15:0]	X_Cont;
wire	[15:0]	Y_Cont;
wire	[9:0]	X_ADDR;
wire	[31:0]	Frame_Cont;
wire			DLY_RST_0;
wire			DLY_RST_1;
wire			DLY_RST_2;
wire			DLY_RST_3;
wire			DLY_RST_4;
wire			Read;
reg		[11:0]	rCCD_DATA;
reg				rCCD_LVAL;
reg				rCCD_FVAL;
wire	[11:0]	sCCD_R;
wire	[11:0]	sCCD_G;
wire	[11:0]	sCCD_B;
wire			sCCD_DVAL;

wire			sdram_ctrl_clk;
wire	[9:0]	oVGA_R;   				//	VGA Red[9:0]
wire	[9:0]	oVGA_G;	 				//	VGA Green[9:0]
wire	[9:0]	oVGA_B;   				//	VGA Blue[9:0]



/************ CLK generate *************/

fp_qsys pll0( // generate with qsys, please follow lab2 tutorials
	.clk_clk(CLOCK_50),
	.reset_reset_n(KEY[3]),
	.altpll_25m_clk(CLK_25M),
	.altpll_100k_clk(CLK_100K),
	.altpll_100m_clk(CLK_100M),
	.altpll_100m_1_clk(CLK_100M_1),
);

// assign sdram_ctrl_clk = CLK_100M;
// assign DRAM_CLK = CLK_100M_1;
// assign D5M_XCLKIN = CLK_25M;
// assign VGA_CLK = CLK_25M;
sdram_pll 			u6	(
							.inclk0(CLOCK2_50),
							.c0(sdram_ctrl_clk),
							.c1(DRAM_CLK),
							.c2(D5M_XCLKIN), //25M
							.c3(VGA_CLK)     //25M 
						);

// //TEST D5M
logic 	 [11:0]				D5M_D;
logic		          		D5M_FVAL;
logic		          		D5M_LVAL;
logic		          		D5M_PIXLCLK;
logic		          		D5M_RESET_N;
logic		          		D5M_SCLK;
wire		          		D5M_SDATA;
logic		          		D5M_STROBE;
logic		          		D5M_TRIGGER;
logic		          		D5M_XCLKIN; //25M

// input
assign GPIO[0] = 1'bz;
assign GPIO[1] = 1'bz;
// assign GPIO[2] = 1'bz;
assign GPIO[3] = 1'bz;
assign GPIO[4] = 1'bz;
assign GPIO[5] = 1'bz;
assign GPIO[6] = 1'bz;
assign GPIO[7] = 1'bz;
assign GPIO[8] = 1'bz;
assign GPIO[9] = 1'bz;
assign GPIO[10] = 1'bz;
assign GPIO[11] = 1'bz;
assign GPIO[12] = 1'bz;
assign GPIO[13] = 1'bz;
assign GPIO[20] = 1'bz;
assign GPIO[21] = 1'bz;
assign GPIO[22] = 1'bz;



//one camera

assign D5M_PIXLCLK 	= GPIO[0];
assign D5M_D[11] 	= GPIO[1];
//GPIO[2] NC
assign D5M_D[10] 	= GPIO[3];
assign D5M_D[9] 	= GPIO[4];
assign D5M_D[8] 	= GPIO[5];
assign D5M_D[7] 	= GPIO[6];
assign D5M_D[6] 	= GPIO[7];
assign D5M_D[5] 	= GPIO[8];
assign D5M_D[4] 	= GPIO[9];
assign D5M_D[3] 	= GPIO[10];
assign D5M_D[2] 	= GPIO[11];
assign D5M_D[1] 	= GPIO[12];
assign D5M_D[0] 	= GPIO[13];
// GPIO[14] NC
// GPIO[15] NC
assign D5M_STROBE   = GPIO[20];
assign D5M_LVAL     = GPIO[21];
assign D5M_FVAL 	= GPIO[22];

//output
logic en = 1;

assign GPIO[16] 	= D5M_XCLKIN;	// D5M_XCLKIN
assign GPIO[17] 	= DLY_RST_1; // D5M_RESET_N
//     GPIO[18] NC
assign GPIO[19] 	= 1'b1;   // D5M_TRIGGER

assign GPIO[24]     = D5M_SCLK;
//---------------------------------------
// // input
// assign GPIO[0] = 1'bz;
// assign GPIO[1] = 1'bz;
// assign GPIO[2] = 1'bz;
// assign GPIO[3] = 1'bz;
// assign GPIO[4] = 1'bz;
// assign GPIO[5] = 1'bz;
// assign GPIO[6] = 1'bz;
// assign GPIO[7] = 1'bz;
// assign GPIO[8] = 1'bz;
// assign GPIO[9] = 1'bz;
// assign GPIO[10] = 1'bz;
// assign GPIO[11] = 1'bz;
// // assign GPIO[12] = 1'bz;
// assign GPIO[13] = 1'bz;
// assign GPIO[14] = 1'bz;
// // assign GPIO[15] = 1'bz;
// assign GPIO[16] = 1'bz;
// // assign GPIO[17] = 1'bz;
// // assign GPIO[18] = 1'bz;
// assign GPIO[19] = 1'bz;
// //assign GPIO[20] = 1'bz;
// // assign GPIO[21] = 1'bz;
// // assign GPIO[22] = 1'bz;



// //one camera

// assign D5M_PIXLCLK 	= GPIO[0];
// assign D5M_D[9] 	= GPIO[2];
// assign D5M_D[7] 	= GPIO[4];
// assign D5M_D[5] 	= GPIO[6];
// assign D5M_D[3] 	= GPIO[8];
// assign D5M_D[1] 	= GPIO[10];
// assign GPIO[12] 	= D5M_XCLKIN;	// D5M_XCLKIN
// assign D5M_STROBE   = GPIO[14];
// assign D5M_FVAL 	= GPIO[16];
// assign GPIO[18]     = D5M_SCLK;


// assign D5M_D[11] 	= GPIO[1];
// assign D5M_D[10] 	= GPIO[3];
// assign D5M_D[8] 	= GPIO[5];
// assign D5M_D[6] 	= GPIO[7];
// assign D5M_D[4] 	= GPIO[9];
// assign D5M_D[2] 	= GPIO[11];
// assign D5M_D[0] 	= GPIO[13];
// assign GPIO[15] 	= DLY_RST_1; // D5M_RESET_N
// // assign GPIO[17] 	= 1'b1;   // D5M_TRIGGER

// assign D5M_LVAL     = GPIO[19];

// // two camera 

// assign GPIO[20] = 1'bz;
// assign GPIO[1] = 1'bz;
// assign GPIO[22] = 1'bz;
// assign GPIO[3] = 1'bz;
// assign GPIO[24] = 1'bz;
// assign GPIO[5] = 1'bz;
// assign GPIO[26] = 1'bz;
// assign GPIO[7] = 1'bz;
// assign GPIO[28] = 1'bz;
// assign GPIO[9] = 1'bz;
// assign GPIO[30] = 1'bz;
// assign GPIO[11] = 1'bz;
// // assign GPIO[12] = 1'bz;
// assign GPIO[13] = 1'bz;
// assign GPIO[34] = 1'bz;
// // assign GPIO[15] = 1'bz;
// assign GPIO[36] = 1'bz;
// // assign GPIO[17] = 1'bz;
// // assign GPIO[18] = 1'bz;
// assign GPIO[19] = 1'bz;
// // assign GPIO[40] = 1'bz;
// // assign GPIO[21] = 1'bz;
// // assign GPIO[22] = 1'bz;

// assign D5M_PIXLCLK 	= GPIO[20];
// assign D5M_D[9] 	= GPIO[22];
// assign D5M_D[7] 	= GPIO[24];
// assign D5M_D[5] 	= GPIO[26];
// assign D5M_D[3] 	= GPIO[28];
// assign D5M_D[1] 	= GPIO[30];
// assign GPIO[32] 	= D5M_XCLKIN;	// D5M_XCLKIN
// assign D5M_STROBE   = GPIO[34];
// assign D5M_FVAL 	= GPIO[36];
// assign GPIO[38]     = D5M_SCLK;


// assign D5M_D[11] 	= GPIO[23];
// assign D5M_D[10] 	= GPIO[25];
// assign D5M_D[8] 	= GPIO[27];
// assign D5M_D[6] 	= GPIO[29];
// assign D5M_D[4] 	= GPIO[31];
// assign D5M_D[2] 	= GPIO[33];
// assign D5M_D[0] 	= GPIO[35];
// assign GPIO[37] 	= DLY_RST_1; // D5M_RESET_N
// assign GPIO[39] 	= 1'b1;   // D5M_TRIGGER

// assign D5M_LVAL     = GPIO[41];

//output
// logic en = 1;




//---------------------------------------

//power on start
wire             auto_start;
//=======================================================
//  Structural coding
//=======================================================
assign  VGA_CTRL_CLK = ~VGA_CLK;

assign	LEDR		=	SW;
assign	LEDG		=	Y_Cont;  
// assign	UART_TXD    = UART_RXD;     

// // 1+2+3 沒有綠點 沒有紅點 畫面藍色  //x
// // 1+3 沒有綠點 沒有紅點 有奇怪的流星 畫面感覺飽和度過高 
// // 1+2 紅色條紋 畫面藍色
// // 2+3 沒有綠點 有紅點
// // 1 有綠點 有一點點紅點  // x
// // 3 沒有綠點 有紅點

//fetch the high 8 bits
assign  VGA_R = oVGA_R[9:2];
assign  VGA_G = oVGA_G[9:2];
assign  VGA_B = oVGA_B[9:2];

//D5M read 
always_ff @(posedge D5M_PIXLCLK)
begin
	rCCD_DATA	<=	D5M_D;
	rCCD_LVAL	<=	D5M_LVAL;
	rCCD_FVAL	<=	D5M_FVAL;
end

//auto start when power on
assign auto_start = ((KEY[0])&&(DLY_RST_3)&&(!DLY_RST_4))? 1'b1:1'b0;
//Reset module
Reset_Delay			u2	(	.iCLK(CLOCK2_50),
							.iRST(KEY[0]),
							.oRST_0(DLY_RST_0),
							.oRST_1(DLY_RST_1),
							.oRST_2(DLY_RST_2),
							.oRST_3(DLY_RST_3),
							.oRST_4(DLY_RST_4)
						);

// //D5M I2C control
I2C_CCD_Config 		u8	(	//	Host Side
							.iCLK(CLOCK2_50),
							.iRST_N(DLY_RST_2),
							.iEXPOSURE_ADJ(KEY[1]),
							.iEXPOSURE_DEC_p(1'b0), // SW[0]
							.iZOOM_MODE_SW(1'b0), //SW[16]
							//	I2C Side
							.I2C_SCLK(D5M_SCLK),
							.I2C_SDAT(GPIO[23])
						);

CCD_Capture			u3	(	.oDATA(mCCD_DATA),
							.oDVAL(mCCD_DVAL),
							.oX_Cont(X_Cont),
							.oY_Cont(Y_Cont),
							.oFrame_Cont(Frame_Cont),
							.iDATA(rCCD_DATA),
							.iFVAL(rCCD_FVAL),
							.iLVAL(rCCD_LVAL),
							.iSTART(!KEY[3]|auto_start),
							.iEND(),
							.iCLK(~D5M_PIXLCLK),
							.iRST(DLY_RST_2)
						);

//D5M raw date convert to RGB data

RAW2RGB				u4	(	.iCLK(D5M_PIXLCLK),
							.iRST(DLY_RST_1),
							.iDATA(mCCD_DATA),
							.iDVAL(mCCD_DVAL),
							.oRed(sCCD_R),
							.oGreen(sCCD_G),
							.oBlue(sCCD_B),
							.oDVAL(sCCD_DVAL),
							.iX_Cont(X_Cont),
							.iY_Cont(Y_Cont)
						);

// Frame count display
// SEG7_LUT_8 			u5	(	.oSEG0(HEX0),.oSEG1(HEX1),
// 							.oSEG2(HEX2),.oSEG3(HEX3),
// 							.oSEG4(HEX4),.oSEG5(HEX5),
// 							.oSEG6(HEX6),.oSEG7(HEX7),
// 							.iDIG(Frame_Cont[31:0])
// 						);

logic [7:0] gray_data;
logic       o_DVAL;

// rgb2gray_2 rgb2g(
//     .clk(D5M_PIXLCLK), 
//     .rst_n(KEY[0]),
//     .i_Green(sCCD_G[11:4]),
//     .i_Red(sCCD_R[11:4]),
//     .i_Blue(sCCD_B[11:4]),
//     .i_DVAL(sCCD_DVAL),
//     .o_gray(gray_data),
//     .o_DVAL(o_DVAL)
// );
//SDRam Read and Write as Frame Buffer
SDram_Control_new	u7	(	//	HOST Side				
						    .RESET_N(KEY[0]),
							.CLK(sdram_ctrl_clk),

							//	FIFO Write Side 1
							.WR1_DATA({sCCD_R[11:8],sCCD_G[11:4],sCCD_B[11:8]}),
							.WR1(sCCD_DVAL),
							// .WR1_DATA({4'b0,gray_data[7:0],4'b0}),
							// .WR1(o_DVAL),
							.WR1_ADDR(0),
						    .WR1_MAX_ADDR(640*480/2),
						    .WR1_LENGTH(8'h50),							
							.WR1_LOAD(!DLY_RST_0),
							.WR1_CLK(D5M_PIXLCLK),


							//	FIFO Read Side 1
						    .RD1_DATA(Read_DATA1),
				        	.RD1(Read),
				        	.RD1_ADDR(0),
						    .RD1_MAX_ADDR(640*480/2),
							.RD1_LENGTH(8'h50),
							.RD1_LOAD(!DLY_RST_0),
							.RD1_CLK(~VGA_CTRL_CLK),
							
							
							// //	FIFO Write Side 2
							.WR2_DATA(top_o_data),
							.WR2(top_o_wr2),
							.WR2_ADDR(23'h100000),
						    .WR2_MAX_ADDR(23'h100000+640*480/2),
							.WR2_LENGTH(8'h50),
							.WR2_LOAD(!DLY_RST_0),
							.WR2_CLK(CLK_25M),

							//	FIFO Read Side 2
						    .RD2_DATA(Read_DATA2),
							.RD2(Read),
							.RD2_ADDR(23'h100000),
						    .RD2_MAX_ADDR(23'h100000+640*480/2),
							.RD2_LENGTH(8'h50),
				        	.RD2_LOAD(!DLY_RST_0),
							.RD2_CLK(~VGA_CTRL_CLK),
							
							//	SDRAM Side
						    .SA(DRAM_ADDR),
							.BA(DRAM_BA),
							.CS_N(DRAM_CS_N),
							.CKE(DRAM_CKE),
							.RAS_N(DRAM_RAS_N),
							.CAS_N(DRAM_CAS_N),
							.WE_N(DRAM_WE_N),
							.DQ(DRAM_DQ),
							.DQM(DRAM_DQM)
						);
//VGA DISPLAY
logic [18:0] pixel_count;
logic top_en;
logic [15:0] top_o_data;
logic [3:0] hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7;
TOP top1(
	.i_clk(CLK_25M),
	.i_rst_n(KEY[0]),
	.i_key_1(key1down),
	.i_key_2(key2down),

    .i_frame_en(top_en),
    .i_pixel_coordinate(pixel_count),
    .i_snap_data(Read_DATA1[11:4]),
	.SW0(SW[0]),
   
    .o_SRAM_ADDR(SRAM_ADDR),
    .io_SRAM_DQ(SRAM_DQ),
    .o_SRAM_WE_N(SRAM_WE_N),
    .o_SRAM_CE_N(SRAM_CE_N),
    .o_SRAM_OE_N(SRAM_OE_N),
    .o_SRAM_LB_N(SRAM_LB_N),
    .o_SRAM_UB_N(SRAM_UB_N),


    //sdram
    .o_wr2(top_o_wr2),
    .o_wr2_data(top_o_data),


	// .stateeee1(stateeee1),
	// .stateeee2(stateeee2),
	// .stateeee3(stateeee3),
	// .stateeee4(stateeee4)
	.hex7(hex7)
	// .hex6(hex6),
	// .hex5(hex5),
	// .hex4(hex4),
	// .hex3(hex3),
	// .hex2(hex2),
	// .hex1(hex1),
	// .hex0(hex0)
);

// SEG7_LUT ss1(	
// 	.oSEG(HEX1),
// 	.iDIG(hex1)
// );
// SEG7_LUT ss0(	
// 	.oSEG(HEX0),
// 	.iDIG(hex0)
// );
// SEG7_LUT ss5(	
// 	.oSEG(HEX5),
// 	.iDIG(hex5)
// );
// SEG7_LUT ss4(	
// 	.oSEG(HEX4),
// 	.iDIG(hex4)
// );
// SEG7_LUT ss2(	
// 	.oSEG(HEX2),
// 	.iDIG(hex2)
// );
// SEG7_LUT ss3(	
// 	.oSEG(HEX3),
// 	.iDIG(hex3)
// );
// SEG7_LUT ss6(	
// 	.oSEG(HEX6),
// 	.iDIG(hex6)
// );
SEG7_LUT ss7(	
	.oSEG(HEX7),
	.iDIG(hex7)
);

// SevenHexDecoder seven_dec1(
// 	.i_hex(stateeee2),
// 	.o_seven_ten(HEX5),
//  	.o_seven_one(HEX4)
// );

// SevenHexDecoder seven_dec3(
// 	.i_hex(stateeee4),
// 	.o_seven_ten(HEX1),
//  	.o_seven_one(HEX0)
// );
// SevenHexDecoder seven_dec0(
// 	.i_hex(stateeee1),
// 	.o_seven_ten(HEX7),
// 	.o_seven_one(HEX6)
// );

// SevenHexDecoder seven_dec2(
// 	.i_hex(stateeee3),
// 	.o_seven_ten(HEX3),
//  	.o_seven_one(HEX2)
// );

logic [7:0] vga_fetch_data_G, vga_fetch_data_B, vga_fetch_data_R;
assign vga_fetch_data_G[7:0] = (SW[17]) ? (SW[16]) ? Read_DATA2[7:0] : Read_DATA2[15:8] :   Read_DATA1[11:4] ;
assign vga_fetch_data_R[7:0] = (SW[17]) ? (SW[16]) ? Read_DATA2[7:0] : Read_DATA2[15:8] :   Read_DATA1[11:4] ;
assign vga_fetch_data_B[7:0] = (SW[17]) ? (SW[16]) ? Read_DATA2[7:0] : Read_DATA2[15:8] :   Read_DATA1[11:4] ;
VGA_Controller		u1	(	//	Host Side
							.oRequest(Read),
							.iRed(vga_fetch_data_R),
							.iGreen(vga_fetch_data_G),
							.iBlue(vga_fetch_data_B),	
							//	VGA Side
							.oVGA_R(oVGA_R),
							.oVGA_G(oVGA_G),
							.oVGA_B(oVGA_B),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC_N),
							.oVGA_BLANK(VGA_BLANK_N),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(DLY_RST_2),
							.iZOOM_MODE_SW(1'b0), //SW[16]

							.pixel_counter(pixel_count),
							.counter_en(top_en)
						);

/************ button debounce *************/
Debounce deb0(
	.i_in(KEY[0]), // Record/Pause
	.i_rst_n(KEY[3]),
	.i_clk(CLOCK_50),
	.o_neg(key0down),
	.o_pos(key0up)
);

Debounce deb1(
	.i_in(KEY[1]), // Play/Pause
	.i_rst_n(KEY[3]),
	.i_clk(CLOCK_50),
	.o_neg(key1down),
	.o_pos(key1up)
);

Debounce deb2(
	.i_in(KEY[2]), // Stop
	.i_rst_n(KEY[3]),
	.i_clk(CLOCK_50),
	.o_neg(key2down),
	.o_pos(key2up)
);




assign vsync_sig = '1 ;


endmodule
