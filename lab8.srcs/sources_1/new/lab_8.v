`timescale 1ns / 1ps

module lab8(Clock, Reset, Red, Green, Yellow);
	input Clock, Reset;
	output Red, Green, Yellow;
	wire Recount;
	Traffic_Control
	myTraffic_Control(
	.Clock(Clock),
	.Reset(Reset),
	.Recount(Recount),
	.Red(Red),
	.Green(Green),
	.Yellow(Yellow)); //FSM
	Datapath myDatapath(
	.Clock(Clock),
	.Reset(Reset),
	.RGY({Red, Green,Yellow}),
	.Recount(Recount));
endmodule

module Traffic_Control(Clock, Reset, Recount, Red, Green, Yellow); //FSM
	input Clock, Reset, Recount;
	output Red, Green, Yellow;
	reg Red, Green, Yellow;
	reg [1:0] currentState, nextState;
	parameter [1:0] Red_Light=0, Green_Light=1, Yellow_Light=2;
	//state register (sequential)
	always @(posedge Clock)begin
		if(Reset)
			currentState <=Red_Light;
		else
			currentState <=nextState;
		end
		//next state logic (combinational)
		always @(currentState or Recount)begin
		case(currentState)
			Red_Light:
			begin
				if (Recount)
					nextState=Green_Light;
				else
					nextState=Red_Light;
				end
			Green_Light:
			begin
				if (Recount)
					nextState=Yellow_Light;
				else
					nextState=Green_Light;
				end
			Yellow_Light:
			begin
				if (Recount)
					nextState=Red_Light;
				else
					nextState=Yellow_Light;
				end
			default: nextState=Red_Light;
		endcase
	end
	//Output logic (combinational)
	always @(currentState)begin
		case(currentState)
			Red_Light:
			begin
				Red=1'b1;
				Green=1'b0;
				Yellow=1'b0;
			end
			Green_Light:
			begin
				Red=1'b0;
				Green=1'b1;
				Yellow=1'b0;
			end
			Yellow_Light:
			begin
				Red=1'b0;
				Green=1'b0;
				Yellow=1'b1;
			end
			default:
			begin
				Red=1'b0;
				Green=1'b0;
				Yellow=1'b0;
			end
		endcase
	end
endmodule

module Datapath(Clock, Reset, RGY, Recount);
	input Clock, Reset;
	input [2:0] RGY;
	output Recount;
	wire [3:0] Counter_Number;
	compare mycompare(
	.current_times(Counter_Number), 
	.RGY(RGY), 
	.Recount(Recount));
	Counter16 myCounter16(
	.Clock(Clock), 
	.Reset(Reset), 
	.Recount(Recount),
	.Count_Out(Counter_Number));
endmodule

module compare(current_times, RGY, Recount);
	input [2:0] RGY;
	input [3:0] current_times;
	output Recount;
	reg Recount;
	parameter R_times=5, G_times=6, Y_times=3;
	always @(RGY or current_times)
	begin
		case (RGY)
			3'b100: begin
			if (current_times== R_times)
				Recount=1;
			else
				Recount=0;
			end
			3'b001: begin
			if (current_times== Y_times)
				Recount=1;
			else
				Recount=0;
			end
			3'b010: begin
			if (current_times== G_times)
				Recount=1;
			else
				Recount=0;
			end
			default: Recount=1;
		endcase
	end
endmodule

module Counter16(Clock, Reset, Recount, Count_Out);
	input Clock, Reset, Recount;
	output[3:0] Count_Out;
	reg [3:0] Count_Out;
	always @(posedge Clock)
	begin
	if (Reset)
		Count_Out <=0;
	else 
		begin
		if (Recount)
			Count_Out <=0;
		else
			Count_Out <=Count_Out+1;
		end
	end
endmodule

