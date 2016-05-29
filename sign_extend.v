module sign_extend_32(
  input wire [15:0] input_16,
  output reg [31:0] result_32
);

always @(*) begin
  result_32[15:0] <= input_16;
  case (input_16[15]) 
    1'b0: result_32 [31:16] <= '0;
    1'b1: result_32 [31:16] <= '1;
  endcase
end
endmodule
