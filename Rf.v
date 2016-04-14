// 2016 Ryan Leonard
// RegisterFile (RF) Module
//
//  The internal data structure is a collection of 
//  32 registers each 32 bits in size. This is represented
//  using the 'memories' data structure as discussed in:
//    http://www.verilogtutorial.info/chapter_3.htm

module rf_32(
  input [4:0]   rs, rt, rd,
  input [31:0]  write_data,
  input         write_enabled,
  output [31:0] outA, outB
);

// A 'memories' data structure representing:
//    32 registers each 32 bits
reg [31:0] register_file[31:0];
//    |                   |
//    v                   v
//  reg_SIZE-1        reg_COUNT-1
//  (register size)   (register file size)

// Using continuous assignment
assign outA = register_file[rs];
assign outB = register_file[rt];

always @ (posedge write_endabled)
  register_file[rd] = write_data;

endmodule
