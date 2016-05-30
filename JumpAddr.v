// 2016 Ryan Leonard
// jump_addr Module
//

module jump_addr (
  jump_relative_addr,
  pc_upper,
  jump_addr
);

input wire [25:0] jump_relative_addr;
input wire [3:0]  pc_upper;
output reg [31:0] jump_addr;

always @(*)
begin
  jump_addr[27:0]  <= jump_relative_addr << 2;
  jump_addr[31:28] <= pc_upper;
end

endmodule
