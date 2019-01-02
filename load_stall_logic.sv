import rv32i_types::*;

module load_stall_logic(
	input sel,
	input rv32i_control_word a,
	output rv32i_control_word f,
	input rv32i_control_word b
);

always_comb
begin
	if (sel == 0)
		f = a;
	else
		f = b;
end

endmodule : load_stall_logic