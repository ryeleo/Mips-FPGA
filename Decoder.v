// 2016 Ryan Leonard
// Decoder Module


module decoder_32(
  input [31:0]	instruction,
);
wire op           = instr[0:0];
wire rs           = instr[0:0];
wire rt           = instr[0:0];
wire rd           = instr[0:0];
wire shamt        = instr[0:0];
wire funct        = instr[0:0];
wire immediate    = instr[0:0];
wire displacement = instr[0:0];
wire target       = instr[0:0];
