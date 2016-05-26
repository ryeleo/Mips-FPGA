module alu_control_test;
  reg   [5:0] func;
  reg 	[1:0] alu_op;
  reg         start;
  wire  [3:0] alu_control;
  wire        alu_op_error;
  wire 	      func_error;
  wire        finish;
  alu_control_32 alu_control_32_test (
    .start(start),
    .func(func),
    .alu_op(alu_op),
    .alu_control(alu_control),
    .err_illegal_func_code(func_error),
    .err_illegal_alu_op(alu_op_error),
    .finish(finish)
  );
 
  initial begin

    $dumpfile("alu_control_32_test.vcd");
    $dumpvars(0, alu_control_32_test);

    $monitor("function code: %b, ALUop: %b, alu_control: %b, func_error: %b, alu_op_error: %b, finish: %b", func, alu_op, alu_control, func_error, alu_op_error, finish); 

    $display("\n=======Mem type\n");

    start <= 1; func <= 6'b10_0000; alu_op = 2'b00; #5; start <= 0; #5;// add 
    start <= 1; func <= 6'b10_0010; alu_op = 2'b00; #5; start <= 0; #5;// sub
    start <= 1; func <= 6'b10_0100; alu_op = 2'b00; #5; start <= 0; #5;// or
    start <= 1; func <= 6'b10_0101; alu_op = 2'b00; #5; start <= 0; #5;// and 
    start <= 1; func <= 6'b101_010; alu_op = 2'b00; #5; start <= 0; #5;// slt  

    $display("\n======= branch type\n");
    start <= 1; func <= 6'b10_0000; alu_op = 2'b01; #5; start <= 0; #5;// r_type 
    start <= 1; func <= 6'b10_0010; alu_op = 2'b01; #5; start <= 0; #5;// lw
    start <= 1; func <= 6'b10_0100; alu_op = 2'b01; #5; start <= 0; #5;// sw
    start <= 1; func <= 6'b10_0101; alu_op = 2'b01; #5; start <= 0; #5;// beq 
    start <= 1; func <= 6'b101_010; alu_op = 2'b01; #5; start <= 0; #5;// addi  

    $display("\n======= r type\n");
    start <= 1; func <= 6'b10_0000; alu_op = 2'b10; #5; start <= 0; #5;// r_type 
    start <= 1; func <= 6'b10_0010; alu_op = 2'b10; #5; start <= 0; #5;// lw
    start <= 1; func <= 6'b10_0100; alu_op = 2'b10; #5; start <= 0; #5;// sw
    start <= 1; func <= 6'b10_0101; alu_op = 2'b10; #5; start <= 0; #5;// beq 
    start <= 1; func <= 6'b101_010; alu_op = 2'b10; #5; start <= 0; #5;// addi

    $display("\n======= Error function code\n");
    start <= 1; func <= 6'b11_1010; alu_op = 2'b10; #5; start <= 0; #5; // r_type 
    start <= 1; func <= 6'b11_1111; alu_op = 2'b10; #5; start <= 0; #5; // lw
    start <= 1; func <= 6'b11_0110; alu_op = 2'b10; #5; start <= 0; #5; // sw
    start <= 1; func <= 6'b11_0101; alu_op = 2'b10; #5; start <= 0; #5; // beq 
    start <= 1; func <= 6'b101_011; alu_op = 2'b10; #5; start <= 0; #5; // addi

    $display("\n======= ALUop code\n");

    start <= 1; func <= 6'b11_1010; alu_op = 2'b11; #5; start <= 0; #5; // r_type 
    start <= 1; func <= 6'b11_1111; alu_op = 2'b11; #5; start <= 0; #5; // lw
    start <= 1; func <= 6'b11_0110; alu_op = 2'b11; #5; start <= 0; #5; // sw
    start <= 1; func <= 6'b11_0101; alu_op = 2'b11; #5; start <= 0; #5; // beq 
    start <= 1; func <= 6'b101_011; alu_op = 2'b11; #5; start <= 0; #5; // addi
  end
endmodule
