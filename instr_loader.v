// 2016 -- Ryan Leonard
// Instruction loading module that is hardcoded for fibbonacci

module instr_loader(
  clock,
  data,
  address
);

parameter MAX_ADDRESS = 64;

input wire clock;
output reg [31:0] data;
output reg [31:0] address;

// Fibbonaci instruction sequence
wire [31:0] fib_instr [0:44];

assign fib_instr[0]  = 32'h201d0100;
assign fib_instr[1]  = 32'h2010000c; // Fib(12) 
assign fib_instr[2]  = 32'hafb00000;
assign fib_instr[3]  = 32'h23bdfffc;
assign fib_instr[4]  = 32'h0c000009;
assign fib_instr[5]  = 32'h23bd0004;
assign fib_instr[6]  = 32'h8fb10000;
assign fib_instr[7]  = 32'hac110024;
assign fib_instr[8]  = 32'h0800002b;
assign fib_instr[9]  = 32'hafbf0000;
assign fib_instr[10] = 32'h23bdfffc;
assign fib_instr[11] = 32'hafbe0000;
assign fib_instr[12] = 32'h23bdfffc;
assign fib_instr[13] = 32'h23be000c;
assign fib_instr[14] = 32'h8fc80000;
assign fib_instr[15] = 32'h20090002;
assign fib_instr[16] = 32'h00005820;
assign fib_instr[17] = 32'h0128582a;
assign fib_instr[18] = 32'h15600002;
assign fib_instr[19] = 32'h20080001;
assign fib_instr[20] = 32'h08000023;
assign fib_instr[21] = 32'h2108ffff;
assign fib_instr[22] = 32'hafa80000;
assign fib_instr[23] = 32'h23bdfffc;
assign fib_instr[24] = 32'h0c000009;
assign fib_instr[25] = 32'h8fc80000;
assign fib_instr[26] = 32'h2108fffe;
assign fib_instr[27] = 32'hafa80000;
assign fib_instr[28] = 32'h23bdfffc;
assign fib_instr[29] = 32'h0c000009;
assign fib_instr[30] = 32'h23bd0004;
assign fib_instr[31] = 32'h8fa80000;
assign fib_instr[32] = 32'h23bd0004;
assign fib_instr[33] = 32'h8fa90000;
assign fib_instr[34] = 32'h01094020;
assign fib_instr[35] = 32'h23bd0004;
assign fib_instr[36] = 32'h8fbe0000;
assign fib_instr[37] = 32'h23bd0004;
assign fib_instr[38] = 32'h8fbf0000;
assign fib_instr[39] = 32'h23bd0004;
assign fib_instr[40] = 32'hafa80000;
assign fib_instr[41] = 32'h23bdfffc;
assign fib_instr[42] = 32'h03e00008;
assign fib_instr[43] = 32'h20000000;
assign fib_instr[44] = 32'h0800002b;

          // This block loops forever pumping out instructions and addresses
          // i is our iterator 
reg [31:0] i;
always @ (posedge clock) 
begin
  if (i < MAX_ADDRESS)
  begin
    data <= fib_instr[i];
    address <= i;
    i <= i+1;
  end
  else 
  begin
    data <= fib_instr[0];
    address <= 0;
    i <= 0;
  end
end

endmodule

  // Below is a collection of hardcoded instructions that we might want to put into
  // our instruction loader sometime...
  /*
     addi_t0_zero_6   = 32'h20080006,
     addi_t1_zero_11  = 32'h2009000B,
     addi_t0_t0_10    = 32'h2108000A,
     addi_t2_t1_240   = 32'h212A00F0,
     add_t2_t0_t1     = 32'h01095020,

     addi_t0_zero_5   = 32'h20080005,
     addi_t1_zero_9   = 32'h20090009,
     sw_t0_zero_0     = 32'hAC080000,
     sw_t1_zero_4     = 32'hAC090004,
     lw_t0_zero_4     = 32'h8C080004,


  // Begin branch assm:
  // https://github.com/jmahler/mips-cpu/blob/master/test/t0005-branch.asm
  addi_t0_zero_1   = 32'h2008_0001,
  addi_t1_zero_2   = 32'h2009_0002,
  addi_t0_t0_1     = 32'h2108_0001,
  beq_t0_t1_skip1  = 32'h1109_0002, // jump forward 2
  addi_t0_t0_255   = 32'h2108_00FF,
  addi_t1_t1_255   = 32'h2129_00FF,
  add_t0_t0_t1     = 32'h0109_4020,
  add_t1_t0_t1     = 32'h0109_4820,
  bne_t0_t1_skip2  = 32'h1509_0002, // jump forward 2
  addi_t0_t0_4095  = 32'h2108_0FFF,
  addi_t1_t1_4095  = 32'h2129_0FFF,

  // jump Testing
  //
  // 0: addi t0, 0, 255
  // 4: j 36
  // ...
  // 36: addi t1, 0, 255
  // 40: jal 80
  // 44: addi t0, 0, 4095
  // 48: j 88
  // ...
  // 80: add t2, t1, t0
  // 84: jr $31
  // 88: DONE
  addi_t0_zero_255      = 32'h2008_00FF,
  j_36                  = 32'h0800_0024,
  addi_t1_zero_255      = 32'h2009_00FF,
  jal_80                = 32'h0C00_0050,
  addi_t0_zero_4095     = 32'h2008_0FFF,
  j_88                  = 32'h0800_0058,
  //add_t2_t0_t1     = 32'h01095020,
  jr_ra                 = 32'h03E0_0008;

   */
