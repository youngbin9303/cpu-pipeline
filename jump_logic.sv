module jump_logic(
	input logic br_en,
	input logic branch,
	input logic jump,
	input logic btb_hit,
	input logic btb_taken,
	output logic do_jump,
	output logic update_btb
);

assign do_jump = ((br_en & branch) | jump) ^ btb_taken;
assign update_btb = (branch | jump) & ~btb_hit;

endmodule : jump_logic