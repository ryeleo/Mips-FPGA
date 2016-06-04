module mips_fpga (
  reset,
  clk
);

input wire reset;
input wire clk;

cpu cpu(
  .reset(reset),
  .clock(clk)
);


endmodule
