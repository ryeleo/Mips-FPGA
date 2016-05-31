// 2016 Ryan Leonard & Rui Tu & Frank Arana

module cpu(
  clock,
  reset
);
input wire clock;
input wire reset;

wire [31:0] mem_wbmux_b;
wire [31:0] pcincadder_wbmux_pcp4;
wire [31:0] sext_alusrcmux_b;
wire [31:0] alusrcmux_alu_b;
wire [3:0] alucontrol_control;
// Zero will be hooked up to branch control
wire [31:0] alu_mem_addr;
wire [31:0] alu_wbmux_a;
wire alu_branchcontrol_zero;
wire [31:0] imem_dec_instr;
wire [31:0] pc_imem_addr;
wire [31:0] jumpmux_pc;
wire [31:0] pc_inc_advance;
wire [31:0] pc_pcincadder;
wire [31:0] pcincadder_branchmux_a;
wire [31:0] pcincadder_branchadder;
wire [31:0] sext_branchadder;
wire [31:0] branchadder_branchmux_b;
wire branchcontrol_branchmux;
wire [31:0] branchmux_jumpmux_a;
wire [3:0] pcincadder_jumpaddr;
wire [31:0] ja_jumpmux_b;
wire [4:0]  rfwritemux_rf_writeaddr;
wire [4:0] rfwritemux_c;
wire [31:0] wbmux_rf_data;
wire [31:0] rf_alu_a;
wire [31:0] rf_alusrcmux_a;
wire [31:0] rf_mem_data;
wire [31:0] rf_jumpmux_c;
wire [5:0] dec_opcode;
wire [5:0] dec_funct;
wire [4:0] dec_rf_readaddrs;
wire [4:0] dec_rf_readaddrt;
wire [4:0] dec_rfwritemux_a;
wire [4:0] dec_rfwritemux_b;
wire [15:0] dec_immediate;
wire [25:0] dec_jumptarg;
wire [1:0] control_aluopraw;
wire [1:0] control_wbmux;
wire       control_memwrite;
wire       control_memread;
wire       control_alusrcmux;
wire [1:0] control_rfwritemux;
wire       control_regwrite;
wire [1:0] control_jumpmux;
wire [1:0] control_branch;

assign dec_rfwritemux_a = dec_rf_readaddrt;
assign rf_mem_data = rf_alusrcmux_a;
assign rf_jumpmux_c = rf_alu_a;
assign pcincadder_jumpaddr = pcincadder_branchmux_a[31:28];
assign sext_branchadder = sext_alusrcmux_b << 2; //Left shift 2 bits before branch adder. From sext
assign pcincadder_wbmux_pcp4 = pcincadder_branchmux_a;
assign pc_inc_advance = 4;
assign alu_wbmux_a = alu_mem_addr;
assign pc_pcincadder = pc_imem_addr;
assign pcincadder_branchadder = pcincadder_branchmux_a;
assign rfwritemux_c = 31; // Hardcoded for jump and link instruction

// Our instruction memory is 32 bit addressed (instruction length), but we are
// given addresses that are byte (8bit addressed). 
// Based on the MIPS RISC
// implementation, we drop the bottom two bits, essentially dividing by 4.
wire [31:0] pc_imem_addrshifted = pc_imem_addr >> 2;
pc pc(
  .clock(clock),
  .reset(reset),
  .pc_in(jumpmux_pc),
  .pc_out(pc_imem_addr)
);

memory instruction_memory ( 
  .clock(clock),
  .write_enabled(),             // this will be wired up with a loader module
  .read_enabled(),              // not now
  .input_address(pc_imem_addrshifted), // input data comes from pc
  .input_data(),                // this will be wired up with a loader module
  .output_data(imem_dec_instr), // the output is instructions
  .err_invalid_address()       // we don't care
);

decoder_32 decode(
  .instruction(imem_dec_instr),
  .opcode(dec_opcode),
  .rs(dec_rf_readaddrs),
  .rt(dec_rf_readaddrt),
  .rd(dec_rfwritemux_b),
  .shamt(),
  .funct(dec_funct),
  .immediate(dec_immediate),
  .jump_target(dec_jumptarg)
);

control_32 control (
    .opcode(dec_opcode),
    .funct(dec_funct),
    .alu_op(control_aluopraw),
    .mem_toreg(control_wbmux),
    .mem_write(control_memwrite),
    .mem_read(control_memread),
    .branch(control_branch),
    .alu_src(control_alusrcmux),
    .reg_dst(control_rfwritemux),
    .reg_write(control_regwrite),
    .jump(control_jumpmux),
    .err_illegal_opcode()
);

mux3 #(.width(5)) rfwrite_mux (
  .input_a(dec_rfwritemux_a),
  .input_b(dec_rfwritemux_b),
  .input_c(rfwritemux_c),
  .choose(control_rfwritemux),
  .result(rfwritemux_rf_writeaddr)
);

rf_32 regfile (
  .clock(clock),
  .read_addr_s(dec_rf_readaddrs),
  .read_addr_t(dec_rf_readaddrt),
  .write_addr(rfwritemux_rf_writeaddr),
  .write_data(wbmux_rf_data),
  .write_enabled(control_regwrite),
  .read_enabled(),
  .outA(rf_alu_a),
  .outB(rf_alusrcmux_a)
);


sign_extend_32 sign_ext(
  .input_16(dec_immediate),
  .result_32(sext_alusrcmux_b)
);

mux2 alusrc_mux(
  .input_a(rf_alusrcmux_a),
  .input_b(sext_alusrcmux_b),
  .choose(control_alusrcmux),
  .result(alusrcmux_alu_b)
);

alu_control_32 alu_control(
  .func(dec_funct),
  .alu_op(control_aluopraw),
  .alu_control(alucontrol_control),
  .err_illegal_alu_op(),
  .err_illegal_func_code()
);

alu_32 alu (
  .input_a(rf_alu_a),
  .input_b(alusrcmux_alu_b),
  .control(alucontrol_control),
  .result(alu_mem_addr),
  .zero(alu_branchcontrol_zero),
  .cout(),
  .err_overflow(),
  .err_invalid_control()
);

// data memory is also 32 bit addressed -- same logic as instruction memory:
// we drop the bottom two bits, essentially dividing by 4.
wire [31:0] alu_mem_addrshifted = alu_mem_addr >> 2;
memory data_memory (
  .clock(clock),
  .input_address(alu_mem_addrshifted),
  .input_data(rf_mem_data),
  .read_enabled(control_memread),
  .write_enabled(control_memwrite),
  .output_data(mem_wbmux_b),
  .err_invalid_address()
);

mux3 wb_mux(
  .input_a(alu_wbmux_a),
  .input_b(mem_wbmux_b),
  .input_c(pcincadder_wbmux_pcp4),
  .choose(control_wbmux),
  .result(wbmux_rf_data)
);

adder pc_inc_adder(
  .input_a(pc_pcincadder),
  .input_b(pc_inc_advance),
  .result(pcincadder_branchmux_a)
);

jump_addr jumpaddr(
  .jump_relative_addr(dec_jumptarg),
  .pc_upper(pcincadder_jumpaddr),
  .jump_addr(ja_jumpmux_b)
);

adder branch_adder(
  .input_a(pcincadder_branchadder),
  .input_b(sext_branchadder),
  .result(branchadder_branchmux_b)
);

branch_control branch_control(
  .branch_op(control_branch),
  .zero(alu_branchcontrol_zero),
  .do_branch(branchcontrol_branchmux)
);

mux2 branch_mux(
  .input_a(pcincadder_branchmux_a),
  .input_b(branchadder_branchmux_b),
  .choose(branchcontrol_branchmux),
  .result(branchmux_jumpmux_a)
);

mux3 jump_mux(
  .input_a(branchmux_jumpmux_a),
  .input_b(ja_jumpmux_b),
  .input_c(rf_jumpmux_c),
  .choose(control_jumpmux),
  .result(jumpmux_pc)
);

endmodule
