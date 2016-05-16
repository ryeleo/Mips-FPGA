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
  
module alu_32 (
  start,
  input_a,
  input_b,
  control,
  zero, 
  finished,
  cout,
  err_overflow,
  err_invalid_control,
  result
);

input wire        start;
input wire [31:0]	input_a;
input wire [31:0]	input_b;
input wire [4:0]	control;
output wire       zero;
output reg        finished;
output reg	      cout;
output reg	      err_overflow;
output reg	      err_invalid_control;
output reg [31:0]	result;

// Control parameters
parameter 
  CONTROL_AND = 5'h0, 
  CONTROL_OR  = 5'h1, 
  CONTROL_ADD = 5'h2, 
  CONTROL_ADD_UNSIGNED = 5'h3, 
  CONTROL_SUB = 5'h6,
  CONTROL_SLT = 5'h7,
  CONTROL_NOR = 5'hc;

localparam 
  INVALID = 33'bx;

// An intermittent value storage register
reg [31:0] tmp;

// Assign our wires for zero and overflow signal 
// based on the results calculated at the start of 
// our clock cycle in the below ALWAYS block.
assign zero = (result == 32'b0) ? 1'b1 : 1'b0;

task addition_signed(
  input [31:0] input_a,
  input [31:0] input_b,
  output [31:0] result);
begin
  {cout,result} = ( input_a + input_b );
  if (input_a[31] == input_b[31] && // If both input have same sign
      input_a[31] != result[31])    // and result has different sign
    err_overflow = 1;
end
endtask

task addition_unsigned_global();
begin
  {cout,result} = ( input_a + input_b );
  err_overflow = cout;
end
endtask

// Determine how to set result and cout based on the
// control signal
always @ (posedge start) 
begin // BEG main
  finished = 0;
  err_invalid_control = 0;
  err_overflow = 0;
  case(control)
    CONTROL_AND: begin
      {cout,result} = ( input_a & input_b );
      finished = 1;
    end

    CONTROL_OR: begin
      {cout,result} = ( input_a | input_b );
      finished = 1;
    end

    CONTROL_ADD: begin
      addition_signed(input_a, input_b, result);
      finished = 1;
    end

    CONTROL_ADD_UNSIGNED: begin
      addition_unsigned_global();
      finished = 1;
    end

    CONTROL_SUB: begin
      tmp = -input_b; 
      addition_signed(input_a, tmp, result);
      if (tmp[31] == input_b[31]) 
      begin
        err_overflow = 1;
        finished = 0;
      end
      else
      begin
        finished = 1;
      end
    end

    CONTROL_SLT: begin
      {cout,result} = ( input_a < input_b ) ? 32'b1 :  32'b0;
      finished = 1;
    end

    CONTROL_NOR: begin
      {cout,result} = (~(input_a|input_b) );
      finished = 1;
    end

    default: begin
      err_invalid_control = 1'b1; 
      finished = 0;
    end
  endcase
  
end // END main

endmodule
