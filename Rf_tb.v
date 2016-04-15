// 2016 Ryan Leonard
// RegisterFile (RF) Module Testbench

`timescale 1ns / 1ns
module rf_32_test;

// The reg/nets we will maniupulate/monitor for testing
reg         clock;    //clock
reg [4:0]   rs;             //input
reg [4:0]   rt;             //input
reg [4:0]   rd;             //input
reg [31:0]  write_data;     //input
reg         we;             //input
wire [31:0] out_rs;         //output
wire [31:0] out_rt;         //output

// build a version of the Design Under Test (dut)
rf_32 dut (
  .clk            (clock),
  .rs             (rs), 
  .rt             (rt), 
  .rd             (rd),
  .write_data     (write_data),
  .write_enabled  (we),
  .outA           (out_rs), 
  .outB           (out_rt)
);


// Clock Generator
initial 
  begin
    clock = 0;
    forever
      #5 clock = ~clock;
  end

// Test stimulus
integer i;
initial
  begin
    rs=5'd0; rt=5'd0; rd=5'd0; 
    we=1'b0; write_data=32'h0;

    //////////////////////////////////////////////////////////// 
    /// Testing For initialization Correctness
    //////////////////////////////////////////////////////////// 
    #100
    $display("==========\nCheck Initialized to 'dont care'\n");
    for (i=0; i<=30; i=i+2) begin
      #10 rs=i; rt=i+1;
    end
    rs=0; rt=0;

    //////////////////////////////////////////////////////////// 
    /// Testing Write
    //////////////////////////////////////////////////////////// 
    #100
    $display("==========\nWrite Some Data to Register File\n");
    #10 rd=5'd0; we=1'b1; write_data=32'hDEADBEEF;
    #10 rd=5'd1; we=1'b1; write_data=32'h00000000;
    #10 rd=5'd2; we=1'b1; write_data=32'h11111111;
    #10 rd=5'd3; we=1'b1; write_data=32'h22222222;
    #10 rd=5'd4; we=3'b1; write_data=32'h33333333;
    #10 rd=5'd5; we=1'b1; write_data=32'h44444444;
    #10 rd=5'd6; we=1'b1; write_data=32'h55555555;
    #10 rd=5'd7; we=1'b1; write_data=32'h66666666;
    #10 rd=5'd8; we=1'b1; write_data=32'h77777777;
    #10 rd=5'd9; we=1'b1; write_data=32'h88888888;
    #10 rd=5'd10; we=1'b1; write_data=32'h99999999;
    #10 rd=5'd11; we=1'b1; write_data=32'hAAAAAAAA;
    #10 rd=5'd12; we=1'b1; write_data=32'hBBBBBBBB;
    #10 rd=5'd13; we=1'b1; write_data=32'hCCCCCCCC;
    #10 rd=5'd14; we=1'b1; write_data=32'hDDDDDDDD;
    #10 rd=5'd15; we=1'b1; write_data=32'hEEEEEEEE;
    #10 rd=5'd16; we=1'b1; write_data=32'hFFFFFFFF;
    #10 rd=5'd17; we=1'b1; write_data=32'h00000001;
    #10 rd=5'd18; we=1'b1; write_data=32'h00000002;
    #10 rd=5'd19; we=1'b1; write_data=32'h00000003;
    #10 rd=5'd20; we=1'b1; write_data=32'h00000004;
    #10 rd=5'd21; we=1'b1; write_data=32'h00000005;
    #10 rd=5'd22; we=1'b1; write_data=32'h00000006;
    #10 rd=5'd23; we=1'b1; write_data=32'h00000007;
    #10 rd=5'd24; we=1'b1; write_data=32'h00000008;
    #10 rd=5'd25; we=1'b1; write_data=32'h00000009;
    #10 rd=5'd26; we=1'b1; write_data=32'h0000000A;
    #10 rd=5'd27; we=1'b1; write_data=32'h0000000B;
    #10 rd=5'd28; we=1'b1; write_data=32'h0000000C;
    #10 rd=5'd29; we=1'b1; write_data=32'h0000000D;
    #10 rd=5'd30; we=1'b1; write_data=32'h0000000E;
    #10 rd=5'd31; we=1'b1; write_data=32'hDEADBEEF;
    #10 we=0;

    //////////////////////////////////////////////////////////// 
    /// Generally checking the register values real quick
    //////////////////////////////////////////////////////////// 
    #100
    $display("==========\nCheck the written values\n");
    for (i=0; i<=30; i=i+2) begin
      #10 rs=i; rt=i+1;
    end

    //////////////////////////////////////////////////////////// 
    /// Testing RS and RT indapendently
    //////////////////////////////////////////////////////////// 
    #100
    $display("==========\nRead (RT) Some From Register File\n");
    #10 rt=5'd0; 
    #10 rt=5'd1;
    #10 rt=5'd2; 
    #10 rt=5'd3; 
    #10 rt=5'd4; 
    #10 rt=5'd5; 
    #10 rt=5'd6; 
    #10 rt=5'd7; 
    #10 rt=5'd8; 
    #10 rt=5'd9; 
    #10 rt=5'd10;
    #10 rt=5'd11;
    #10 rt=5'd12;
    #10 rt=5'd13;
    #10 rt=5'd14;
    #10 rt=5'd15;
    #10 rt=5'd16;
    #10 rt=5'd17;
    #10 rt=5'd18;
    #10 rt=5'd19;
    #10 rt=5'd20;
    #10 rt=5'd21;
    #10 rt=5'd22;
    #10 rt=5'd23;
    #10 rt=5'd24;
    #10 rt=5'd25;
    #10 rt=5'd26;
    #10 rt=5'd27;
    #10 rt=5'd28;
    #10 rt=5'd29;
    #10 rt=5'd30;
    #10 rt=5'd31;
    #100
    $display("==========\nRead (RS) Some From Register File\n");
    #10 rs=5'd0; 
    #10 rs=5'd1;
    #10 rs=5'd2; 
    #10 rs=5'd3; 
    #10 rs=5'd4; 
    #10 rs=5'd5; 
    #10 rs=5'd6; 
    #10 rs=5'd7; 
    #10 rs=5'd8; 
    #10 rs=5'd9; 
    #10 rs=5'd10;
    #10 rs=5'd11;
    #10 rs=5'd12;
    #10 rs=5'd13;
    #10 rs=5'd14;
    #10 rs=5'd15;
    #10 rs=5'd16;
    #10 rs=5'd17;
    #10 rs=5'd18;
    #10 rs=5'd19;
    #10 rs=5'd20;
    #10 rs=5'd21;
    #10 rs=5'd22;
    #10 rs=5'd23;
    #10 rs=5'd24;
    #10 rs=5'd25;
    #10 rs=5'd26;
    #10 rs=5'd27;
    #10 rs=5'd28;
    #10 rs=5'd29;
    #10 rs=5'd30;
    #10 rs=5'd31;
  end

// Basic console output
initial 
  begin
    $monitor("%d, %d(rs), %d(rt), %d(rd), %b(we), %d(wd), %d(rs_d), %d(rt_d)", 
      $time, rs, rt, rd, we, write_data, out_rs, out_rt); 
    //$monitor("RF: %p", dut.register_file);
  end

endmodule
