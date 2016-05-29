// 2016 Ryan Leonard
// jump_addr Module Testbench
//

module jump_addr_test;
reg [25:0] jump_relative_addr;
reg [3:0] pc_upper;
wire [31:0] jump_addr;

jump_addr dut(jump_relative_addr, pc_upper, jump_addr);

initial
begin // BEG Test stimulus
  $monitor("relativeaddr: %h, pcupper: %h || jumpaddr: %h", jump_relative_addr, pc_upper, jump_addr);
  jump_relative_addr = 26'h1;
  pc_upper = 'h0;
  #10;

  jump_relative_addr = 26'h0;
  pc_upper = 4'hF;
  #10;

  jump_relative_addr = 26'h1;
  pc_upper = 4'hF;
  #10;

  jump_relative_addr = 26'h2AAAAAA;
  pc_upper = 4'hF;
  #10;
  jump_relative_addr = 26'h0CCCCCC;
  pc_upper = 4'hF;
  #10;

  jump_relative_addr = 26'h3FFFFFF;
  pc_upper = 4'hF;
  #10;
  
end

endmodule
