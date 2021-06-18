`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 10:07:53
// Design Name: 
// Module Name: ifetch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IFetch_UART(
output[31:0] Instruction, // the instruction fetched from this module
output[31:0] branch_base_addr, // (pc+4) to ALU which is used by branch type instruction
output reg[31:0] link_addr, // (pc+4) to decoder which is used by jal instruction
output reg[31:0] pco,
input clock,reset, // Clock and reset
// from ALU
input[31:0] Addr_result, // the calculated address from ALU
input Zero, // while Zero is 1, it means the ALUresult is zero
// from Decoder
input[31:0] Read_data_1, // the address of instruction used by jr instruction
// from controller
input Branch, // while Branch is 1,it means current instruction is beq
input nBranch, // while nBranch is 1,it means current instruction is bnq
input Jmp, // while Jmp 1,it means current instruction is jump
input Jal, // while Jal is 1,it means current instruction is jal
input Jr, // while Jr is 1,it means current instruction is jr
// UART Programmer Pinouts
input upg_rst_i, // UPG reset (Active High)
input upg_clk_i, // UPG clock (10MHz)
input upg_wen_i, // UPG write enable
input[13:0] upg_adr_i, // UPG write address
input[31:0] upg_dat_i, // UPG write data
input upg_done_i // 1 if program finished
);

reg[31:0] PC, Next_PC;
wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i );
program instmem (
.clka (kickOff ? clock : upg_clk_i ),
.wea (kickOff ? 1'b0 : upg_wen_i ),
.addra (kickOff ? PC[15:2] : upg_adr_i ),
.dina (kickOff ? 32'h00000000 : upg_dat_i ),
.douta (Instruction)
);

assign branch_base_addr = PC + 4;
//assign link_addr = Next_PC;
always@*
    pco = PC;
always @* begin
    if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) // beq, bne
        Next_PC = Addr_result*4;  // the calculated new value for PC
    else if(Jr == 1)
        Next_PC = Read_data_1*4; // the value of $31 register
    else
        Next_PC = PC + 4; // PC+4
end

always @(negedge clock) begin
    if(reset == 1)
        PC <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    else
    begin
        if(Jmp == 1) 
            PC <= {4'b0000,Instruction[25:0],2'b00};   
        else if(Jal==1) begin
//             link_addr[31:30] <= PC[31:30];
//             link_addr[29:0] <= PC[31:2] + 1'b1;
             PC <= {4'b0000,Instruction[25:0],2'b00};
        end
        else
            PC <= Next_PC;
    end
end
wire jalorjmp ;
assign jalorjmp= Jal || Jmp;
always @(jalorjmp )begin
    link_addr = (PC+4) >>2;
end
endmodule
