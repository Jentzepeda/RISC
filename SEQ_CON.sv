/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #9                        German Zepeda, Fall 2017  ***
*** Experiment #9, Modeling a Sequence Controller                           ***
*******************************************************************************
*** Filename: SEQ_CON.sv                                                    ***
***                                                                         ***
*******************************************************************************
*/
`timescale 1 ns / 1ns
module SEQ_CON (
	ADDR,	//6 bit address
	OPCODE,	//input opcode
	PHASE,	//input phase
	ZF,		//z flag
	CF,		//carry flag
	OF,		//over flow flag
	SF,		//signed flag
	I_FLAG,//other flag??
	IR_EN,	//output ir enable
	A_EN,	//output A enable
	B_EN,	//output b enable
	PDR_EN,	//pdr enable
	PORT_EN,//port enable
	PORT_RD,//port reader??
	PC_EN,	//pc enable
	PC_LOAD,//pc load
	ALU_EN,//alu enable
	ALU_OE,//alu output enable
	RAM_OE,//ram output enable
	RDR_EN,//rdr enable
	RAM_CS//ram chip set
);
	//local param
	localparam LOAD = 4'b0000;
	localparam STORE = 4'b0001;
	localparam ADD = 4'b0010;
	localparam SUB = 4'b0011;
	localparam AND = 4'b0100;
	localparam OR  = 4'b0101;
	localparam XOR = 4'b0110;
	localparam NOT = 4'b0111;
	localparam B  = 4'b1000;
	localparam BZ = 4'b1001;
	localparam BN = 4'b1010;
	localparam BV = 4'b1011;
	localparam BC = 4'b1100;
	//inputs
	input I_FLAG,ZF,CF,OF,SF;
	input [6:0] ADDR;
	input [3:0] OPCODE;
	input [1:0] PHASE;
	//outputs
	output reg IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD;
	output reg PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS;
	always_comb begin
		case (PHASE)
			2'b00 :begin//fetch this is fine
				IR_EN=1'b1;
				A_EN=1'b0;
				B_EN=1'b0;
				PDR_EN=1'b0;
				PORT_EN=1'b0;
				PC_LOAD=1'b0;
				ALU_EN=1'b0;
				ALU_OE=1'b0;
				RDR_EN=1'b0;
				PORT_RD=1'b0;
				PC_EN=1'b0;
				RAM_OE=1'b0;
				RAM_CS=1'b1;//active low
			end
///////////////////////////////////////////////////////////////////////////////
			2'b01 :begin //decode 
				IR_EN=1'b0;
				PC_LOAD=1'b0;
				PC_EN=1'b0;
				if(OPCODE==LOAD) begin
					if(ADDR>7'd31&&ADDR<7'd64)begin //ram
						RAM_CS=1'b0;//active low
						RDR_EN=1'b1;
						RAM_OE=1'b0;//here
					end else if(ADDR==7'd64||ADDR==7'd65)begin //a and b
						if(I_FLAG) begin 
							RDR_EN=1'b1;
							RAM_CS=1'b0;//active low
							RAM_OE=1'b0;
						end
						else begin 
							RDR_EN=RDR_EN;
							RAM_OE=RAM_OE;
							RAM_CS=RAM_CS;
						end
					end
				end else if(OPCODE==STORE) begin 
					if(ADDR==7'd67)
						PORT_RD=1'b1;
						PORT_EN=1'b0;//added this
				end
			end
///////////////////////////////////////////////////////////////////////////////
			2'b10 :begin //execute done?
				if(OPCODE==LOAD) begin
					if(ADDR==7'd64)//writes to A
						A_EN=1'b1;
					else if(ADDR==7'd65)//writes to b
						B_EN=1'b1;
					else if(ADDR==7'd66)//enables port direction 
						PDR_EN=1'b1;
					else if(ADDR==7'd67)begin//i/o port
						PORT_EN=1'b1;
						PORT_RD=1'b0;
						RAM_OE=1'b1;
						RDR_EN=1'b1;
					end else begin 
						A_EN=1'b0;
						B_EN=1'b0;
						PORT_RD=1'b0;
						PDR_EN=1'b0;
					end
				end else if(OPCODE==STORE) begin 
					RAM_CS=1'b0;//active low, to allow ram to work
					RAM_OE=1'b0;
					//RDR_EN=1'b0;//enables ram sremoved this
					ALU_EN=1'b1;
					ALU_OE=1'b1;
				end else if(OPCODE>=ADD&&OPCODE<=NOT)begin//alu operations
					ALU_OE=1'b1;
					ALU_EN=1'b1;
				end else
					IR_EN=IR_EN;
					A_EN=A_EN;
					B_EN=B_EN;
					PDR_EN=PDR_EN;
					PORT_EN=PORT_EN;
					PC_LOAD=PC_LOAD;
					ALU_EN=ALU_EN;
					ALU_OE=ALU_OE;
					RDR_EN=RDR_EN;
					RAM_OE=RAM_OE;
					RAM_CS=RAM_CS;
			end
///////////////////////////////////////////////////////////////////////////////
			2'b11 :begin //update complete
				PC_EN=1'b1;
				if(OPCODE>=B&&OPCODE<=BC) begin 
					if(OPCODE==B)
						PC_LOAD=1'b1;
					else if(OPCODE==BZ&&ZF)
						PC_LOAD=1'b1;
					else if(OPCODE==BN&&SF)
						PC_LOAD=1'b1;
					else if(OPCODE==BV&&OF)
						PC_LOAD=1'b1;
					else if(OPCODE==BC&&CF)
						PC_LOAD=1'b1;
					else
						PC_LOAD=1'b0;
				end
				IR_EN=1'b0;
				A_EN=1'b0;
				B_EN=1'b0;
				PDR_EN=1'b0;
				PORT_EN=1'b0;
				ALU_EN=1'b0;
				ALU_OE=1'b0;
				RDR_EN=1'b0;
				RAM_OE=1'b0;
				RAM_CS=1'b1;
			end
///////////////////////////////////////////////////////////////////////////////
			default : begin //keep the same values
				IR_EN=IR_EN;
				A_EN=A_EN;
				B_EN=B_EN;
				PDR_EN=PDR_EN;
				PORT_EN=PORT_EN;
				PC_LOAD=PC_LOAD;
				ALU_EN=ALU_EN;
				ALU_OE=ALU_OE;
				RDR_EN=RDR_EN;
				RAM_OE=RAM_OE;
				RAM_CS=RAM_CS;
			end
		endcase
	end
endmodule