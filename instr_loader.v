module instr_loader(
  clock,
  data,
  address
);

parameter MAX_ADDRESS = 64;

input wire clock;
output reg [31:0] data;
output reg [31:0] address;

// Fibbonaci instruction sequence
localparam [31:0] fib_instr [0:43] = '{
          32'h201d0100,
          32'h2010000c, // Fib(12) 
          32'hafb00000,
          32'h23bdfffc,
          32'h0c000009,
          32'h23bd0004,
          32'h8fb10000,
          32'hac110024,
          32'h0800002b,
          32'hafbf0000,
          32'h23bdfffc,
          32'hafbe0000,
          32'h23bdfffc,
          32'h23be000c,
          32'h8fc80000,
          32'h20090002,
          32'h00005820,
          32'h0128582a,
          32'h15600002,
          32'h20080001,
          32'h08000023,
          32'h2108ffff,
          32'hafa80000,
          32'h23bdfffc,
          32'h0c000009,
          32'h8fc80000,
          32'h2108fffe,
          32'hafa80000,
          32'h23bdfffc,
          32'h0c000009,
          32'h23bd0004,
          32'h8fa80000,
          32'h23bd0004,
          32'h8fa90000,
          32'h01094020,
          32'h23bd0004,
          32'h8fbe0000,
          32'h23bd0004,
          32'h8fbf0000,
          32'h23bd0004,
          32'hafa80000,
          32'h23bdfffc,
          32'h03e00008,
          32'h20000000 };

// This block loops forever pumping out instructions and addresses
// i is our iterator 
reg [31:0] i;
always @ (posedge clock) begin

  if (i < MAX_ADDRESS)
  begin
    data <= fib_instr[i];
    address <= i;
    i <= i+1;
  end
  else 
  begin
    data <= fib_instr[0];
    address <= 0;
    i <= 0;
  end

end

endmodule
