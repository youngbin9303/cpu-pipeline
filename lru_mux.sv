module lru_mux
(
	input [2:0] lru_in,
	output logic [1:0] lru_sel
);

always_comb
begin
	case(lru_in)
		3'b000: lru_sel = 2'b00;
		3'b001: lru_sel = 2'b00;
		3'b010: lru_sel = 2'b01;
		3'b011: lru_sel = 2'b01;
		3'b100: lru_sel = 2'b10;
		3'b101: lru_sel = 2'b11;
		3'b110: lru_sel = 2'b10;
		3'b111: lru_sel = 2'b11;
	endcase
end

endmodule : lru_mux