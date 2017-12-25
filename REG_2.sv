/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #10                       German Zepeda, Fall 2017  ***
*** Experiment #10, RISC-Y						                            ***
*******************************************************************************
*** Filename: REG_2.sv                                                      ***
***                                                                         ***
*******************************************************************************
*/
`timescale 1 ns / 1ns
module REG_2 (
	CLK,
	ENA,
	INPUT,
	OUTPUT
);
	//parameter
	parameter SIZE = 8;
	//input
	input CLK,ENA;
	input[SIZE-1:0] INPUT;
	//output
	output reg [SIZE-1:0] OUTPUT;
	always@(posedge CLK)begin
		if(ENA)
			OUTPUT<=INPUT;
		else OUTPUT<=OUTPUT;
	end
endmodule