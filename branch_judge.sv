import rv32i_types::*;

module branch_judge
(
	 input branch_tf,
	 input rv32i_control_word ctrl,
	 output logic out
);

always_comb
begin
	if(ctrl.opcode == op_br | ctrl.opcode == op_jal | ctrl.opcode == op_jalr)
		if(branch_tf == 1)
			out = 1;
		else
			out = 0;
	else
		out = 0;
end

endmodule : branch_judge