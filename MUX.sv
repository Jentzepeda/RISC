/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #10                       German Zepeda, Fall 2017  ***
*** Experiment #10, RISC-Y                                                  ***
*******************************************************************************
*** Filename: Scale_Mux.v                                                   ***
***                                                                         ***
*******************************************************************************
*/
`timescale 1 ns/ 1 ns
module Scale_Mux(
	A,	//input A
	B,	//input B
	SEL,//input SEL
	OUT //output OUT
);
	//parameter
	parameter SIZE =1;
	//inputs
	input [SIZE-1:0] A,B;
	input SEL;

	//output
	output reg [SIZE-1:0] OUT;

	// mux
	always@(A,B,SEL)begin 
		OUT = SEL ? B:A;
	end
endmodule
