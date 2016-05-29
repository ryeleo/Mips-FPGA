// 2016 Rui Tu
//  adder Module
// we don't handle overflows in anyform

module adder (
  input_a,
  input_b,
  result
);
  parameter width = 32;
  
  input wire [width - 1: 0] input_a;
  input wire [width - 1: 0] input_b;

  output reg [width - 1: 0] result;


  always@(*) begin
    result <= input_a + input_b;
  end


endmodule
