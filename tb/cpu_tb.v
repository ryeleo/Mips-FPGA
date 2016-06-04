// 2016 Ryan and Rui

// We got rid of the shift right 2 in the jump mux for JAL

module cpu_test;

reg clock;
reg reset;
cpu dut(clock, reset);

localparam [31:0] fib_instr [0:43] = '{
          32'h201d0100,
          32'h2010000c,
          32'hafb00000,
          32'h23bdfffc,
          32'h0c000009,
          32'h23bd0004,
          32'h8fb10000,
          32'hac110024,
          32'h0800002b,
          32'hafbf0000,
          32'h23bdfffc,
          32'hafbe0000,
          32'h23bdfffc,
          32'h23be000c,
          32'h8fc80000,
          32'h20090002,
          32'h00005820,
          32'h0128582a,
          32'h15600002,
          32'h20080001,
          32'h08000023,
          32'h2108ffff,
          32'hafa80000,
          32'h23bdfffc,
          32'h0c000009,
          32'h8fc80000,
          32'h2108fffe,
          32'hafa80000,
          32'h23bdfffc,
          32'h0c000009,
          32'h23bd0004,
          32'h8fa80000,
          32'h23bd0004,
          32'h8fa90000,
          32'h01094020,
          32'h23bd0004,
          32'h8fbe0000,
          32'h23bd0004,
          32'h8fbf0000,
          32'h23bd0004,
          32'hafa80000,
          32'h23bdfffc,
          32'h03e00008,
          32'h20000000 };
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
            lw_t0_zero_4     = 32'h8C080004,


            // Begin branch assm:
            // https://github.com/jmahler/mips-cpu/blob/master/test/t0005-branch.asm
            addi_t0_zero_1   = 32'h2008_0001,
            addi_t1_zero_2   = 32'h2009_0002,
            addi_t0_t0_1     = 32'h2108_0001,
            beq_t0_t1_skip1  = 32'h1109_0002, // jump forward 2
            addi_t0_t0_255   = 32'h2108_00FF,
            addi_t1_t1_255   = 32'h2129_00FF,
            add_t0_t0_t1     = 32'h0109_4020,
            add_t1_t0_t1     = 32'h0109_4820,
            bne_t0_t1_skip2  = 32'h1509_0002, // jump forward 2
            addi_t0_t0_4095  = 32'h2108_0FFF,
            addi_t1_t1_4095  = 32'h2129_0FFF,

            // jump Testing
            //
            // 0: addi t0, 0, 255
            // 4: j 36
            // ...
            // 36: addi t1, 0, 255
            // 40: jal 80
            // 44: addi t0, 0, 4095
            // 48: j 88
            // ...
            // 80: add t2, t1, t0
            // 84: jr $31
            // 88: DONE
            addi_t0_zero_255      = 32'h2008_00FF,
            j_36                  = 32'h0800_0024,
            addi_t1_zero_255      = 32'h2009_00FF,
            jal_80                = 32'h0C00_0050,
            addi_t0_zero_4095     = 32'h2008_0FFF,
            j_88                  = 32'h0800_0058,
            //add_t2_t0_t1     = 32'h01095020,
            jr_ra                 = 32'h03E0_0008;


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
integer i;
initial begin
  /*
  $display("TEST SUITE 1: ");
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



  #100;
  $display("Initializing instruction memory");
  load_instr(0, addi_t0_zero_1);
  load_instr(4, addi_t1_zero_2);
  load_instr(8, addi_t0_t0_1);
  load_instr(12,beq_t0_t1_skip1);
  load_instr(16,addi_t0_t0_255);
  load_instr(20,addi_t1_t1_255);
  load_instr(24,add_t0_t0_t1);
  load_instr(28,add_t1_t0_t1);
  load_instr(32,bne_t0_t1_skip2);
  load_instr(36,addi_t0_t0_4095);
  load_instr(40,addi_t1_t1_4095);

  $display("Resetting the program counter to 0th instruction");
  reset = 1;
  #20

  $display("Running instructions!");
  reset = 0;
  #200;
  assert_equal(dut.regfile.register_file[t0], 4);
  assert_equal(dut.regfile.register_file[t1], 6);

  #100;
*/
  /*
  $display("Initializing instruction memory");
  load_instr(0, addi_t0_zero_255 );
  load_instr(4, j_36             );
  load_instr(36, addi_t1_zero_255);
  load_instr(40,jal_80           );
  load_instr(44,addi_t0_zero_4095);
  load_instr(48,j_88             );
  load_instr(80,add_t2_t0_t1     );
  load_instr(84,jr_ra            );
  $display("Resetting the program counter to 0th instruction");
  reset = 1;
  #20

  $display("Running instructions!");
  reset = 0;
  #200;
  assert_equal(dut.regfile.register_file[t0], 4095);
  assert_equal(dut.regfile.register_file[t1], 255);
  assert_equal(dut.regfile.register_file[t2], 510);
*/


  $display("Running Fibbonacci! Fib(4)");
  for (i = 0; i < 44; i = i + 1) begin
      load_instr(i*4, fib_instr[i]);
  end

  // 2 reset the CPU
  $display("Resetting the program counter to 0th instruction");
  reset = 1;
  #20

  $display("Running instructions!");
  reset = 0;
  #1000000; // 1000 clock cycles

  // 3 Make assertions
  assert_equal(dut.regfile.register_file[t0], 144);

end
endmodule
