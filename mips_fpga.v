module mips_fpga (
  SW_0,
  CLOCK_50,
  HEX0,
  LEDR
); 

input wire SW_0;
input wire CLOCK_50;
output wire [6:0] HEX0;
output wire [9:0] LEDR;

wire [31:0] res;

cpu cpu(
  .run_switch(SW_0),
  .clock(CLOCK_50),
  .output_reg9(res)
);

assign LEDR[9] = SW_0;
assign LEDR[0] = (res == 32'd144) ? 1'b1 : 1'b0;
assign HEX0 = 7'h2A;
//cpu.regfile.register_file

endmodule
