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
