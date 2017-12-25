/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #10                       German Zepeda, Fall 2017  ***
*** Experiment #10, RISC-Y						                            ***
*******************************************************************************
*** Filename: REG_1.sv                                                      ***
***                                                                         ***
*******************************************************************************
*/
`timescale 1 ns /1ns
module REG_1 (
	CLK,
	RST,
	ENA,
	INPUT,
	OUTPUT
);
	//parameter
	parameter SIZE = 8;
	//input
	input CLK,RST,ENA;//RST is active low
	input[SIZE-1:0] INPUT;
	//output
	output reg [SIZE-1:0] OUTPUT;
	always@(posedge CLK or negedge RST)begin
		if(!RST)
			OUTPUT<='b0;
		else if(ENA)
			OUTPUT<=INPUT;
		else OUTPUT<=OUTPUT;
	end
endmodule