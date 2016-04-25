// 2016 Ryan Leonawrite_addr
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

`timescale 1ns / 1ns;
module rf_32(
  input wire        clock,
  input wire        reset,
  input wire [4:0]  read_addr_s, read_addr_t, write_addr,
  input wire        write_enabled,
  input wire [31:0] write_data,
  output reg [31:0] outA, outB
);

// Set all of our registeread_addr_s to logical default values
initial 
begin
  outA <= 0;
  outB <= 0;
end

// A 'memories' data structure representing:
//    32 registeread_addr_s each 32 bits
reg [31:0] register_file[31:0];
//    |                   |
//    v                   v
//  reg_SIZE-1        reg_COUNT-1
//  (register size)   (register file size)


// Using an always block for inputs into our memory array
integer i;
always @ (posedge clock)
begin 
  if (reset) 
  begin // BEG reset
  for (i=0; i<=31; i=i+1)
    register_file[i] = 32'b0;
  end // END reset
  else
  begin // BEG logic
    if (write_enabled && write_addr != 5'd0)
      register_file[write_addr] <= write_data;
  end // END logic
end

// Read at the negative edge of the clock to ensure 'read-after-write' doesn't
// occur
always @ (negedge clock)
  begin
    outA <= register_file[read_addr_s];
    outB <= register_file[read_addr_t];
  end


endmodule
