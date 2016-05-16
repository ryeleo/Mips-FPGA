// 2016 Ryan Leonard
// Decoder Module

module decoder_32(
  instruction,
  // output for r-type instructionuctions
  r_opcode,
  r_rs,
  r_rt,
  r_rd,
  r_shamt,
  r_function,
  // output for i-type instructionuctions
  i_opcode,
  i_rs,
  i_rt,
  i_immediate,
  // output for j-type instructionuctions
  j_opcode,
  j_jump_target
);

input wire [31:0]  instruction;

output wire [5:0] r_opcode;
output wire [4:0] r_rs;
output wire [4:0] r_rt;
output wire [4:0] r_rd;
output wire [4:0] r_shamt;
output wire [5:0] r_function;

output wire [5:0]  i_opcode;
output wire [4:0]  i_rs;
output wire [4:0]  i_rt;
output wire [15:0] i_immediate;

output wire [5:0]  j_opcode;
output wire [25:0] j_jump_target;

assign r_opcode    = instruction[31:26];
assign r_rs        = instruction[25:21];
assign r_rt        = instruction[20:16];
assign r_rd        = instruction[15:11];
assign r_shamt     = instruction[10:06];
assign r_function  = instruction[05:00];

assign i_opcode     = instruction[31:26];
assign i_rs         = instruction[25:21];
assign i_rt         = instruction[20:16];
assign i_immediate  = instruction[15:00];

assign j_opcode       = instruction[31:26];
assign j_jump_target  = instruction[25:00];

endmodule
