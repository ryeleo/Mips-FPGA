module alu_control_test;
  reg   [5:0] func;

  reg 	[1:0] alu_op;
  wire  [3:0] alu_control;
  wire        alu_op_error;
  wire 		  func_error;
  alu_control_32 dut(
    .func(func),
    .alu_op(alu_op),
    .alu_control(alu_control),
    .err_illegal_func_code(func_error),
    .err_illegal_alu_op(alu_op_error)
  );
 
  initial begin

    $dumpfile("alu_control_32_test.vcd");
    $dumpvars(0, dut);

    $monitor("				  function code: %b, ALUop: %b, alu_control: %b, func_error: %b, , alu_op_error: %b", func, alu_op, alu_control, func_error, alu_op_error); 

    $display("\n=======Mem type\n");
    func <= 6'b10_0000; alu_op = 2'b00; #5; // add 
    func <= 6'b10_0010; alu_op = 2'b00; #5; // sub
    func <= 6'b10_0100; alu_op = 2'b00; #5; // or
    func <= 6'b10_0101; alu_op = 2'b00; #5; // and 
    func <= 6'b101_010; alu_op = 2'b00; #5; // slt  

    $display("\n======= branch type\n");
    func <= 6'b10_0000; alu_op = 2'b01; #5; // r_type 
    func <= 6'b10_0010; alu_op = 2'b01; #5; // lw
    func <= 6'b10_0100; alu_op = 2'b01; #5; // sw
    func <= 6'b10_0101; alu_op = 2'b01; #5; // beq 
    func <= 6'b101_010; alu_op = 2'b01; #5; // addi  

    $display("\n======= r type\n");
    func <= 6'b10_0000; alu_op = 2'b10; #5; // r_type 
    func <= 6'b10_0010; alu_op = 2'b10; #5; // lw
    func <= 6'b10_0100; alu_op = 2'b10; #5; // sw
    func <= 6'b10_0101; alu_op = 2'b10; #5; // beq 
    func <= 6'b101_010; alu_op = 2'b10; #5; // addi
    func <= dut.jr_func; alu_op = dut.arith_aluop; #5; // jr

    $display("\n======= Error function code\n");
    func <= 6'b11_1010; alu_op = 2'b10; #5; // r_type 
    func <= 6'b11_1111; alu_op = 2'b10; #5; // lw
    func <= 6'b11_0110; alu_op = 2'b10; #5; // sw
    func <= 6'b11_0101; alu_op = 2'b10; #5; // beq 
    func <= 6'b101_011; alu_op = 2'b10; #5; // addi

    $display("\n======= ALUop code\n");
    func <= 6'b11_1010; alu_op = 2'b11; #5; // r_type 
    func <= 6'b11_1111; alu_op = 2'b11; #5; // lw
    func <= 6'b11_0110; alu_op = 2'b11; #5; // sw
    func <= 6'b11_0101; alu_op = 2'b11; #5; // beq 
    func <= 6'b101_011; alu_op = 2'b11; #5; // addi
  end
endmodule
