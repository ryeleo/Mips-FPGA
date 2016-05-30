// 2016 Ryan and Rui
//
// TODO: Binary input tests for mips cpu

module mips_cpu_test;

reg clock;
reg [31:0] instruction;
mips_cpu dut(clock, instruction);

// Test inputs
/*
addi $t0, $zero, 6  # (0110)
addi $t1, $zero, 11 # (1011)
*/
localparam addi_t0zero6  = 32'h20080006,
					 addi_t1zero11 = 32'h2009000B;

// Clock Generator (#10 period)
initial 
begin
  clock = 1; 
  #5;
  forever
  begin
    clock = ~clock; 
    #5;
  end
end


// Test logic
initial begin
 // $display("Initializing registers");
  // Don't need these since we are adding to the zero register
  //dut.regfile.register_file[8] = 2;
  //dut.regfile.register_file[9] = 3;
  #10;
  $display("T0 content: %h", dut.regfile.register_file[8]);

  instruction = addi_t0zero6; 
  #10;
  $display("T0 content: %h", dut.regfile.register_file[8]);
  if (dut.regfile.register_file[9] != 'h6)
    $display("FAILED");

  instruction = addi_t1zero11; 
  #10;
  $display("T1 content: %h", dut.regfile.register_file[9]);
  if (dut.regfile.register_file[9] != 'hb)
    $display("FAILED");

end




endmodule
