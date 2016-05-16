// 2016 Ryan Leonard
// Decoder Module
//
//    R-type
//  opcode   rs    rt     rd    shamt   alu_function
//  ______ ______ ______ ______ ______ ______
// |______|______|______|______|______|______|
//   6bit   5bit   5bit   5bit   5bit   6bit
//
//
//    I-type
//  opcode   rs     rt     immediate
//  ______ ______ ______ ____________________
// |______|______|______|____________________|
//   6bit   5bit   5bit       16bit
//
//    J-type
//  opcode           jump_target
//  ______ __________________________________
// |______|__________________________________|
//   6bit            26bit
//

module decoder_32(
  instruction,
  opcode,
  rs,
  rt,
  rd,
  shamt,
  alu_function,
  immediate,
  jump_target
);

input wire [31:0]  instruction;
output wire [5:0] opcode;
output wire [4:0] rs;
output wire [4:0] rt;
output wire [4:0] rd;
output wire [4:0] shamt;
output wire [5:0] alu_function;
output wire [15:0] immediate;
output wire [25:0] jump_target;

assign opcode       = instruction[31:26];
assign rs           = instruction[25:21];
assign rt           = instruction[20:16];
assign rd           = instruction[15:11];
assign shamt        = instruction[10:06];
assign alu_function = instruction[05:00];
assign immediate    = instruction[15:00];
assign jump_target  = instruction[25:00];

endmodule
