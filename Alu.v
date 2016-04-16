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
  output reg	      cout, zero, overflow,
  output reg [31:0]	result
);

always @ (posedge clk) 
  begin
    case(control)
      4'h0    : {cout,result} = ( s & t );
      4'h1    : {cout,result} = ( s | t );
      4'h2    : {cout,result} = ( s + t );
      4'h6    : {cout,result} = ( s - t );
      4'h7    : {cout,result} = ( s < t ) ? 32'b1 :  32'b0;
      4'hC    : {cout,result} = (~(s|t) );
      default : {cout,result} = 33'bx;
    endcase
    zero = (result == 32'b0) ? 1 : 0;
    overflow = cout;
  end
endmodule
