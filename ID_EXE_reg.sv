import rv32i_types::*;

module ID_EXE_reg
(
	input clk,
	input logic load,
	input logic flush,
	input logic local_pred_in,
	input logic global_pred_in,
	input logic btb_hit_in,
	input logic btb_taken_in,
	input rv32i_word pc_in,
	input rv32i_word pc_plus4_in,
	input rv32i_word u_imm_in,
	input rv32i_word rs1_in,
	input rv32i_word rs2_in,
	input rv32i_word alu_input2_in,
	input rv32i_control_word control_rom_in, 
	input rv32i_reg reg1_in,
	input rv32i_reg reg2_in,
	input rv32i_reg rd_in,
	output rv32i_word pc_out,
	output logic local_pred_out,
	output logic global_pred_out,
	output logic btb_hit_out,
	output logic btb_taken_out,
	output rv32i_word pc_plus4_out,
	output rv32i_word u_imm_out,
	output rv32i_word rs1_out,
	output rv32i_word rs2_out,
	output rv32i_word alu_input2_out,
	output rv32i_control_word control_rom_out,
	output rv32i_reg reg1_out,
	output rv32i_reg reg2_out,
	output rv32i_reg rd_out
);

rv32i_word pc_data;
rv32i_word pc_plus4_data;
rv32i_word u_imm_data;
rv32i_word rs1_data;
rv32i_word rs2_data;
rv32i_word alu_input2_data;
rv32i_control_word control_rom_data;
rv32i_reg reg1_data;
rv32i_reg reg2_data;
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
	rs1_data = 0;
	rs2_data = 0;
	alu_input2_data = 0;
	control_rom_data = 0;
	reg1_data = 0;
	reg2_data = 0;
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
		rs1_data <= 0;
		rs2_data <= 0;
		alu_input2_data <= 0;
		control_rom_data <= 0;
		reg1_data <= 0;
		reg2_data <= 0;
		rd_data <= 0;
		local_prediction <= 0;
		global_prediction <= 0;
		btb_hit <= 0;
		btb_taken <= 0;
	end
	else if(load) begin
		pc_data <= pc_in;
		pc_plus4_data <= pc_plus4_in;
		u_imm_data <= u_imm_in;
		rs1_data <= rs1_in;
		rs2_data <= rs2_in;
		alu_input2_data <= alu_input2_in;
		control_rom_data <= control_rom_in;
		reg1_data <= reg1_in;
		reg2_data <= reg2_in;
		rd_data <= rd_in;
		local_prediction <= local_pred_in;
		global_prediction <= global_pred_in;
		btb_hit <= btb_hit_in;
		btb_taken <= btb_taken_in;
	end
	else begin
		pc_data <= pc_data;
		pc_plus4_data <= pc_plus4_data;
		u_imm_data <= u_imm_data;
		rs1_data <= rs1_data;
		rs2_data <= rs2_data;
		alu_input2_data <= alu_input2_data;
		control_rom_data <= control_rom_data;
		reg1_data <= reg1_data;
		reg2_data <= reg2_data;
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
	rs1_out = rs1_data;
	rs2_out = rs2_data;
	alu_input2_out = alu_input2_data;
	control_rom_out = control_rom_data;
	reg1_out = reg1_data;
	reg2_out = reg2_data;
	rd_out = rd_data;
	local_pred_out = local_prediction;
	global_pred_out = global_prediction;
	btb_hit_out = btb_hit;
	btb_taken_out = btb_taken;

end

endmodule : ID_EXE_reg