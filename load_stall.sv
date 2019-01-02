import rv32i_types::*;

module load_stall_logic
(
	input sel,
	input rv32i_control_word a,
	input rv32i_control_word b,
	output logic rv32i_control_word f
);

always_comb
begin
	if (sel == 0)
		f = a;
	else
		f = b;
end

endmodule : load_stall_logic