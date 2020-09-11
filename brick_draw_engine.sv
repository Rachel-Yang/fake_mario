/*level1 map*/
module level1_draw_engine(
    input logic Clk,
    output [19:0] SRAM_ADDR,
    input [15:0] SRAM_DATA,

    input [9:0] DrawX, DrawY,
    input [9:0] mario_pos_x, mario_pos_y,
    input [1:0] bg_index, 
    output [3:0] color_idx
);

logic [19:0] bg_offset;
int BRICK = 20;

//select background
always_comb
begin
    bg_offset = 20'd0;
    save_color = 4'd0;

    unique case (bg_index)
        2'd0: bg_offset = 20'd0;
        2'd1: bg_offset = 20'h4B000;
	    default : ;
    endcase

    unique case (trigger_save)
        1'b0: save_color = save_color1;
        1'b1: save_color = save_color2;
        default : ;
    endcase

    SRAM_ADDR = bg_offset + DrawY * 20'd640 + DrawX;
end

logic [12:0] brick_address, spine_address, save_address, arrow_address;
logic [3:0] brick_color, spine_color, save_color, save_color1, save_color2, arrow_color;
logic trigger_save = 1'b0;

/*draw brick*/
brick_groundROM brick_ground_instance( 
    .read_address(brick_address), .Clk,
    .color_idx(brick_color)
);

/*draw spine*/
spineROM spine_instance(
    .read_address(spine_address), .Clk,
    .color_idx(spine_color)
);

/*draw save_point*/
save_pointROM save_instance(
    .read_address(save_address), .Clk,
    .color_idx(save_color1)    
);

/*draw save_point2*/
save_point2ROM save2_instance(
    .read_address(save_address), .Clk,
    .color_idx(save_color2)    
);

/*draw arrow_right*/
arrow_rightROM arrow_instance(
    .read_address(arrow_address), .Clk,
    .color_idx(arrow_color)    
);

//get brick address
assign brick_address = (DrawY % BRICK) * BRICK + (DrawX % BRICK);
assign spine_address = (DrawY % BRICK) * BRICK + (DrawX % BRICK);
assign save_address = (DrawY % BRICK) * BRICK + (DrawX % BRICK);
assign arrow_address = (DrawY % BRICK) * 2 * BRICK + (DrawX % (2*BRICK));

always_ff @ (posedge Clk)
begin
    /*check if mario in save-point*/
    if (mario_pos_x < 4*BRICK && mario_pos_x >= 3*BRICK && mario_pos_y + 10'd24 >= 20*BRICK)
        trigger_save <= 1'b1;
end

always_ff @ (posedge Clk) 
begin
    color_idx <= SRAM_DATA[3:0];

    /*check if there is a brick*/
    if ((DrawX < 2*BRICK && DrawY >= 18*BRICK) ||
        (DrawX < 8*BRICK && DrawX >= 2*BRICK && DrawY >= 21*BRICK) ||
        (DrawX < 10*BRICK && DrawX >= 8*BRICK && DrawY >= 20*BRICK) ||
        (DrawX < 14*BRICK && DrawX >= 12*BRICK && DrawY >= 20*BRICK) ||
        (DrawX < 19*BRICK && DrawX >= 16*BRICK && DrawY >= 20*BRICK) ||
        (DrawX < 25*BRICK && DrawX >= 19*BRICK && DrawY >= 21*BRICK) ||
        (DrawX < 29*BRICK && DrawX >= 25*BRICK && DrawY >= 18*BRICK) ||
        (DrawX >= 29*BRICK && DrawY >= 17*BRICK))

        color_idx <=  brick_color;

    /*check if there is a save point*/
    if (DrawX < 4*BRICK && DrawX >= 3*BRICK && DrawY < 21*BRICK && DrawY >= 20* BRICK &&
        save_color != 0)
        color_idx <= save_color;

    /*check if there is an arrow*/
    if (DrawX < 30*BRICK && DrawX >= 28*BRICK && DrawY < 15*BRICK && DrawY >= 14* BRICK &&
        arrow_color != 0)

        color_idx <= arrow_color;

    /*check if there is a spine*/
    if (DrawX < 22*BRICK && DrawX >= 21*BRICK && DrawY < 21*BRICK && DrawY >= 20*BRICK
        && spine_color != 0)
        color_idx <= spine_color;
end

endmodule


/*level2 map*/
module level2_draw_engine(
    input logic Clk, Reset,
    output [19:0] SRAM_ADDR,
    input [15:0] SRAM_DATA,

    input [9:0] DrawX, DrawY,
	 input [9:0] mario_pos_x, mario_pos_y,
    input [1:0] bg_index, 
    output [3:0] color_idx,
    /*moving spines*/
    input logic trigger,
    output [9:0] spine_x
);

logic [19:0] bg_offset;
int BRICK = 20;

//select background
always_comb
begin
    bg_offset = 20'd0;
    save_color = 4'd0;

    unique case (bg_index)
        2'd0: bg_offset = 20'd0;
        2'd1: bg_offset = 20'h4B000;
	    default : ;
    endcase

    unique case (trigger_save)
        1'b0: save_color = save_color1;
        1'b1: save_color = save_color2;
        default : ;
    endcase

    SRAM_ADDR = bg_offset + DrawY * 20'd640 + DrawX;
end

logic [12:0] brick_address, spine_address, save_address;
logic [3:0] brick_color, spine_color, spine_move_color, save_color, save_color1, save_color2;
logic trigger_save = 1'b0;

/*draw brick*/
brick_groundROM brick_ground_instance(.read_address(brick_address), .Clk, .color_idx(brick_color));

/*draw spine*/
spineROM spine_instance(.read_address(spine_address), .Clk, .color_idx(spine_color));

/*draw save_point*/
save_pointROM save_instance(.read_address(save_address), .Clk, .color_idx(save_color1));
save_point2ROM save2_instance(.read_address(save_address), .Clk, .color_idx(save_color2));

/*process the moving spines*/
logic [9:0] cur_spine_x;
spine_moveROM movespine_instance(.read_address(spine_address), .Clk, .color_idx(spine_move_color));
spine_move spine_move_instance(.Clk, .Reset, .trigger, .spine_x(cur_spine_x));

//get brick address
assign brick_address = (DrawY % BRICK) * BRICK + (DrawX % BRICK);
assign spine_address = (DrawY % BRICK) * BRICK + (DrawX % BRICK);
assign save_address = (DrawY % BRICK) * BRICK + (DrawX % BRICK);

always_ff @ (posedge Clk)
begin
    /*check if mario in save-point*/
    if (mario_pos_x < 29*BRICK && mario_pos_x >= 28*BRICK && mario_pos_y + 10'd24 >= 15*BRICK)
        trigger_save <= 1'b1;
end

always_ff @ (posedge Clk) 
begin
    color_idx <= SRAM_DATA[3:0];

    /*check if there is a brick*/
    if ((DrawX < 18*BRICK && DrawY >= 13*BRICK && DrawY < 14*BRICK) ||
        (DrawX < 18*BRICK && DrawY >= 18*BRICK) ||
        (DrawX < 23*BRICK && DrawX >= 5*BRICK && DrawY >= 7*BRICK && DrawY < 8*BRICK) ||
        (DrawX < 24*BRICK && DrawX >= 23*BRICK && DrawY >= 7*BRICK && DrawY < 17*BRICK) ||
        (DrawX < 26*BRICK && DrawX >= 24*BRICK && DrawY >= 13*BRICK && DrawY < 14*BRICK) ||
        (DrawX < 26*BRICK && DrawX >= 24*BRICK && DrawY >= 7*BRICK && DrawY < 8*BRICK) ||
        (DrawX >= 24*BRICK && DrawY >= 16*BRICK && DrawY < 17*BRICK) ||
        (DrawX >= 28*BRICK && DrawY >= 10*BRICK && DrawY < 11*BRICK))

        color_idx <=  brick_color;

    /*check if there is a save_point*/
    if (DrawX < 29*BRICK && DrawX >= 28*BRICK && DrawY < 16*BRICK && DrawY >= 15* BRICK &&
        save_color != 0)

        color_idx <= save_color;

    /*check if there is a spine*/
    if (((DrawX < 30*BRICK && DrawX >= 29*BRICK && DrawY < 10*BRICK && DrawY >= 9*BRICK) ||
        (DrawX < 9*BRICK && DrawX >= 7*BRICK && DrawY < 18*BRICK && DrawY >= 17*BRICK) ||
        (DrawX < 15*BRICK && DrawX >= 13*BRICK && DrawY < 7*BRICK && DrawY >= 6*BRICK)) &&
        spine_color != 0 )

        color_idx <= spine_color;

    /*check if there is a moving spine*/
    if (DrawX < cur_spine_x && DrawX >= cur_spine_x - BRICK &&
        DrawY < 13*BRICK && DrawY >= 8*BRICK &&
        spine_move_color != 0 && cur_spine_x != 10'd0)

        color_idx <= spine_move_color;

end

assign spine_x = cur_spine_x;

endmodule


module level0_draw_engine(
    input logic Clk,
    output [19:0] SRAM_ADDR,
    input [15:0] SRAM_DATA,

    input [9:0] DrawX, DrawY,
    input [1:0] bg_index, 
    output [3:0] color_idx
);

logic [19:0] bg_offset;
int BRICK = 20;

//select background
always_comb
begin
    bg_offset = 20'd0;

    unique case (bg_index)
        2'd0: bg_offset = 20'd0;
        2'd1: bg_offset = 20'h4B000;
	    default : ;
    endcase

    SRAM_ADDR = bg_offset + DrawY * 20'd640 + DrawX;
end

/*draw start info*/
logic [3:0] start_info;

startinfo start_instance(
    .DrawX, .DrawY, .color_idx(start_info)
);

always_ff @ (posedge Clk)
begin
    color_idx <= SRAM_DATA[3:0];

    if (start_info != 0)
            color_idx <= start_info;
end

endmodule



