/*ground brick OCM*/
module brick_groundROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx   
);

logic [3:0] mem [0:400-1];

initial
begin
	 $readmemh("import_files/brick_ground.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule


/*spine OCM*/
module spineROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx   
);

logic [3:0] mem [0:400-1];

initial
begin
	 $readmemh("import_files/spine.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule


/*spine_move OCM*/
module spine_moveROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx   
);

logic [3:0] mem [0:400-1];

initial
begin
	 $readmemh("import_files/spine_move.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule


/*save_point OCM*/
module save_pointROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx   
);

logic [3:0] mem [0:400-1];

initial
begin
	 $readmemh("import_files/save_point.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule


/*save_point2 OCM*/
module save_point2ROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx   
);

logic [3:0] mem [0:400-1];

initial
begin
	 $readmemh("import_files/save_point2.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule


/*arrow OCM*/
module arrow_rightROM
(
	input [12:0] read_address,
	input Clk,
	output logic [3:0] color_idx   
);

logic [3:0] mem [0:800-1];

initial
begin
	 $readmemh("import_files/arrow_right.txt", mem);
end

always_ff @ (posedge Clk) begin
	color_idx <= mem[read_address];
end

endmodule
