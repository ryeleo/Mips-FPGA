// 2016 Ryan Leonard
// ALU + RF Module

`timescale 1ns / 1ns
module alu_rf_32(
  input wire        clock,
  // Register File Knobs
  input wire        write_enabled,
  input wire [4:0]  read_addr_s,
  input wire [4:0]  read_addr_t,
  input wire [4:0]  write_addr,
  // ALU Knob
  input wire [3:0]	control,
  // ALU Outputs
  output wire cout, 
  output wire zero, 
  output wire err_overflow, 
  output wire err_invalid_control
);

// The nets interconnecting our alu and rf
wire [31:0]	regfile_to_alu_s;        
wire [31:0]	regfile_to_alu_t;        
wire [31:0]	alu_result_write_data; // It is a register for laziness

// Connect our ALU to our Register File (rf)
alu_32 alu(
  .clock    (clock),
  .input_a  (regfile_to_alu_s),
  .input_b  (regfile_to_alu_t),
  .result   (alu_result_write_data),
  .control  (control),
  .cout     (cout),
  .zero     (zero),
  .err_overflow (overflow),
  .err_invalid_control  (err_invalid_control)
);

rf_32 regfile(
  .clock          (clock),
  .write_data     (alu_result_write_data),
  .outA           (regfile_to_alu_s), 
  .outB           (regfile_to_alu_t),
  .read_addr_s    (read_addr_s), 
  .read_addr_t    (read_addr_t), 
  .write_addr     (write_addr),
  .write_enabled  (write_enabled)
);

endmodule 
