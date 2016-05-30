// Rui Tu
module (
	clk,
	reset,
	pc_in,
	pc_out
);

	reg [31:0] pc_reg;
	input wire clock;
	input wire [31:0] pc_in;
	output reg [31:0] pc_out;

	always@(posedge clk) begin
		if (reset) begin
			pc_reg = 32'h0;
		end
		pc_out = pc_reg;
	end

endmodule
