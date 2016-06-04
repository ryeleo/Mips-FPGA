// 2016 Rui Tu
//  adder Module
// we don't handle overflows in anyform
// THe default will return the most recent choice
module mux3 (
  input_a,
  input_b,
  input_c,
  
  choose,
  result
);
  parameter width = 32;
  
  input wire [width - 1: 0] input_a;
  input wire [width - 1: 0] input_b;
  input wire [width - 1: 0] input_c;
  input wire [1:0] choose;

  output reg [width - 1: 0] result;
  
  localparam CHOOSE_A = 2'b00,
             CHOOSE_B = 2'b01,
             CHOOSE_C = 2'b10;

  always@(*) begin
    case(choose) 
      CHOOSE_A: result <= input_a;
      CHOOSE_B: result <= input_b;
      CHOOSE_C: result <= input_c;
      // default gets the result from the most recent value
      default:  result <= 1'bx;
    endcase
  end
endmodule
