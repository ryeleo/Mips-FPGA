// 2016 Ryan and Rui
// We got rid of the shift right 2 in the jump mux for JAL

module cpu_test;

reg clock;
reg running_switch;
wire [31:0] reg_t0;
cpu dut(clock, running_switch, reg_t0);

localparam 
            t0 = 8,
            t1 = 9,
            t2 = 10;

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

// Test logic
integer i;
initial begin
  $display("=====\nWaiting for instruction to load");
  running_switch = 0;
  #1000;
  $display("=====\nRunning instructions!");
  running_switch = 1;
  #100000; // 1000 cycles
  // 3 Make assertions
  assert_equal(dut.regfile.register_file[t0], 144);
  assert_equal(reg_t0, 144);
end
endmodule
