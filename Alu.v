// 2016 Ryan Leonard
// ALU Module
//
// ALU Execution begins on posedge of clock.
//
//  Table representing the default control signals enabled by 
//  this ALU
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
  
`timescale 1ns / 1ns;
module alu_32 (
  input wire        clk,
  input wire        reset,
  input wire [31:0]	s, t,
  input wire [3:0]	control,
  output wire       zero, overflow,
  output reg	      cout, 
  output reg [31:0]	result
);

// Control parameters
parameter 
  CONTROL_AND = 4'h0, 
  CONTROL_OR  = 4'h1, 
  CONTROL_ADD = 4'h2, 
  CONTROL_SUB = 4'h6,
  CONTROL_SLT = 4'h7,
  CONTROL_NOR = 4'hc;

localparam 
  INVALID = 33'bx;

// Assign our wires for zero and overflow signal 
// based on the results calculated at the start of 
// our clock cycle in the below ALWAYS block.
assign zero     = (result == 32'b0) ? 1'b1 : 1'b0;
assign overflow = cout;

// Determine how to set result and cout based on the
// control signal and the 
always @ (posedge clk) 
begin
  if (reset)
  begin
    cout <= INVALID;
    result <= INVALID;
  end
  else 
  case(control)
    CONTROL_AND : {cout,result} <= ( s & t );
    CONTROL_OR  : {cout,result} <= ( s | t );
    CONTROL_ADD : {cout,result} <= ( s + t );
    CONTROL_SUB : {cout,result} <= ( s - t );
    CONTROL_SLT : {cout,result} <= ( s < t ) ? 32'b1 :  32'b0;
    CONTROL_NOR : {cout,result} <= (~(s|t) );
    default : {cout,result} <= INVALID; 
  endcase
end

endmodule
