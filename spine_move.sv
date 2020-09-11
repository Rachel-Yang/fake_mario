module spine_move(
    input logic Clk, Reset,
    input logic trigger,
    output [9:0] spine_x
);

int BRICK = 20;
logic [9:0] spine_posx, spine_posx_next;
logic [31:0] counter, counter_next;

enum logic [2:0] {Start, Move, Wait, Done} State, Next_State;

always_ff @ (posedge Clk)
begin
    if (Reset)
        State <= Wait;
    else    
        State <= Next_State;

    spine_posx <= spine_posx_next;
    counter <= counter_next;
end

always_comb
begin
    Next_State = State;
    spine_posx_next = spine_posx;
    counter_next = counter;

    unique case (State)
        Wait:
            if (trigger)
                Next_State = Start;
        Start:
            Next_State = Move;
        Move:
            if (spine_posx == 10'd460)
                Next_State = Done;
            else if (counter == 32'd150000)
                begin
                    counter_next = 32'd0;
                    spine_posx_next = spine_posx + 1;
                end
            else 
                counter_next = counter + 1;
        Done:
            Next_State = Done;
        default: ;
    endcase        

    case (State)
        Wait:   
            begin
                spine_posx_next = 10'd0;
                counter_next = 32'd0;
            end  
        Start:  
            begin
                counter_next = 32'd0;
                spine_posx_next = BRICK;
            end
        default: ;
    endcase
end

assign spine_x = spine_posx;

endmodule
