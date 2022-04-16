module vga_driver
(
    input                   I_clk   , // 25MHz clock
    input                   I_rst_n , // reset
    input          [15:0]   I_data  , // IMG data depth:16
    output         [7:0]    O_red   , // VGA red 
    output         [7:0]    O_green , // VGA green
    output         [7:0]    O_blue  , // VGA blue
    output                  O_hs    , // VGA horizontal sync
    output                  O_vs    ,  // VGA vertical sync
    output                  O_SDram_read,
    input                   I_start ,
    input          [15:0]   I_subpic[30:0][30:0]
);

// horizontal parameter under 640*480
localparam      C_H_SYNC_PULSE      =   96  , 
                C_H_BACK_PORCH      =   48  ,
                C_H_ACTIVE_TIME     =   640 ,
                C_H_FRONT_PORCH     =   16  ,
                C_H_LINE_PERIOD     =   800 ;

// vertical parameter under 640*480              
localparam      C_V_SYNC_PULSE      =   2   , 
                C_V_BACK_PORCH      =   33  ,
                C_V_ACTIVE_TIME     =   480 ,
                C_V_FRONT_PORCH     =   10  ,
                C_V_FRAME_PERIOD    =   525 ;

// size of output vision
localparam      C_IMAGE_WIDTH       =   640 ,
                C_IMAGE_HALF_WIDTH  =   320 ,
                C_IMAGE_HEIGHT      =   480 ,
                C_IMAGE_PIX_NUM     =   307200 ;


logic [11:0]      R_h_cnt         ; // horizontal counter
logic [11:0]      R_v_cnt         ; // vertical counter
logic [17:0]      R_rom_addr      ;
logic [15:0]      W_rom_data      ;
logic             R_clk_25M       ;

logic             W_active_flag   ; // active flag for valid RGB

// assign W_rom_data = I_data ;

//////////////////////////////////////////////////////////////////
// 30x30 testing
//////////////////////////////////////////////////////////////////
logic [11:0]      h_mod30 ;
logic [11:0]      v_mod30 ;
logic hs_en, vs_en;
assign hs_en = ( (R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH)) && (R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_IMAGE_WIDTH  )));
assign vs_en = ( (R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH)) && (R_v_cnt < (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_IMAGE_HEIGHT )));
assign SDram_read = (hs_en & vs_en) ? 1 : 0;
always @(posedge R_clk_25M or negedge I_rst_n)
begin
    if(!I_rst_n)
        h_mod30 <=  12'd0   ;
    else if(R_h_cnt == C_H_LINE_PERIOD - 1'b1)
        h_mod30 <=  12'd0   ;
    else if(h_mod30 == 12'd29 )
        h_mod30 <=  12'd0   ;
    else if(R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                        )  && 
        R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_IMAGE_WIDTH  - 1'b1))
        h_mod30 <= h_mod30 + 1'b1 ;
    else
        h_mod30 <=  12'd0   ;       
end

always @(posedge R_clk_25M or negedge I_rst_n)
begin
    if(!I_rst_n)
        v_mod30 <=  12'd0   ;
    else if(R_v_cnt == C_V_FRAME_PERIOD - 1'b1)
        v_mod30 <=  12'd0   ;
    else if(v_mod30 == 12'd29 )
        v_mod30 <=  12'd0   ;
    else if( R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                        )  && 
        R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_IMAGE_HEIGHT - 1'b1) && 
        R_h_cnt == C_H_LINE_PERIOD - 1'b1 )
        v_mod30 <=  v_mod30 + 1'b1  ;
    else
        v_mod30 <=  v_mod30 ;                        
end 
  
always_comb begin
    if(R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                        )  && 
        R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_IMAGE_WIDTH  - 1'b1)  &&
        R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                        )  && 
        R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_IMAGE_HEIGHT - 1'b1)  )
        W_rom_data = I_subpic[h_mod30][v_mod30] ;
    else
        W_rom_data = I_subpic[0][0] ;
end
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// to generate 25MHz clock
//////////////////////////////////////////////////////////////////
assign R_clk_25M = I_clk ;
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// to generate horizontal clock
//////////////////////////////////////////////////////////////////
always @(posedge R_clk_25M or negedge I_rst_n)
begin
    if(!I_rst_n)
        R_h_cnt <=  12'd0   ;
    else if(R_h_cnt == C_H_LINE_PERIOD - 1'b1)
        R_h_cnt <=  12'd0   ;
    else
        R_h_cnt <=  R_h_cnt + 1'b1  ;                
end                

assign O_hs =   (R_h_cnt < C_H_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// to generate vertical clock
//////////////////////////////////////////////////////////////////
always @(posedge R_clk_25M or negedge I_rst_n)
begin
    if(!I_rst_n)
        R_v_cnt <=  12'd0   ;
    else if(R_v_cnt == C_V_FRAME_PERIOD - 1'b1)
        R_v_cnt <=  12'd0   ;
    else if(R_h_cnt == C_H_LINE_PERIOD - 1'b1)
        R_v_cnt <=  R_v_cnt + 1'b1  ;
    else
        R_v_cnt <=  R_v_cnt ;                        
end                

assign O_vs =   (R_v_cnt < C_V_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
//////////////////////////////////////////////////////////////////  

assign W_active_flag =  (R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                  ))  &&
                        (R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME))  && 
                        (R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
                        (R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME))  ;                     

//////////////////////////////////////////////////////////////////
// divide monitor horizontally into 8 segmentation, each having width of 80 
//////////////////////////////////////////////////////////////////

// assign VGA_R[7:3] = cmos2fifo_wr_data[15:11];
// assign VGA_G[7:2] = cmos2fifo_wr_data[10:5];
// assign VGA_B[7:3] = cmos2fifo_wr_data[4:0];

always @(posedge R_clk_25M or negedge I_rst_n)
begin
    if(!I_rst_n) 
        R_rom_addr  <=  18'd0 ;
    else if(W_active_flag && I_start)     
        begin
            if(R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                        )  && 
               R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_IMAGE_WIDTH  - 1'b1)  &&
               R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                        )  && 
               R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_IMAGE_HEIGHT - 1'b1)  )
                begin
                    if( R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_IMAGE_HALF_WIDTH  - 1'b1) ) begin
                        O_red       <= 8'b1111_1111         ; // red
                        O_green     <= 8'b0                 ; // green
                        O_blue      <= 8'b1111_1111         ; // blue
                        if(R_rom_addr == C_IMAGE_PIX_NUM - 1'b1)
                            R_rom_addr  <=  18'd0 ;
                        else
                            R_rom_addr  <=  R_rom_addr  +  1'b1 ;  
                    end
                    else begin
                        O_red       <= { W_rom_data[15:11], 3'b0 }    ; // red
                        O_green     <= { W_rom_data[10:5], 2'b0 }      ; // green
                        O_blue      <= { W_rom_data[4:0], 3'b0 }     ; // blue
                        if(R_rom_addr == C_IMAGE_PIX_NUM - 1'b1)
                            R_rom_addr  <=  18'd0 ;
                        else
                            R_rom_addr  <=  R_rom_addr  +  1'b1 ;  
                    end
                          
                end
            else
                begin
                    O_red       <=  8'd0        ;
                    O_green     <=  8'd0        ;
                    O_blue      <=  8'd0        ;
                    R_rom_addr  <=  R_rom_addr  ;
                end                          
        end
    else
        begin
            O_red       <=  8'd0        ;
            O_green     <=  8'd0        ;
            O_blue      <=  8'd0        ;
            R_rom_addr  <=  R_rom_addr  ;
        end          
end


//////////////////////////////////////////////////////////////////
// (5,6,5) -> (8,8,8)
//////////////////////////////////////////////////////////////////


// R8 = ( R5 * 527 + 23 ) >> 6;
// G8 = ( G6 * 259 + 33 ) >> 6;
// B8 = ( B5 * 527 + 23 ) >> 6;

endmodule