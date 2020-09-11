
module buffer_select(
    input logic Clk,
    input [1:0] we, re,
	input [18:0] address,
    input [3:0] data_In,
    output [3:0] data_Out
);

logic [3:0] buffer0_out, buffer1_out;

frame_buffer buffer0(
	.Clk,
	.data_In,
    .address,
    .WE(we[0]), .RE(re[0]),
    .data_Out(buffer0_out)
);

frame_buffer buffer1(
	.Clk,
	.data_In,
    .address,
    .WE(we[1]), .RE(re[1]),
    .data_Out(buffer1_out)
);

always_comb 
begin
	 data_Out = 4'd0;
    case(re)
        2'b01:
            data_Out = buffer0_out;
        2'b10:
            data_Out = buffer1_out;
        default: ;
    endcase
end

endmodule
