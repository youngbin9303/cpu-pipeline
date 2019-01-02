import rv32i_types::*;

module cpu
(
	/* clk */
   input clk,
	
	/* i cache signals*/
	input rv32i_word i_cache_rdata,
	input i_cache_resp,
	output rv32i_word i_cache_address,
	output rv32i_word i_cache_wdata,
	output rv32i_mem_wmask i_cache_wmask,
	output logic i_cache_read,
	output logic i_cache_write,
	 
	/* d cache signals*/
	input rv32i_word d_cache_rdata,
	input d_cache_resp,
	output rv32i_word d_cache_address,
	output rv32i_word d_cache_wdata,
	output rv32i_mem_wmask d_cache_wmask,
	output logic d_cache_read,
	output logic d_cache_write	
);

/* Internal Signals */
/* unused i_cache write related signals */
assign i_cache_wdata = 32'b0;
assign i_cache_wmask = 4'b0;
assign i_cache_write = 1'b0;

/* IF */
rv32i_word pc_mux_out;
rv32i_word pc_out;
rv32i_word pc_plus4_out;
logic btb_hit;
logic btb_uncond;
rv32i_word btb_next_pc;
rv32i_word pc_plus4_btb_mux_out;
logic btb_resp;
logic btb_take_logic_out;

/* IF/ID */
rv32i_word if_id_pc_out;
rv32i_word if_id_pc_plus4_out;
logic if_id_btb_taken_out;
logic if_id_btb_hit_out;
logic [2:0] if_id_funct3_out;
logic [6:0] if_id_funct7_out;
rv32i_opcode if_id_opcode_out;
rv32i_word if_id_i_imm_out;
rv32i_word if_id_s_imm_out;
rv32i_word if_id_b_imm_out;
rv32i_word if_id_u_imm_out;
rv32i_word if_id_j_imm_out;
rv32i_reg if_id_rs1_out;
rv32i_reg if_id_rs2_out;
rv32i_reg if_id_rd_out;

/* ID */
rv32i_word regfile_rs1_out;
rv32i_word regfile_rs2_out;
rv32i_word alu_input2_mux_out;
rv32i_control_word control_rom_out;

/* ID/EXE */
rv32i_word id_exe_pc_out;
rv32i_word id_exe_pc_plus4_out;
logic id_exe_btb_taken_out;
logic id_exe_btb_hit_out;
rv32i_word id_exe_i_imm_out;
rv32i_word id_exe_u_imm_out;
rv32i_word id_exe_rs1_out;
rv32i_word id_exe_rs2_out;
rv32i_word id_exe_alu_input2_out;
rv32i_control_word id_exe_control_rom_out; 
rv32i_reg id_exe_reg1_out;
rv32i_reg id_exe_reg2_out;
rv32i_reg id_exe_rd_out;

/* EXE */
rv32i_word alu_input1_mux_out;
rv32i_word alu_out;
rv32i_word cmp_mux_out;
logic cmp_br_en_out;

/* Forwarding */
logic [1:0] forward_sel_A;
logic [1:0] forward_sel_B;
logic [1:0] forward_sel_C;
logic forward_sel_D;
rv32i_word forwarding_rs1_out;
rv32i_word forwarding_rs2_out;
rv32i_word forwarding_rs3_out;

/* EXE/MEM */
rv32i_word exe_mem_pc_out;
rv32i_word exe_mem_pc_plus4_out;
logic exe_mem_btb_hit_out;
logic exe_mem_btb_taken_out;
rv32i_word exe_mem_u_imm_out;
rv32i_word exe_mem_alu_out;
rv32i_word exe_mem_rs2_out;
logic exe_mem_br_en_out;
rv32i_reg exe_mem_rd_out;
rv32i_control_word exe_mem_control_rom_out;


/* MEM */
rv32i_mem_wmask aligned_d_cache_wmask;
rv32i_word aligned_d_cache_wdata;
rv32i_word aligned_d_cache_rdata;
rv32i_word jalr_mux_out;
rv32i_word regfile_mux_out;
rv32i_word jump_pc_mux_out;
logic jump_logic_out;
logic do_jump;
logic update_btb;

/* MEM/WB */
rv32i_word mem_wb_d_cache_data_out;
rv32i_control_word mem_wb_control_rom_out;
rv32i_reg mem_wb_rd_out;
rv32i_word mem_wb_rd_data_out;

/* WB */
rv32i_word rd_data_mux_out;

/* flush */
logic flush;

/* stall */
logic stall;
logic stall_final;
logic if_id_stall;
logic mem_wb_stall;
logic stall_check;

/* branch predictor */
logic branch_result;
logic local_branch_predictor;
logic global_branch_predictor;
logic tournament_result;
logic if_id_pred;
logic id_exe_pred;
logic exe_mem_pred;
logic id_exe_global;
logic if_id_global;
logic exe_mem_global;
logic local_correctness;
logic global_correctness;
logic [3:0] history;


/*
 * IF
 */
branch_correctness branch_correctness
(
	 .branch_result(exe_mem_br_en_out),
	 .exe_mem_pred(exe_mem_pred),
	 .exe_mem_global(exe_mem_global),
	 .local_correctness(local_correctness),
	 .global_correctness(global_correctness)
);
 
local_branch local_branch
(
	 .clk,
	 .stall(stall_final),
	 .branch(exe_mem_control_rom_out.branch),
	 .br_en(exe_mem_br_en_out),
	 .prediction(local_branch_predictor)
); 

global_predictor global_predictor
(
	.clk,
	.pc_in(exe_mem_pc_out),
	.resp(btb_resp),
	.stall(stall),
	.branch(exe_mem_control_rom_out.branch),
	.last_branch(exe_mem_br_en_out),
	.bhr_out(history),
	.branch_decision(global_branch_predictor)
); 

tournament tournament
(
	 .clk,
	 .stall(stall_final),
	 .correctness({local_correctness, global_correctness}), 
	 .branch(exe_mem_control_rom_out.branch),
	 .history(history[1:0]),
	 .tournament_result(tournament_result)
);

pc_register pc
(
    .clk,
    .load(~stall_final),
    .in(pc_mux_out),
    .out(pc_out)
);

pc_plus4 pc_plus4
(
    .in(pc_out),
	 .out(pc_plus4_out)
);

mux2 pc_mux
(
	 .sel(do_jump),
    .a(pc_plus4_btb_mux_out),
    .b(jump_pc_mux_out),
    .f(pc_mux_out)
);

btb btb(
	.clk(clk),
	.pc(pc_out),
	.is_jal(exe_mem_control_rom_out.jump),
	.write(update_btb),
	.write_pc(exe_mem_pc_out),
	.write_next_pc(jalr_mux_out),
	.hit(btb_hit),
	.uncond(btb_uncond),
	.next_pc(btb_next_pc),
	.resp(btb_resp)
);

btb_take_logic btb_take_logic(
	.btb_hit(btb_hit),
	.btb_uncond(btb_uncond),
	.prediction(tournament_result),
	.btb_take(btb_take_logic_out)
);

mux2 pc_plus4_btb_mux(
	.sel(btb_take_logic_out),
	.a(pc_plus4_out),
	.b(btb_next_pc),
	.f(pc_plus4_btb_mux_out)
);


assign i_cache_address = pc_out;
assign i_cache_read = ~do_jump;


/*
 * IF/ID Buffer
 */
IF_ID_reg IF_ID_reg
(
	.clk,
	.load(~stall_final),
	.flush(flush),
	.local_pred(local_branch_predictor),
	.global_pred(global_branch_predictor),
	.btb_hit_in(btb_hit),
	.btb_taken_in(btb_take_logic_out),
	.pc_in(pc_out),
	.pc_plus4_in(pc_plus4_out),
	.i_cache_data_in(i_cache_rdata),
	.pc_out(if_id_pc_out),
	.pc_plus4_out(if_id_pc_plus4_out),
	.funct3_out(if_id_funct3_out),
	.funct7_out(if_id_funct7_out),
	.opcode_out(if_id_opcode_out),
	.i_imm_out(if_id_i_imm_out),
	.s_imm_out(if_id_s_imm_out),
	.b_imm_out(if_id_b_imm_out),
	.u_imm_out(if_id_u_imm_out),
	.j_imm_out(if_id_j_imm_out),
	.local_pred_out(if_id_pred),
	.global_pred_out(if_id_global),
	.btb_hit_out(if_id_btb_hit_out),
	.btb_taken_out(if_id_btb_taken_out),
	.rs1_out(if_id_rs1_out),
	.rs2_out(if_id_rs2_out),
	.rd_out(if_id_rd_out)
);


/*
 * ID
 */
regfile regfile
(
    .clk,
	 .load(mem_wb_control_rom_out.load_regfile),
	 .in(rd_data_mux_out),
	 .src_a(if_id_rs1_out),
	 .src_b(if_id_rs2_out),
	 .dest(mem_wb_rd_out),
	 .reg_a(regfile_rs1_out),
	 .reg_b(regfile_rs2_out)
);

mux8 alu_input2_mux
(
    .sel(control_rom_out.alu_input2_mux_sel),
	 .a(if_id_i_imm_out),
	 .b(if_id_u_imm_out),
	 .c(if_id_b_imm_out),
	 .d(if_id_s_imm_out),
	 .e(if_id_j_imm_out),
	 .g(regfile_rs2_out),
	 .h({32{1'b0}}),
	 .i({32{1'b0}}),
	 .f(alu_input2_mux_out)
);

control_rom control_rom
(
	.opcode(if_id_opcode_out),
	.funct3(if_id_funct3_out),
	.funct7(if_id_funct7_out),
	.ctrl(control_rom_out)
);


/*
 * ID/EXE Buffer
 */
ID_EXE_reg ID_EXE_reg
(
	.clk(clk),
	.load(~stall_final),
	.flush(flush),
	.pc_in(if_id_pc_out),
	.pc_plus4_in(if_id_pc_plus4_out),
	.btb_hit_in(if_id_btb_hit_out),
	.btb_taken_in(if_id_btb_taken_out),
	.local_pred_in(if_id_pred),
	.global_pred_in(if_id_global),
	.u_imm_in(if_id_u_imm_out),
	.rs1_in(regfile_rs1_out),
	.rs2_in(regfile_rs2_out),
	.alu_input2_in(alu_input2_mux_out),
	.control_rom_in(control_rom_out),
	.reg1_in(if_id_rs1_out),
	.reg2_in(if_id_rs2_out),
	.rd_in(if_id_rd_out),
	.pc_out(id_exe_pc_out),
	.pc_plus4_out(id_exe_pc_plus4_out),
	.local_pred_out(id_exe_pred),
	.global_pred_out(id_exe_global),
	.u_imm_out(id_exe_u_imm_out),
	.rs1_out(id_exe_rs1_out),
	.rs2_out(id_exe_rs2_out),
	.alu_input2_out(id_exe_alu_input2_out),
	.control_rom_out(id_exe_control_rom_out),
	.btb_hit_out(id_exe_btb_hit_out),
	.btb_taken_out(id_exe_btb_taken_out),
	.reg1_out(id_exe_reg1_out),
	.reg2_out(id_exe_reg2_out),
	.rd_out(id_exe_rd_out)
);


/*
 * EXE
 */
mux2 alu_input1_mux
(
    .sel(id_exe_control_rom_out.alu_input1_mux_sel),
	 .a(forwarding_rs1_out),
	 .b(id_exe_pc_out),
	 .f(alu_input1_mux_out)
); 

alu alu
(
    .aluop(id_exe_control_rom_out.aluop),
	 .a(alu_input1_mux_out),
	 .b(forwarding_rs2_out),
	 .f(alu_out)
);

mux2 cmp_mux
(
    .sel(id_exe_control_rom_out.cmp_mux_sel),
	 .a(forwarding_rs3_out),
	 .b(id_exe_i_imm_out),
	 .f(cmp_mux_out)
);

cmp cmp
(
    .sel(id_exe_control_rom_out.cmpop),
	 .a(forwarding_rs1_out),
	 .b(cmp_mux_out),
	 .f(cmp_br_en_out)
);

/* Forwarding */

data_forwarding data_forwarding
(
	.ex_control(id_exe_control_rom_out),
	.mem_control(exe_mem_control_rom_out),
	.wb_control(mem_wb_control_rom_out),
	.mem_dest(exe_mem_rd_out),
	.wb_dest(mem_wb_rd_out),
	.ex_src_A(id_exe_reg1_out),
	.ex_src_B(id_exe_reg2_out),
	.sel_A(forward_sel_A),
	.sel_B(forward_sel_B),
	.sel_C(forward_sel_C),
	.sel_D(forward_sel_D)
);

mux4 fowarding_rs1
(
	.sel(forward_sel_A),
	.a(id_exe_rs1_out),
	.b(rd_data_mux_out),
	.c(exe_mem_alu_out),
	.d(32'b0),
	.f(forwarding_rs1_out)
);

/* muxed alu_input2 */

mux4 fowarding_rs2
(
	.sel(forward_sel_B),
	.a(id_exe_alu_input2_out),
	.b(rd_data_mux_out),
	.c(exe_mem_alu_out),
	.d(32'b0),
	.f(forwarding_rs2_out)
);

mux4 fowarding_rs3
(
	.sel(forward_sel_C),
	.a(id_exe_rs2_out),
	.b(rd_data_mux_out),
	.c(exe_mem_alu_out),
	.d(32'b0),
	.f(forwarding_rs3_out)
);


/*
 * EXE/MEM Buffer
 */
EXE_MEM_reg EXE_MEM_reg
(
	.clk(clk),
	.load({~stall, ~stall_check}),
	.flush(flush),
	.pc_in(id_exe_pc_out),
	.pc_plus4_in(id_exe_pc_plus4_out),
	.btb_hit_in(id_exe_btb_hit_out),
	.btb_taken_in(id_exe_btb_taken_out),
	.local_pred_in(id_exe_pred),
	.global_pred_in(id_exe_global),
	.u_imm_in(id_exe_u_imm_out),
	.alu_in(alu_out),
	.rs2_in(id_exe_rs2_out),
	.br_en_in(cmp_br_en_out),
	.control_rom_in(id_exe_control_rom_out),
	.rd_in(id_exe_rd_out),
	.pc_out(exe_mem_pc_out),
	.pc_plus4_out(exe_mem_pc_plus4_out),
	.local_pred_out(exe_mem_pred),
	.global_pred_out(exe_mem_global),
	.u_imm_out(exe_mem_u_imm_out),
	.alu_out(exe_mem_alu_out),
	.rs2_out(exe_mem_rs2_out),
	.br_en_out(exe_mem_br_en_out),
	.btb_hit_out(exe_mem_btb_hit_out),
	.btb_taken_out(exe_mem_btb_taken_out),
	.control_rom_out(exe_mem_control_rom_out),
	.rd_out(exe_mem_rd_out)
);


/*
 * MEM
 */
assign d_cache_address = exe_mem_alu_out;
assign d_cache_wdata = aligned_d_cache_wdata;
assign d_cache_wmask = aligned_d_cache_wmask;
assign d_cache_read = exe_mem_control_rom_out.d_cache_read;
assign d_cache_write = exe_mem_control_rom_out.d_cache_write;

wdata_align_logic wdata_align_logic(
	.offset(exe_mem_alu_out[1:0]),
	.str_op(exe_mem_control_rom_out.str_op),
	.wdata(exe_mem_rs2_out),
	.aligned_wmask(aligned_d_cache_wmask),
	.aligned_wdata(aligned_d_cache_wdata)
);

mux2 jalr_mux
(
    .sel(exe_mem_control_rom_out.aluop == op_jalr),
	 .a(exe_mem_alu_out),
	 .b({exe_mem_alu_out[31:1], {1'b0}}),
	 .f(jalr_mux_out)
);

mux2 jump_pc_mux(
	.sel(exe_mem_btb_taken_out),
	.a(jalr_mux_out),
	.b(exe_mem_pc_plus4_out),
	.f(jump_pc_mux_out)
);

mux4 regfile_mux
(
    .sel(exe_mem_control_rom_out.regfile_mux_sel),
	 .a(exe_mem_alu_out),
	 .b({{31'b0}, exe_mem_br_en_out}),
	 .c(exe_mem_u_imm_out),
	 .d(exe_mem_pc_plus4_out),
	 .f(regfile_mux_out)
);

jump_logic jump_logic(
	.br_en(exe_mem_br_en_out),
	.branch(exe_mem_control_rom_out.branch),
	.jump(exe_mem_control_rom_out.jump),
	.btb_hit(exe_mem_btb_hit_out),
	.btb_taken(exe_mem_btb_taken_out),
	.do_jump(do_jump),
	.update_btb(update_btb)
);

rdata_align_logic rdata_align_logic
(
	.offset(exe_mem_alu_out[1:0]),
	.ldr_op(exe_mem_control_rom_out.ldr_op),
	.rdata(d_cache_rdata),
	.aligned_rdata(aligned_d_cache_rdata)
);


/*
 * MEM/WB Buffer
 */
MEM_WB_reg MEM_WB_reg
(
	.clk(clk),
	.load(~stall),
	.rd_data_in(regfile_mux_out),
	.d_cache_data_in(aligned_d_cache_rdata),
	.control_rom_in(exe_mem_control_rom_out),
	.rd_in(exe_mem_rd_out),
	.rd_data_out(mem_wb_rd_data_out),
	.d_cache_data_out(mem_wb_d_cache_data_out),
	.control_rom_out(mem_wb_control_rom_out),
	.rd_out(mem_wb_rd_out)
);


/*
 * WB
 */
mux2 rd_data_mux(
	.sel(mem_wb_control_rom_out.opcode == op_load),
	.a(mem_wb_rd_data_out),
	.b(mem_wb_d_cache_data_out),
	.f(rd_data_mux_out)
);


/* Flush Logic */
assign flush = do_jump & ((~update_btb) | btb_resp);

/* Stall Logic */
assign if_id_stall = (i_cache_read & (~i_cache_resp)) | (update_btb & (~btb_resp));
assign mem_wb_stall = (d_cache_read | d_cache_write) & (~d_cache_resp);
assign stall = if_id_stall | mem_wb_stall;
assign stall_check = forward_sel_D & (pc_out != 32'h00000060) & (pc_out != 32'h00000064) & (pc_out != 32'h00000068);
assign stall_final = stall | stall_check;

endmodule : cpu