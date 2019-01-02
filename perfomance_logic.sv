import rv32i_types::*;

module perfomance_logic
(
	input rv32i_opcode opcode,
	input rv32i_word label_addr,
	output logic pc_flag
);

always_comb
begin
	if (opcode == op_load) begin
		if (label_addr[31:4] == 'hFFFFFFF) begin
			pc_flag = 1'b1;
		end
		else begin
		pc_flag = 1'b0;
		end
	end
	else begin
		pc_flag = 1'b0;
	end
end


endmodule : perfomance_logic