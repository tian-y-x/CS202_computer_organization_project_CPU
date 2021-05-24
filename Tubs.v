`timescale 1ns / 1ps
module Tubs(
    input clock,
    input sys_rst_n,
    input CubeCtrl,
    input [15:0] switch,
    output reg [7:0]control, 
    output reg [7:0]cube_data
    );
    reg[2:0] number;
    reg [16:0]divider_cnt;
    reg clk_1K;
    reg [7:0]dout1,dout2,dout3,dout4;
    always@(posedge clock  ) begin
        if(sys_rst_n==1) begin
            divider_cnt <= 15'd0;
            clk_1K<=1'd0;
            end
        else if(divider_cnt ==9999) begin
            divider_cnt <= 15'd0;
            clk_1K<=~clk_1K;
            end
        else
            divider_cnt <= divider_cnt + 1'b1;
        end
    always @(negedge clk_1K or negedge sys_rst_n )begin
        if     (sys_rst_n)  number<=0;
        else if(number==7)  number<=0;
        else                number<=number+1;
        end
    always@(switch) begin
    if(switch[3:0]==4'b0000) dout1 = 8'b0111111;
    if(switch[3:0]==4'b0001) dout1 = 8'b0000110;
    if(switch[3:0]==4'b0010) dout1 = 8'b1011011;
    if(switch[3:0]==4'b0011) dout1 = 8'b1001111;
    if(switch[3:0]==4'b0100) dout1 = 8'b1100110;
    if(switch[3:0]==4'b0101) dout1 = 8'b1101101;
    if(switch[3:0]==4'b0110) dout1 = 8'b1111101;
    if(switch[3:0]==4'b0111) dout1 = 8'b0100111;
    if(switch[3:0]==4'b1000) dout1 = 8'b1111111;
    if(switch[3:0]==4'b1001) dout1 = 8'b1100111;
    if(switch[3:0]==4'b1010) dout1 = 8'b1110111;
    if(switch[3:0]==4'b1011) dout1 = 8'b1111100;
    if(switch[3:0]==4'b1100) dout1 = 8'b0111001;
    if(switch[3:0]==4'b1101) dout1 = 8'b1011110;
    if(switch[3:0]==4'b1110) dout1 = 8'b1111001;
    if(switch[3:0]==4'b1111) dout1 = 8'b1110001;
    end
    always@(switch) begin
    if(switch[7:4]==4'b0000) dout2 = 8'b0111111;
    if(switch[7:4]==4'b0001) dout2 = 8'b0000110;
    if(switch[7:4]==4'b0010) dout2 = 8'b1011011;
    if(switch[7:4]==4'b0011) dout2 = 8'b1001111;
    if(switch[7:4]==4'b0100) dout2 = 8'b1100110;
    if(switch[7:4]==4'b0101) dout2 = 8'b1101101;
    if(switch[7:4]==4'b0110) dout2 = 8'b1111101;
    if(switch[7:4]==4'b0111) dout2 = 8'b0100111;
    if(switch[7:4]==4'b1000) dout2 = 8'b1111111;
    if(switch[7:4]==4'b1001) dout2 = 8'b1100111;
    if(switch[7:4]==4'b1010) dout2 = 8'b1110111;
    if(switch[7:4]==4'b1011) dout2 = 8'b1111100;
    if(switch[7:4]==4'b1100) dout2 = 8'b0111001;
    if(switch[7:4]==4'b1101) dout2 = 8'b1011110;
    if(switch[7:4]==4'b1110) dout2 = 8'b1111001;
    if(switch[7:4]==4'b1111) dout2 = 8'b1110001;
    end
    always@(switch) begin
    if(switch[11:8]==4'b0000) dout3 = 8'b0111111;
    if(switch[11:8]==4'b0001) dout3 = 8'b0000110;
    if(switch[11:8]==4'b0010) dout3 = 8'b1011011;
    if(switch[11:8]==4'b0011) dout3 = 8'b1001111;
    if(switch[11:8]==4'b0100) dout3 = 8'b1100110;
    if(switch[11:8]==4'b0101) dout3 = 8'b1101101;
    if(switch[11:8]==4'b0110) dout3 = 8'b1111101;
    if(switch[11:8]==4'b0111) dout3 = 8'b0100111;
    if(switch[11:8]==4'b1000) dout3 = 8'b1111111;
    if(switch[11:8]==4'b1001) dout3 = 8'b1100111;
    if(switch[11:8]==4'b1010) dout3 = 8'b1110111;
    if(switch[11:8]==4'b1011) dout3 = 8'b1111100;
    if(switch[11:8]==4'b1100) dout3 = 8'b0111001;
    if(switch[11:8]==4'b1101) dout3 = 8'b1011110;
    if(switch[11:8]==4'b1110) dout3 = 8'b1111001;
    if(switch[11:8]==4'b1111) dout3 = 8'b1110001;
    end
    always@(switch) begin
    if(switch[15:12]==4'b0000) dout4 = 8'b0111111;
    if(switch[15:12]==4'b0001) dout4 = 8'b0000110;
    if(switch[15:12]==4'b0010) dout4 = 8'b1011011;
    if(switch[15:12]==4'b0011) dout4 = 8'b1001111;
    if(switch[15:12]==4'b0100) dout4 = 8'b1100110;
    if(switch[15:12]==4'b0101) dout4 = 8'b1101101;
    if(switch[15:12]==4'b0110) dout4 = 8'b1111101;
    if(switch[15:12]==4'b0111) dout4 = 8'b0100111;
    if(switch[15:12]==4'b1000) dout4 = 8'b1111111;
    if(switch[15:12]==4'b1001) dout4 = 8'b1100111;
    if(switch[15:12]==4'b1010) dout4 = 8'b1110111;
    if(switch[15:12]==4'b1011) dout4 = 8'b1111100;
    if(switch[15:12]==4'b1100) dout4 = 8'b0111001;
    if(switch[15:12]==4'b1101) dout4 = 8'b1011110;
    if(switch[15:12]==4'b1110) dout4 = 8'b1111001;
    if(switch[15:12]==4'b1111) dout4 = 8'b1110001;
    end                                                                                                                                             
    always @(number)begin    
    //if(CubeCtrl)     
        case(number)
        4:begin control=8'b11110111; cube_data=~dout4;end
        5:begin control=8'b11111011; cube_data=~dout3;end
        6:begin control=8'b11111101; cube_data=~dout2;end
        7:begin control=8'b11111110; cube_data=~dout1;end
        default:control=8'b11111111;
        endcase
     end
endmodule