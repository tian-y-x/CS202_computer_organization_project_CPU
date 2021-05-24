module MemOrIO( mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, CUBECtrl,SwitchCtrl);
input mRead; // read memory, from control32
input mWrite; // write memory, from control32
input ioRead; // read IO, from control32
input ioWrite; // write IO, from control32
input[31:0] addr_in; // from alu_result in executs32
output[31:0] addr_out; // address to memory

input[31:0] m_rdata; // data read from memory
input[15:0] io_rdata; // data read from io,16 bits
output reg[31:0] write_data; // data to memory or I/O???m_wdata, io_wdata???

output reg [31:0] r_wdata; // data to idecode32(register file)
input[31:0] r_rdata; // data read from idecode32(register file)

output  CUBECtrl;
output LEDCtrl; // LED Chip Select
output SwitchCtrl; // Switch Chip Select
assign addr_out= addr_in;
// The data wirte to register file may be from memory or io. // While the data is from io, it should be the lower 16bit of r_wdata. assign r_wdata = ?????????
// Chip select signal of Led and Switch are all active high;

assign LEDCtrl= 1'b1;
assign CUBECtrl=1'b1;
assign SwitchCtrl= 1'b1;

always @* begin
if((mWrite==1)||(ioWrite==1))
//wirte_data could go to either memory or IO. where is it from?
write_data = r_rdata;
else
write_data = 32'hZZZZZZZZ;
end

always @* begin
if((mRead==1)||(ioRead==1))
//wirte_data could go to either memory or IO. where is it from?
r_wdata = ioRead?{16'b0,io_rdata}:m_rdata;
else
r_wdata = 32'h0000ffff;
end

endmodule