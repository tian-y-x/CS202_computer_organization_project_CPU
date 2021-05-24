`timescale 1ns / 1ps

module ControllerIO(
Opcode,Function_opcode,Jr,RegDST,ALUSrc,RegWrite,MemWrite,Branch,
nBranch,Jmp,Jal,I_format,Sftmd,ALUOp,Alu_resultHigh,MemorIOtoReg,MemRead,IORead,IOWrite
);
input [5:0] Opcode;
input [5:0] Function_opcode;
output Jr;//
output RegDST;//
output ALUSrc;//
output RegWrite;//
output MemWrite;//
output Branch;//
output nBranch;//
output Jmp;//
output Jal;//
output I_format;//
output Sftmd;//
output [1:0]ALUOp;//

input[21:0] Alu_resultHigh; // From the execution unit Alu_Result[31..10]
output MemorIOtoReg;// 1 indicates that data needs to be read from memory or I/O to the register
output MemRead; // 1 indicates that the instruction needs to read from the memory
output IORead; // 1 indicates I/O read
output IOWrite; // 1 indicates I/O write

assign Jr =((Function_opcode==6'b001000)&&(Opcode==6'b000000)) ? 1'b1 : 1'b0;
assign Jal=(Opcode==6'b000011) ? 1'b1 : 1'b0;
assign Jmp=(Opcode==6'b000010) ? 1'b1 : 1'b0;


wire R_type=(Opcode==6'b0)?1'b1:1'b0;
wire J_type=(Jr||Jal||Jmp)?1'b1:1'b0;
wire I_type=(R_type||J_type)?1'b0:1'b1;


wire beq=(Opcode==6'b000100)? 1'b1 : 1'b0;
wire bne=(Opcode==6'b000101)? 1'b1 : 1'b0;
wire lw=(Opcode==6'b100011)? 1'b1 : 1'b0;
wire sw=(Opcode==6'b101011)? 1'b1 : 1'b0;

wire beqorbne=beq||bne;
wire RorI=R_type||I_format;

assign I_format=I_type&&(!(beq||bne||lw||sw));
assign ALUOp={RorI,beqorbne};
assign Branch=beq;
assign nBranch=bne;
assign RegDST=R_type;
assign Sftmd = (((Function_opcode==6'b000000)||(Function_opcode==6'b000010)
||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)
||(Function_opcode==6'b000110)||(Function_opcode==6'b000111))
&& R_type)? 1'b1:1'b0;
assign ALUSrc=(I_type && ! beq && !bne )?1'b1 :1'b0;

assign RegWrite = (R_type || lw || Jal || I_format) && !(Jr) ; // Write memory or write IO
assign MemWrite = ((sw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;
assign MemRead = ((lw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;
assign IORead = ((lw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0;
assign IOWrite = ((sw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0;

// Read operations require reading data from memory or I/O to write to the register
assign MemorIOtoReg = IORead || MemRead ;
endmodule