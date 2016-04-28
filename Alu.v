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
//
//  If an invalid control signal is sent into our ALU, then the
//  err_invalid_control wire will be raised to high.
  
`timescale 1ns / 1ns;
module alu_32 (
  input wire        clock,
  input wire [31:0]	input_a, input_b,
  input wire [3:0]	control,
  output wire       zero, 
  output reg	      cout, err_overflow, err_invalid_control,
  output reg [31:0]	result
);

// Control parameters
parameter 
  CONTROL_AND = 4'h0, 
  CONTROL_OR  = 4'h1, 
  CONTROL_ADD = 4'h2, 
  CONTROL_ADD_UNSIGNED = 4'h3, 
  CONTROL_SUB = 4'h6,
  CONTROL_SLT = 4'h7,
  CONTROL_NOR = 4'hc;

localparam 
  INVALID = 33'bx;

// Assign our wires for zero and overflow signal 
// based on the results calculated at the start of 
// our clock cycle in the below ALWAYS block.
assign zero     = (result == 32'b0) ? 1'b1 : 1'b0;

// Determine how to set result and cout based on the
// control signal and the 
always @ (posedge clock) 
begin
  err_invalid_control = 0;
  err_overflow = 0;
  case(control)
    CONTROL_AND : 
      {cout,result} = ( input_a & input_b );

    CONTROL_OR  : 
      {cout,result} = ( input_a | input_b );

    CONTROL_ADD : 
    begin
      {cout,result} = ( input_a + input_b );
      if (input_a[31] == input_b[31] && // If both input have same sign
          input_a[31] != result[31])    // and result has different sign
      begin
        err_overflow = 1;
      end
    end

    CONTROL_ADD_UNSIGNED : 
    begin
      {cout,result} = ( input_a + input_b );
      err_overflow = cout;
    end

    CONTROL_SUB : 
      {cout,result} = ( input_a - input_b );

    CONTROL_SLT : 
      {cout,result} = ( input_a < input_b ) ? 32'b1 :  32'b0;

    CONTROL_NOR : 
      {cout,result} = (~(input_a|input_b) );

    default : 
      err_invalid_control = 1'b1; 

  endcase
  
end

endmodule
