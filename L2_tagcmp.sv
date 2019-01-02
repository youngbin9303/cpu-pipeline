module L2_tagcmp
(
	input logic [22:0] a,
	input logic [22:0] b,
	output logic f
);

always_comb
begin
	if (a == b)
		f = 1'b1;
	else
		f = 1'b0;
end

endmodule : L2_tagcmp
