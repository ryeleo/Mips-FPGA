// 2016 Ryan Leonard
// ALU Module
//
//

module (
  jump_relative_addr,
  pc_upper,
  jump_address
);

input wire [25:0] jump_relative_addr;
input wire [3:0] pc_upper;
output reg [31:0] jump_addr;

always @(*)
begin
  jump_addr <= {pc_upper, jump_relative_addr << 2};
end

endmodule
