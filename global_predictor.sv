import rv32i_types::*;

module global_predictor
(
	input clk,
	input [31:0] pc_in,
	input logic branch,
	input logic stall,
	input last_branch,
	input resp,
	output [3:0] bhr_out,
	output logic branch_decision
);

logic [3:0] index;
logic write;

shift_register shift_register
(
	.clk,
	.write((~stall) & branch),
	.datain(last_branch),
	.dataout(bhr_out)
);

pht pht
(
	.clk,
	.write((~stall) & branch),
	.index,
	.last_branch,
	.branch_predict(branch_decision)
);

assign index = bhr_out ^ pc_in[5:2];

endmodule : global_predictor