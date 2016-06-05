module mips_fpga (
  SW,
  CLOCK_50,
  HEX0,
  HEX1,
  HEX2,
  HEX3,
  LEDR
); 

input  [9:0] SW;
input  CLOCK_50;
output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [9:0] LEDR;

wire main_clk = CLOCK_50;

wire [31:0] res;

cpu cpu(
  .run_switch(SW[0]),
  .clock(main_clk),
  .output_reg9(res)
);

//assign LEDR[9] = SW[0];
//assign LEDR[8] = main_clk;
//assign LEDR[0] = (res == 32'd144) ? 1'b1 : 1'b0;
//cpu.regfile.register_file

//assign LEDR[1] = SW[1];

LED_7seg ledseg0(
	.BCD(res[3:0]),
	.segA(HEX0[0]),
  .segB(HEX0[1]),
  .segC(HEX0[2]),
  .segD(HEX0[3]),
  .segE(HEX0[4]),
  .segF(HEX0[5]),
  .segG(HEX0[6]),
  .segDP()
);
LED_7seg ledseg1(
	.BCD(res[7:4]),
	.segA(HEX1[0]),
  .segB(HEX1[1]),
  .segC(HEX1[2]),
  .segD(HEX1[3]),
  .segE(HEX1[4]),
  .segF(HEX1[5]),
  .segG(HEX1[6]),
  .segDP()
);
LED_7seg ledseg2(
	.BCD(res[11:8]),
	.segA(HEX2[0]),
  .segB(HEX2[1]),
  .segC(HEX2[2]),
  .segD(HEX2[3]),
  .segE(HEX2[4]),
  .segF(HEX2[5]),
  .segG(HEX2[6]),
  .segDP()
);
LED_7seg ledseg3(
	.BCD(res[15:12]),
	.segA(HEX3[0]),
  .segB(HEX3[1]),
  .segC(HEX3[2]),
  .segD(HEX3[3]),
  .segE(HEX3[4]),
  .segF(HEX3[5]),
  .segG(HEX3[6]),
  .segDP()
);
endmodule
