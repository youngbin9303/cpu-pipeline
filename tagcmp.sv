module tagcmp #(parameter width = 32)
(
	input logic [width-1:0] a,
	input logic [width-1:0] b,
	output logic f
);

always_comb
begin
	if (a == b)
		f = 1'b1;
	else
		f = 1'b0;
end

endmodule : tagcmp
