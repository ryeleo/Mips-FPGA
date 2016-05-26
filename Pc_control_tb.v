module pc_control_test;
	reg	    start;
	reg         reset;
	reg         beq;
	reg         jump;
	reg  [31:0] branch_addr;
	reg  [25:0] jump_addr;
	wire [31:0] new_pc;
	wire	    finish;	
	pc_control_32 pc_control_32_test(
		.start(start),
		.reset(reset),
		.beq(beq),
		.jump(jump),
		.branch_offset(branch_addr),
		.jump_addr(jump_addr),
		.pc(new_pc),
		.finish(finish)
	);

	initial begin
		$dumpfile("pc_control_32_test");
		$monitor("                 beq: %b, branch_addr: %d, jump: %b, jump_addr: %d, new_pc %d", beq, branch_addr, jump, jump_addr, new_pc);
		start <= 1; reset = 1; #2; start <= 0; #2;
		start <= 1; reset = 0; #2; start <= 0; #2;
		$display("After reset====================");
		start <= 1; beq <= 0; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2; start <= 0; #2;
		start <= 1; beq <= 0; jump <= 1; jump_addr = 1000; branch_addr = 2000; #2; start <= 0; #2;
		start <= 1; beq <= 0; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2; start <= 0; #2;
        	start <= 1; beq <= 0; jump <= 1; jump_addr = 1000; branch_addr = 2000; #2; start <= 0; #2;
      		start <= 1; beq <= 0; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2; start <= 0; #2;
      		start <= 1; beq <= 1; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2; start <= 0; #2;
      		start <= 1; beq <= 0; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2; start <= 0; #2;
      		start <= 1; beq <= 1; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2; start <= 0; #2;
		$stop;

	end
endmodule
