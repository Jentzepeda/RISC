/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #7                        German Zepeda, Fall 2017  ***
*** Experiment #7, Register File Models                                     ***
*******************************************************************************
*** Filename: RAM.sv                                                        ***
***                                                                         ***
*******************************************************************************
*/
`timescale 1ns / 1ns
module RAM (
	ADB,	//address bus
	OE,		//output enable
	CS,		//chip set
	WS,		//write strobe
	DATAB	//data buss
);
	//parameters
	parameter DEPTH =8;//8 bit 
	parameter WIDTH =5;//5 bit address
	//inout
	inout [(DEPTH-1):0] DATAB;
	//inputs
	input [(WIDTH-1):0] ADB;
	input OE,CS,WS;//when cs is 0, active
	//reg
	reg [(DEPTH-1):0] MEM [0:(2**WIDTH)-1];
	reg[(DEPTH-1):0] DREG;//kinda like a temp to show it gets values
	//asign
	assign DATAB =(OE&&CS) ? DREG:'bz;
	//always block
	always@(posedge WS) begin
		if(!OE&&!CS)
			MEM[ADB]=DATAB;
	end
	always_comb begin
		DREG=MEM[ADB];
	end
endmodule