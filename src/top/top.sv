module TOP(
    input             i_clk,  //25M
    input             i_rst_n,
    input             i_key_1,
    input             i_key_2,
    input             i_frame_en,
    input   [18:0]    i_pixel_coordinate,
    input   [7:0]     i_snap_data,
	input             SW0,
    //sram
    output  [19:0]    o_SRAM_ADDR,
    inout   [15:0]    io_SRAM_DQ,
    output            o_SRAM_WE_N,
    output            o_SRAM_CE_N,
    output            o_SRAM_OE_N,
    output            o_SRAM_LB_N,
    output            o_SRAM_UB_N,

    //sdram
    output            o_wr2,
    output   [15:0]   o_wr2_data,
    // output   [5:0]    stateeee1,
    output   [3:0]    hex7
    // output   [3:0]    hex6,
    // output   [5:0]    stateeee2,
    // output   [3:0]    hex5, 
    // output   [3:0]    hex4,
    // output   [5:0]    stateeee3,
    // output   [3:0]    hex3, 
    // output   [3:0]    hex2,
    // output   [5:0]    stateeee4
    // output   [3:0]    hex1,
    // output   [3:0]    hex0
);

localparam  IDLE                =   4'd0;
localparam  snapping_1          =   4'd1;
localparam  writing_pic_1       =   4'd2;
localparam  IDLE2               =   4'd3; 
localparam  snapping_2          =   4'd4;
localparam  collecting_1        =   4'd5;
localparam  collecting_2        =   4'd6;
localparam  writing             =   4'd7;
localparam  writing_pic_12      =   4'd8;
localparam  waiting_permission  =   4'd15; //f
localparam  calculating         =   4'd10;
localparam  vga_display         =   4'd11; 

localparam  write_disparity     =   4'd12;


logic [3:0] state_w, state_r;
logic [18:0] address_count_w, address_count_r;

logic [19:0] addr_read, addr_write;
logic [15:0] data_write, data_read;
logic [7:0]  snap_data_w, snap_data_r;
logic [18:0] pixel_coordinate_w, pixel_coordinate_r ;
logic [15:0] data_combine_w, data_combine_r;
logic [7:0]  data_left_w, data_left_r;
logic        enable_w, enable_r;
logic [15:0] left_right_image;
logic        o_cal_finish;
logic [19:0] en_counter_w, en_counter_r; 
logic        en_maxico;
logic [39:0] vector_l_1;
logic [39:0] vector_l_2;
logic [39:0] vector_l_3;
logic [39:0] vector_l_4;
logic [39:0] vector_l_5;
logic [39:0] vector_r_1;
logic [39:0] vector_r_2;
logic [39:0] vector_r_3;
logic [39:0] vector_r_4;
logic [39:0] vector_r_5;
logic [7:0]  o_left_edge, o_right_edge, o_min_Disparity_1, final_disparity_map, o_min_Disparity_2;
logic        o_homo;
assign pixel_coordinate_w = i_pixel_coordinate;
assign addr_read = (state_r == collecting_2 ) ? { 1'b1, address_count_r} :  {1'b0 , address_count_r};///////////////////////////
assign data_write = (state_r == writing ) ? data_combine_r : {8'b0, snap_data_r};
assign snap_data_w = i_snap_data;


assign o_SRAM_ADDR = (state_r == snapping_1 || state_r == snapping_2 || state_r == writing ) ? addr_write : addr_read[19:0]; 
assign io_SRAM_DQ  = (state_r == snapping_1 || state_r == snapping_2 || state_r == writing ) ? data_write : 16'dz;
assign data_read   = (state_r != snapping_1 && state_r != snapping_2 && state_r != writing ) ? io_SRAM_DQ : 16'd0;

assign o_SRAM_WE_N = (state_r == snapping_1 || state_r == snapping_2 || state_r == writing ) ? 1'b0 : 1'b1;
assign o_SRAM_CE_N = 1'b0;
assign o_SRAM_OE_N = 1'b0;
assign o_SRAM_LB_N = 1'b0;
assign o_SRAM_UB_N = 1'b0;

assign o_wr2 = (state_r == writing_pic_12 || state_r == writing_pic_1 || state_r == write_disparity)  ? 1'b1: 1'b0;
// assign o_wr2 = (state_r  == writing_pic_12 || state_r == writing_pic_1)  ? 1'b1: o_cal_finish;

// assign o_wr2_data = (state_r == writing_pic_12 || state_r ==  writing_pic_1  )  ? data_read[15:0] : (SW0) ? {o_min_Disparity_1[7:0], final_disparity_map[7:0]} : {o_min_Disparity_2[7:0], o_homo, 7'b0} ; // final_disparity_map[7:0] ;   ///ffff is disparity
assign o_wr2_data = (state_r == writing_pic_12 || state_r ==  writing_pic_1  )  ? data_read[15:0] : {final_disparity_map[7:0], o_min_Disparity_1[7:0]} ; // final_disparity_map[7:0] ;   ///ffff is disparity (result, pure)
// assign o_wr2_data = (state_r == writing_pic_12 || state_r ==  writing_pic_1  )  ? data_read[15:0] : {o_min_Disparity_2[7:0], o_homo, 7'b0} ; // final_disparity_map[7:0] ;   ///ffff is disparity (homo, edge)


assign left_right_image = ( enable_r == 1'b1 )  ? data_read[15:0] : 16'h0000;
assign final_disparity_map = (o_homo) ? o_min_Disparity_1 : o_min_Disparity_2; // if homo_parameter == 1, then use the result with no edge detection

assign hex7 = state_r;
RAM buffer(
    .i_clk(i_clk),
    .rst_n(i_rst_n),
    .i_start(1'b1),
    .i_en(enable_r),
    .i_left_image(left_right_image[7:0]),
    .i_right_image(left_right_image[15:8]),
    .vector_l_1(vector_l_1),
    .vector_l_2(vector_l_2),
    .vector_l_3(vector_l_3),
    .vector_l_4(vector_l_4),
    .vector_l_5(vector_l_5),
    .vector_r_1(vector_r_1),
    .vector_r_2(vector_r_2),
    .vector_r_3(vector_r_3),
    .vector_r_4(vector_r_4),
    .vector_r_5(vector_r_5),
	.o_en(en_maxico)
);

logic [7:0] dis_vector_l_1 [4:0][4:0];
logic [7:0] dis_vector_r_1 [4:0][4:0];

// left
assign dis_vector_l_1[0][0] = vector_l_5[39:32] ; assign dis_vector_l_1[1][0] = vector_l_5[31:24] ; assign dis_vector_l_1[2][0] = vector_l_5[23:16] ; assign dis_vector_l_1[3][0] = vector_l_5[15:8] ; assign dis_vector_l_1[4][0] = vector_l_5[7:0] ;
assign dis_vector_l_1[0][1] = vector_l_4[39:32] ; assign dis_vector_l_1[1][1] = vector_l_4[31:24] ; assign dis_vector_l_1[2][1] = vector_l_4[23:16] ; assign dis_vector_l_1[3][1] = vector_l_4[15:8] ; assign dis_vector_l_1[4][1] = vector_l_4[7:0] ;
assign dis_vector_l_1[0][2] = vector_l_3[39:32] ; assign dis_vector_l_1[1][2] = vector_l_3[31:24] ; assign dis_vector_l_1[2][2] = vector_l_3[23:16] ; assign dis_vector_l_1[3][2] = vector_l_3[15:8] ; assign dis_vector_l_1[4][2] = vector_l_3[7:0] ;
assign dis_vector_l_1[0][3] = vector_l_2[39:32] ; assign dis_vector_l_1[1][3] = vector_l_2[31:24] ; assign dis_vector_l_1[2][3] = vector_l_2[23:16] ; assign dis_vector_l_1[3][3] = vector_l_2[15:8] ; assign dis_vector_l_1[4][3] = vector_l_2[7:0] ;
assign dis_vector_l_1[0][4] = vector_l_1[39:32] ; assign dis_vector_l_1[1][4] = vector_l_1[31:24] ; assign dis_vector_l_1[2][4] = vector_l_1[23:16] ; assign dis_vector_l_1[3][4] = vector_l_1[15:8] ; assign dis_vector_l_1[4][4] = vector_l_1[7:0] ;

//right
assign dis_vector_r_1[0][0] = vector_r_5[39:32] ; assign dis_vector_r_1[1][0] = vector_r_5[31:24] ; assign dis_vector_r_1[2][0] = vector_r_5[23:16] ; assign dis_vector_r_1[3][0] = vector_r_5[15:8] ; assign dis_vector_r_1[4][0] = vector_r_5[7:0] ;
assign dis_vector_r_1[0][1] = vector_r_4[39:32] ; assign dis_vector_r_1[1][1] = vector_r_4[31:24] ; assign dis_vector_r_1[2][1] = vector_r_4[23:16] ; assign dis_vector_r_1[3][1] = vector_r_4[15:8] ; assign dis_vector_r_1[4][1] = vector_r_4[7:0] ;
assign dis_vector_r_1[0][2] = vector_r_3[39:32] ; assign dis_vector_r_1[1][2] = vector_r_3[31:24] ; assign dis_vector_r_1[2][2] = vector_r_3[23:16] ; assign dis_vector_r_1[3][2] = vector_r_3[15:8] ; assign dis_vector_r_1[4][2] = vector_r_3[7:0] ;
assign dis_vector_r_1[0][3] = vector_r_2[39:32] ; assign dis_vector_r_1[1][3] = vector_r_2[31:24] ; assign dis_vector_r_1[2][3] = vector_r_2[23:16] ; assign dis_vector_r_1[3][3] = vector_r_2[15:8] ; assign dis_vector_r_1[4][3] = vector_r_2[7:0] ;
assign dis_vector_r_1[0][4] = vector_r_1[39:32] ; assign dis_vector_r_1[1][4] = vector_r_1[31:24] ; assign dis_vector_r_1[2][4] = vector_r_1[23:16] ; assign dis_vector_r_1[3][4] = vector_r_1[15:8] ; assign dis_vector_r_1[4][4] = vector_r_1[7:0] ;



logic test_inconsistent ;

calculationCore calCore(
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_valid(en_maxico),  
	.i_first_vector_l(dis_vector_l_1),   
    .i_first_vector_r(dis_vector_r_1),

    // .o_test_for_inconsistent(test_inconsistent),
    .o_valid(o_cal_finish),   
    .o_pure_disparity(o_min_Disparity_1),
    .o_edge_disparity(o_min_Disparity_2),
    .o_homogeneity(o_homo)
);
// logic test_state_w, test_state_r;
// always_comb begin : test_FSM
//     case(test_state_r) 
//     1'b0    : test_state_w = (test_inconsistent) ? 1'b1: test_state_r;
//     1'b1    : test_state_w = test_state_r;
//     default : test_state_w = test_state_r;
// 	 endcase
// end
// always_ff @( posedge i_clk or negedge i_rst_n ) begin : blockName
//     if(!i_rst_n) test_state_r <= '0;
//     else         test_state_r <= test_state_w;
// end

always_comb begin : FSM
    case(state_r) 
    IDLE : begin //0
        state_w = state_r;
        addr_write[19:0] = { 1'b0, pixel_coordinate_r[18:0]};
        address_count_w = 19'b0;
        data_combine_w = 16'b0;
        data_left_w = 8'b0;
        enable_w = 1'b0;
        en_counter_w = 20'd0;
        if(i_key_2) begin
            state_w = snapping_2;
        end
        else if(i_frame_en) begin
            state_w = snapping_1;
        end
    end
    IDLE2 : begin //11
        state_w = state_r;
        addr_write[19:0] = { 1'b1 , pixel_coordinate_r[18:0]};
        address_count_w = 19'b0;
        data_combine_w = 16'b0;
        data_left_w = 8'b0;
        enable_w = 1'b0;
        en_counter_w = 20'd0;
        if(i_key_2) begin
            state_w = collecting_1;
        end
        else if(i_frame_en) begin
            state_w = snapping_2;
        end
    end
    snapping_1 : begin // 1
        state_w = state_r;
        addr_write[19:0] = {1'b0, pixel_coordinate_r[18:0]};
        address_count_w = 19'd0;
        data_combine_w = 16'b0;
        data_left_w = 8'b0;
        enable_w = 1'b0;
        en_counter_w = 20'd0;
        if(i_key_2) begin
            state_w = writing_pic_1;
        end
        else if(!i_frame_en) begin
            state_w = IDLE;
        end

    end
    writing_pic_1 : begin  //write sdram
        addr_write[19:0] = { 1'b0, address_count_r[18:0] };

        state_w = state_r;
        address_count_w = address_count_r + 19'd1;
        enable_w = 1'b0;
        data_left_w =  data_left_r;
        data_combine_w = data_combine_r;
        en_counter_w = 20'd0;
        if(address_count_r == 19'd307199)begin
            state_w = snapping_2;
            address_count_w = 19'b0;
        end
    end
    snapping_2 : begin // write sram
        state_w = state_r;
        addr_write[19:0] = {1'b1, pixel_coordinate_r[18:0]};
        address_count_w = 19'd0;
        // address_count_w = (address_count_r == 19'd307199) ? 19'd0 : address_count_r + 19'd1;
        data_combine_w = 16'b0;
        data_left_w = 8'b0;
        enable_w = 1'b0;
        en_counter_w = 20'd0;
        if(i_key_2) begin
            state_w = collecting_1;
        end
        else if(!i_frame_en) begin
            state_w = IDLE2;
        end
        else if(i_key_1) begin
            state_w = snapping_1;
        end
    end

    collecting_1 : begin 
        addr_write[19:0] = { 1'b0, address_count_r[18:0] };
        state_w = collecting_2;
        address_count_w = address_count_r;
        data_left_w = data_read;
        data_combine_w = 16'b0;
        enable_w = 1'b0;
        en_counter_w = 20'd0;
    end

    collecting_2 : begin 
        addr_write[19:0] = { 1'b0, address_count_r[18:0] };
        state_w = writing;
        address_count_w = address_count_r;
        data_left_w = data_left_r;
        // data_combine_w = {data_left_r[7:0], data_read};
        data_combine_w = {data_read, data_left_r[7:0]};
		enable_w = 1'b0;
        en_counter_w = 20'd0;
    end
    writing : begin    //write sram
        addr_write[19:0] = { 1'b0, address_count_r[18:0] };

        state_w = collecting_1;
        address_count_w = address_count_r + 19'd1;
        enable_w = 1'b0;
        data_left_w =  data_left_r;
        data_combine_w = data_combine_r;
        en_counter_w = 20'd0;
        if(address_count_r == 19'd307199)begin
            state_w = writing_pic_12; //10
            address_count_w = 19'd0;
        end
    end
    writing_pic_12 : begin  //write sdram
        state_w = state_r; 
        address_count_w = address_count_r + 19'b1;
        addr_write[19:0] = {1'b1, address_count_r};
        enable_w = 1'b0;
        data_left_w = 8'd0;
        data_combine_w = 16'd0;
        en_counter_w = 20'd0;
        if(address_count_r == 19'd307199) begin
            state_w = waiting_permission;
        end
    end
    waiting_permission : begin
        addr_write[19:0] = { 1'b0, address_count_r[18:0] };
        state_w = state_r;
        address_count_w = 19'd0;
        // address_count_w = (address_count_r == 19'd307199) ? 19'd0 : address_count_r + 19'd1;
        enable_w = 1'b0;
        data_left_w =  data_left_r;
        data_combine_w = data_combine_r;
        en_counter_w = 20'd0;
        if(i_key_2) begin
            enable_w = 1'b1;
            state_w  = calculating;
        end
        else if(i_key_1) begin
            enable_w = 1'b0;
            state_w = snapping_2;
        end
    end

    calculating : begin  //6
        state_w = state_r;
        address_count_w = address_count_r + 19'd1;
        // address_count_w = 19'd0;
        addr_write[19:0] = { 1'b0, address_count_r };
        enable_w = enable_r;
        data_left_w = 8'd0;
        data_combine_w = 16'd0;
        en_counter_w = en_counter_r + 20'd1;
        if(o_cal_finish) begin // o_cal_finish
            state_w = write_disparity;
        end

    end

    write_disparity : begin //10    //unfinish  
        state_w = state_r; 
        address_count_w = address_count_r + 19'd1;
        addr_write[19:0] = {1'b1, address_count_r };
        data_left_w = 8'd0;
        data_combine_w = 16'd0;
        enable_w = enable_r;
        en_counter_w =  en_counter_r + 20'b1;
        if(en_counter_r == 20'd307199) begin
            enable_w = 1'b0;
            en_counter_w = 20'd0;
            state_w = state_r;
        end
        else if(o_cal_finish == 1'b0) begin
            enable_w = enable_r;
            en_counter_w = 20'd0;
            state_w = vga_display;
        end
    end
    vga_display : begin //7
        state_w = state_r;
        address_count_w = 19'd0;
        addr_write[19:0] = { 1'b1, address_count_r};
        enable_w = 1'b0;
        data_left_w = 8'd0;
        data_combine_w = 16'd0;
        enable_w = 1'b0 ;
        en_counter_w = 20'b0;
        
        if(i_key_2) begin
            state_w = snapping_1;
        end
    end
    


    default : begin
        state_w = IDLE;
        addr_write[19:0] = {1'b0, pixel_coordinate_r[18:0]};
        address_count_w = 19'b0;
        data_combine_w = 16'b0;
        data_left_w = 8'b0;
        enable_w = 1'b0;
        en_counter_w = 20'b0;
    end
    endcase
end

always_ff @( posedge i_clk or negedge i_rst_n ) begin
    if(!i_rst_n) begin
        state_r              <= '0;
        pixel_coordinate_r   <= '0;
        snap_data_r          <= '0;
        address_count_r      <= '0;
        data_left_r          <= '0;
        data_combine_r       <= '0;
        enable_r             <= '0;
        en_counter_r         <= '0;
        
    end
    else begin
        state_r              <= state_w;
        pixel_coordinate_r   <= pixel_coordinate_w;
        snap_data_r          <= snap_data_w;
        address_count_r      <= address_count_w;
        data_left_r          <= data_left_w;
        data_combine_r       <= data_combine_w;
        enable_r             <= enable_w;
        en_counter_r         <= en_counter_w;
    end
end


endmodule 