module Dmem_UART( 
        input clock,
        input [0:0] Memwrite ,
        input [15:0]address,
        input [31:0]write_data,
        output [31:0]read_data,
        // UART Programmer Pinouts
        input upg_rst_i, // UPG reset (Active High)
        input upg_clk_i, // UPG ram_clk_i (10MHz)
        input upg_wen_i, // UPG write enable
        input [13:0] upg_adr_i, // UPG write address
        input [31:0] upg_dat_i, // UPG write data
        input upg_done_i // 1 if programming is finished
        
    );
//    DRAM RAM (
//    .clka(clk), // input wire clka
//    .wea(Memwrite), // input wire [0 : 0] wea
//    .addra(address[15:2]), // input wire [13 : 0] addra
//    .dina(write_data), // input wire [31 : 0] dina
//    .douta(read_data) // output wire [31 : 0] douta
//    );
    wire ram_clk = !clock;
    // CPU work on normal mode when kickOff is 1. 
    //CPU work on Uart communicate mode when kickOff is 0. 
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    DRAM ram (
    .clka (kickOff ? ram_clk : upg_clk_i),
    .wea (kickOff ? Memwrite : upg_wen_i),
    .addra (kickOff ? address[15:2] : upg_adr_i),
    .dina (kickOff ? write_data : upg_dat_i),
    .douta (read_data)
    );
endmodule
