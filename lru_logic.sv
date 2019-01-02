module lru_logic
(
	input hit0,
	input hit1,
	input hit2,
	input hit3,
	input [2:0] lru_datain,
	output logic [2:0] lru_logic_out
);

always_comb
begin
	lru_logic_out = 0;
	if (hit0) begin
		lru_logic_out = {1'b1,1'b1, lru_datain[0]}; end
	if (hit1) begin
		lru_logic_out = {1'b1,1'b0, lru_datain[0]}; end
	if (hit2) begin
		lru_logic_out = {1'b0, lru_datain[1], 1'b1}; end
	if (hit3) begin
		lru_logic_out = {1'b0, lru_datain[1], 1'b0}; end
end

endmodule : lru_logic
