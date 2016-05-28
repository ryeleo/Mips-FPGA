// 2016 Rui Tu
//  mux3_tb Module


module mux3_tb;
  reg [31:0]input_a;
  reg [31:0]input_b;
  reg [31:0]input_c;
  reg [1:0]choose;

  wire [31:0]result;

  mux3  dut(
    input_a,
    input_b,
    input_c,
    choose,
    result
  );

  initial begin
    $monitor("A: %h B: %h C: %h, CHOOSE: %b, result %h", input_a, input_b, input_c, choose, result); 
    input_a = 32'hA; input_b = 32'hB; input_c = 32'hC; 
    choose = 2'd0;#5;
    choose = 2'd1;#5;
    choose = 2'd2;#5;
    choose = 2'd3;#5;
  end




endmodule

