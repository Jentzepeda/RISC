/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #10                       German Zepeda, Fall 2017  ***
*** Experiment #10, RISC-Y                                                  ***
*******************************************************************************
*** Filename: COUNTER.sv                                                    ***
***                                                                         ***
*******************************************************************************
*** This models a counter												    ***
*******************************************************************************
*/
`timescale 1 ns /1ns
module COUNTER (
	CLK,
	RST,
	PC_LOAD,
	PC_ENA,
	DATA,
	COUNT
);
	//parameters
	parameter SIZE = 8;
	//inputs
	input CLK,RST,PC_ENA,PC_LOAD;//active low RST
	input[SIZE-1:0] DATA;
	//output
	output reg [SIZE-1:0] COUNT;
	always@(posedge CLK or negedge RST)begin
		if(!RST)
			COUNT<='b0;
		else if(PC_ENA)
			if(!PC_LOAD)
				COUNT<=COUNT+1;
			else
				COUNT<=DATA;
		else
			COUNT<=COUNT;
	end
endmodule