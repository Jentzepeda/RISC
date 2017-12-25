/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #10                        German Zepeda, Fall 2017 ***
*** Experiment #10, RISC-Y						                            ***
*******************************************************************************
*** Filename: ALU.sv                                                        ***
***                                                                         ***
*******************************************************************************
*/
`timescale 1ns / 1ns
//`define sign 1
module ALU (
	CLK,	//Clock
	EN,		//enable
	OE,		//output enable
	OPCODE,	//input
	A,		//a
	B,		//b
	ALU_OUT,//output ALU
	CF,		//carry flag
	OF,		//over flow flag
	SF,		//signed flag
	ZF		//zero flag
);
	//parameters
	parameter WIDTH = 8;
	localparam ADD =4'b0010,SUB=4'b0011,AND=4'b0100,OR=4'b0101,XOR=4'b0110,ELSE=4'b0111;
	//outputs
	output reg [(WIDTH-1):0] ALU_OUT;
	output reg CF,OF,SF,ZF;
	//inputs
	input [3:0] OPCODE;
	input [(WIDTH-1):0] A,B;
	input CLK,EN,OE;
	//always block
	always@(posedge CLK)begin
		if(EN && OE)begin 
			case (OPCODE)
			ADD:begin 
				{CF,ALU_OUT}<=(A+B);//carry and overflow
				`ifdef sign
					if(($signed(A+B)<0&&$signed(A)>0&&$signed(B)>0)||($signed(A+B)>0&&$signed(A)<0&&$signed(B)<0))
						OF=0;
					else
						OF=1;
				`endif
			end 
			SUB: begin 
				{OF,ALU_OUT}<=(A-B);
				if(A<B)
					CF<=1;
				else
					CF<=0;
			end
			AND: ALU_OUT <= A&B;//everything else
			OR: ALU_OUT <= A|B;//everything else
			XOR: ALU_OUT <= A^B;//everything else
			ELSE: ALU_OUT <= ~A;//everything else
			default : ALU_OUT <= ALU_OUT;
		endcase
		end else if(!OE&& EN)begin 
			ALU_OUT <= 'bz;
		end else
		ALU_OUT <= ALU_OUT;
	end
	always@(ALU_OUT)begin 
		ZF<=~(|ALU_OUT);
		SF<=(ALU_OUT[WIDTH-1]==1);
	end
endmodule