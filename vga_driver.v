`timescale 1ns / 1ps

module vga_driver(
        input sys_clk,              //系统时钟100Mhz
        input vga_clk25,            //25Mhz
        input vga_rst_n,            //复位
        input [11:0] pixel_data,    //颜色数据
        
        output vga_hs,              //行场同步
        output vga_vs,
        output reg[10:0] H_DISP,
        output reg[10:0] V_DISP,
        output [11:0] vga_rgb,      //输出到显示屏
        output [10:0] pixel_xpos,   //坐标
        output [10:0] pixel_ypos,
        output reg vga_clk_cur
    );
    reg [10:0] H_TOTAL; 
    reg [10:0] H_FRONT; //行显示前沿
    reg [10:0] H_SYNC;
    reg [10:0] V_TOTAL; 
    reg [10:0] V_FRONT; //列显示前沿    
    reg [10:0] V_SYNC;
    reg [10:0] H_BACK;  //行显示后沿
    reg [10:0] V_BACK;  //列显示后沿
    
    always@(posedge sys_clk) begin
            H_TOTAL <= 11'd800;
            H_DISP<=11'd640;
            H_FRONT<=11'd16;
            H_SYNC<=11'd96;
            H_BACK<=11'd48;
            V_TOTAL<=11'd525;
            V_DISP<=11'd480;
            V_FRONT<=11'd10;
            V_SYNC<=11'd2;
            V_BACK<=11'd33;
            vga_clk_cur<=vga_clk25;
    end
    
    reg [10:0] cnt_h;
    reg [10:0] cnt_v;
    
    wire vga_en;
    wire data_req;
            
    assign vga_rgb=vga_en ?pixel_data:12'd0;
    
    assign vga_hs =(cnt_h <= H_SYNC - 1'b1) ? 1'b0 :1'b1;
    
    assign vga_vs =(cnt_v <= V_SYNC - 1'b1) ? 1'b0 : 1'b1;
    
    assign vga_en =(((cnt_h >= H_SYNC+H_BACK)&&(cnt_h < H_SYNC+H_BACK+H_DISP))
           &&((cnt_v >= V_SYNC+V_BACK)&&(cnt_v < V_SYNC+V_BACK+V_DISP)))? 1'b1:1'b0;
           
    assign data_req=(((cnt_h >= H_SYNC+H_BACK-1'b1)&&(cnt_h < H_SYNC+H_BACK+H_DISP-1'b1))
           &&((cnt_v >= V_SYNC+V_BACK)&&(cnt_v < V_SYNC+V_BACK+V_DISP)))? 1'b1:1'b0;
           
    assign pixel_xpos =data_req ?(cnt_h -(H_SYNC +H_BACK-1'b1)) :11'd0;
    
    assign pixel_ypos =data_req ?(cnt_v -(V_SYNC +V_BACK-1'b1)) : 11'd0;
    
    
    always @(posedge vga_clk_cur or negedge vga_rst_n) begin         
        if (vga_rst_n)
            cnt_h <= 11'd0;                                  
        else begin
            if(cnt_h < H_TOTAL - 1'b1)                                               
                cnt_h <= cnt_h + 1'b1;                               
            else 
                cnt_h <= 11'd0;  
        end
    end
    
    always @(posedge vga_clk_cur or negedge vga_rst_n) begin         
        if (vga_rst_n)
            cnt_v <= 11'd0;                                  
        else if(cnt_h == H_TOTAL - 1'b1) begin
            if(cnt_v < V_TOTAL - 1'b1)                                               
                cnt_v <= cnt_v + 1'b1;                               
            else 
                cnt_v <= 11'd0;  
        end
    end
    
endmodule