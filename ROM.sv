/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #7                        German Zepeda, Fall 2017  ***
*** Experiment #7, Register File Models                                     ***
*******************************************************************************
*** Filename: ROM.sv                                                        ***
***                                                                         ***
*******************************************************************************
*/
`timescale 1ns / 1ns
module ROM(
	ADB,	//address bus
	OE,		//output enable
	CS,		//chip set
	DATAB	//data buss
);
	//parameters
	parameter DEPTH =8;//8 bit 
	parameter WIDTH =5;//5 bit address
	//input
	input OE,CS;
	input [(WIDTH-1):0] ADB;
	//reg
	reg [(DEPTH-1):0] ROM [0:(2**WIDTH)-1];
	//output
	output reg [(DEPTH-1):0] DATAB;
	//always bock
	always@(*)begin 
		if(!CS&&OE)begin 
			DATAB<=ROM[ADB];
		end else
			DATAB<='bz;
	end
endmodule