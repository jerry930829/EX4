`timescale 1ns / 1ps

module RYG(clk,reset,state);
	input clk,reset;
	output [2:0]state;
	wire recount;
	control_state CS(
	.clk(clk),
	.reset(reset),
	.recount(recount),
	.state(state)
	);
	control_time CT(
	.clk(clk),
	.reset(reset),
	.state(state),
	.recount(recount)
	);
	
endmodule

module control_state(clk,reset,recount,state);
	input clk,reset,recount;
	output [2:0]state;
	reg [2:0]state,nextstate;
	parameter [2:0] R=3'b100,Y=3'b010,G=3'b001;
	always @(posedge clk)begin
		if(reset)
			state <= R;
		else
			state <= nextstate;
	end
	always @(state or recount)begin
	case(state)
		R:begin
			if(recount)
				nextstate=G;
			else
				nextstate=R;
		end
		Y:begin
			if(recount)
				nextstate=R;
			else
				nextstate=Y;
		end
		G:begin
			if(recount)
				nextstate=Y;
			else
				nextstate=G;
		end
		default: nextstate=R;
	endcase
	end
endmodule

module control_time(clk,reset,state,recount);
	input clk,reset;
	input [2:0]state;//RYG
	output recount;
	reg recount;
	reg [3:0]count;
	parameter RT=4,GT=5,YT=2;
	always @(state or count)begin
		case(state)
			3'b100:begin
				if(count==RT)
					recount=1;
				else
					recount=0;
			end
			3'b010:begin
				if(count==YT)
					recount=1;
				else
					recount=0;
			end
			3'b001:begin
				if(count==GT)
					recount=1;
				else
					recount=0;
			end
			default:recount=1;
		endcase
	end
	always @(posedge clk)begin
		if (reset)
			count<=0;
		else begin
			if(recount)
				count<=0;
			else
				count<=count+1;
		end
	end
endmodule

