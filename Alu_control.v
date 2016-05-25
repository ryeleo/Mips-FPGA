module alu_control_32 (
	input  wire[5:0] func,
	input  wire[1:0] alu_op,
	input  wire	 start,
	
	output reg [3:0] alu_control,
	output reg 	 err_illegal_func_code,
	output reg 	 err_illegal_alu_op
	output reg 	 finished
);
	reg [3:0] 	 temp_op;

	parameter   add_func       = 6'b10_0000,
    		    sub_func       = 6'b10_0010,
		    or_func        = 6'b10_0101,
		    and_func       = 6'b10_0100,
		    slt_func       = 6'b101_010,

		    mem_aluop      = 2'b00,
		    beq_aluop	   = 2'b01,
		    artih_aluop    = 2'b10,
		    default_aluop  = 2'b00,

		    add_op         = 4'b0010,
		    sub_op         = 4'b0110,
		    and_op         = 4'b0000,
		    or_op          = 4'b0001,
		    slt_op         = 4'b0111,
		    default_op     = 4'b0000;


	always @(posedge start) begin
		finish	  			      = 1;
		case(func)	
			add_func: begin
				temp_op               = add_op;
				err_illegal_func_code = 0;
			end
			sub_func: begin
				temp_op               = sub_op;
				err_illegal_func_code = 0;
			end
			or_func:  begin
				temp_op               = or_op;
				err_illegal_func_code = 0;
			end
			and_func: begin
				temp_op               = and_op;
				err_illegal_func_code = 0;
			end
			slt_func: begin
				temp_op               = slt_op;
				err_illegal_func_code = 0;
			end
			default: begin
				temp_op               = default_op;
				err_illegal_func_code = 1;
				$display("unimplement function code: %b\n", func);
			end
		endcase

		case(alu_op)
			mem_aluop: begin
				alu_control 	      = add_op;
				err_illegal_alu_op    = 0;
			end
			beq_aluop: begin
			  	alu_control           =  sub_op;
				err_illegal_alu_op    =  0;	
			end
			artih_aluop: begin
				alu_control           =  temp_op;
				err_illegal_alu_op    =  0;
			end
			default: begin   
				alu_control           =  default_op;
				err_illegal_alu_op    =  1;
				$display("unsupported ALUop: %b\n", alu_op);
			end
	
		endcase
	
end
endmodule            
