
// 2016 Rui Tu
//  mux2 Module
module mux2 (
  input_a,
  input_b,
  
  choose,
  result
);
  parameter width = 32;
  
  input wire [width - 1: 0] input_a;
  input wire [width - 1: 0] input_b;
  input wire choose;

  output reg [width - 1: 0] result;
  
  localparam CHOOSE_A = 1'b0,
             CHOOSE_B = 1'b1;

  always@(*) begin
    case(choose) 
      CHOOSE_A: result <= input_a;
      CHOOSE_B: result <= input_b;
    endcase
  end
endmodule
