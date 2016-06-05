module scratch(
  SW_0,
  LEDR);

input wire SW_0;
output wire [9:0] LEDR;

// One LED is hooked up to Switch
assign LEDR = 9'hAAA;
endmodule
