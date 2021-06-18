module Decoder(
    output[31:0] read_data_1,
    output[31:0] read_data_2,
    output[31:0] imme_extend,
    input [31:0] Instruction,
    input [31:0] read_data, //from DATA RAM or I/O port
    input [31:0] ALU_result,//need to extend to 32 bit
    input Jal,              //1 mean current instuction is JAL
    input RegWrite,
    input MemtoReg,
    input RegDst,
    input clock,reset,
    input [31:0] opcplus4   //from fetch unit,used in JAL
    );
    reg[31:0] register[0:31];
    reg[4:0] write_register_address;
    reg[31:0] write_data;
    
    wire[4:0] read_register_1_address;  //rs
    wire[4:0] read_register_2_address;  //rt
    wire[4:0] write_register_address_1; //r-form to be written rd
    wire[4:0] write_register_address_0; //i-form to be written rt
    wire[15:0] Instruction_immediate_value; //the instance data in instucion
    wire[5:0] opcode;                   //the instruction code
    wire sign;                 
    wire [15:0]sign_ex_16;     
   
    assign opcode = Instruction[31:26];
    assign read_register_1_address = Instruction[25:21];    //r or i
    assign read_register_2_address = Instruction[20:16];    //r
    assign write_register_address_1 = Instruction[15:11];   //r
    assign write_register_address_0 = Instruction[20:16];   //i 
    assign Instruction_immediate_value = Instruction[15:0]; //i
    assign sign = Instruction_immediate_value[15];
    assign sign_ex_16=sign ? 16'b1111111111111111:16'b0000000000000000;
    
    assign imme_extend = (6'b001100 == opcode || 6'b001101 == opcode)?{16'b0000000000000000,Instruction_immediate_value}:{sign_ex_16,Instruction_immediate_value};
    assign read_data_1 = register[read_register_1_address];
    assign read_data_2 = register[read_register_2_address];
    
    integer i;
    always @(posedge clock or posedge reset) begin       
        if(reset == 1) begin             
            for(i=0;i<32;i=i+1)
                register[i] <= 0;
        end 
        else if(RegWrite==1)
                register[write_register_address] <= write_data;    
        end
    always @* begin 
        write_data = Jal ? opcplus4 : (MemtoReg ? read_data : ALU_result); end
                        //jal               //Mem to Reg    // R-form
     always @* begin                                            
       if(RegWrite == 1)
            write_register_address = Jal ? 5'b11111 : (RegDst ? write_register_address_1 : write_register_address_0);
       end
endmodule