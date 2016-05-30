// 2016 Ryan Leonard
// Memory Module Testbench
//
//
module memory_32_test();

// setup our memory parameters 
localparam WORD_SIZE = 32;
localparam MEMORY_SIZE = 1000;
localparam ON   = 1'b1;
localparam OFF  = 1'b0;

// The reg/nets we will maniupulate/monitor for testing
reg clock;    
reg read_enabled;
reg write_enabled;
reg [WORD_SIZE-1:0]	address;  
reg [WORD_SIZE-1:0]	input_data;
wire error;
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
  .clock          (clock),
  .read_enabled   (read_enabled),
  .write_enabled  (write_enabled),
  .input_address  (address),
  .input_data     (input_data),
  .output_data    (output_data),
  .err_invalid_address  (error)
);

task reset();
begin
  read_enabled = OFF;
  write_enabled = OFF;
  address = OFF;  
  input_data = OFF;
end
endtask

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

  $display("==========\n Write Values (offset 200) \n");
  for (i=0; i<MEMORY_SIZE; i=i+200) 
  begin
    reset();
    write_enabled = ON;
    address = i; 
    input_data = i+1;
    #10;
  end

  $display("==========\nRead Values (offset 100) \n");
  for (i=0; i<MEMORY_SIZE; i=i+100) 
  begin
    reset();
    read_enabled = ON;
    address = i; 
    #10;
  end

  $display("==========\n Write then read max value at max addr \n");
  reset();
  write_enabled = ON;
  address = MEMORY_SIZE-1; 
  input_data = '1; // max number is all 1's
  #10;

  reset();
  read_enabled = ON;
  address = MEMORY_SIZE-1; 
  #10;

  $display("==========\n Try reading and writing to invalid address\n");
  reset();
  write_enabled = ON;
  address = MEMORY_SIZE; 
  #10;

  reset();
  read_enabled = ON;
  address = MEMORY_SIZE; 
  #10;

  reset();
  write_enabled = ON;
  address = -1; 
  #10;

  reset();
  read_enabled = ON;
  address = -1; 
  #10;
end

// Basic console output
initial 
begin
  $display("Time || address || input, output || error");
  $monitor("%d || %d || %d, %d || %b",
    $time, address, input_data, output_data, error);
end

endmodule
