module pc_control_test;
	reg         clk;
	reg         reset;
	reg         beq;
	reg         jump;
	reg  [31:0] branch_addr;
	reg  [25:0] jump_addr;
	wire [31:0] new_pc;
	
	pc_control_32 pc_control_32_test(
		.clk(clk),
		.reset(reset),
		.beq(beq),
		.jump(jump),
		.branch_addr(branch_addr),
		.jump_addr(jump_addr),
		.pc(new_pc)
	);

	initial begin
		clk   = 0;
	end

	always begin 
		clk = !clk; #1; 
	end
	initial begin
		$dumpfile("pc_control_32_test");
		$dumpvar(0, pc_control_32_test);
		$monitor("                 clk: %b, beq: %b, branch_addr: %d, jump: %b, jump_addr: %d, new_pc %d", clk, beq, branch_addr, jump, jump_addr, new_pc);
		reset = 1; #2;
		reset = 0; #2;
		$display("After reset====================");
		beq <= 0; jump <= 0; jump_addr = 1000; branch_addr = 2000; #4;
		beq <= 1; jump <= 0; jump_addr = 1000; branch_addr = 2000; #4;
		beq <= 0; jump <= 0; jump_addr = 1000; branch_addr = 2000; #4;
		$stop;

	end
endmodule
