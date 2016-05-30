module pc_test;
	reg reset;
	reg clk;
	reg [31:0]  pc_in;
	wire [31:0] pc_out;

	pc dut (clk, reset, pc_in, pc_out);

	initial begin
		clk    = 0;
		reset  = 0;
	end

	always
		#5 clk = !clk;

	initial
	begin

	
	  $monitor("clk: %b, reset: %b, pc_in: %h, pc_out: %h", clk, reset, pc_in, pc_out);
	  reset = 1; #10;
	  reset = 0; #10;
	  pc_in = 32'haaaaaaaa; #10; 
	  pc_in = 32'hbbbbbbbb; #10; 
	  pc_in = 32'hcccccccc; #10; 
	  pc_in = 32'hdddddddd; #10; 
	  pc_in = 32'heeeeeeee; #10; 
	  pc_in = 32'hffffffff; #10; 
	end
endmodule
