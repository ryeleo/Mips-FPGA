// 2016 Rui Tu
//  control Module
// combinational logic
/* information from http://www.cs.columbia.edu/~martha/courses/3827/sp11/slides/9_singleCycleMIPS.pdf 
	http://www.eng.ucy.ac.cy/mmichael/courses/ECE314/LabsNotes/02/MIPS_Instruction_Coding_With_Hex.pdf
*/
module control_32(
	input  wire [5:0] opcode,

	output reg 	[1:0] alu_op,
	output reg        mem_toreg,
	output reg 		  mem_write,
	output reg 		  mem_read,
	output reg 		  branch,
	output reg 		  alu_src,
	output reg 		  reg_dst,
	output reg 		  reg_write,
	output reg 		  jump,

	output reg        err_illegal_opcode
);
			    /* possible opcodes */
	parameter   r_type      = 6'b0000_00,
			    lw		    = 6'b1000_11,
			    sw 		    = 6'b1010_11,
			    beq 	    = 6'b0001_00,
			    addi	    = 6'b0010_00,
			    j    	    = 6'b0000_10,

			    on  	    = 1'b1,
			    off 	    = 1'b0,

				/* 3 difference aluop */
			    mem_alu     = 2'b00,
			    beq_alu	    = 2'b01,
			    artih_alu   = 2'b10,
			    jump_code	= 2'b00;
	
	always @(*) begin
		case (opcode)
			
			r_type: begin
				mem_toreg          <= off;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= off;
				reg_dst            <= on;
				reg_write          <= on;
				jump               <= off;

				alu_op             <= artih_alu;
				err_illegal_opcode <= off;

			end

			lw: begin
				mem_toreg          <= on;
				mem_write          <= off;
				mem_read           <= on;
				branch             <= off;
				alu_src            <= on;
				reg_dst            <= off;
				reg_write          <= on;
				jump               <= off;
				
				alu_op             <= mem_alu;
				err_illegal_opcode <= off;

			end

			sw: begin
				mem_toreg          <= off;
				mem_write          <= on;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= on;
				reg_dst            <= off;
				reg_write          <= off;
				jump               <= off;

				alu_op     		   <= mem_alu;
				err_illegal_opcode <= off;

			end

			beq: begin
				mem_toreg          <= off;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= on;
				alu_src            <= off;
				reg_dst            <= off;
				reg_write          <= off;
				jump               <= off;

				alu_op             <= beq_alu;
				err_illegal_opcode <= off;

			end

			addi: begin
				mem_toreg          <= off;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= on;
				reg_dst            <= off;
				reg_write          <= on;
				jump               <= off;

				alu_op             <= mem_alu;
				err_illegal_opcode <= off;

			end

			j: begin
				mem_toreg          <= off;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= off;
				reg_dst            <= off;
				reg_write          <= off;
				jump               <= on;

				jump 	           <= on;
				alu_op             <= jump_code;
				err_illegal_opcode <= off;

			end

			default: begin 
				mem_toreg          <= off;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= off;
				reg_dst            <= off;
				reg_write          <= off;
				jump               <= off;

				alu_op             <= 2'b00;
				err_illegal_opcode <= on;
				$display("cannot decode instruction %b\n", opcode);
			end
		endcase
	end
endmodule
