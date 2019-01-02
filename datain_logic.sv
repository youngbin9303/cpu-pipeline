module datain_logic(
	input logic hit,
	input [2:0] offset,
	input [3:0] byte_enable,
	input [31:0] mem_wdata,
	input [255:0] cache_data,
	input [255:0] pmem_rdata,
	output [255:0] out
);

logic [31:0] wdata0_out;
logic [31:0] wdata1_out;
logic [31:0] wdata2_out;
logic [31:0] wdata3_out;
logic [31:0] wdata4_out;
logic [31:0] wdata5_out;
logic [31:0] wdata6_out;
logic [31:0] wdata7_out;

mux4 word0
(
	.sel({(~hit),(offset==3'b000)}),
	.a(cache_data[31:0]),
	.b(wdata0_out),
	.c(pmem_rdata[31:0]),
	.d(pmem_rdata[31:0]),
	.f(out[31:0])
);

mux4 word1
(
	.sel({(~hit),(offset==3'b001)}),
	.a(cache_data[63:32]),
	.b(wdata1_out),
	.c(pmem_rdata[63:32]),
	.d(pmem_rdata[63:32]),
	.f(out[63:32])
);

mux4 word2
(
	.sel({(~hit),(offset==3'b010)}),
	.a(cache_data[95:64]),
	.b(wdata2_out),
	.c(pmem_rdata[95:64]),
	.d(pmem_rdata[95:64]),
	.f(out[95:64])
);

mux4 word3
(
	.sel({(~hit),(offset==3'b011)}),
	.a(cache_data[127:96]),
	.b(wdata3_out),
	.c(pmem_rdata[127:96]),
	.d(pmem_rdata[127:96]),
	.f(out[127:96])
);

mux4 word4
(
	.sel({(~hit),(offset==3'b100)}),
	.a(cache_data[159:128]),
	.b(wdata4_out),
	.c(pmem_rdata[159:128]),
	.d(pmem_rdata[159:128]),
	.f(out[159:128])
);

mux4 word5
(
	.sel({(~hit),(offset==3'b101)}),
	.a(cache_data[191:160]),
	.b(wdata5_out),
	.c(pmem_rdata[191:160]),
	.d(pmem_rdata[191:160]),
	.f(out[191:160])
);

mux4 word6
(
	.sel({(~hit),(offset==3'b110)}),
	.a(cache_data[223:192]),
	.b(wdata6_out),
	.c(pmem_rdata[223:192]),
	.d(pmem_rdata[223:192]),
	.f(out[223:192])
);

mux4 word7
(
	.sel({(~hit),(offset==3'b111)}),
	.a(cache_data[255:224]),
	.b(wdata7_out),
	.c(pmem_rdata[255:224]),
	.d(pmem_rdata[255:224]),
	.f(out[255:224])
);


concat32 wdata0
(
	.mem_wdata(mem_wdata),
	.cache_data(cache_data[31:0]),
	.byte_enable(byte_enable),
	.data(wdata0_out)
);

concat32 wdata1
(
	.mem_wdata(mem_wdata),
	.cache_data(cache_data[63:32]),
	.byte_enable(byte_enable),
	.data(wdata1_out)
);

concat32 wdata2
(
	.mem_wdata(mem_wdata),
	.cache_data(cache_data[95:64]),
	.byte_enable(byte_enable),
	.data(wdata2_out)
);

concat32 wdata3
(
	.mem_wdata(mem_wdata),
	.cache_data(cache_data[127:96]),
	.byte_enable(byte_enable),
	.data(wdata3_out)
);

concat32 wdata4
(
	.mem_wdata(mem_wdata),
	.cache_data(cache_data[159:128]),
	.byte_enable(byte_enable),
	.data(wdata4_out)
);

concat32 wdata5
(
	.mem_wdata(mem_wdata),
	.cache_data(cache_data[191:160]),
	.byte_enable(byte_enable),
	.data(wdata5_out)
);

concat32 wdata6
(
	.mem_wdata(mem_wdata),
	.cache_data(cache_data[223:192]),
	.byte_enable(byte_enable),
	.data(wdata6_out)
);


concat32 wdata7
(
	.mem_wdata(mem_wdata),
	.cache_data(cache_data[255:224]),
	.byte_enable(byte_enable),
	.data(wdata7_out)
);


endmodule : datain_logic