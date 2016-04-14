// 2016 Ryan Leonard
// ALU Module Testbench
`timescale 1ns / 1ns
module test_alu_32;
// The reg/nets we will maniupulate/monitor for testing
reg [31:0]	a;        //input
reg [31:0]	b;        //input
reg [3:0]	  control;  //input
wire	      cout;     //out
wire	      zero;     //out
wire	      overflow; //out
wire [31:0]	result;   //out
reg  [8*3:0] str_control; // HELPER
// build a version of the Design Under Test (dut)
alu_32 dut(
  .a	      (a),
  .b	      (b),
  .control  (control),
  .cout     (cout),
  .zero     (zero),
  .overflow (overflow),
  .result   (result)
);

// Test stimulus
initial
  begin
    //Testing AND
    a=32'h0; b=32'h0;
    control = 4'h0;
    #10 a=32'b01;   b=32'b01;
    #10 a=32'b10;   b=32'b01;
    #10 a=32'hFFFFFFFF; b=32'h00000000;
    #10 a=32'h00000000; b=32'h0000FFFF;
    #10 a=32'h0000FF00; b=32'h000000FF;
    #10 a=32'h000000FF; b=32'h0000FF00;
    #10 a=32'h0000F000; b=32'h0000F000;
    #10 a=32'h0000000F; b=32'h0000000F;
    #10 a=32'hFFFFFFFF; b=32'hFFFFFFFF;
    #10 a=32'h0000000F; b=32'hFFFFFFFF;
    //Testing OR
    #10 control = 4'h1; 
        a=32'b01;   b=32'b01; 
    #10 a=32'b10;   b=32'b01;
    #10 a=32'hFFFFFFFF; b=32'h0000000F;
    #10 a=32'h0000000F; b=32'hFFFFFFFF;
    //Testing ADD
    #10 control = 4'h2; 
        a=32'd1;   b=32'd1; 
    #10 a=32'd3;   b=32'd1;
    #10 a=32'd100; b=32'd300;
    #10 a=32'd1234; b=32'd4321;
    #10 a=32'd9; b=32'd1;
      // Overflow cases
    #10 a=32'hFFFFFFFF; b=32'h00000001;
  end

// Little helper that makes our string output prettier
always @ (control)
  case(control)
    0 : str_control = "and";
    1 : str_control = " or";
    2 : str_control = "add";
    3 : str_control = "sub";
    4 : str_control = "slt";
    5 : str_control = "nor";
    default : str_control = " ? ";
  endcase

// Basic console output
initial 
  begin
    $display("time, a (op) b = result"); 
    $monitor("%d, %d %s %d = %d", $time, a, str_control, b, result); 
  end

endmodule 
