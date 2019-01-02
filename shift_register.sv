module shift_register #(parameter width = 4)
(
	input clk,
	input write,
	input datain,
	output logic [width-1:0] dataout
);

logic [width-1:0] data;

initial
begin
	data = 0;
end

always_ff @(negedge clk)
begin
	if (write) begin
		data = data << 1;
		data[0] = datain;
	end
end

assign dataout = data;

endmodule : shift_register