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

rf_32 regfile (
  .clock(),
  .read_addr_s(),
  .read_addr_t(),
  .write_addr(),
  .write_data(),
  .write(enabled(),
  .outA(),
  .outB()
);

alu_32 alu (
  .input_a(),
  .input_b(),
  .control(),
  .result(),
  .zero(),
  .cout(),
  .err_overflow(),
  .err_invalid_control()
);

memory data_memory (
  .clock(),
  .input_address(),
  .input_data(),
  .read_enabled(),
  .write_enabled(),
  .output_data(),
  .err_invalid_address()
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
