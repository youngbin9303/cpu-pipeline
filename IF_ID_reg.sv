import rv32i_types::*;

module IF_ID_reg
(
	input clk,
	input logic load,
	input logic flush,
	input rv32i_word pc_in,
	input rv32i_word pc_plus4_in,
	input rv32i_word i_cache_data_in,
	input logic local_pred,
	input logic global_pred,
	input logic btb_hit_in,
	input logic btb_taken_in,
	output rv32i_word pc_out,
	output rv32i_word pc_plus4_out,
	output logic [2:0] funct3_out,
	output logic [6:0] funct7_out,
	output logic local_pred_out,
	output logic global_pred_out,
	output rv32i_opcode opcode_out,
	output logic btb_hit_out,
	output logic btb_taken_out,
	output rv32i_word i_imm_out,
	output rv32i_word s_imm_out,
	output rv32i_word b_imm_out,
	output rv32i_word u_imm_out,
	output rv32i_word j_imm_out,
	output rv32i_reg rs1_out,
	output rv32i_reg rs2_out,
	output rv32i_reg rd_out
);

rv32i_word pc_data;
rv32i_word pc_plus4_data;
rv32i_word i_cache_data;
logic local_prediction;
logic global_prediction;
logic btb_hit;
logic btb_taken;

initial
begin
	pc_data = 0;
	pc_plus4_data = 0;
	i_cache_data = 0;
	local_prediction = 0;
	global_prediction = 0;
	btb_hit = 0;
	btb_taken = 0;
end


always_ff @(posedge clk)
begin
	if(flush) begin
		pc_data <= 0;
		pc_plus4_data <= 0;
		i_cache_data <= 0;
		local_prediction <= 0;
		global_prediction <= 0;
		btb_hit <= 0;
		btb_taken <= 0;
	end
	else if(load) begin
		pc_data <= pc_in;
		pc_plus4_data <= pc_plus4_in;
		i_cache_data <= i_cache_data_in;
		local_prediction <= local_pred;
		global_prediction <= global_pred;
		btb_hit <= btb_hit_in;
		btb_taken <= btb_taken_in;
	end
	else begin
		pc_data <= pc_data;
		pc_plus4_data <= pc_plus4_data;
		i_cache_data <= i_cache_data;
		local_prediction <= local_prediction;
		global_prediction <= global_prediction;
		btb_hit <= btb_hit;
		btb_taken <= btb_taken;
	end
end

always_comb
begin
	pc_out = pc_data;
	pc_plus4_out = pc_plus4_data;
	funct3_out = i_cache_data[14:12];
	funct7_out = i_cache_data[31:25];
	opcode_out = rv32i_opcode'(i_cache_data[6:0]);
	i_imm_out = {{21{i_cache_data[31]}}, i_cache_data[30:20]};
	s_imm_out = {{21{i_cache_data[31]}}, i_cache_data[30:25], i_cache_data[11:7]};
	b_imm_out = {{20{i_cache_data[31]}}, i_cache_data[7], i_cache_data[30:25], i_cache_data[11:8], 1'b0};
	u_imm_out = {i_cache_data[31:12], 12'h000};
	j_imm_out = {{12{i_cache_data[31]}}, i_cache_data[19:12], i_cache_data[20], i_cache_data[30:21], 1'b0};
	rs1_out = i_cache_data[19:15];
	rs2_out = i_cache_data[24:20];
	rd_out = i_cache_data[11:7];
	local_pred_out = local_prediction;
	global_pred_out = global_prediction;
	btb_hit_out = btb_hit;
	btb_taken_out = btb_taken;
end

endmodule : IF_ID_reg