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
  input_a,
  input_b,
  control,
  zero, 
  cout,
  err_overflow,
  err_invalid_control,
  result
);

// Control parameters
parameter 
  CONTROL_SIGNAL_SIZE = 4, // # of bits in control signal
  CONTROL_AND = 5'h0, 
  CONTROL_OR  = 5'h1, 
  CONTROL_ADD = 5'h2, 
  CONTROL_ADD_UNSIGNED = 5'h3, 
  CONTROL_SUB = 5'h6,
  CONTROL_SLT = 5'h7,
  CONTROL_NOR = 5'hc,
  OFF = 1'b0,
  ON = 1'b1;

localparam 
  INVALID = 33'bx,
  WORD_SIZE = 32,
  MSB = WORD_SIZE-1; // Most signficant bit

input wire [WORD_SIZE-1:0]	input_a;
input wire [WORD_SIZE-1:0]	input_b;
input wire [CONTROL_SIGNAL_SIZE-1:0]	control;
output wire       zero;
output reg	      cout;
output reg	      err_overflow;
output reg	      err_invalid_control;
output reg [WORD_SIZE-1:0]	result;

// An intermittent value storage register
reg [WORD_SIZE-1:0] tmp;

// Assign our wires for zero and overflow signal 
// based on the results calculated at the start of 
// our clock cycle in the below ALWAYS block.
assign zero = (result == 32'b0) ? ON : OFF;

task addition_signed(
  input [WORD_SIZE-1:0] input_a,
  input [WORD_SIZE-1:0] input_b,
  output [WORD_SIZE-1:0] result);
begin
  {cout,result} = ( input_a + input_b );
  if (input_a[MSB] == input_b[MSB] && // If both input have same sign
      input_a[MSB] != result[MSB])    // and result has different sign
    err_overflow <= ON;
end
endtask

// Determine how to set result and cout based on the
// control signal
always @ (*)
begin // BEG main

  case(control)
    CONTROL_AND: begin
      err_invalid_control <= OFF;
      err_overflow <= OFF;
      {cout,result} <= ( input_a & input_b );
    end

    CONTROL_OR: begin
      err_invalid_control <= OFF;
      err_overflow <= OFF;
      {cout,result} <= ( input_a | input_b );
    end

    CONTROL_ADD: begin
      err_invalid_control <= OFF;
      {cout,result} = ( input_a + input_b );
      if (input_a[MSB] == input_b[MSB] && // If both input have same sign
          input_a[MSB] != result[MSB])    // and result has different sign
        err_overflow <= ON;
      else 
        err_overflow <= OFF;
    end

    CONTROL_ADD_UNSIGNED: begin
      err_invalid_control <= OFF;
      {cout,result} <= ( input_a + input_b );
      err_overflow <= cout;
    end

    // TODO: Test this bad boy -- not needed for fibonacci
    CONTROL_SUB: begin
      err_invalid_control <= OFF;
      {cout,result} = ( input_a - input_b );
      if (input_a[MSB] == 0 && input_b[MSB] == 1 && result[MSB] == 1 ||
          input_a[MSB] == 1 && input_b[MSB] == 0 && result[MSB] == 0)
        err_overflow <= ON;
      else 
        err_overflow <= OFF;
    end

    CONTROL_SLT: begin
      err_invalid_control <= OFF;
      err_overflow <= OFF;
      {cout,result} <= ( input_a < input_b ) ? ON :  OFF;
    end

    CONTROL_NOR: begin
      err_invalid_control <= OFF;
      err_overflow <= OFF;
      cout <= OFF;
      result <= (~(input_a|input_b) );
    end

    default: begin
      err_invalid_control <= ON; 
      err_overflow <= OFF;
      $display("cannot decode control signal %b: ", control);
    end
  endcase
end // END main

endmodule
