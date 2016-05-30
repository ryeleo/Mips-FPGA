
// 2016 Ryan Leonard & Rui Tu

module cpu(
  clock
);

input wire clock;
input wire reset;
wire [31:0] imem_dec_instr;
wire [31:0] pc_imem_addr;

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
  .input_address(pc_imem_addr), // input data comes from pc
  .input_data(),                // this will be wired up with a loader module
  .output_data(imem_dec_instr), // the output is instructions
  .err_invalid_address()       // we don't care
);


wire [5:0] dec_opcode;
wire [5:0] dec_funct;
wire [4:0] dec_rf_readaddrs;
wire [4:0] dec_rf_readaddrt;
wire [4:0] dec_rfwritemux_a;
wire [4:0] dec_rfwritemux_b;
wire [15:0] dec_immediate;
wire [25:0] dec_jumptarg;
assign dec_rfwritemux_a = dec_rf_readaddrt;
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

wire [1:0] control_aluopraw;
wire [1:0] control_wbmux;
wire       control_memwrite;
wire       control_memread;
//  wire [] branch
wire       control_alusrcmux;
wire [1:0] control_rfwritemux;
wire       control_regwrite;
// wire [] jump;
// wire       err_illegal_opcode;
control_32 control (
    .opcode(dec_opcode),
    .funct(dec_funct),
    .alu_op(control_aluopraw),
    .mem_toreg(control_wbmux),
    .mem_write(control_memwrite),
    .mem_read(control_memread),
    .branch(),
    .alu_src(control_alusrcmux),
    .reg_dst(control_rfwritemux),
    .reg_write(control_regwrite),
    .jump(),
    .err_illegal_opcode()
);

wire [4:0]  rfwritemux_rf_writeaddr;
wire [4:0] rfwritemux_c;
assign rfwritemux_c = 31; // Hardcoded for jump and link instruction
mux3 #(.width(5)) rfwrite_mux (
  .input_a(dec_rfwritemux_a),
  .input_b(dec_rfwritemux_b),
  .input_c(rfwritemux_c),
  .choose(control_rfwritemux),
  .result(rfwritemux_rf_writeaddr)
);

wire [31:0] wbmux_rf_data;
wire [31:0] rf_alu_a;
wire [31:0] rf_alusrcmux_a;
wire [31:0] rf_mem_data;
assign rf_mem_data = rf_alusrcmux_a;
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


wire [31:0] sext_alusrcmux_b;
sign_extend_32 sign_ext(
  .input_16(dec_immediate),
  .result_32(sext_alusrcmux_b)
);

wire [31:0] alusrcmux_alu_b;
mux2 alusrc_mux(
  .input_a(rf_alusrcmux_a),
  .input_b(sext_alusrcmux_b),
  .choose(control_alusrcmux),
  .result(alusrcmux_alu_b)
);

wire [3:0] alucontrol_control;
alu_control_32 alu_control(
  .func(dec_funct),
  .alu_op(control_aluopraw),
  .alu_control(alucontrol_control),
  .err_illegal_alu_op(),
  .err_illegal_func_code()
);

// Zero will be hooked up to branch control
wire [31:0] alu_mem_addr;
wire [31:0] alu_wbmux_a;
assign alu_wbmux_a = alu_mem_addr;
alu_32 alu (
  .input_a(rf_alu_a),
  .input_b(alusrcmux_alu_b),
  .control(alucontrol_control),
  .result(alu_mem_addr),
  .zero(),
  .cout(),
  .err_overflow(),
  .err_invalid_control()
);

wire [31:0] mem_wbmux_b;
memory data_memory (
  .clock(clock),
  .input_address(alu_mem_addr),
  .input_data(rf_mem_data),
  .read_enabled(control_memread),
  .write_enabled(control_memwrite),
  .output_data(mem_wbmux_b),
  .err_invalid_address()
);

mux3 wb_mux(
  .input_a(alu_wbmux_a),
  .input_b(mem_wbmux_b),
  .input_c(),
  .choose(control_wbmux),
  .result(wbmux_rf_data)
);


/* =============================================================================== */








endmodule
