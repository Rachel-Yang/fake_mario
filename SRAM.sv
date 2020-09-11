/**
 * Inputs:
 *      Chip Enable
 *      Upper Bit Enable
 *      Lower Bit Enable
 *      Output Enable
 *      Write Enable
**/
module  SRAM_Interface ( 	
                    input logic Clk,
					input logic [19:0]  ADDR, 
					input logic CE, UB, LB, OE, WE,
					input logic [15:0] Data_from_SRAM,
					output logic [15:0] Data_to_Drawing_Engine
);

	// Load data from SRAM.
	always_comb
    begin 
        Data_to_Drawing_Engine = 16'd0;
        if (WE && ~OE) 
			Data_to_Drawing_Engine = Data_from_SRAM;
    end

endmodule