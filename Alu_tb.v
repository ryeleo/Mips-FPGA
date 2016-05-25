// 2016 Ryan Leonard
// ALU Module Testbench

`timescale 1ns / 1ns
module test_alu_32;
localparam 
  WORD_SIZE = 32;

// The reg/nets we will maniupulate/monitor for testing
reg         clock;
reg [WORD_SIZE-1:0]	input_a;
reg [WORD_SIZE-1:0]	input_b;
reg [3:0]	  control;
wire	      cout;
wire	      zero;
wire	      valid;
wire	      err_overflow;
wire [WORD_SIZE-1:0]	result;
wire	      err_invalid_control;

// build a version of the Design Under Test (dut)
alu_32 dut(
  .start    (clock),
  .input_a  (input_a),
  .input_b  (input_b),
  .control  (control),
  .cout     (cout),
  .zero     (zero),
  .finished (valid),
  .err_overflow (err_overflow),
  .result   (result),
  .err_invalid_control    (err_invalid_control)
);

// Clock Generator (#10 period)
initial 
begin
  clock = 1; 
  #5;
  forever
  begin
    clock = ~clock; 
    #5;
  end
end

initial
begin // BEG Test stimulus
  #20;
  //////////////////////////////////////////////////////////// 
  /// Testing AND
  //////////////////////////////////////////////////////////// 
  $display("==========\nTesting AND operator\n");
  control = dut.CONTROL_AND;
  input_a=32'b01;       
  input_b=32'b01; 
  #10;
  input_a=32'b10;       
  input_b=32'b01; 
  #10;
  input_a=32'hFFFFFFFF; 
  input_b=32'h00000000; 
  #10;
  input_a=32'h00000000; 
  input_b=32'h0000FFFF; 
  #10;
  input_a=32'h0000FF00; 
  input_b=32'h000000FF; 
  #10;
  input_a=32'h000000FF; 
  input_b=32'h0000FF00; 
  #10;
  input_a=32'h0000F000; 
  input_b=32'h0000F000; 
  #10;
  input_a=32'h0000000F; 
  input_b=32'h0000000F; 
  #10;
  input_a=32'hFFFFFFFF; 
  input_b=32'hFFFFFFFF; 
  #10;
  input_a=32'h0000000F; 
  input_b=32'hFFFFFFFF; 
  #10;

  //////////////////////////////////////////////////////////// 
  /// Testing OR
  //////////////////////////////////////////////////////////// 
  $display("==========\nTesting OR operator\n");
  control = dut.CONTROL_OR; 
  input_a=32'b01;       input_b=32'b01; #10;
  input_a=32'b10;       input_b=32'b01; #10;
  input_a=32'hFFFFFFFF; input_b=32'h0000000F; #10;
  input_a=32'h0000000F; input_b=32'hFFFFFFFF; #10;

  //////////////////////////////////////////////////////////// 
  /// Testing NOR
  //////////////////////////////////////////////////////////// 
  $display("==========\nTesting NOR operator\n");
  control = dut.CONTROL_NOR; 
  input_a=32'b01;       input_b=32'b01; #10;
  input_a=32'b10;       input_b=32'b01; #10;
  input_a=32'hFFFFFFFF; input_b=32'h0000000F; #10;
  input_a=32'h0000000F; input_b=32'hFFFFFFFF; #10;

  //////////////////////////////////////////////////////////// 
  /// Testing ADD
  //////////////////////////////////////////////////////////// 
  $display("==========\nTesting ADDU (unsigned) operator\n");
  control = dut.CONTROL_ADD_UNSIGNED; 
  input_a=32'd1;        input_b=32'd1; #10;
  input_a=32'd3;        input_b=32'd1; #10;
  input_a=32'd100;      input_b=32'd300; #10;
  input_a=32'd1234;     input_b=32'd4321; #10;
  input_a=32'd9;        input_b=32'd1; #10;
  $display("========== OVERFLOW CONDITIONS ==========");
  input_a=32'hFFFFFFFF; input_b=32'h1; #10;
  input_a=32'h1;        input_b=32'hFFFFFFFF; #10;
  input_a=32'hFFFFFFFF; input_b=32'hFFFFFFFF; #10;

  $display("==========\nTesting ADD (signed) operator\n");
  control = dut.CONTROL_ADD; 
  input_a=-32'd1;       input_b=32'd1; #10;
  $display("========== OVERFLOW CONDITIONS ==========");
  input_a=32'h7FFFFFFF; input_b=32'h1; #10;         // overflow (max pos + 1)
  input_a={1'b1,WORD_SIZE-1'b0}; input_b=32'hFFFFFFFF; #10;  // overflow (max neg + -1)
  input_a={1'b1,WORD_SIZE-1'b0}; input_b={1'b1,WORD_SIZE-1'b0}; #10;  // overflow (max neg)
  input_a=32'h7FFFFFFF; input_b=32'h7FFFFFFF; #10;  // overflow (max pos)

  //////////////////////////////////////////////////////////// 
  /// Testing SUB
  //////////////////////////////////////////////////////////// 
  $display("==========\nTesting SUB (signed) operator\n");
  control = dut.CONTROL_SUB; 
  input_a=32'd1;        input_b=32'd1; #10;
  input_a=32'd3;        input_b=32'd1; #10;
  input_a=32'd100;      input_b=32'd101; #10;
  input_a=32'd4321;     input_b=32'd1234; #10;
  input_a=32'd9;        input_b=32'd1; #10;
  input_a=32'hFFFFFFFF; input_b=32'h1; #10;
  input_a=32'h0;        input_b=32'hFFFFFFFF; #10;
  input_a=32'hFFFFFFFF; input_b=32'hFFFFFFFF; #10;
  $display("========== OVERFLOW CONDITIONS ==========");
  input_a={1'b1,WORD_SIZE-1'b0}; input_b=32'h00000001; #10;//(max neg- 1)
  input_a=32'h7FFFFFFF; input_b=32'hFFFFFFFF; #10;//(max pos- -1)
  input_a={1'b1,WORD_SIZE-1'b0}; input_b=32'h7FFFFFFF; #10;//(max neg)
  input_a=32'h7FFFFFFF; input_b={1'b1,WORD_SIZE-1'b0}; #10;//(max pos)

  //////////////////////////////////////////////////////////// 
  /// Testing SLT
  //////////////////////////////////////////////////////////// 
  $display("==========\nTesting SLT operator\n");
  control = dut.CONTROL_SLT; 
  input_a=32'd1;          input_b=32'd1; #10;
  input_a=32'd1;          input_b=32'd2; #10;
  input_a=32'hFFFFFFFF;   input_b=32'hFFFFFFFE; #10;
  input_a=32'hFFFFFFFE;   input_b=32'hFFFFFFFF; #10;
  input_a=32'hFFFFFFFF;   input_b=32'hFFFFFFFF; #10;
  input_a=32'h00000000;   input_b=32'hFFFFFFFF; #10;
  input_a=32'hFFFFFFFF;   input_b=32'h00000000; #10;

  //////////////////////////////////////////////////////////// 
  /// Testing Invalid Operator
  //////////////////////////////////////////////////////////// 
  $display("==========\nTesting Invalid operator\n");
  control = 4'hf; 
  input_a=32'd1;          input_b=32'd1; #10;
  $stop;
end // END Test stimulus

// Little helper that makes our string output prettier
reg  [8*4:0] str_control;
always @ (control)
begin
  case(control)
    dut.CONTROL_AND : str_control = "and";
    dut.CONTROL_OR  : str_control = " or";
    dut.CONTROL_ADD : str_control = "add";
    dut.CONTROL_ADD_UNSIGNED : str_control = "addu";
    dut.CONTROL_SUB : str_control = "sub";
    dut.CONTROL_SLT : str_control = "slt";
    dut.CONTROL_NOR : str_control = "nor";
    default : str_control = " ? ";
  endcase
end

// Basic console output
initial 
begin
  $display("time, a (op) input_b = result || zero, overflow, cout, err_inv_control"); 
  $monitor("%d, %h %s %h = %h || %b, %b, %b, %b", 
    $time, input_a, str_control, input_b, result, zero, err_overflow, cout, err_invalid_control); 
end

endmodule 
