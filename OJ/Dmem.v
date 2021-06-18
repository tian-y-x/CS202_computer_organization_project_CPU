module Dmem( 
        input clock,
        input [0:0] Memwrite ,
        input [15:0]address,
        input [31:0]write_data,
        output [31:0]read_data
        
    );
    wire clk;
    // Part of dmemory32 module
    //Generating a clk signal, which is the inverted clock of the clock signal
    assign clk = !clock;
    //Create a instance of RAM(IP core), binding the ports
    RAM RAM (
    .clka(clk), // input wire clka
    .wea(Memwrite), // input wire [0 : 0] wea
    .addra(address[15:2]), // input wire [13 : 0] addra
    .dina(write_data), // input wire [31 : 0] dina
    .douta(read_data) // output wire [31 : 0] douta
    );
endmodule