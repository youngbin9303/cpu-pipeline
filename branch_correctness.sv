import rv32i_types::*;

module branch_correctness 
(
	 input branch_result,
	 input exe_mem_pred,
	 input exe_mem_global,
	 output logic local_correctness,
	 output logic global_correctness
);

always_comb
begin
	local_correctness = ~(branch_result ^ exe_mem_pred);
	global_correctness = ~(branch_result ^ exe_mem_global);
end

endmodule : branch_correctness