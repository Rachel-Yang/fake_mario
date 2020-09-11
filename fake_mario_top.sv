/**
 * Name: fake_mario_top
 * Description: top level of fake_mario
**/
module fake_mario_top(	
	   	input         CLK_50, 		//		clk.clk
		// PIO Interface
		input  [3:0]  KEY,  		//   	key_wire.export
		output [7:0]  LEDG, 		//  	ledg_wire.export
		output [15:0] LEDR, 		//  	ledr_wire.export
		input  [15:0] SW,   	  	//    	sw_wire.export

		output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
									// 		hex display on board for debug
		// DRAM Interface
		output        DRAM_CLK,		//  	sdram_clk.clk
		output [12:0] DRAM_ADDR,	// 		sdram_wire.addr
		output [1:0]  DRAM_BA,    	//           .ba
		output        DRAM_CAS_N, 	//           .cas_n
		output        DRAM_CKE,   	//           .cke
		output        DRAM_CS_N,  	//           .cs_n
		inout  [31:0] DRAM_DQ,    	//           .dq
		output [3:0]  DRAM_DQM,   	//           .dqm
		output        DRAM_RAS_N, 	//           .ras_n
		output        DRAM_WE_N,  	//           .we_n
		// CY7C67200 Interface
		inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
		output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
		output logic        OTG_CS_N,     //CY7C67200 Chip Select
							OTG_RD_N,     //CY7C67200 Write
							OTG_WR_N,     //CY7C67200 Read
							OTG_RST_N,    //CY7C67200 Reset
		input               OTG_INT,      //CY7C67200 Interrupt
		// VGA Interface 
		output logic [7:0]  VGA_R,        //VGA Red
							VGA_G,        //VGA Green
							VGA_B,        //VGA Blue
		output logic        VGA_CLK,      //VGA Clock
							VGA_SYNC_N,   //VGA Sync signal
							VGA_BLANK_N,  //VGA Blank signal
							VGA_VS,       //VGA virtical sync signal
							VGA_HS,       //VGA horizontal sync signal
		//SRAM Interface
		output logic [19:0] SRAM_ADDR,
        output logic SRAM_CE, SRAM_UB, SRAM_LB, SRAM_OE, SRAM_WE,
        inout  wire  [15:0] SRAM_DATA,
		  
		// Audio
		output reg DAC_LR_CLK, 
		output USB_clk, BCLK, SCLK, DAC_DATA,
		inout SDIN
		
);

/* Clock and Reset */
logic Reset_h, Clk;
assign Clk = CLK_50;
always_ff @ (posedge Clk) begin
	Reset_h <= ~(KEY[0]);        // The push buttons are active low
end

/**
 * Hex Drivers
 * Description: for debug use
**/
logic[31:0] HEX_DEBUG;

HexDriver Hex0(.In0(HEX_DEBUG[ 3: 0]), .Out0(HEX0));
HexDriver Hex1(.In0(HEX_DEBUG[ 7: 4]), .Out0(HEX1));
HexDriver Hex2(.In0(HEX_DEBUG[11: 8]), .Out0(HEX2));
HexDriver Hex3(.In0(HEX_DEBUG[15:12]), .Out0(HEX3));
HexDriver Hex4(.In0(HEX_DEBUG[19:16]), .Out0(HEX4));
HexDriver Hex5(.In0(HEX_DEBUG[23:20]), .Out0(HEX5));
HexDriver Hex6(.In0(HEX_DEBUG[27:24]), .Out0(HEX6));
HexDriver Hex7(.In0(HEX_DEBUG[31:28]), .Out0(HEX7));

/**
 * Audio
 *
**/
Audio_Top audio_instance (
	.clk(Clk), .reset(KEY[0]), .SW0(SW[0]),
	.SDIN,
	.SCLK, .USB_clk, .BCLK,
	.DAC_LR_CLK,
	.DAC_DATA,
	.ACK_LEDR(LEDR[2:0])
);

/**
 * VGA
 * Description:
**/
logic [9:0] DrawX, DrawY;
vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

VGA_controller vga_controller_instance(
	// input
	.Clk, .Reset(Reset_h), .VGA_CLK,
	// output to VGA
	.VGA_HS, .VGA_VS,     
	.VGA_BLANK_N, .VGA_SYNC_N,
	.DrawX, .DrawY
);

logic [7:0] VGA_R1, VGA_G1, VGA_B1, VGA_R2, VGA_G2, VGA_B2;

always_comb
begin
	VGA_R = 8'd0;
	VGA_G = 8'd0;
	VGA_B = 8'd0;
	unique case(bg_index)
		2'd0:
		begin
			VGA_R = VGA_R1;
			VGA_G = VGA_G1;
			VGA_B = VGA_B1;
		end
		2'd1:
		begin
			VGA_R = VGA_R2;
			VGA_G = VGA_G2;
			VGA_B = VGA_B2;
		end
		default: ;
	endcase
end

colorROM color_mapper (
	.read_address(color_idx), .Clk, 
	// output to VGA
	.color_vector({VGA_R1, VGA_G1, VGA_B1})
);

color2ROM color2_mapper (
	.read_address(color_idx), .Clk, 
	// output to VGA
	.color_vector({VGA_R2, VGA_G2, VGA_B2})
);

/* temp index and pos info */
logic [3:0] color_idx;
logic [31:0] softctl;
logic [1:0] bg_index;
logic [2:0] mario_index, level_idx;
logic [9:0] mario_pos_x, mario_pos_y;
logic is_death;
logic [9:0] spine_x;
logic trigger, reset_game;

/*assign index*/
assign bg_index = softctl[31:30];
assign mario_index = softctl[29:27];
assign level_idx = softctl[26:24];
/*assign mario position*/
assign mario_pos_x = softctl[19:10];
assign mario_pos_y = softctl[9:0];
/*assign death signal*/
assign is_death = softctl[20];
/*assign trigger signal*/
assign trigger = softctl[21];
/*assign reset_game*/
assign reset_game = softctl[22];

draw_engine draw_engine_instance(
	// input 
	.DrawX, .DrawY, .Clk,
	.bg_index, .mario_index, .level_index(level_idx),
	.mario_pos_x, .mario_pos_y,
	.is_death, .trigger,
	// output
	.SRAM_ADDR, .SRAM_DATA,
	.color_idx, .spine_x,
	.Reset(reset_game)
);

assign HEX_DEBUG = {20'd0, Reset_h, trigger, spine_x};

/*Set SRAM signals*/
always_comb
begin
SRAM_CE = 1'b0;
SRAM_UB = 1'b0;
SRAM_LB = 1'b0;
SRAM_OE = 1'b0;
SRAM_WE = 1'b1;
end

/**
 * HPI interface
 * Description: EZ-OTG HPI Interface
**/
logic [1:0] hpi_addr;
logic [15:0] hpi_data_in, hpi_data_out;
logic hpi_r, hpi_w, hpi_cs, hpi_reset;
logic [7:0] keycode;
hpi_io_intf hpi_io_instance(
						.Clk(Clk),
						.Reset(Reset_h),
						// signals connected to NIOS II
						.from_sw_address(hpi_addr),
						.from_sw_data_in(hpi_data_in),
						.from_sw_data_out(hpi_data_out),
						.from_sw_r(hpi_r),
						.from_sw_w(hpi_w),
						.from_sw_cs(hpi_cs),
						.from_sw_reset(hpi_reset),
						// signals connected to EZ-OTG chip
						.OTG_DATA(OTG_DATA),    
						.OTG_ADDR(OTG_ADDR),    
						.OTG_RD_N(OTG_RD_N),    
						.OTG_WR_N(OTG_WR_N),    
						.OTG_CS_N(OTG_CS_N),
						.OTG_RST_N(OTG_RST_N)
);

/**
 * Name: fake_mario_soc
 * Description: connected to fake_mario_soc
**/
fake_mario fake_mario_soc
(
	.clk_clk(CLK_50),
	.reset_reset_n(1'b1),
	.key_wire_export(KEY), 
	.ledg_wire_export(LEDG),
	.interface_export(softctl),
	//sdram
	.sdram_clk_clk(DRAM_CLK),
	.sdram_wire_addr(DRAM_ADDR), 
	.sdram_wire_ba(DRAM_BA), 
	.sdram_wire_cas_n(DRAM_CAS_N), 
	.sdram_wire_cke(DRAM_CKE), 
	.sdram_wire_cs_n(DRAM_CS_N), 
	.sdram_wire_dq(DRAM_DQ),
	.sdram_wire_dqm(DRAM_DQM), 
	.sdram_wire_ras_n(DRAM_RAS_N), 
	.sdram_wire_we_n(DRAM_WE_N),
	//otg_hpi
	.keycode_export(keycode),
	.otg_hpi_address_export(hpi_addr),
	.otg_hpi_data_in_port(hpi_data_in),
	.otg_hpi_data_out_port(hpi_data_out),
	.otg_hpi_cs_export(hpi_cs),
	.otg_hpi_r_export(hpi_r),
	.otg_hpi_w_export(hpi_w),
	.otg_hpi_reset_export(hpi_reset),
	//input
	.position_export({22'd0, spine_x})
);

endmodule
