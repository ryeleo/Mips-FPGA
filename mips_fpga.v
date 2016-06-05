module mips_fpga (
  SW_0,
  CLOCK_50
); 

input wire SW_0;
input wire CLOCK_50;

cpu cpu(
  .run_switch(SW_0),
  .clock(CLOCK_50)
);


endmodule
