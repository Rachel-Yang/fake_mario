
module state_machine(
    input logic Clk, Reset,
    input [9:0] DrawX, DrawY,

    output [1:0] we, re
);

enum logic [2:0] {Start, Write0, Read1, Write1, Read0} State, Next_state;

always_ff @ (posedge Clk)
begin
    if (Reset) 
        State <= Start;
    else 
        State <= Next_state;
end

always_comb
begin 
    // Default next state is staying at current state
    Next_state = State;

    

    // Assign next state
    unique case (State)
        Start:
            Next_state = Write0;
        Write0:
            Next_state = Read1;
        Read1:
            if (DrawX == 10'd799 && DrawY == 10'd524)
                Next_state = Write1;
            else
                Next_state = Write0;
        Write1:
            Next_state = Read0;
        Read0:
            if (DrawX == 10'd799 && DrawY == 10'd524)
                Next_state = Write0;
            else
                Next_state = Write1;
        default : ;
	endcase


    // Default controls signal values
    
    we = 2'b00;
    re = 2'b00;

    // Assign control signals based on current state
    case (State)
        Write0:
            we = 2'b01;
        Write1:
            we = 2'b10;
        Read0:
            re = 2'b01;
        Read1:
            re = 2'b10;
        default : ;
    endcase
end

endmodule
