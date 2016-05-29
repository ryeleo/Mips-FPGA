// 2016 Rui Tu
// PC Control Module
//
// PC Control should happen after ALU, so should be done in the Memory cycle
// or the Writeback cycle.

module pc_control_32(
	input 		              clk,			        // clock
	input                   reset,		            // reset bit
	input wire              beq,	     	        // branch and zero
	input wire	            jump,			        // if jump then 1
	input wire [31:0]       branch_offset,	        // from branch_offset 
	input wire [25:0]       jump_addr,		        // instruction [25:0]
	output reg [31:0]       pc			            // pc out
);

	wire [1: 0]             jump_branch;
	wire [27:0]				extend_jump_address;
	reg  [31:0]             pc_reg;
	reg  [31:0]             temp_pc_reg;

  // Extended jump addr = jump address * 4
	assign extend_jump_address = (jump_addr << 2);

	always @(posedge clk) begin

		if ( reset ) begin
			pc_reg      <= 0;
			temp_pc_reg <= 0;
		end else begin
	
			temp_pc_reg = pc_reg + 4;

      // Jump takes priority over branching
			if ( jump == 1 )
        // Take 4 MSB from PC+4, take the 28 least significant bits from 
				pc_reg = {temp_pc_reg[31:28], extend_jump_address};

			else if ( beq == 1 )
				pc_reg = temp_pc_reg + ( branch_offset << 2 );

			else
				pc_reg = temp_pc_reg;

		end
		
		pc = pc_reg;
	
	end
endmodule
