// 2016 Ryan Leonard
// ALU Module

module alu_32(
  input [31:0]	a, b,
  input [3:0]	  control,
  output	      cout, zero, overflow,
  output [31:0]	result
);
assign result
  = ( control == 4'h0 ) ? ( a & b )
  : ( control == 4'h1 ) ? ( a | b )
  : ( control == 4'h2 ) ? ( a + b )
  : ( control == 4'h3 ) ? ( a - b )
  : 32'bx;

endmodule
