module concat32
(
	input [31:0] mem_wdata,
	input [31:0] cache_data,
	input [3:0] byte_enable,
	output logic [31:0] data
);

mux2 #(.width(8)) wdata0
(
	.sel(byte_enable[0]),
	.a(cache_data[7:0]),
	.b(mem_wdata[7:0]),
	.f(data[7:0])
);

mux2 #(.width(8)) wdata1
(
	.sel(byte_enable[1]),
	.a(cache_data[15:8]),
	.b(mem_wdata[15:8]),
	.f(data[15:8])
);

mux2 #(.width(8)) wdata2
(
	.sel(byte_enable[2]),
	.a(cache_data[23:16]),
	.b(mem_wdata[23:16]),
	.f(data[23:16])
);

mux2 #(.width(8)) wdata3
(
	.sel(byte_enable[3]),
	.a(cache_data[31:24]),
	.b(mem_wdata[31:24]),
	.f(data[31:24])
);

endmodule : concat32