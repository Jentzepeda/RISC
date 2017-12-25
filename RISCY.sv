/******************************************************************************
***                                                                         ***
*** Ece 526L Experiment #10                       German Zepeda, Fall 2017  ***
*** Experiment #10, RISC-Y						                            ***
*******************************************************************************
*** Filename: RISCY.sv                                                      ***
***                                                                         ***
*******************************************************************************
*/
`timescale 1 ns / 1 ns
module RISCY(
	CLK,
	RST,
	IO
);
	//inputs
	input CLK,RST;
	inout [7:0] IO;
	//wires
	wire [4:0] COUNT; //counter
	wire [31:0] ROM_O;//from rom out to mir
	wire [31:0] MIR; //output of rom register
	//ram wire
	wire [7:0] BIRAM;//bi ram
	wire [7:0] RAM_O;//output of ram register
	//io
	wire [7:0] DATA;//port read data
	wire PORTDRD;//PORT read data
	wire PORTDIR;//port direction output
	wire [7:0] PORTDRO;//outpur of port data register
	//ALU
	wire [7:0] A,B;//outputs of a and B register into alu
	wire CF,OF,SF,ZF;
	wire [7:0] ALU_DATA;
	//seq con outputs
	wire IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD;
	wire PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS;
	wire [1:0] PHASE;
	wire AASDR;
	//ROM AND RAM
	ROM #(.DEPTH(32),.WIDTH(5)) ROM_T(COUNT,1'b1,1'b0,ROM_O);//32x32 rom there is no rom OE or ROM cs assume its active
	RAM #(.DEPTH(8),.WIDTH(5)) RAMT(MIR[4:0],RAM_OE,RAM_CS,CLK,BIRAM);//8x32 ram
	//registers reg 2 has no reset, 1 does
	REG_2 #(.SIZE(8)) 	A_REG(CLK,A_EN,DATA,A);//A register into ALU
	REG_2 #(.SIZE(8)) 	B_REG(CLK,B_EN,DATA,B);//B register into alu
	REG_2 #(.SIZE(8))	PDR(CLK,PORT_EN,DATA,PORTDRO);//port data register
	REG_1 #(.SIZE(1)) 	PDIR(CLK,RST,PDR_EN,DATA[0],PORTDIR);//port direction register
	REG_2 #(.SIZE(8)) 	RAMDR(CLK,RDR_EN,BIRAM,RAM_O);//ram data register
	REG_2 #(.SIZE(32))	ROMDR(CLK,IR_EN,ROM_O,MIR);//rom data register
	//mux
	Scale_Mux #(.SIZE(8)) MUXD(MIR[7:0],RAM_O,RAM_OE,DATA);//this will either take ram or rom data
	//coutner
	COUNTER #(.SIZE(5)) COUNT1(CLK,RST,PC_LOAD,PC_EN,MIR[24:20],COUNT);
	//ALU
	ALU #(.WIDTH(8))	ALU_T(CLK,ALU_EN,ALU_OE,MIR[31:28],A,B,ALU_DATA,CF,OF,SF,ZF);
	//sequence controller
	AASD A_REST(CLK,RST,AASDR);
	PHASER PHASE_M(CLK,AASDR,1'b0,PHASE);
	SEQ_CON CON(MIR[26:20],MIR[31:28],PHASE,ZF,CF,OF,SF,MIR[27],IR_EN,A_EN,B_EN,
	PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS);
	//ASSIGNS
	assign IO=PORTDIR?PORTDRO:'bz;
	assign DATA=PORT_RD?IO:'bz;
	assign BIRAM =(ALU_OE)?ALU_DATA:RAM.DREG;
endmodule