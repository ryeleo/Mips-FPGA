module control_test;
  reg   [5:0] opcode;

  wire 	[1:0] alu_op;
  wire        mem_toreg;
  wire 				mem_write;
  wire 				mem_read;
  wire 				branch;
  wire 				alu_src;
  wire 				reg_dst;
  wire 				reg_write;
  wire 				jump;
  wire        error;

  control_32 control (
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
 
  wire [7:0] result;
  assign result[7] = reg_write;
  assign result[6] = reg_dst;
  assign result[5] = alu_src;
  assign result[4] = branch;
  assign result[3] = mem_write;
  assign result[2] = mem_read;
  assign result[1] = mem_toreg;
  assign result[0] = jump;

  initial begin
    $dumpfile("control_test.vcd");
    $dumpvars(0, control_test);

    $monitor("Opcode: %b, result: %b, ALUop: %b, error: %b", opcode, result, alu_op, error); 
    opcode <= 6'b0000_00; #5; // r_type 

    opcode <= 6'b1000_11; #5;// lw
    opcode <= 6'b1010_11; #5;// sw
    opcode <= 6'b0001_00; #5;// beq 
    opcode <= 6'b0010_00; #5;// addi  
    opcode <= 6'b0000_10; #5;// jump

    $display("\nError codes\n\n");
    opcode <= 6'b0011_10; #5;// r_type 
    opcode <= 6'b1111_11; #5;// lw
    opcode <= 6'b1110_11; #5;// sw
    opcode <= 6'b0111_10; #5;// beq 
    opcode <= 6'b1110_10; #5;// addi  
    opcode <= 6'b1001_11; #5;// jump
  end
endmodule