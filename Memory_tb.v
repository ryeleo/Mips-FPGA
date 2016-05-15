// 2016 Ryan Leonard
// Memory Module Testbench
//
//
module memory_tb ();

// setup our memory parameters 
localparam WORD_SIZE = 32;
localparam MEMORY_SIZE = 1000;

// The reg/nets we will maniupulate/monitor for testing
reg clock;    
reg write_enabled;
wire valid;
wire error;
reg [WORD_SIZE-1:0]	address;  
reg [WORD_SIZE-1:0]	input_data;
wire [WORD_SIZE-1:0]	output_data;

// build a version of the Design Under Test (dut)
//  Instead of hand controlling the 'start' signal, we will
//  hook it up to the clock so that every clock cycle we will
//  attempt to perform either a read or a write to memory.
memory
#(
  .WORD_SIZE (WORD_SIZE), 
  .MEMORY_SIZE (MEMORY_SIZE)
) dut(
  .start          (clock),
  .write_enabled  (write_enabled),
  .address        (address),
  .input_data     (input_data),
  .valid          (valid),
  .output_data    (output_data),
  .err_invalid_address  (error)
);

// Clock Generator (#10 period)
initial 
begin
  clock = 1; 
  #5;
  forever
  begin
    clock = ~clock; 
    #5;
  end
end

integer i;
initial
begin // BEG Test stimulus
  #20;

  $display("==========\n Write Values (offset 200) \n");
  for (i=0; i<MEMORY_SIZE; i=i+200) 
  begin
    write_enabled = 1;
    address = i; 
    input_data = i+1;
    #10;
  end
  input_data = 0; // for readability in the tests...

  $display("==========\nRead Values (offset 100) \n");
  write_enabled = 0;
  for (i=0; i<MEMORY_SIZE; i=i+100) 
  begin
    write_enabled = 0;
    address = i; 
    #10;
  end

  $display("==========\n Write then read max value at max addr \n");
  write_enabled = 1;
  address = MEMORY_SIZE-1; 
  input_data = '1; // max number is all 1's
  #10;
  write_enabled = 0;
  address = MEMORY_SIZE-1; 
  input_data = 0; // for readability
  #10;

  $display("==========\n Try reading and writing to invalid address\n");
  write_enabled = 1;
  address = MEMORY_SIZE; 
  input_data = '0;
  #10;
  write_enabled = 0;
  address = MEMORY_SIZE; 
  input_data = '0; 
  #10;
  write_enabled = 1;
  address = -1; 
  input_data = '0;
  #10;
  write_enabled = 0;
  address = -1; 
  input_data = '0; 
  #10;
end

// Basic console output
initial 
begin
  $display("Time || address || input, output || valid, error");
  $monitor("%d || %d || %d, %d || %b, %b",
    $time, address, input_data, output_data, valid, error);
end

endmodule
