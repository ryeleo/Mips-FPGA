// 2016 Ryan Leonard
// ALU + RF  Module Testbench

`timescale 1ns / 1ns
module test_alu_rf_32;

// The reg/nets we will maniupulate/monitor for testing
// Essentially we are controlling which instruction is being
// executed directly instead of the instruction decoder and 
// resultant instruction register telling us what to do.
reg         clock;    //clock
reg [4:0]   rs;       //input
reg [4:0]   rt;       //input
reg [4:0]   rd;       //input
reg [3:0]	  control;  //input
reg         we;       //input
wire	      cout;     //out
wire	      zero;     //out
wire	      overflow; //out
wire	      err_invalid_control; //out

// Connect our ALU to our Register File (rf)
alu_rf_32 dut(
  .clock          (clock),
  .read_addr_s    (rs),     // knob
  .read_addr_t    (rt),     // knob
  .write_addr     (rd),     // knob
  .write_enabled  (we),     // knob
  .control        (control),// knob
  .cout           (cout),   // monitor
  .zero           (zero),   // monitor
  .err_overflow   (overflow),// monitor
  .err_invalid_control   (err_invalid_control)// monitor
);


// Clock Generator
initial 
begin
  clock = 1;
  forever
    #5 clock = !clock;
end

task no_operation();
begin
  rs=5'd0; 
  rt=5'd0; 
  we=1'b0; 
  control=dut.alu.CONTROL_AND; 
  rd=5'd0; 
end
endtask

// Test stimulus
//  Our test stimulus is broken down into three sections:
//    1: Register Initialization
//    2: Testing basic operations of ALU (uses RegisterFile[20-30])
//    3: Testing a toy program
//    4: Testing a toy program filling the pipeline
//
//  Nuances:
//      First detail we run into is that we are using a pipelined
//    structure and as a result to perform ONE computation we need 
//    to perform Register Read, ALU Execution, and Register Write 
//    each on their own clock cycle. This looks like the following:
//        (1) Register Read CC -- set Write Enabled to false, select rs
//            and rt values.
//        (2) ALU Execution CC -- set the control signal
//        (3) Register WriteBack CC -- set the writeback (rd) value and
//            enable write (set Write Enabled to true)
//        
//      Need to make sure that write enabled is turned off unless
//    we are writing to the register file (i.e. in the "Register 
//    Write" Clock cycle).
//      To actually fill the pipeline we will have to do some strange
//    magic -- most notably, we will still have to abide by the three 
//    clock cycle layout of above, 
//      Performing a NOOP is simple enough by just adding r0 and r0 to
//    r0.
//
initial
begin
  // Start with NOOP
  no_operation();

  //////////////////////////////////////////////////////////// 
  /// Register Initialization
  //////////////////////////////////////////////////////////// 
  $display("==========\nSetup our Register File by hand\n");
  dut.regfile.register_file[1] = 32'd1;
  dut.regfile.register_file[2] = 32'd16;
  dut.regfile.register_file[3] = 32'd4;
  dut.regfile.register_file[4] = 32'd0;
  dut.regfile.register_file[5] = 32'd0;
  dut.regfile.register_file[10] = 32'd0;
  #10;

  //////////////////////////////////////////////////////////// 
  /// Testing basic addition
  //////////////////////////////////////////////////////////// 
  no_operation(); 
  #50;

  $display("==========\nRun our super basic program: adding together \n");

  // add $r20, $r0, $r0
  rs=5'd0; 
  rt=5'd0; 
  we=1'b0; 
  #10;  // Register Read CC
  control=dut.alu.CONTROL_ADD; 
  #10;  // ALU Execution CC
  rd=5'd20; 
  we=1'b1; 
  #10;  // Writeback CC
  
  // add $r20, $r20, $r2
  rs=5'd20; 
  rt=5'd2; 
  we=1'b0; 
  #10;  // Register Read CC
  control=dut.alu.CONTROL_ADD; 
  #10;  // ALU Execution CC
  rd=5'd20; 
  we=1'b1; 
  #10;  // Writeback CC
  
  // add $r21, $r20, $r2
  rs=5'd20; 
  rt=5'd2; 
  we=1'b0; 
  #10;  // Register Read CC
  control=dut.alu.CONTROL_ADD; 
  #10;  // ALU Execution CC
  rd=5'd21; 
  we=1'b1; 
  #10;  // Writeback CC

  //////////////////////////////////////////////////////////// 
  /// Testing basic subtraction
  //////////////////////////////////////////////////////////// 

  $display("==========\nRun our super basic program: subtracting \n");
  
  // sub $r22, $r10, $r1
  rs=5'd20; 
  rt=5'd1; 
  we=1'b0; 
  #10;  // Register Read CC
  control=dut.alu.CONTROL_SUB; 
  #10;  // ALU Execution CC
  rd=5'd22; 
  we=1'b1; 
  #10;  // Writeback CC

  // sub $r22, $r22, $r1
  rs=5'd22; 
  rt=5'd1; 
  we=1'b0; 
  #10;  // Register Read CC
  control=dut.alu.CONTROL_SUB; 
  #10;  // ALU Execution CC
  rd=5'd22; 
  we=1'b1; 
  #10;  // Writeback CC

  //////////////////////////////////////////////////////////// 
  /// Testing Toy Program
  //////////////////////////////////////////////////////////// 
  no_operation(); 
  #50;

  $display("==========\nRun our super toy program \n");
  // Check if our decrementer is less than zero 
  // slt $r5, $r3, $r0
  rs=5'd3; 
  rt=5'd0; 
  we=1'b0; 
  #10;  // Register Read CC
  control=dut.alu.CONTROL_SLT; 
  #10;  // ALU Execution CC
  rd=5'd5; 
  we=1'b1; 
  #10;  // Writeback CC

  // Do the branching in verilog logic...
  while (dut.regfile.register_file[5] == 0) 
  begin
    // add $r4, $r4, $r2
    rs=5'd4; 
    rt=5'd2; 
    we=1'b0; 
    #10;  // Register Read CC
    control=dut.alu.CONTROL_ADD; 
    #10;  // ALU Execution CC
    rd=5'd4; 
    we=1'b1; 
    #10;  // Writeback CC

    // sub $r3, $r3, $r1
    rs=5'd3; 
    rt=5'd1; 
    we=1'b0; 
    #10;  // Register Read CC
    control=dut.alu.CONTROL_SUB; 
    #10;  // ALU Execution CC
    rd=5'd3; 
    we=1'b1; 
    #10;  // Writeback CC

    // slt $r5, $r3, $r1
    rs=5'd3; 
    rt=5'd1; 
    we=1'b0; 
    #10;  // Register Read CC
    control=dut.alu.CONTROL_SLT; 
    #10;  // ALU Execution CC
    rd=5'd5; 
    we=1'b1; 
    #10;  // Writeback CC
  end
  $display("R4\n Expected: %d\n Observed: %d", 
    32'h40, dut.regfile.register_file[4]);

  //////////////////////////////////////////////////////////// 
  /// Testing basic pipelining
  //////////////////////////////////////////////////////////// 
  $display("==========\nRunning a basic pipelined set of Ops\n");
  no_operation(); 
  #50;

  // add $r9, $r0, $r0
  // or $r10, $r2, $r1
  // and $r11, $r2, $r1
  // slt $r30, $r0, $r9
  rs=5'd0; rt=5'd0;                                         we=1'b0;  #10; // CC 1
  rs=5'd2; rt=5'd1;           control=dut.alu.CONTROL_ADD;  we=1'b0;  #10; // CC 2
  rs=5'd2; rt=5'd1;  rd=5'd9; control=dut.alu.CONTROL_OR;   we=1'b1;  #10; // CC 3
  rs=5'd9; rt=5'd10; rd=5'd10; control=dut.alu.CONTROL_AND; we=1'b1;  #10; // CC 3
                     rd=5'd11; control=dut.alu.CONTROL_SLT; we=1'b1;  #10; // CC 4
                     rd=5'd30;                              we=1'b1;  #10; // CC 5

  $display("R30\n Expected: %d\n Observed: %d", 
    32'h01, dut.regfile.register_file[30]);

  //////////////////////////////////////////////////////////// 
  /// End with NOOPs
  //////////////////////////////////////////////////////////// 
  no_operation(); 
end

// Basic console output
initial 
  $monitor("%d, %b(cout), %b(zero), %b(overflow), %b(control_err)",
    $time, cout, zero, overflow, err_invalid_control);

endmodule 
