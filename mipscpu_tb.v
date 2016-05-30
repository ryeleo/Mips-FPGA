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
localparam 
           t0 = 8,
           t1 = 9,
           t2 = 10,
           addi_t0_zero_6   = 32'h20080006,
					 addi_t1_zero_11  = 32'h2009000B,
           addi_t0_t0_10    = 32'h2108000A,
           addi_t2_t1_240   = 32'h212A00F0,
           add_t2_t0_t1     = 32'h01095020,
           
           addi_t0_zero_5   = 32'h20080005,
           addi_t1_zero_9   = 32'h20090009,
           sw_t0_zero_0     = 32'hAC080000,
           sw_t1_zero_4     = 32'hAC090004,
           lw_t0_zero_4     = 32'h8C080004;
  /*
  * addi $t0, $zero, 5
    addi $t1, $zero, 9

    sw $t0, 0($zero)	# 5
    sw $t1, 4($zero)	# 9

    lw $t0, 4($zero)	# 9
    add $t0, $t0, $t1	# 9 + 9 = 18
   *
   */

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

task assert_equal(
  input [31:0] expected,
  input [31:0] observed);
  begin
    if (expected != observed)
      $display("ASSERTION EQUAL FAIL: %p != %p", expected, observed);
    else
      $display("SUCCESS:            %p == %p", expected, observed);
  end
endtask


// Test logic
initial begin
 // $display("Initializing registers");
  // Don't need these since we are adding to the zero register
  //dut.regfile.register_file[8] = 2;
  //dut.regfile.register_file[9] = 3;
  #10;

  instruction = addi_t0_zero_6; 
  #10;
  assert_equal(dut.regfile.register_file[t0], 6);

  instruction = addi_t1_zero_11; 
  #10;
  assert_equal(dut.regfile.register_file[t1], 11);

  instruction = addi_t0_t0_10; 
  #10;
  assert_equal(dut.regfile.register_file[t0], 16);

  instruction = addi_t2_t1_240; 
  #10;
  assert_equal(dut.regfile.register_file[t2], 251);

  instruction = add_t2_t0_t1; 
  #10;
  assert_equal(dut.regfile.register_file[t2], 27);

  $display("We started the second iteration");

  instruction = addi_t0_zero_5; 
  #10;
  assert_equal(dut.regfile.register_file[t0], 5);

  instruction = addi_t1_zero_9; 
  #10;
  assert_equal(dut.regfile.register_file[t1], 9);

  instruction = sw_t0_zero_0;  // storing t0 to memory[0]
  #10;
  assert_equal(dut.data_memory.data[0], 5);

  instruction = sw_t1_zero_4; // storing t1 to memory[4]
  #10;
  assert_equal(dut.data_memory.data[4], 9);
  
  instruction = lw_t0_zero_4;  // loading memory[4] into t0
  #10;
  assert_equal(dut.regfile.register_file[t0], 9);
end
          /*

           addi_t0_zero_5   = 32'h20080005,
           addi_t1_zero_9   = 32'h20090009,
           sw_t0_zero_0     = 32'hAC080000,
           sw_t1_zero_4     = 32'hAC090004,
           lw_t0_zero_4     = 32'h8C080004;

          */


endmodule
