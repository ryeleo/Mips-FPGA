module sign_extend_32(
  input wire [15:0] input_16,
  output reg [31:0] result_32
);

always @(*) begin
  result_32[15:0] <= input_16;
  case (input_16[15]) 
    1'b0: result_32 [31:16] <= 16'h0000;
    1'b1: result_32 [31:16] <= 16'h1111;
  endcase
end
endmodule
