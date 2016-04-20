// 2016 Ryan Leonard
// RegisterFile (RF) Module
//
//  The internal data structure is a collection of 
//  32 registers each 32 bits in size. This is represented
//  using the 'memories' data structure as discussed in:
//    http://www.verilogtutorial.info/chapter_3.htm

`timescale 1ns / 1ns
module rf_32(
  input wire        clk,
  input wire [4:0]  rs, rt, rd,
  input wire        write_enabled,
  input wire [31:0] write_data,
  output reg [31:0] outA, outB
);

// Set all of our registers to logical default values
initial 
  begin
    outA <= 0;
    outB <= 0;
  end

// A 'memories' data structure representing:
//    32 registers each 32 bits
reg [31:0] register_file[31:0];
//    |                   |
//    v                   v
//  reg_SIZE-1        reg_COUNT-1
//  (register size)   (register file size)


/* 
//Initialize all registers to zero
integer i;
initial 
  for (i=0; i<=31; i=i+1) begin
    register_file[i] = 32'b0;
  end
*/

//Initialize zero register to zero.
initial
  register_file[0] <= 32'b0;

// Using continuous assignment for our outputing
//assign outA = register_file[rs];
//assign outB = register_file[rt];

// Using an always block for inputs into our memory array
always @ (posedge clk)
    if (write_enabled && rd != 5'd0)
      register_file[rd] <= write_data;

// Read at the negative edge of the clock to ensure 'read-after-write' doesn't
// occur
always @ (negedge clk)
  begin
    outA <= register_file[rs];
    outB <= register_file[rt];
  end


endmodule
