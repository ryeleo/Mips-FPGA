// 2016 Ryan Leonard
// ALU Module
// This module currently does not have support for a clock input thus is 
// asynchronous and strictly combinational.
//
//  Table representing the functionality enabled by this ALU
//  -----------------------
//  | ALU |     |         |
//  | Bits| Hex | Function|  
//  -----------------------
//  |0000 | 'h0 | AND     | 
//  |0001 | 'h1 | OR      | 
//  |0010 | 'h2 | ADD     | 
//  |0110 | 'h6 | SUB     | 
//  |0111 | 'h7 | SLT     | 
//  |1100 | 'hC | NOR     | 
//  -----------------------
  

module alu_32(
  input         clk,
  input [31:0]	s, t,
  input [3:0]	  control,
  output	      cout, zero, overflow,
  output [31:0]	result
);

// Using continuous assignment
assign overflow = cout;

assign zero = (result == 32'b0) ? 1 : 0;

assign {cout, result}
  = ( control == 4'h0 ) ?   ( s & t )
  : ( control == 4'h1 ) ?   ( s | t )
  : ( control == 4'h2 ) ?   ( s + t )
  : ( control == 4'h6 ) ?   ( s - t )
  : ( control == 4'h7 ) ?   ( s < t ) ? 32'b1 :  32'b0
  : ( control == 4'hC ) ?   (~(s|t) )
  : 32'bx;

endmodule
