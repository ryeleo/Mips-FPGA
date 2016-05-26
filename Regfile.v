// 2016 Ryan Leonard
// RegisterFile (RF) Module
//
//  The internal data structure is a collection of 
//  32 registeread_addr_s each 32 bits in size. This is represented
//  using the 'memories' data structure as discussed in:
//    http://www.verilogtutorial.info/chapter_3.htm
//
//  Notice that on the positive edge of each clock cycle, we
//  are performing data write. On the negative edge of each clock
//  cycle, we are performing data read.

// TODO: How do we make the finish bit work as expected?

module rf_32(
  clock,
  read_enabled,
  read_addr_s, 
  read_addr_t, 
  write_enabled,
  write_addr,
  write_data,
  outA, 
  outB
);

parameter
  OFF = 1'b0,
  ON = 1'b1;

localparam 
  REG_SIZE = 32,
  REGFILE_SIZE = 32,
  INDEX_SIZE = 5,
  ZERO = 32'b0;

input wire        start;
input wire        read_enabled;
input wire [INDEX_SIZE-1:0]  read_addr_s;
input wire [INDEX_SIZE-1:0]  read_addr_t;
input wire        write_enabled;
input wire [INDEX_SIZE-1:0]  write_addr;
input wire [REG_SIZE-1:0] write_data;
output reg        finish;
output reg [REG_SIZE-1:0] outA;
output reg [REG_SIZE-1:0] outB;

// A 'memories' data structure representing:
//    32 registeread_addr_s each 32 bits
reg [REG_SIZE-1:0] register_file[REGFILE_SIZE-1:0];
//    |                   |
//    v                   v
//  reg_SIZE-1        reg_COUNT-1
//  (register size)   (register file size)


always @ (posedge start)
begin // BEG logic
  finish = OFF;
  outA = register_file[read_addr_s];
  outB = register_file[read_addr_t];
  if (write_enabled)
    register_file[write_addr] = write_data;
  register_file[0] = ZERO;
  finish = ON;
end // END logic

endmodule
