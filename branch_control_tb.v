// Rui Tu


module branch_control_tb;
reg [1:0] branchop;
reg zero;

wire out;
branch_control dut (branchop, zero, out);

initial
begin
  $monitor("branchop: %b, zero: %b, out: %b", branchop, zero, out);
  branchop = 2'b00; zero = 1'b0; #5; 
  branchop = 2'b10; zero = 1'b0; #5; 
  branchop = 2'b01; zero = 1'b0; #5; 
  branchop = 2'b00; zero = 1'b1; #5; 
  branchop = 2'b11; zero = 1'b0; #5; 
  branchop = 2'b01; zero = 1'b1; #5; 
  branchop = 2'b10; zero = 1'b1; #5; 
  branchop = 2'b11; zero = 1'b1; #5; 
end
endmodule
