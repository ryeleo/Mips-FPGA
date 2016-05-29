// Rui Tu
module branch_control(
  branch_op,
  zero,
  branch_sig
);

  input wire [1:0] branch_op;
  input wire       zero;
  output reg       do_branch;

  always@(*) begin
    // do_branch will be 1 if we are going to use a branch
    do_branch <= (branch_op[0] ^ zero) & branch_op[1];
  end

endmodule
