module btb_take_logic(
	input logic btb_hit,
	input logic btb_uncond,
	input logic prediction,
	output logic btb_take
);

assign btb_take = btb_hit & (btb_uncond | prediction);

endmodule : btb_take_logic