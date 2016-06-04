module mips_fpga (
  KEY_0,
  CLOCK_50
); 

input wire KEY_0;
input wire CLOCK_50;

cpu cpu(
  .reset(KEY_0),
  .clock(CLOCK_50)
);


endmodule
