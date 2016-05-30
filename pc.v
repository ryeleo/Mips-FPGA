// Rui Tu
module pc(
	clk,
	reset,
	pc_in,
	pc_out
);

	reg [31:0] pc_reg;
	input wire clk;
	input wire reset;
	input wire [31:0] pc_in;
	output reg [31:0] pc_out;

	always@(posedge clk) begin
		if (reset)
			pc_reg = 32'h0;
		else
			pc_reg = pc_in;
		
		pc_out = pc_reg;
	end

endmodule
