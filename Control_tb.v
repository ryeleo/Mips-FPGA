module control_test;
  reg   [5:0] opcode;

  wire 	[1:0] alu_op;
  wire  [1:0] mem_toreg;
  wire 				mem_write;
  wire 				mem_read;
  wire 				branch;
  wire 				alu_src;
  wire 	[1:0] reg_dst;
  wire 				reg_write;
  wire 	[1:0] jump;
  wire        error;

  control_32 dut (
    .opcode(opcode),
    .alu_op(alu_op),
    .mem_toreg(mem_toreg),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .branch(branch),
    .alu_src(alu_src),
    .reg_dst(reg_dst),
    .reg_write(reg_write),
    .jump(jump),
    .err_illegal_opcode(error)
  );
 
  wire [10:0] result = {reg_write, reg_dst, alu_src, branch, mem_write, mem_read, mem_toreg, jump};

  initial begin
    $dumpfile("control_test.vcd");
    $dumpvars(0, control_test);

    $monitor("Opcode: %b, result: %b, ALUop: %b, error: %b", opcode, result, alu_op, error); 
    opcode <= 6'b0000_00; #5; // r_type 

    opcode <= dut.lw; #5;// lw
    opcode <= dut.sw; #5;// sw
    opcode <= dut.beq; #5;// beq 
    opcode <= dut.addi; #5;// addi  
    opcode <= dut.j; #5;// jump
    opcode <= dut.jal; #5;// jal

    $display("\nError codes\n\n");
    opcode <= 6'b0011_10; #5;// r_type 
    opcode <= 6'b1111_11; #5;// lw
    opcode <= 6'b1110_11; #5;// sw
    opcode <= 6'b0111_10; #5;// beq 
    opcode <= 6'b1110_10; #5;// addi  
    opcode <= 6'b1001_11; #5;// jump
  end
endmodule
