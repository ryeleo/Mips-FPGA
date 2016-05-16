// 2016 Ryan Leonard
// Decoder Module Testbench
//
module test_decoder_32;

reg [31:0] instruction;
wire [5:0] opcode;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] shamt;
wire [5:0] alu_function;
wire [15:0] immediate;
wire [25:0] jump_target;

decoder_32 dut (
  .instruction (instruction),
  .opcode (opcode),
  .rs (rs),
  .rt (rt),
  .rd (rd),
  .shamt (shamt),
  .alu_function (alu_function),
  .immediate (immediate),
  .jump_target (jump_target)
);

// Test stimulus
initial
begin // BEG test

  $display("==========\nCheck misc instructions R-type\n");
  instruction = 32'hffffffff;
  #10;
  instruction = 32'h00000000;
  #10;
  instruction = 32'b000001_00001_00001_00001_00001_000001;
  #10;
  instruction = 32'b100000_10000_01000_00100_00010_000001;
  #10;
  instruction = 32'b100000_10000_01000_00100_00010_000000;
  #10;

  $display("==========\nCheck misc instructions I-type\n");
  instruction = 32'b000001_00001_00001_0000000000000000;
  #10;
  instruction = 32'b000001_00001_00001_1000000000000000;
  #10;
  instruction = 32'b000001_00001_00001_1111111111111111;
  #10;

  $display("==========\nCheck misc instructions J-type (max is jump is 3ffffff)\n");
  instruction = {6'b000001, 26'h00000000};
  #10;
  instruction = {7'b000001_1, 25'h00000000};
  #10;
  instruction = {6'b000001, 26'hffffffff};
  #10;
end // END testing

// Basic console output
initial 
begin
  $display("opcode, rs, rt, rd, shamt, alu_function || immediate || jump_target");
  $monitor("%d, %d, %d, %d, %d, %d, %h, %h",
    opcode, rs, rt, rd, shamt, alu_function, immediate, jump_target);
end

endmodule

