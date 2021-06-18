module CPU_UART(
    input           sys_clk,         
    input           sys_rst_n,
    input           vga_rst_n,
    input[23:0]     sw_input,
    output[23:0]    led,
    output[7:0]     control,
    output[7:0]     cube_data,
    
    output          vga_hs,
    output          vga_vs,
    output[11:0]    vga_rgb,
    input           start_pg,
    input           rx,
    output          tx
    );
    // UART Programmer Pinouts
    wire upg_clk, upg_clk_o,rst;
    wire upg_flg1,upg_flg2;
    wire upg_wen_o; //Uart write out enable
    wire upg_done_o; //Uart rx data have done
    //data to which memory unit of program_rom/dmemory32
    wire [14:0] upg_adr_o;
    //data to program_rom or dmemory32
    wire [31:0] upg_dat_o;
    wire spg_bufg;
    BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter
    // Generate UART Programmer reset signal
    reg upg_rst;
    
    always @ (posedge sys_clk) begin
    if (spg_bufg) upg_rst = 0;
    if (sys_rst_n) upg_rst = 1;
    end
    assign rst = sys_rst_n | !upg_rst;
    uart_bmpg_0
    (
        .upg_clk_i  (upg_clk),
        .upg_rst_i  (upg_rst),
        .upg_rx_i   (rx),
        .upg_clk_o  (upg_clk_o),
        .upg_wen_o  (upg_wen_o),
        .upg_adr_o  (upg_adr_o),
        .upg_dat_o  (upg_dat_o),
        .upg_done_o (upg_done_o),
        .upg_tx_o   (tx)
        
        
    );
    assign          upg_flg1 = upg_wen_o & upg_adr_o[14];
    assign          upg_flg2 = upg_wen_o & (!upg_adr_o[14]);
    wire[31:0]      instruction;
    wire[31:0]      Imme_extend;
    wire[31:0]      Read_data_1,Read_data_2;
    wire[31:0]      ALU_Result; 
    
    wire            ALUSrc;     //1 indicate the 2nd data is immidiate (except "beq","bne")
    wire[1:0]       ALUOp;      // if the instruction is R-type or I_format, ALUOp is 2'b10; if the instruction is"beq" or "bne", ALUOp is 2'b01????// if the instruction is"lw" or "sw", ALUOp is 2'b00????
    
    wire            Branch,nBranch,Jmp,Jal,Zero,Jr;
    wire            RegWrite; 
    wire            RegDst; 
    wire            Sftmd;
    wire            I_format;
    wire[31:0]      PC_plus_4;
    wire[31:0]      opcplus4;
    wire[31:0]      Addr_Result;
    wire[31:0]      write_data;
    wire[31:0]      mread_data;
    wire[31:0]      read_data;
    wire[31:0]      address;
    wire[31:0]      ioread_data;
    wire            MemorIOtoReg;
    wire[21:0]      ALU_resultHigh;
    wire memread,memwrite,ioread,iowrite,LEDCtrl,SwitchCtrl,CubeCtrl,flag;
    wire clk;
    wire vga_clk_w25;
    assign ALU_resultHigh=ALU_Result[31:10];
    pll upll(
    .clk_in1(sys_clk),
    .clk_out3(vga_clk_w25),
    .clk_out2(upg_clk),
    .clk_out1(clk)
    );
    vga_top u_vga_top(
        .sys_clk    (sys_clk),
        .vga_rst_n  (vga_rst_n),
        .vga_clk_w25(vga_clk_w25),
        .vga_hs     (vga_hs),
        .vga_vs     (vga_vs),
        .vga_rgb    (vga_rgb),
        .led        (led)
    
    );
    Tubs u_cube(
        .clock          (sys_clk),
        .sys_rst_n      (sys_rst_n),
        .CubeCtrl(CubeCtrl),
        .switch(led[15:0]),
        .control(control),
        .cube_data(cube_data)
    );
    MemOrIO u_memorio
    (
        .mRead        (memread),				
        .mWrite       (memwrite),               
        .ioRead         (ioread),             
        .ioWrite        (iowrite),               
        
        .addr_in     (ALU_Result),       
        .addr_out       (address),      

        .m_rdata        (mread_data),      
        .io_rdata       (ioread_data),   
        .r_wdata        (read_data),           
        .r_rdata        (Read_data_2),           
        .write_data     (write_data),    
        .CUBECtrl       (CubeCtrl),
        .LEDCtrl        (LEDCtrl),           
        .SwitchCtrl     (SwitchCtrl)         
    );

    Switch u_switchs
    (
        .switclk        (clk),
        .switrst        (sys_rst_n),
        .switchread     (ioread),
        .switchaddr     (address[1:0]),
        .switch_i       (sw_input),

        .switchrdata    (ioread_data),
        .switchcs       (SwitchCtrl)
    );
    
    LED u_leds
    (
    .led_clk            (clk),
    .ledrst             (sys_rst_n),
    .ledwrite           (iowrite),
    .ledcs              (LEDCtrl),
    .ledaddr            (address[1:0]),
    .ledwdata           (write_data[15:0]),
    .ledout             (led)
    );
    Dmem_UART u_dememory
    (
        .upg_clk_i      (upg_clk_o),
        .upg_wen_i      (upg_flg1),
        .upg_adr_i      (upg_adr_o[13:0]),
        .upg_dat_i      (upg_dat_o),
        .upg_done_i     (upg_done_o),
        .upg_rst_i      (upg_rst),
        
        .clock          (clk),
        .Memwrite       (memwrite),
        .address        (address),
        .write_data     (write_data),
        .read_data      (mread_data)
    );
    Decoder u_decoder
    (
        .Instruction        (instruction),
        .Imme_extend        (Imme_extend),
        .Read_data_1        (Read_data_1),
        .Read_data_2        (Read_data_2),
        .ALU_Result         (ALU_Result),
        .MemOrIOtoReg       (MemorIOtoReg),
        .read_data          (read_data),
        .clock              (clk),
        .reset              (sys_rst_n), 
        .Jal                (Jal),  
        .RegWrite           (RegWrite),    
        .RegDst             (RegDst),
        .opcplus4           (opcplus4)
    );
    ControllerIO u_controller
    (
        .ALUSrc             (ALUSrc),
        .ALUOp              (ALUOp),
        
        .Opcode             (instruction[31:26]),
        .Function_opcode    (instruction[5:0]),

        .Sftmd              (Sftmd),
        .Branch             (Branch),
        .nBranch            (nBranch),
        .Jr                 (Jr),
        .Jal                (Jal),
        .Jmp                (Jmp),
        .I_format           (I_format),
  
        .RegWrite           (RegWrite),    
        .RegDST             (RegDst),
        .MemWrite           (memwrite),
        .MemRead            (memread),
        
        .Alu_resultHigh     (ALU_resultHigh), 
        .MemorIOtoReg       (MemorIOtoReg),
        .IORead             (ioread), 
        .IOWrite            (iowrite) 

    );
    ALU u_alu
    (
        //.led                (led),
        .Read_data_1        (Read_data_1),
        .Read_data_2        (Read_data_2),
        .Imme_extend        (Imme_extend),
        .ALUSrc             (ALUSrc),
        .ALUOp              (ALUOp),
        .Function_opcode    (instruction[5:0]),
        .Opcode             (instruction[31:26]),
        
        .Shamt              (instruction[10:6]),
        .Sftmd              (Sftmd),
        .Jr                 (Jr),
        .Zero               (Zero),
        .I_format           (I_format),
        
        .ALU_Result         (ALU_Result),
        .PC_plus_4          (PC_plus_4),
        .Addr_Result        (Addr_Result)
    );
    IFetch_UART u_ifetch
    (
        .upg_wen_i          (upg_wen_o),
        .upg_clk_i          (upg_clk_o),
        .upg_adr_i          (upg_adr_o[13:0]),
        .upg_dat_i          (upg_dat_o),
        .upg_done_i         (upg_done_o),
        .upg_rst_i          (upg_rst),
        
        .Instruction        (instruction),
        .branch_base_addr   (PC_plus_4),
        .link_addr          (opcplus4),
        .clock              (clk),
        .reset              (sys_rst_n), 

        .Addr_result        (Addr_Result),
        .Zero               (Zero),
        .Read_data_1        (Read_data_1), 

        .Branch             (Branch), 
        .nBranch            (nBranch), 
        .Jmp                (Jmp), 
        .Jal                (Jal), 
        .Jr                 (Jr) 
    );

endmodule
