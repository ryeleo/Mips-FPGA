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
reg [1:0] read_write_control; // = {1 --> read_enabled, 0 --> write_enabled};
localparam READ   = 2'b10;
localparam WRITE  = 2'b01;
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
  .read_enabled   (read_write_control[1]),
  .write_enabled  (read_write_control[0]),
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
    read_write_control = WRITE;
    address = i; 
    input_data = i+1;
    #10;
  end
  input_data = 0; // for readability in the tests...

  $display("==========\nRead Values (offset 100) \n");
  for (i=0; i<MEMORY_SIZE; i=i+100) 
  begin
    read_write_control = READ;
    address = i; 
    #10;
  end

  $display("==========\n Write then read max value at max addr \n");
  read_write_control = WRITE;
  address = MEMORY_SIZE-1; 
  input_data = '1; // max number is all 1's
  #10;
  read_write_control = READ;
  address = MEMORY_SIZE-1; 
  input_data = 0; // for readability
  #10;

  $display("==========\n Try reading and writing to invalid address\n");
  read_write_control = WRITE;
  address = MEMORY_SIZE; 
  input_data = '0;
  #10;
  read_write_control = READ;
  address = MEMORY_SIZE; 
  input_data = '0; 
  #10;
  read_write_control = WRITE;
  address = -1; 
  input_data = '0;
  #10;
  read_write_control = READ;
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
