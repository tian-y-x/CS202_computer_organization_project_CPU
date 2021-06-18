`timescale 1ns / 1ps

//top of display
module vga_top
    (
        //input s_flag,   
        input sys_clk,
        input vga_rst_n,
        
        input vga_clk_w25,
        input [15:0] led,
        
        output vga_hs,
        output vga_vs,
        output [11:0] vga_rgb
    );
    wire rst_n_w;
    wire [11:0] pixel_data_w;
    wire [10:0] pixel_xpos_w;
    wire [10:0] pixel_ypos_w;

    
    wire[10:0] H_DISP;
    wire[10:0] V_DISP;
    wire       vga_clk_cur;
    
        
    vga_driver u_vga_driver
    (
    .H_DISP     (H_DISP),
    .V_DISP     (V_DISP),
    .sys_clk    (sys_clk),
    .vga_clk25  (vga_clk_w25),
    .vga_rst_n  (vga_rst_n),
    .vga_hs     (vga_hs),
    .vga_vs     (vga_vs),
    .vga_rgb    (vga_rgb),
    .pixel_data (pixel_data_w),
    .vga_clk_cur(vga_clk_cur),
    .pixel_xpos (pixel_xpos_w),
    .pixel_ypos (pixel_ypos_w)
    );
    vga_colorbar u_vga_display
    (
    //.en(s_flag),
    .led(led),
    .H_DISP(H_DISP),
    .V_DISP(V_DISP),
    .vga_rst_n (vga_rst_n),
    .vga_clk(vga_clk_cur),
    .pixel_xpos (pixel_xpos_w),
    .pixel_ypos (pixel_ypos_w),
    .pixel_data (pixel_data_w)
    );
endmodule
