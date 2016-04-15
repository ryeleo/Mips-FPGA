// 2016 Ryan Leonard
// ALU Module Testbench

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


// The nets interconnecting our alu and rf
wire [31:0]	rs_to_a;        
wire [31:0]	rt_to_b;        
wire [31:0]	result_to_rd; // It is a register for laziness

// Connect our ALU to our Register File (rf)
alu_32 alu(
  .s	      (rs_to_a),      // interconnect
  .t	      (rt_to_b),      // interconnect
  .result   (result_to_rd), // interconnect
  .control  (control), 
  .cout     (cout),
  .zero     (zero),
  .overflow (overflow)
);

rf_32 rf(
  .write_data     (result_to_rd), // interconnect
  .outA           (rs_to_a),      // interconnect
  .outB           (rt_to_b),      // interconnect
  .clk            (clock),
  .rs             (rs), 
  .rt             (rt), 
  .rd             (rd),
  .write_enabled  (we)
);

// Clock Generator
initial 
  begin
    clock = 0;
    forever
      #5 clock = ~clock;
  end

// Test stimulus
initial
  begin
    //////////////////////////////////////////////////////////// 
    /// Setup Register file
    //////////////////////////////////////////////////////////// 
    $display("==========\nSetup our Register File by hand\n");
    #100
    rf.register_file[1] = 32'd1;
    rf.register_file[2] = 32'd16;
    rf.register_file[3] = 32'd4;
    rf.register_file[4] = 32'd0;
    rf.register_file[5] = 32'd0;

    //////////////////////////////////////////////////////////// 
    /// Testing basic addition, subtraction, slt
    //////////////////////////////////////////////////////////// 
    $display("==========\nRun our super basic program: adding together \n");
    #100
    
    // add $r4, $r4, $r2
    #10 control=4'h2; rd=5'd5; rs=5'd3; rt=5'd0; we=1'b1; 
    // add $r4, $r4, $r2
    #10 control=4'h2; rd=5'd5; rs=5'd3; rt=5'd0; we=1'b1; 
    // add $r4, $r4, $r2
    #10 control=4'h2; rd=5'd5; rs=5'd3; rt=5'd0; we=1'b1; 
    // add $r4, $r4, $r2
    #10 control=4'h2; rd=5'd5; rs=5'd3; rt=5'd0; we=1'b1; 

    // sub $r4, $r4, $r2
    #10 control=4'h6; rd=5'd5; rs=5'd3; rt=5'd0; we=1'b1; 



    //////////////////////////////////////////////////////////// 
    /// Testing basic addition, subtraction, slt
    //////////////////////////////////////////////////////////// 
    $display("==========\nRun our super basic program: adding together \n");
    #100
    
    // Check if our decrementer is less than zero 
    // slt $r5, $r3, $r0
    #10 control=4'h7; rd=5'd5; rs=5'd3; rt=5'd0; we=1'b1; 
    // Do the branching in verilog logic...
    while (rf.register_file[5] == 0) begin
      // add $r4, $r4, $r2
      #10 control=4'h2; rd=5'd5; rs=5'd3; rt=5'd0; we=1'b1; 

      // sub $r3, $r3, $r1
      #10 control=4'h6; rd=5'd3; rs=5'd3; rt=5'd1; we=1'b1; 

      // slt $r5, $r3, $r0
      #10 control=4'h7; rd=5'd5; rs=5'd3; rt=5'd0; we=1'b1; 
    end
  end 

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
