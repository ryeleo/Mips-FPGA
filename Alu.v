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
  
localparam 

`timescale 1ns / 1ns
module alu_32(
  parameter add_signal=4'h2,
  input wire        clk,
  input wire        reset,
  input wire [31:0]	s, t,
  input wire [3:0]	control,
  output reg	      cout, zero, overflow,
  output reg [31:0]	result
);

localparam ADD


// Set all of our registers to logical default values
initial 

always @ (posedge clk) 
begin
  if (reset)
  begin
    cout <= 0;
    zero <= 1;
    overflow <= 0;
    result <= 0;
  end
  else 
  case(control)
    4'h0    : {cout,result} <= ( s & t );
    4'h1    : {cout,result} <= ( s | t );
    4'h2    : {cout,result} <= ( s + t );
    4'h6    : {cout,result} <= ( s - t );
    4'h7    : {cout,result} <= ( s < t ) ? 32'b01 :  32'b00;
    4'hC    : {cout,result} <= (~(s|t) );
    default : {cout,result} <= 33'bx; 
  endcase
end

always @ (negedge clk)
begin
  zero      <= (result == 32'b0) ? 1 : 0;
  overflow  <= cout;
end

endmodule
