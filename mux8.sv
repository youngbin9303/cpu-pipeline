module mux8 #(parameter width = 32)
(
	input logic [2:0] sel,
	input logic[width-1:0] a, b, c, d, e, g, h, i,
	output logic [width-1:0] f
);
always_comb
begin
	if (sel == 3'b000)
		f = a;
	else if (sel == 3'b001)
		f = b;
	else if (sel == 3'b010)
		f = c;
	else if (sel == 3'b011)
		f = d;
	else if (sel == 3'b100)
		f = e;
	else if (sel == 3'b101)
		f = g;
	else if (sel == 3'b110)
		f = h;
	else
		f = i;
end
endmodule : mux8