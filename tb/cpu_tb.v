// 2016 Ryan and Rui
//

module cpu_test;

reg clock;
reg reset;
cpu dut(clock, reset);

// Test input instructions
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
    if (expected === observed)
      $display("(%d)SUCCESS:            %p == %p", $time, expected, observed);
    else
      $display("(%d)ASSERTION EQUAL FAIL: %p != %p", $time, expected, observed);
  end
endtask

task load_instr (
  input [31:0] addr, 
  input [31:0] instruction
);
  dut.instruction_memory.data[addr >> 2] = instruction;
endtask

// Test logic
initial begin
  $display("Initializing instruction memory");
  load_instr(0, addi_t0_zero_6);
  load_instr(4, addi_t1_zero_11);
  load_instr(8, addi_t0_t0_10);
  load_instr(12, addi_t2_t1_240);
  load_instr(16, add_t2_t0_t1);
  load_instr(20, addi_t0_zero_5);
  load_instr(24, addi_t1_zero_9);
  load_instr(28, sw_t0_zero_0);
  load_instr(32, sw_t1_zero_4);
  load_instr(36, lw_t0_zero_4);
  // Don't need these since we are adding to the zero register
  //dut.regfile.register_file[8] = 2;
  //dut.regfile.register_file[9] = 3;

  $display("Resetting the program counter to 0th instruction");
  reset = 1;
  #20

  $display("Running instructions!");
  reset = 0;

  assert_equal(dut.regfile.register_file[t0], 6);
  #10;
  $display("PC: ");
  assert_equal(dut.pc.pc_reg, 4);

  assert_equal(dut.regfile.register_file[t1], 11);
  #10;
  assert_equal(dut.regfile.register_file[t0], 16);
  #10;
  assert_equal(dut.regfile.register_file[t2], 251);
  #10;
  assert_equal(dut.regfile.register_file[t2], 27);
  #10;

  $display("We started the second iteration");
  assert_equal(dut.regfile.register_file[t0], 5);
  #10;
  assert_equal(dut.regfile.register_file[t1], 9);
  #10;
  assert_equal(dut.data_memory.data[0], 5);
  #10;
  assert_equal(dut.data_memory.data[1], 9); // Store into the '4th' byte address which is our 1st word address
  #10;
  assert_equal(dut.regfile.register_file[t0], 9);
  #10;
end
          /*

           addi_t0_zero_5   = 32'h20080005,
           addi_t1_zero_9   = 32'h20090009,
           sw_t0_zero_0     = 32'hAC080000,
           sw_t1_zero_4     = 32'hAC090004,
           lw_t0_zero_4     = 32'h8C080004;

          */


endmodule
