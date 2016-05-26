// 2016 Ryan Leonard
// RegisterFile (RF) Module Testbench

module rf_32_test;

// The reg/nets write_enabled will maniupulate/monitor for testing
reg         clock;
reg         read_enabled;
reg [4:0]   read_addr_s;
reg [4:0]   read_addr_t;
reg         write_enabled;
reg [4:0]   write_addr;
reg [31:0]  write_data;
wire [31:0] read_data_s;
wire [31:0] read_data_t;

// build a veread_addr_sion of the Design Under Test (dut)
rf_32 dut (
  .clock          (clock),
  .read_enabled   (read_enabled),
  .read_addr_s    (read_addr_s), 
  .read_addr_t    (read_addr_t), 
  .write_addr     (write_addr),
  .write_data     (write_data),
  .write_enabled  (write_enabled),
  .outA           (read_data_s), 
  .outB           (read_data_t)
);

/**********************************************************
*
* Assertion Methods
*
**********************************************************/
task assert_equal(
  input [31:0] expected,
  input [31:0] observed);
  begin
    if (expected != observed)
      $display("ASSERTION EQUAL FAIL: %p != %p", expected, observed);
  end
endtask

task assert_register_value(
  input [31:0] expected,
  input [4:0] register_addr
); 
  begin
    if (dut.register_file[register_addr] != expected)
      $display("ASSERTION FAIL: reg[%p] value mismatch \n  expected: %p\n  actual: %p", register_addr, expected, dut.register_file[register_addr]);
  end
endtask

task reset();
  begin
    read_enabled=0;
    read_addr_s=0; 
    read_addr_t=0;
    write_addr=0; 
    write_data=0;
    write_enabled=0;
  end
endtask

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


// Test Stimulus
integer i;
initial
begin // BEG test

  $display("==========\nCheck all don't care (using s & t)\n");
  reset();
  for (i=0; i<=30; i=i+2) begin
    read_addr_s = i; 
    read_addr_t = i+1;
    #10;
    assert_equal(read_data_s, 32'bx);
    assert_equal(read_data_t, 32'bx);
  end

  /// Testing Write
  $display("==========\nWrite Some Data to Register File\n");
  reset();
  write_enabled=1'b1; 

  write_addr=5'd0; 
  write_data=32'hDEADBEEF;
  #10;

  write_addr=5'd1; 
  write_data=32'h00000000;
  #10;

  write_addr=5'd2; 
  write_data=32'h11111111;
  #10;

  write_addr=5'd3; 
  write_data=32'h22222222;
  #10; 

  write_addr=5'd4; 
  write_data=32'h33333333;
  #10; 

  write_addr=5'd5; 
  write_data=32'h44444444;
  #10; 

  write_addr=5'd6; 
  write_data=32'h55555555;
  #10;

  write_addr=5'd7; 
  write_data=32'h66666666;
  #10;

  write_addr=5'd8; 
  write_data=32'h77777777;
  #10;

  write_addr=5'd9; 
  write_data=32'h88888888;
  #10;

  write_addr=5'd10; 
  write_data=32'h99999999;
  #10;

  write_addr=5'd11; 
  write_data=32'hAAAAAAAA;
  #10;

  write_addr=5'd12; 
  write_data=32'hBBBBBBBB;
  #10;

  write_addr=5'd13; 
  write_data=32'hCCCCCCCC;
  #10;

  write_addr=5'd14; 
  write_data=32'hDDDDDDDD;
  #10;

  write_addr=5'd15; 
  write_data=32'hEEEEEEEE;
  #10;

  write_addr=5'd16; 
  write_data=32'hFFFFFFFF;
  #10;

  write_addr=5'd17; 
  write_data=32'h00000001;
  #10;

  write_addr=5'd18; 
  write_data=32'h00000002;
  #10;

  write_addr=5'd19; 
  write_data=32'h00000003;
  #10;

  write_addr=5'd20; 
  write_data=32'h00000004;
  #10;

  write_addr=5'd21; 
  write_data=32'h00000005;
  #10;

  write_addr=5'd22; 
  write_data=32'h00000006;
  #10;

  write_addr=5'd23; 
  write_data=32'h00000007;
  #10;

  write_addr=5'd24; 
  write_data=32'h00000008;
  #10;

  write_addr=5'd25; 
  write_data=32'h00000009;
  #10;

  write_addr=5'd26; 
  write_data=32'h0000000A;
  #10;

  write_addr=5'd27; 
  write_data=32'h0000000B;
  #10;

  write_addr=5'd28; 
  write_data=32'h0000000C;
  #10;

  write_addr=5'd29; 
  write_data=32'h0000000D;
  #10;

  write_addr=5'd30; 
  write_data=32'h0000000E;
  #10;

  write_addr=5'd31; 
  write_data=32'hDEADBEEF;
  #10;


  //////////////////////////////////////////////////////////// 
  /// Testing RS and RT indapendently
  //////////////////////////////////////////////////////////// 
  $display("==========\nRead (RS) Some From Register File\n");
  reset();
  for (i=0; i<32; i=i+1) 
  begin
    read_addr_s=i; 
    #10;
  end

  $display("==========\nRead (RT) Some From Register File\n");
  reset();
  for (i=0; i<32; i=i+1) 
  begin
    read_addr_t=i; 
    #10;
  end
end // END testing

// Basic console output
initial 
begin
  $display("Time || read_addr_s, read_addr_t, write_addr || write_enabled || write_data, read_data_s, read_data_t");
  $monitor("%d || %d, %d, %d || %b || %h, %h, %h",
    $time, read_addr_s, read_addr_t, 
    write_addr, write_enabled, write_data, 
    read_data_s, read_data_t); 
end

endmodule
