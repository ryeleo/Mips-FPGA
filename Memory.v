// 2016 Ryan Leonard
// Memory Module
//
// Read/write happenning at same time is unexpected behavior.
//
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
  MEMORY_SIZE = 1024, 
  WORD_SIZE = 32; // 32 --> 32bit system, 64 --> 64bit system

input wire                  start;
input wire 	                write_enabled;
input wire 	                read_enabled;
input wire [WORD_SIZE-1:0]	input_address;
input wire [WORD_SIZE-1:0]	input_data;
output reg                  valid;
output reg [WORD_SIZE-1:0]	output_data;
output wire                 err_invalid_address;

// A data structure 
reg [WORD_SIZE:0]  data[MEMORY_SIZE:0];
//    |                   |
//    v                   v
//(datum size)      (memory size)


initial
begin
  valid <= 0;
end

// Begin computing on positive edge of the start signal
always @ (posedge start) 
begin
  valid = 0;

  if (!err_invalid_address) 
  begin
    // Perform write to memory if write_enabled bit is high
    if (write_enabled) 
    begin
      data[input_address] <= input_data;
    end
    if (read_enabled)
    begin
      // Will our critical path be just as fast if we remove the
      // else block and do the output_data read regardless?
      output_data <= data[input_address];
      valid = 1;
    end
  end
end

assign err_invalid_address = 
  (input_address > MEMORY_SIZE-1) || (input_address < 0) ? 1 : 0;

endmodule
