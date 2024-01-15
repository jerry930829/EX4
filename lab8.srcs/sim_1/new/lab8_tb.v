`timescale 1ns / 1ps

module lab8_tb;
	reg clk,Reset;
	wire Red,Green,Yellow;
	
	lab8 UUT(
	.Clock(clk), 
	.Reset(Reset),
	.Red(Red),
	.Green(Green),
	.Yellow(Yellow)
	);
	
	initial clk=1'b1;
	always #20 clk=~clk;
	
	initial begin
		Reset=1'b1;
		#30 Reset=1'b0;
	end
	initial #3000 $finish;
endmodule
