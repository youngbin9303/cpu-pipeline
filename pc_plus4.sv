module pc_plus4 
(
	input logic [31:0] in,
	output logic [31:0] out
);

assign out = in + 3'b100;

endmodule : pc_plus4