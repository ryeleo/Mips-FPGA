module instr_loader_test;

reg clock;
wire [31:0] data;
wire [31:0] addr;
instr_loader dut(
  .clock(clock),
  .data(data),
  .address(addr)
);

task assert_equal(
  input [31:0] expected,
  input [31:0] observed);
  begin
    if (expected != observed)
      $display("ASSERTION EQUAL FAIL: %p != %p", expected, observed);
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
begin
  $monitor("data %h, address %d", data, addr);
  #10;
  $display("=====\nChecking increment behavior\n");
  for (i = 0; i < dut.MAX_ADDRESS; i = i + 1)
  begin
    #10;
    assert_equal(i, addr);
  end

  $display("=====\nChecking modulo behavior -- addr should be zero\n");
  #10;
  assert_equal(0, addr);

  $display("Letting run for one more whole cycle -- addr should be zero again\n");
  #(10 * dut.MAX_ADDRESS);
  $display("DONE");
end


endmodule 
