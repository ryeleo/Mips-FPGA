// 2016 Ryan Leonawrite_addr
// RegisterFile (RF) Module Testbench

`timescale 1ns / 1ns;
module test_rf_32;

// The reg/nets write_enabled will maniupulate/monitor for testing
reg         clock;            //clock
reg         reset;            //reset
reg [4:0]   read_addr_s;      //input
reg [4:0]   read_addr_t;      //input
reg [4:0]   write_addr;       //input
reg [31:0]  write_data;       //input
reg         write_enabled;    //input
wire [31:0] read_data_s;  //output
wire [31:0] read_data_t;  //output

// build a veread_addr_sion of the Design Under Test (dut)
rf_32 dut (
  .clock          (clock),
  .reset          (reset),
  .read_addr_s    (read_addr_s), 
  .read_addr_t    (read_addr_t), 
  .write_addr     (write_addr),
  .write_data     (write_data),
  .write_enabled  (write_enabled),
  .outA           (read_data_s), 
  .outB           (read_data_t)
);


// Clock Generator
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

// Test stimulus
integer i;
initial
begin // BEG test
  reset = 1; 
  read_addr_s=0; 
  read_addr_t=0;
  write_addr=0; 
  write_enabled=0;
  write_data=0;
  #20;
  reset = 1'b0; // turn off reset for future testing

  //////////////////////////////////////////////////////////// 
  /// Testing For initialization Correctness
  //////////////////////////////////////////////////////////// 
  $display("==========\nCheck Reset all to Zero (using s & t)\n");
  for (i=0; i<=30; i=i+2) begin
    read_addr_s=i; 
    read_addr_t=i+1;
    #10;
  end

  //////////////////////////////////////////////////////////// 
  /// Testing Write
  //////////////////////////////////////////////////////////// 
  $display("==========\nWrite Some Data to Register File\n");
  read_addr_s=0;  
  read_addr_t=0;
  write_enabled=1'b1; 
  write_addr=5'd0; 
  write_data=32'hDEADBEEF;
  #10;
  write_addr=5'd1; 
  write_data=32'h00000000;
  #10 
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
  write_enabled=0;
  write_data=32'h0;

  //////////////////////////////////////////////////////////// 
  /// Testing RS and RT indapendently
  //////////////////////////////////////////////////////////// 
  $display("==========\nRead (RS) Some From Register File\n");
  for (i=0; i<32; i=i+1) 
  begin
    read_addr_s=i; 
    #10;
  end
  $display("==========\nRead (RT) Some From Register File\n");
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
