// 2016 Ryan Leonard
// Sandbox Module

`timescale 1ns / 1ns
module sandbox();

reg [7:0] a, b;
wire [7:0] res;
wire carry;

reg [7:0] c, d;
wire [7:0] res2;
wire carry2;
wire x, y;

assign {carry, res} = a + b;

assign {carry2, res2} = c - d;

assign {x, y} = 2'b10;

initial
begin
  a=0; b=0;
  #10 a=8; b=8;
  #10 a=100; b=100;
  #10 a=255; b=1;
  #10 a=255; b=255;
  c=0; d=0;
  #10 c=8;   d=8;
  #10 c=100; d=100;
  #10 c=255; d=1;
  #10 c=-10; d=255;
  $display("{x,y} = 2'b10 -- x(%d), y(%d)", x, y);
end

initial 
  begin
    $monitor("%d, %d + %d = %d (%d)", $time, a, b, res, carry);
    $monitor("%d, %d - %d = %d (%d)", $time, c, d, res2, carry2);
  end



endmodule
