// 2016 Ryan Leonard & Rui Tu
// regalumem is a composition of Register file, Alu, and data memory

module regalumem(
  clock,
  rd,
  rs,
  rt,
  immediate,
  alu_control,
  mem_read_data,
  mem_write_data,
);

input wire clock;
input wire [4:0] rd; 
input wire [4:0] rs; 
input wire [4:0] rt;
input wire [15:0] immediate;
input wire [1:0] alu_control;
output reg [31:0] mem_read_data;
output reg [31:0] mem_write_data;

endmodule
