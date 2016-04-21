// 2016 Ryan Leonard
// ALU Module Testbench

`timescale 1ns / 1ns;
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

// The nets interconnecting our alu and rf
wire [31:0]	rs_to_a;        
wire [31:0]	rt_to_b;        
wire [31:0]	result_to_rd; // It is a register for laziness

// Connect our ALU to our Register File (rf)
alu_32 alu(
  .clk      (clock),
  .s	      (rs_to_a),      // interconnect
  .t	      (rt_to_b),      // interconnect
  .result   (result_to_rd), // interconnect
  .control  (control),      // knob
  .cout     (cout),         // monitor
  .zero     (zero),         // monitor
  .overflow (overflow)      // monitor
);

rf_32 rf(
  .clk            (clock),      
  .write_data     (result_to_rd), // interconnect
  .outA           (rs_to_a),      // interconnect
  .outB           (rt_to_b),      // interconnect
  .rs             (rs),           // knob
  .rt             (rt),           // knob
  .rd             (rd),           // knob
  .write_enabled  (we)            // knob
);

// Clock Generator
initial 
  begin
    clock = 1;
    forever
      #5 clock = !clock;
  end

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
    // Initialize all of our knobs to 0
    rs=5'd0; rt=5'd0; we=1'b0; control=4'h0; rd=5'd0; 

    //////////////////////////////////////////////////////////// 
    /// Register Initialization
    //////////////////////////////////////////////////////////// 
    $display("==========\nSetup our Register File by hand\n");
    rf.register_file[1] = 32'd1;
    rf.register_file[2] = 32'd16;
    rf.register_file[3] = 32'd4;
    rf.register_file[4] = 32'd0;
    rf.register_file[5] = 32'd0;
    rf.register_file[10] = 32'd0;
    #10;

    //////////////////////////////////////////////////////////// 
    /// Testing basic addition
    //////////////////////////////////////////////////////////// 
    $display("==========\nRun our super basic program: adding together \n");
    
    // add $r20, $r20, $r2
    rs=5'd20; rt=5'd2; we=1'b0; #10;  // Register Read CC
    control=4'h2; #10;                // ALU Execution CC
    rd=5'd20; we=1'b1; #10;           // Writeback CC
    
    // add $r21, $r20, $r2
    rs=5'd20; rt=5'd2; we=1'b0; #10;  // Register Read CC
    control=4'h2; #10;                // ALU Execution CC
    rd=5'd21; we=1'b1; #10;           // Writeback CC

    // NOOP
    rs=5'd0; rt=5'd0; we=1'b0; control=4'h2; rd=5'd0; #50;


    //////////////////////////////////////////////////////////// 
    /// Testing basic subtraction
    //////////////////////////////////////////////////////////// 
    $display("==========\nRun our super basic program: subtracting \n");
    
    // sub $r22, $r10, $r1
    rs=5'd20; rt=5'd1; we=1'b0; #10;  // Register Read CC
    control=4'h6; #10;                // ALU Execution CC
    rd=5'd22; we=1'b1; #10;            // Writeback CC
    // sub $r22, $r22, $r1
    rs=5'd22; rt=5'd1; we=1'b0; #10;   // Register Read CC
    control=4'h6; #10;                // ALU Execution CC
    rd=5'd22; we=1'b1; #10;            // Writeback CC

    // NOOP
    rs=5'd0; rt=5'd0; we=1'b0; control=4'h2; rd=5'd0; #50;

    //////////////////////////////////////////////////////////// 
    /// Testing Toy Program
    //////////////////////////////////////////////////////////// 
    $display("==========\nRun our super toy program \n");
    // Check if our decrementer is less than zero 
    // slt $r5, $r3, $r0
    rs=5'd3; rt=5'd0; we=1'b0; #10;  // Register Read CC
    control=4'h7; #10;                // ALU Execution CC
    rd=5'd5; we=1'b1; #10;            // Writeback CC

    // Do the branching in verilog logic...
    while (rf.register_file[5] == 0) begin
      // add $r4, $r4, $r2
      rs=5'd4; rt=5'd2; we=1'b0; #10;  // Register Read CC
      control=4'h2; #10;                // ALU Execution CC
      rd=5'd4; we=1'b1; #10;            // Writeback CC

      // sub $r3, $r3, $r1
      rs=5'd3; rt=5'd1; we=1'b0; #10;  // Register Read CC
      control=4'h6; #10;                // ALU Execution CC
      rd=5'd3; we=1'b1; #10;            // Writeback CC

      // slt $r5, $r3, $r1
      rs=5'd3; rt=5'd1; we=1'b0; #10;   // Register Read CC
      control=4'h7; #10;                // ALU Execution CC
      rd=5'd5; we=1'b1; #10;            // Writeback CC
    end

  // NOOP
  rs=5'd0; rt=5'd0; we=1'b0; control=4'h2; rd=5'd0; #50;

  end 

  // add $r9, $r0, $r0
  //    Read Regs 
  rs=5'd0; rt=5'd0;                 we=1'b0;          #10; // CC 1
  rs=5'd9; rt=5'd15;  control=4'h2;                   #10; // CC 2
  rs=5'd9; rt=5'd16;  control=4'h1; rd=5'd3; we=1'b1; #10; // CC 3
                      control=4'h1; rd=5'd3; we=1'b1; #10;
  // or $r9, $r9, $r16
  rs=5'd3; rt=5'd1; we=1'b0; #10;   // Register Read CC
  rd=5'd5; we=1'b1; #10;            // Writeback CC

  // or $r9, $r9, $r15
  rs=5'd3; rt=5'd1; we=1'b0; #10;   // Register Read CC
  control=4'h1; #10;                // ALU Execution CC
  rd=5'd5; we=1'b1; #10;            // Writeback CC

  // NOOP
  rs=5'd0; rt=5'd0; we=1'b0; control=4'h2; rd=5'd0; #50;

// Little helper that makes our string output prettier
reg  [8*3:0] str_control;
always @ (posedge clock)
  case(control)
    'h0 : str_control = "and";
    'h1 : str_control = " or";
    'h2 : str_control = "add";
    'h3 : str_control = "sub";
    'h7 : str_control = "slt";
    'hC : str_control = "nor";
    default : str_control = " ? ";
  endcase

// Basic console output
initial 
  begin
    $monitor("%d, %b(cout), %b(zero), %b(overflow), %h(rs_to_a), %h(rt_to_b), %h(aluResult)", 
      $time, cout, zero, overflow, rs_to_a, rt_to_b, result_to_rd);

// The nets interconnecting our alu and rf
  end

endmodule 
