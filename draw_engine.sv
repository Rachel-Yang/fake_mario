
module draw_engine(
    input logic Clk, Reset,
    output [19:0] SRAM_ADDR,
    input [15:0] SRAM_DATA,

    input [9:0] DrawX, DrawY,
    input [9:0] mario_pos_x, mario_pos_y,
    input [1:0] bg_index, 
    input [2:0] mario_index, level_index,
    input logic is_death, trigger,
    output [3:0] color_idx,
    output [9:0] spine_x
);

//select the level and sprites
int MARIO_X = 20;
int MARIO_Y = 24;
logic [3:0] mario_color, brick_color;

always_comb 
begin
    mario_color = 4'd0;
    brick_color = level1_color;
	SRAM_ADDR = SRAM_level1;

    unique case (mario_index)
        3'd0: mario_color = standr_color;
        3'd1: mario_color = runr_color;
        3'd2: mario_color = standl_color;
        3'd3: mario_color = runl_color;
        3'd4: mario_color = jumpr_color;
        3'd5: mario_color = jumpl_color;
		default : ;
    endcase

    unique case (level_index)
        3'd0: brick_color = level0_color;
        3'd1: brick_color = level1_color;
        3'd2: 
		  begin
				  brick_color = level2_color;
				  SRAM_ADDR = SRAM_level2;
		  end
        default: ;
    endcase

end

/*draw mario*/
logic [12:0] mario_address = 0;
logic [3:0] runr_color, standr_color, jumpr_color,
            runl_color, standl_color, jumpl_color;

mario_runrROM mario_runr_instance(.read_address(mario_address), .Clk, .color_idx(runr_color));
mario_runlROM mario_runl_instance(.read_address(mario_address), .Clk, .color_idx(runl_color));
mario_standrROM mario_standr_instance(.read_address(mario_address), .Clk, .color_idx(standr_color));
mario_standlROM mario_standl_instance(.read_address(mario_address), .Clk, .color_idx(standl_color));
mario_jumprROM mario_jumpr_instance(.read_address(mario_address), .Clk, .color_idx(jumpr_color));
mario_jumplROM mario_jumpl_instance(.read_address(mario_address), .Clk, .color_idx(jumpl_color));

/*draw brick*/
logic [3:0] level0_color, level1_color, level2_color;
logic [19:0] SRAM_level0, SRAM_level1, SRAM_level2;

level0_draw_engine level0_instance(
    .Clk, .SRAM_ADDR(SRAM_level0), .SRAM_DATA, .DrawX, .DrawY,
    .bg_index, .color_idx(level0_color)
);
level1_draw_engine level1_instance(
    .Clk, .SRAM_ADDR(SRAM_level1), .SRAM_DATA, .DrawX, .DrawY, .mario_pos_x, .mario_pos_y,
    .bg_index, .color_idx(level1_color)
);
level2_draw_engine level2_instance(
    .Clk, .SRAM_ADDR(SRAM_level2), .SRAM_DATA, .DrawX, .DrawY, .mario_pos_x, .mario_pos_y,
    .bg_index, .color_idx(level2_color),
    .trigger, .spine_x, .Reset
);

/*draw death info*/
logic [3:0] death_info;

deathinfo death_instance(
    .DrawX, .DrawY, .color_idx(death_info)
);

always_comb
begin
	mario_address = 13'd0;

    if (mario_pos_x <= DrawX && 
        mario_pos_x + MARIO_X > DrawX &&
        mario_pos_y <= DrawY &&
        mario_pos_y + MARIO_Y > DrawY)
        mario_address = (DrawY - mario_pos_y) * MARIO_X + (DrawX - mario_pos_x);

end

always_ff @ (posedge Clk)
begin
    color_idx <= brick_color;

    if (mario_pos_x <= DrawX && 
        mario_pos_x + MARIO_X > DrawX &&
        mario_pos_y <= DrawY &&
        mario_pos_y + MARIO_Y > DrawY &&
        mario_color != 0)
        begin
            color_idx <= mario_color;
        end

    if (is_death == 1'b1 && death_info != 0)
            color_idx <= death_info;
end

endmodule
