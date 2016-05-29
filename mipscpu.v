// 2016 Ryan Leonard & Rui Tu
// regalumem is a composition of Register file, Alu, and data memory
//
// Both regfile and memory can be driven by the same clock since storeword is
// the only instruction that writes to memory

module mips_cpu(
  clock,
  instruction
);

input wire clock;
input wire [31:0] instruction;

wire [5:0] dec_opcode;
wire [5:0] dec_funct;
wire [4:0] dec_rf_readaddrs;
wire [4:0] dec_rf_readaddrt;
wire [4:0] dec_rfwritemux_a;
wire [4:0] dec_rfwritemux_b;
wire [15:0] dec_immediate;
wire [25:0] dec_jumptarg;

assign dec_rfwritemux_a = dec_rf_readaddrt;
decoder_32 decode(
  .instruction(instruction),
  .opcode(dec_opcode),
  .rs(dec_rf_readaddrs),
  .rt(dec_rf_readaddrt),
  .rt(dec_rf_readaddrt),
  .shamt(),
  .funct(dec_funct),
  .immediate(dec_immediate),
  .jump_target(dec_jumptarg)
);

wire [4:0] rfwritemux_c;
assign rfwritemux_c = 31; // Hardcoded for jump and link instruction

rf_32 regfile (
  .clock(clock),
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
  .clock(clock),
  .input_address(),
  .input_data(),
  .read_enabled(),
  .write_enabled(),
  .output_data(),
  .err_invalid_address()
);

sign_extend_32 sign_ext(
  .input_16(),
  .output_32()
);

endmodule
