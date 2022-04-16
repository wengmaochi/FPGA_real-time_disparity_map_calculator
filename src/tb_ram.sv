module tb_ram(
    input                 clk,
    input                 rst_n,
    input                 i_KEY2,
    input                 i_KEY1,
    input                 i_KEY0,
    input       [17:0]    SW,
    output      [6:0]     o_SEG1,
    output      [6:0]     o_SEG2,
    output      [6:0]     o_SEG3,
    output      [6:0]     o_SEG4,
    output      [6:0]     o_SEG5,
    output      [6:0]     o_SEG6,
    output      [6:0]     o_SEG7,
    output      [6:0]     o_SEG8
);

logic   [8*5-1:0]    vector_r_5;
logic   [8*5-1:0]    vector_r_4;
logic   [8*5-1:0]    vector_r_3;
logic   [8*5-1:0]    vector_r_2;
logic   [8*5-1:0]    vector_r_1;

logic   [8*5-1:0]    vector_l_5;
logic   [8*5-1:0]    vector_l_4;
logic   [8*5-1:0]    vector_l_3;
logic   [8*5-1:0]    vector_l_2;
logic   [8*5-1:0]    vector_l_1;


// reg [15:0] rom1[640*5-1:0];//168
// reg [15:0] rom2[640*5-1:0];//168
// initial begin
//     $readmemh("./src/regs.txt",rom1,0,640*5-1);
// end
// initial begin
//     $readmemh("./src/regs2.txt",rom2,0,640*5-1);
// end

logic   [20:0]    counter_left_w, counter_left_r, counter_right_w, counter_right_r, romc1, romc2;
logic             start_w, start_r;
logic   [ 2:0]    state_w, state_r;
logic   [ 3:0]    display1, display2, display3, display4, display5, display6;

logic   [ 9:0]    count_640_w, count_640_r;
logic             clken_r, clken_w;

//assign romc1 = counter_left_r % (640*5-1);
//assign romc2 = counter_right_r % (640*5-1);

RAM rammm(
    .i_clk(clk),
    .rst_n(rst_n),
    // .i_start(start_r),
    .i_start(clken_r),
    .i_left_image(counter_left_r),
    .i_right_image(counter_right_r),
    .vector_l_1(vector_l_1),
    .vector_l_2(vector_l_2),
    .vector_l_3(vector_l_3),
    .vector_l_4(vector_l_4),
    .vector_l_5(vector_l_5),
    .vector_r_1(vector_r_1),
    .vector_r_2(vector_r_2),
    .vector_r_3(vector_r_3),
    .vector_r_4(vector_r_4),
    .vector_r_5(vector_r_5)
);

logic key2_w, key2_r;
assign key2_w = i_KEY2;
always_comb begin 
    state_w = state_r;
    start_w = start_r;
    // case(state_r)
    //     3'd0 : begin
    //         state_w = 3'd1;
    //         start_w = 0;
    //         counter_left_w = 21'b0;
    //         counter_right_w = 21'd5;
    //         if( key2_r ) begin
    //             state_w = 3'd1;
    //             start_w = 1'b1;
    //             counter_right_w = 21'd1;//640
    //         end
    //     end
    //     3'd1 : begin
    //         state_w = state_r;
    //         start_w = start_r;
    //             counter_left_w = counter_left_r   ;
    //             counter_right_w = counter_right_r ;
    //         if(i_KEY1) begin
    //             counter_left_w = counter_left_r + 21'd639;
    //             counter_right_w = counter_right_r +21'd639;
    //         end
    //         else if(i_KEY2) begin
    //             counter_left_w = counter_left_r + 21'd1;
    //             counter_right_w = counter_right_r +21'd1;
    //         end

  
    //     end

    //     default : begin
    //         state_w = 3'd0;
    //         start_w = start_r;
    //         counter_left_w = 21'd0;
    //         counter_right_w = 21'd0;
    //     end
    // endcase
end
logic [3:0] SW_num;
assign SW_num = SW[3:0];
// always_comb begin 
//     case (SW_num)
//         4'd1 : begin display1 = vector_l_1[3:0]; display2=vector_l_1[7:4]; display3=vector_r_1[3:0]; display4=vector_r_1[7:4]; end
//         4'd2 : begin display1 = vector_l_2[3:0]; display2=vector_l_2[7:4]; display3=vector_r_2[3:0]; display4=vector_r_2[7:4]; end
//         4'd3 : begin display1 = vector_l_3[3:0]; display2=vector_l_3[7:4]; display3=vector_r_3[3:0]; display4=vector_r_3[7:4]; end
//         4'd4 : begin display1 = vector_l_4[3:0]; display2=vector_l_4[7:4]; display3=vector_r_4[3:0]; display4=vector_r_4[7:4]; end
//         4'd5 : begin display1 = vector_l_5[3:0]; display2=vector_l_5[7:4]; display3=vector_r_5[3:0]; display4=vector_r_5[7:4]; end
//         4'd0 : begin display1 = 4'b0; display2='0; display3='0; display4= '0; end
//         default : begin display1 = 4'b0; display2='0; display3='0; display4= '0; end
//     endcase
// end

always_comb begin 
    case (SW_num)
        4'd1 : begin display1 = vector_l_1[3:0]; display2=vector_l_1[7:4]; display3=vector_r_1[3:0]; display4=vector_r_1[7:4]; end
        4'd2 : begin display1 = vector_l_1[11:8]; display2=vector_l_1[15:12]; display3=vector_r_2[11:8]; display4=vector_r_2[15:12]; end
        4'd3 : begin display1 = vector_l_1[19:16]; display2=vector_l_1[23:20]; display3=vector_r_3[19:16]; display4=vector_r_3[7:4]; end
        4'd4 : begin display1 = vector_l_1[27:24]; display2=vector_l_1[31:28]; display3=vector_r_4[3:0]; display4=vector_r_4[7:4]; end
        4'd5 : begin display1 = vector_l_1[35:32]; display2=vector_l_1[39:36]; display3=vector_r_5[3:0]; display4=vector_r_5[7:4]; end
        // 4'd0 : begin display1 = 4'b0; display2='0; display3='0; display4= '0; end
        default : begin display1 = 4'b0; display2='0; display3='0; display4= '0; end
    endcase
end
always_comb begin
    counter_left_w = counter_left_r;
    if(count_640_r < 640 && count_640_r > 0) begin
        count_640_w = count_640_r + 1;
        clken_w = 1'b1;
        counter_left_w = counter_left_r + 1;
    end 
    else if( i_KEY0 ) begin
        count_640_w = count_640_r + 1;
        clken_w = 1'b1;
        counter_left_w = counter_left_r + 1;
    end
    else begin
        count_640_w = count_640_r;
        clken_w = 1'b0;
    end
end


// always_comb begin
//     display1 = vector_l_[3:0]; 
//     display2 = vector_l_1[7:4];
//     display3 = vector_l_1[11:8]; 
//     display4 = vector_l_1[15:12];
// end


SEG7_LUT u1 (
    .iDIG({1'b0,state_r}),
    .oSEG(o_SEG1)
);
SEG7_LUT u2 (
    .iDIG(),
    .oSEG(o_SEG2)
);
SEG7_LUT u3 (
    .iDIG(display1),
    .oSEG(o_SEG3)
);
SEG7_LUT u4 (
    .iDIG(display2),
    .oSEG(o_SEG4)
);
SEG7_LUT u5 (
    .iDIG(display3),
    .oSEG(o_SEG5)
);
SEG7_LUT u6 (
    .iDIG(display4),
    .oSEG(o_SEG6)
);
assign display5 = (SW[17]) ? counter_right_r[3:0] : counter_left_r[3:0];
assign display6 = (SW[17]) ? counter_right_r[7:4] : counter_left_r[7:4];
SEG7_LUT u7 (
    .iDIG(display5),
    .oSEG(o_SEG7)
);
SEG7_LUT u8 (
    .iDIG(display6),
    .oSEG(o_SEG8)
);
always_ff @( posedge clk or negedge rst_n ) begin 
    if( !rst_n ) begin
        start_r <= '0;
        state_r <= '0;
        counter_right_r <= '0;
        counter_left_r  <= '0;
        key2_r <= '0;
        count_640_r <= 0;
        clken_r <= 1'b0;
    end
    else begin
        counter_right_r <= counter_right_w;
        counter_left_r  <= counter_left_w;
        start_r <= start_w;
        state_r <= state_w;
        key2_r <= '0;
        count_640_r <= count_640_w;
        clken_r <= clken_w;
    end
end

endmodule