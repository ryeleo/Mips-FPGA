

module sign_extend_test;
reg [15:0] in;
wire [31:0] out;
sign_extend_32 dut (in, out);

initial
begin
  $monitor("input: %b, output: %b", in, out);
  in = 16'hFFFF;
  #5; 
  in = 16'h0000;
  #5; 
  in = 16'h8000; 
  #5; 
  in = 16'h4000;
  #5; 
  in = 16'h7FFF;
  #5; 
end
endmodule
