`timescale 1ns / 1ps


module RYG_tb;
	reg clk,reset;
	wire [2:0]state;
	RYG UUT(
	.clk(clk), 
	.reset(reset),
	.state(state)
	);
	
	initial clk=1'b1;
	always #20 clk=~clk;
	
	initial begin
		reset=1'b1;
		#30 reset=1'b0;
	end
	initial #650 $finish;
	initial $monitor ($time,"reset=%b,RYG=%b",reset,state);
endmodule