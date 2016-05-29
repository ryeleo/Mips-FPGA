// 2016 Rui Tu
//  adder_tb Module
// we don't handle overflows in anyform


module adder_tb;
  reg [31:0]input_a;
  reg [31:0]input_b;

  wire [31:0]result;

  localparam width = 32;
  adder #(.width(width)) dut(
    input_a,
    input_b,
    result
  );

  initial begin
    $monitor("%d + %d = %d", input_a, input_b, result); 
    input_a = 32'd0; input_b = 32'h0; #5;
    input_a = 32'd1000000; input_b = 32'd99999999; #5;
    input_a = 32'd4; input_b = 32'd10000000; #5;
  end




endmodule
