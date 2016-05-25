module pc_control_test;
	reg         clk;
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
		.clk(clk),
		.reset(reset),
		.beq(beq),
		.jump(jump),
		.branch_offset(branch_addr),
		.jump_addr(jump_addr),
		.pc(new_pc),
		.finish(finish)
	);

	initial begin
		clk   = 0;
	end

	always begin 
		clk = !clk; #1; 
	end
	initial begin
		$dumpfile("pc_control_32_test");
		$monitor("                 clk: %b, beq: %b, branch_addr: %d, jump: %b, jump_addr: %d, new_pc %d", clk, beq, branch_addr, jump, jump_addr, new_pc);
		reset = 1; #1;
		reset = 0; #1;
		$display("After reset====================");
		beq <= 0; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2;
		beq <= 0; jump <= 1; jump_addr = 1000; branch_addr = 2000; #2;
		beq <= 0; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2;
        	beq <= 0; jump <= 1; jump_addr = 1000; branch_addr = 2000; #2;
      		beq <= 0; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2;
      		beq <= 1; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2;
      		beq <= 0; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2;
      		beq <= 1; jump <= 0; jump_addr = 1000; branch_addr = 2000; #2;
		$stop;

	end
endmodule
