`timescale 1ns / 1ps

module vga_colorbar
(
input [10:0] pixel_xpos,
input [10:0] pixel_ypos,
input vga_rst_n,vga_clk,
input [10:0] H_DISP,V_DISP,
input [15:0] led,
output reg[11:0]  pixel_data
);



localparam WHITE= 12'b1111_1111_1111;
localparam BLACK= 12'b0000_0000_0000;
localparam BLUE= 12'b1111_0000_0000;
localparam GREEN= 12'b0000_1111_0000;
localparam RED= 12'b0000_0000_1111;
localparam YELLOW= 12'b0000_1111_1111;
localparam PINK= 12'b1111_0000_1111;
localparam YOUNG= 12'b1111_1111_0000;

reg [11:0] COLOR=12'b0000_0000_0000;

always @(led) begin
if(vga_rst_n)begin
        
end
else begin 
if((pixel_xpos >= 0) && (pixel_xpos <= (H_DISP/16)*1))    begin                                          
pixel_data <= (led[15] ==1'b1) ? WHITE:BLACK;
end                           
else if((pixel_xpos >= (H_DISP/16)*1) && (pixel_xpos < (H_DISP/16)*2))begin
pixel_data <= (led[14] ==1'b1) ? WHITE:BLACK; 
end
else if((pixel_xpos >= (H_DISP/16)*2) && (pixel_xpos < (H_DISP/16)*3))begin
pixel_data <= (led[13] ==1'b1) ? WHITE:BLACK;
end
else if((pixel_xpos >= (H_DISP/16)*3) && (pixel_xpos < (H_DISP/16)*4))begin
pixel_data <= (led[12] ==1'b1) ? WHITE:BLACK;  
end
else  if((pixel_xpos >= (H_DISP/16)*4) && (pixel_xpos < (H_DISP/16)*5))begin
pixel_data <= (led[11] ==1'b1) ? WHITE:BLACK; 
end
else   if((pixel_xpos >= (H_DISP/16)*5) && (pixel_xpos < (H_DISP/16)*6))begin
pixel_data <= (led[10] ==1'b1) ? WHITE:BLACK;
end
else  if((pixel_xpos >= (H_DISP/16)*6) && (pixel_xpos < (H_DISP/16)*7))begin
pixel_data <= (led[9] ==1'b1) ? WHITE:BLACK;
end
else  if((pixel_xpos >= (H_DISP/16)*7) && (pixel_xpos < (H_DISP/16)*8))begin
pixel_data <= (led[8] ==1'b1) ? WHITE:BLACK;  
end
else  if((pixel_xpos >= (H_DISP/16)*8) && (pixel_xpos < (H_DISP/16)*9))begin
pixel_data <= (led[7] ==1'b1) ? WHITE:BLACK;  
end
else  if((pixel_xpos >= (H_DISP/16)*9) && (pixel_xpos < (H_DISP/16)*10))begin
pixel_data <= (led[6] ==1'b1) ? WHITE:BLACK;
end
else  if((pixel_xpos >= (H_DISP/16)*10) && (pixel_xpos < (H_DISP/16)*11))begin
pixel_data <= (led[5] ==1'b1) ? WHITE:BLACK;
end
else  if((pixel_xpos >= (H_DISP/16)*11) && (pixel_xpos < (H_DISP/16)*12))begin
pixel_data <= (led[4] ==1'b1) ? WHITE:BLACK; 
end
else  if((pixel_xpos >= (H_DISP/16)*12) && (pixel_xpos < (H_DISP/16)*13))begin
pixel_data <= (led[3] ==1'b1) ? WHITE:BLACK;  
end
else  if((pixel_xpos >= (H_DISP/16)*13) && (pixel_xpos < (H_DISP/16)*14))begin
pixel_data <= (led[2] ==1'b1) ? WHITE:BLACK;  
end
else  if((pixel_xpos >= (H_DISP/16)*14) && (pixel_xpos < (H_DISP/16)*15))begin
pixel_data <= (led[1] ==1'b1) ? WHITE:BLACK;  
end else begin
pixel_data <= (led[0] ==1'b1) ? WHITE:BLACK;    
end
end
end

endmodule