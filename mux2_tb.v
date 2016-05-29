
// 2016 Rui Tu
//  mux2_tb Module


module mux2_tb;
  reg [31:0]input_a;
  reg [31:0]input_b;
  reg choose;

  wire [31:0]result;

  mux2 dut(
    input_a,
    input_b,
    choose,
    result
  );

  initial begin
    $monitor("A: %h B: %h, CHOOSE: %b, result %h", input_a, input_b, choose, result); 
    input_a = 32'hA; input_b = 32'hB; 
    choose = 2'd0;#5;
    choose = 2'd1;#5;
  end
endmodule

