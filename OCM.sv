module  colorROM
(
	input [3:0] read_address,
	input Clk,
	output logic [23:0] color_vector
);

logic [23:0] mem [0:14];

initial
begin
	 $readmemh("import_files/color.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_vector <= mem[read_address];
end

endmodule


module  color2ROM
(
	input [3:0] read_address,
	input Clk,
	output logic [23:0] color_vector
);

logic [23:0] mem [0:9];

initial
begin
	 $readmemh("import_files/color2.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_vector <= mem[read_address];
end

endmodule


/*mario run right*/
module mario_runrROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx
);

logic [3:0] mem [0:480-1];

initial
begin
	 $readmemh("import_files/mario_runr.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule

/*mario run left*/
module mario_runlROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx
);

logic [3:0] mem [0:480-1];

initial
begin
	 $readmemh("import_files/mario_runl.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule


/*mario stand right*/
module mario_standrROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx
);

logic [3:0] mem [0:480-1];

initial
begin
	 $readmemh("import_files/mario_standr.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule


/*mario stand left*/
module mario_standlROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx
);

logic [3:0] mem [0:480-1];

initial
begin
	 $readmemh("import_files/mario_standl.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule


/*mario jump right*/
module mario_jumprROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx
);

logic [3:0] mem [0:480-1];

initial
begin
	 $readmemh("import_files/mario_jumpr.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule


/*mario jump left*/
module mario_jumplROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx
);

logic [3:0] mem [0:480-1];

initial
begin
	 $readmemh("import_files/mario_jumpl.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule

