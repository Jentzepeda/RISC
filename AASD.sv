/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #10                        German Zepeda, Fall 2017  ***
*** Experiment #10, RISC-Y                                                  ***
*******************************************************************************
*** Filename: AASD.sv                                                       ***
***                                                                         ***
*******************************************************************************
*** This models the asynchronous assert, and synchronus de-assert function  ***
*******************************************************************************
*/
`timescale 1 ns / 1ns
module AASD(CLK,RST,AASDR);
	input CLK,RST;
	reg DFF1;
	output reg AASDR;//this had reg, but then removed
	always@(posedge CLK or negedge RST) begin
		if(!RST) begin
			DFF1   <= 0;
			AASDR  <= 0;
		end else begin
			DFF1   <= 1;
			AASDR  <= DFF1;
		end
	end
endmodule
