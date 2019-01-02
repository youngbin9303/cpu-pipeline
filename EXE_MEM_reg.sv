import rv32i_types::*;

module EXE_MEM_reg
(
	input clk,
	input logic [1:0] load,
	input logic flush,
	input rv32i_word pc_in,
	input rv32i_word pc_plus4_in,
	input rv32i_word u_imm_in,
	input rv32i_word alu_in,
	input rv32i_word rs2_in,
	input logic br_en_in,
	input logic btb_hit_in,
	input logic btb_taken_in,
	input logic local_pred_in,
	input logic global_pred_in,
	input rv32i_control_word control_rom_in,
	input rv32i_reg rd_in,
	output rv32i_word pc_out,
	output rv32i_word pc_plus4_out,
	output rv32i_word u_imm_out,
	output rv32i_word alu_out,
	output rv32i_word rs2_out,
	output logic br_en_out,
	output logic local_pred_out,
	output logic global_pred_out,
	output logic btb_hit_out,
	output logic btb_taken_out,
	output rv32i_control_word control_rom_out,
	output rv32i_reg rd_out
);

rv32i_word pc_data;
rv32i_word pc_plus4_data;
rv32i_word u_imm_data;
rv32i_word alu_data;
rv32i_word rs2_data;
logic br_en_data;
rv32i_control_word control_rom_data;
rv32i_reg rd_data;
logic local_prediction;
logic global_prediction;
logic btb_hit;
logic btb_taken;

initial
begin
	pc_data = 0;
	pc_plus4_data = 0;
	u_imm_data = 0;
	alu_data = 0;
	rs2_data = 0;
	br_en_data = 0;
	control_rom_data = 0;
	rd_data = 0;
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
		u_imm_data <= 0;
		alu_data <= 0;
		rs2_data <= 0;
		br_en_data <= 0;
		control_rom_data <= 0;
		rd_data <= 0;
		local_prediction <= 0;
		global_prediction <= 0;
		btb_hit <= 0;
		btb_taken <= 0;
	end
	else if(load == 2'b11) begin
		pc_data <= pc_in;
		pc_plus4_data <= pc_plus4_in;
		u_imm_data <= u_imm_in;
		alu_data <= alu_in;
		rs2_data <= rs2_in;
		br_en_data <= br_en_in;
		control_rom_data <= control_rom_in;
		rd_data <= rd_in;
		local_prediction <= local_pred_in;
		global_prediction <= global_pred_in;
		btb_hit <= btb_hit_in;
		btb_taken <= btb_taken_in;

	end
	else if(load == 2'b10) begin
		pc_data <= pc_data;
		pc_plus4_data <= pc_plus4_data;
		u_imm_data <= u_imm_data;
		alu_data <= 0;
		rs2_data <= rs2_data;
		br_en_data <= br_en_data;
		control_rom_data.opcode <= op_imm;
		control_rom_data.aluop <= alu_add;
		rd_data <= 0;
		local_prediction <= local_prediction;
		global_prediction <= global_prediction;
		btb_hit <= btb_hit;
		btb_taken <= btb_taken;
	end
	
	else begin //load == 2'b00 & 2'b01
		pc_data <= pc_data;
		pc_plus4_data <= pc_plus4_data;
		u_imm_data <= u_imm_data;
		alu_data <= alu_data;
		rs2_data <= rs2_data;
		br_en_data <= br_en_data;
		control_rom_data <= control_rom_data;
		rd_data <= rd_data;
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
	u_imm_out = u_imm_data;
	alu_out = alu_data;
	rs2_out = rs2_data;
	br_en_out = br_en_data;
	control_rom_out = control_rom_data;
	rd_out = rd_data;
	local_pred_out = local_prediction;
	global_pred_out = global_prediction;
	btb_hit_out = btb_hit;
	btb_taken_out = btb_taken;
end

endmodule : EXE_MEM_reg