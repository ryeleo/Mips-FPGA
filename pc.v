// Rui Tu
module pc(
	clock,
	reset,
	pc_in,
	pc_out
);

  
	reg [31:0] pc_reg;

	input wire clock;
	input wire reset;
	input wire [31:0] pc_in;
	output reg [31:0] pc_out;


  // we assume the output of the jumpmux will be
  // stable until the start of the posedge of the next
  // clock cycle
	always@(negedge clock) begin
		if (reset)
    begin
			pc_reg = 32'h0;
    end
		else
    begin
			pc_reg = pc_in;
    end
		
		pc_out = pc_reg;
	end

endmodule
