/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #1                        German Zepeda, Fall 2017  ***
*** Experiment #10, RISC-Y			                                        ***
*******************************************************************************
*** Filename: PHASER.sv                                                     ***
***                                                                         ***
*******************************************************************************
*** This models a phase                                                     ***
*******************************************************************************
*/
`timescale 1 ns / 1ns
module PHASER (
	CLK,	//clock
	RST,	//reset
	ENA,	//enable
	PHASE  //phaser
);
	//inputs
	input CLK,RST,ENA;//reset and ena are active low iputs
	output enum reg[1:0] {FETCH,DECODE,EXECUTE,UPDATE} PHASE;
	always@(posedge CLK, negedge RST) begin 
		if(!RST)begin //active low reset
			PHASE<=PHASE.first();//if reset is enabled, we going back to the begging 
		end	else begin 
			if(!ENA)begin //active low enable
				PHASE<=PHASE.next();//if ena is enables go to the next phase
			end
		end
	end
endmodule