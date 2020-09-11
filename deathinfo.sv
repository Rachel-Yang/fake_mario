module deathinfo(
    input [9:0] DrawX, DrawY,
    output [3:0] color_idx
);

logic [1:0]shape_on;
logic [4:0]variable;
logic [10:0] shape_x;

logic [10:0] shape_G_x  = 60;
logic [10:0] shape_A_x  = 123;
logic [10:0] shape_M_x  = 186;
logic [10:0] shape_E1_x = 249;

logic [10:0] shape_O_x  = 343;
logic [10:0] shape_V_x  = 406;
logic [10:0] shape_E2_x = 469;
logic [10:0] shape_R_x  = 532;


logic [10:0] shape_y1   = 60;


logic [10:0] shape_P_x  = 95;
logic [10:0] shape_R2_x = 127;
logic [10:0] shape_E3_x = 159;
logic [10:0] shape_S_x  = 191;
logic [10:0] shape_S2_x = 223;

logic [10:0] shape_R3_x = 271;

logic [10:0] shape_T_x  = 319;
logic [10:0] shape_O2_x = 351;

logic [10:0] shape_R4_x = 399;
logic [10:0] shape_E4_x = 431;
logic [10:0] shape_T2_x = 463;
logic [10:0] shape_R5_x = 495;
logic [10:0] shape_Y_x  = 527;

logic [10:0] shape_y2   = 180;

logic [10:0] big_x      = 48;
logic [10:0] big_y      = 64;
logic [10:0] small_x    = 24;
logic [10:0] small_y    = 32;

logic [10:0] sprite_addr;
logic [7:0] sprite_data;

font_rom font_instance (.addr(sprite_addr), .data(sprite_data));

always_comb
begin
    //G x47
    if (DrawX >= shape_G_x && DrawX < shape_G_x + big_x &&
        DrawY >= shape_y1 && DrawY < shape_y1 + big_y)
    begin
        shape_on = 2'b01;
        variable = 5'd0;
        sprite_addr = ((DrawY - shape_y1)/'d4 + 16*'h47);
    end
    //A x41
    else if (DrawX >= shape_A_x && DrawX < shape_A_x + big_x &&
        DrawY >= shape_y1 && DrawY < shape_y1 + big_y)
    begin
        shape_on = 2'b01;
        variable = 5'd1;
        sprite_addr = ((DrawY - shape_y1)/'d4 + 16*'h41);
    end
    //M x4d
    else if (DrawX >= shape_M_x && DrawX < shape_M_x + big_x &&
        DrawY >= shape_y1 && DrawY < shape_y1 + big_y)
    begin
        shape_on = 2'b01;
        variable = 5'd2;
        sprite_addr = ((DrawY - shape_y1)/'d4 + 16*'h4d);
    end
    //E1 x45
    else if (DrawX >= shape_E1_x && DrawX < shape_E1_x + big_x &&
        DrawY >= shape_y1 && DrawY < shape_y1 + big_y)
    begin
        shape_on = 2'b01;
        variable = 5'd3;
        sprite_addr = ((DrawY - shape_y1)/'d4 + 16*'h45);
    end
    //O x4f
    else if (DrawX >= shape_O_x && DrawX < shape_O_x + big_x &&
        DrawY >= shape_y1 && DrawY < shape_y1 + big_y)
    begin
        shape_on = 2'b01;
        variable = 5'd4;
        sprite_addr = ((DrawY - shape_y1)/'d4 + 16*'h4f);
    end
    //V x56
    else if (DrawX >= shape_V_x && DrawX < shape_V_x + big_x &&
        DrawY >= shape_y1 && DrawY < shape_y1 + big_y)
    begin
        shape_on = 2'b01;
        variable = 5'd5;
        sprite_addr = ((DrawY - shape_y1)/'d4 + 16*'h56);
    end
    //E2 x45
    else if (DrawX >= shape_E2_x && DrawX < shape_E2_x + big_x &&
        DrawY >= shape_y1 && DrawY < shape_y1 + big_y)
    begin
        shape_on = 2'b01;
        variable = 5'd6;
        sprite_addr = ((DrawY - shape_y1)/'d4 + 16*'h45);
	end
    //R x52
    else if (DrawX >= shape_R_x && DrawX < shape_R_x + big_x &&
        DrawY >= shape_y1 && DrawY < shape_y1 + big_y)
    begin
        shape_on = 2'b01;
        variable = 5'd7;
        sprite_addr = ((DrawY - shape_y1)/'d4 + 16*'h52);
    end


    //P x50
    else if (DrawX >= shape_P_x && DrawX < shape_P_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd8;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h50);
    end
    //R2 x52
    else if (DrawX >= shape_R2_x && DrawX < shape_R2_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd9;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h52);
    end
    //E3 x45
    else if (DrawX >= shape_E3_x && DrawX < shape_E3_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd10;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h45);
    end
    //S x53
    else if (DrawX >= shape_S_x && DrawX < shape_S_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd11;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h53);
    end
    //S2 x53
    else if (DrawX >= shape_S2_x && DrawX < shape_S2_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd12;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h53);
    end

    //R3 x52
    else if (DrawX >= shape_R3_x && DrawX < shape_R3_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b11;
        variable = 5'd13;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h52);
    end

    //T x54
    else if (DrawX >= shape_T_x && DrawX < shape_T_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd14;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h54);
    end
    //O2 x4f
    else if (DrawX >= shape_O2_x && DrawX < shape_O2_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd15;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h4f);
    end

    //R4 x52
    else if (DrawX >= shape_R4_x && DrawX < shape_R4_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd16;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h52);
    end
    //E4 x45
    else if (DrawX >= shape_E4_x && DrawX < shape_E4_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd17;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h45);
    end
    //T2 x54
    else if (DrawX >= shape_T2_x && DrawX < shape_T2_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd18;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h54);
    end
    //R5 x52
    else if (DrawX >= shape_R5_x && DrawX < shape_R5_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd19;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h52);
    end
    //Y x59
    else if (DrawX >= shape_Y_x && DrawX < shape_Y_x + small_x &&
        DrawY >= shape_y2 && DrawY < shape_y2 + small_y)
    begin
        shape_on = 2'b10;
        variable = 5'd20;
        sprite_addr = ((DrawY - shape_y2)/'d2 + 16*'h59);
    end

    else
    begin
        shape_on = 2'b00;
		variable = 5'd0;
        sprite_addr = 10'b0;
    end         

end

always_comb
begin
    shape_x = 0;
    unique case(variable)
        5'd0: shape_x = shape_G_x;
        5'd1: shape_x = shape_A_x;
        5'd2: shape_x = shape_M_x;
        5'd3: shape_x = shape_E1_x;

        5'd4: shape_x = shape_O_x;
        5'd5: shape_x = shape_V_x;
        5'd6: shape_x = shape_E2_x;
        5'd7: shape_x = shape_R_x;

        5'd8: shape_x = shape_P_x;
        5'd9: shape_x = shape_R2_x;
        5'd10: shape_x = shape_E3_x;
        5'd11: shape_x = shape_S_x;
        5'd12: shape_x = shape_S2_x;

        5'd13: shape_x = shape_R3_x;

        5'd14: shape_x = shape_T_x;
        5'd15: shape_x = shape_O2_x;

        5'd16: shape_x = shape_R4_x;
        5'd17: shape_x = shape_E4_x;
        5'd18: shape_x = shape_T2_x;
        5'd19: shape_x = shape_R5_x;
        5'd20: shape_x = shape_Y_x;
        default: ;
    endcase
end

always_comb
begin
    if ((shape_on == 2'b01) && sprite_data[(11'd47-(DrawX - shape_x))/'d6] == 1'b1)
        color_idx = 4'd9; //white
    else if ((shape_on == 2'b10) && sprite_data[(11'd23-(DrawX - shape_x))/'d3] == 1'b1)
        color_idx = 4'd9; //white

    else if (DrawX >= 10'd60 && DrawX < 10'd580 && 
             DrawY >= 10'd145 && DrawY < 10'd149 &&
             (DrawX - 10'd60) % 10'd15 <= 10'd10 )
        color_idx = 4'd9; //white
    else if ((shape_on ==2'b11 ) && sprite_data[(11'd23-(DrawX - shape_x))/'d3] == 1'b1)
        color_idx = 4'd14; //yellow
    else
        color_idx = 0;
end

endmodule

