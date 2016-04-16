// 2016 Ryan Leonard
// ALU Module Testbench

`timescale 1ns / 1ns
module test_alu_32;

// The reg/nets we will maniupulate/monitor for testing
reg         clock;    //clock
reg [31:0]	a;        //input
reg [31:0]	b;        //input
reg [3:0]	  control;  //input
wire	      cout;     //out
wire	      zero;     //out
wire	      overflow; //out
wire [31:0]	result;   //out

// build a version of the Design Under Test (dut)
alu_32 dut(
  .clk      (clock),
  .s	      (a),
  .t	      (b),
  .control  (control),
  .cout     (cout),
  .zero     (zero),
  .overflow (overflow),
  .result   (result)
);

// Clock Generator
initial 
  begin
    #5 clock = 0;
    forever
      #5 clock = ~clock;
  end


// Test stimulus
initial
  begin
    //////////////////////////////////////////////////////////// 
    /// Testing AND
    //////////////////////////////////////////////////////////// 
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

    //////////////////////////////////////////////////////////// 
    /// Testing OR
    //////////////////////////////////////////////////////////// 
    #10 control = 4'h1; 
        a=32'b01;   b=32'b01; 
    #10 a=32'b10;   b=32'b01;
    #10 a=32'hFFFFFFFF; b=32'h0000000F;
    #10 a=32'h0000000F; b=32'hFFFFFFFF;

    //////////////////////////////////////////////////////////// 
    /// Testing NOR
    //////////////////////////////////////////////////////////// 
    #10 control = 4'hC; 
        a=32'b01;   b=32'b01; 
    #10 a=32'b10;   b=32'b01;
    #10 a=32'hFFFFFFFF; b=32'h0000000F;
    #10 a=32'h0000000F; b=32'hFFFFFFFF;

    //////////////////////////////////////////////////////////// 
    /// Testing ADD
    //////////////////////////////////////////////////////////// 
    #10 control = 4'h2; 
        a=32'd1;   b=32'd1; 
    #10 a=32'd3;   b=32'd1;
    #10 a=32'd100; b=32'd300;
    #10 a=32'd1234; b=32'd4321;
    #10 a=32'd9; b=32'd1;
    #10 a=32'hFFFFFFFF; b=32'h1;
    #10 a=32'h1; b=32'hFFFFFFFF;
    #10 a=32'hFFFFFFFF; b=32'hFFFFFFFF;

    //////////////////////////////////////////////////////////// 
    /// Testing SLT
    //////////////////////////////////////////////////////////// 
    #10 control = 4'h7; 
        a=32'd1;   b=32'd1; 
    #10 a=32'd1;   b=32'd2;
    #10 a=32'hFFFFFFFF;   b=32'hFFFFFFFE;
    #10 a=32'hFFFFFFFE;   b=32'hFFFFFFFF;
    #10 a=32'hFFFFFFFF;   b=32'hFFFFFFFF;
    #10 a=32'h00000000;   b=32'hFFFFFFFF;
    #10 a=32'hFFFFFFFF;   b=32'h00000000;
  end

// Little helper that makes our string output prettier
reg  [8*3:0] str_control;
always @ (a or b)
  case(control)
    'h0 : str_control = "and";
    'h1 : str_control = " or";
    'h2 : str_control = "add";
    'h3 : str_control = "sub";
    'h7 : str_control = "slt";
    'hC : str_control = "nor";
    default : str_control = " ? ";
  endcase

// Basic console output
initial 
  begin
    $display("time, a (op) b = result, zero, overflow, cout"); 
    $monitor("%d, %d %s %d = %d, %b, %b, %b", 
      $time, a, str_control, b, result, zero, overflow, cout); 
  end

endmodule 
