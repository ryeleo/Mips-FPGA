// 2016 Ryan Leonard
// Memory Module
//
// Read/write happenning at same time is unexpected behavior.
//
// Read enabled is no longer used
module memory ( 
  clock,
  write_enabled,
  read_enabled,
  input_address,
  input_data,
  output_data,
  err_invalid_address
);

// Parametrs to change the size of our system's basic
parameter 
  ON = 1'b1,
  OFF = 1'b0,
  MEMORY_SIZE = 1024, 
  WORD_SIZE = 32; // 32 --> 32bit system, 64 --> 64bit system

input wire                    clock;
input wire 	                  write_enabled;
input wire 	                  read_enabled;
input wire   [WORD_SIZE-1:0]	input_address;
input wire   [WORD_SIZE-1:0]	input_data;
output wire  [WORD_SIZE-1:0]	output_data;
output reg                    err_invalid_address;

// A data structure 
reg [WORD_SIZE:0]  data[MEMORY_SIZE:0];

// Begin computing on positive edge
always @ (negedge clock) 
begin
  err_invalid_address <= (input_address > MEMORY_SIZE-1) || (input_address < 0) ? ON : OFF;

  if (write_enabled) 
    data[input_address] <= input_data;
end
  
assign output_data = data[input_address];

endmodule
