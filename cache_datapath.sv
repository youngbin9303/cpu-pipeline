import rv32i_types::*;

module cache_datapath(
	/* clk */
	input clk,

	/* datapath <-> control */
	input logic idling,
	input logic alloc,
	input logic w_back,
	output logic hit_any,
	output logic dirty0_out,
	output logic dirty1_out,
	output logic lru_out,
	
	/* cpu <-> cache */
	input logic mem_read,
	input logic mem_write,
	input rv32i_word mem_address,
	input rv32i_word mem_wdata,
	input rv32i_mem_wmask mem_byte_enable,
	output logic mem_resp,
	output logic [31:0] mem_rdata,
	
	/* cache <-> memory */
	input logic [255:0] pmem_rdata,
	input logic pmem_resp,
	output rv32i_word pmem_address,
	output logic [255:0] pmem_wdata
);

logic tag_n_valid0_w_enable;
logic tag_n_valid1_w_enable;
logic data_n_dirty0_w_enable;
logic data_n_dirty1_w_enable;
logic hit0;
logic hit1;
logic [23:0] tag0_out;
logic [23:0] tag1_out;
logic valid0_out;
logic valid1_out;
logic tagcmp0_out;
logic tagcmp1_out;
logic [255:0] data0_in;
logic [255:0] data0_out;
logic [255:0] data1_in;
logic [255:0] data1_out;
rv32i_word word_mux0_out;
rv32i_word word_mux1_out;

assign mem_resp = hit_any & (mem_read | mem_write);

mux4 #(.width(32)) pmem_addr_mux(
	.sel({w_back, lru_out}),
	.a(mem_address),
	.b(mem_address),
	.c({tag0_out,mem_address[7:0]}),
	.d({tag1_out,mem_address[7:0]}),
	.f(pmem_address)
);

array #(.width(256)) data0(
	.clk(clk),
   .write(data_n_dirty0_w_enable),
   .index(mem_address[7:5]),
   .datain(data0_in),
   .dataout(data0_out)
);


array #(.width(256)) data1(
	.clk(clk),
   .write(data_n_dirty1_w_enable),
   .index(mem_address[7:5]),
   .datain(data1_in),
	.dataout(data1_out)
);

array #(.width(24)) tag0(
	.clk(clk),
   .write(tag_n_valid0_w_enable),
   .index(mem_address[7:5]),
   .datain(mem_address[31:8]),
	.dataout(tag0_out)
);

array #(.width(24)) tag1(
	.clk(clk),
   .write(tag_n_valid1_w_enable),
   .index(mem_address[7:5]),
   .datain(mem_address[31:8]),
	.dataout(tag1_out)
);

array #(.width(1)) valid0(
	.clk(clk),
	.write(tag_n_valid0_w_enable),
	.index(mem_address[7:5]),
	.datain(alloc),
	.dataout(valid0_out)
);

array #(.width(1)) valid1(
	.clk(clk),
	.write(tag_n_valid1_w_enable),
	.index(mem_address[7:5]),
	.datain(alloc),
	.dataout(valid1_out)
);

array #(.width(1)) dirty0(
	.clk(clk),
	.write(data_n_dirty0_w_enable),
	.index(mem_address[7:5]),
	.datain(~alloc),
	.dataout(dirty0_out)
);

array #(.width(1)) dirty1(
	.clk(clk),
	.write(data_n_dirty1_w_enable),
	.index(mem_address[7:5]),
	.datain(~alloc),
	.dataout(dirty1_out)
);

array #(.width(1)) LRU(
	.clk(clk),
	.write(hit_any),
	.index(mem_address[7:5]),
	.datain(hit0),
	.dataout(lru_out)
);

tagcmp #(.width(24)) tagcmp0(
	.a(tag0_out),
	.b(mem_address[31:8]),
	.f(tagcmp0_out)
);

tagcmp #(.width(24)) tagcmp1(
	.a(tag1_out),
	.b(mem_address[31:8]),
	.f(tagcmp1_out)
);

mux8 #(.width(32)) word_mux0(
	.sel(mem_address[4:2]),
	.a(data0_out[31:0]),
	.b(data0_out[63:32]),
	.c(data0_out[95:64]),
	.d(data0_out[127:96]),
	.e(data0_out[159:128]),
	.g(data0_out[191:160]),
	.h(data0_out[223:192]),
	.i(data0_out[255:224]),
	.f(word_mux0_out)
);

mux8 #(.width(32)) word_mux1(
	.sel(mem_address[4:2]),
	.a(data1_out[31:0]),
	.b(data1_out[63:32]),
	.c(data1_out[95:64]),
	.d(data1_out[127:96]),
	.e(data1_out[159:128]),
	.g(data1_out[191:160]),
	.h(data1_out[223:192]),
	.i(data1_out[255:224]),
	.f(word_mux1_out)
);

mux2 #(.width(32)) mem_rdata_mux(
	.sel(hit1),
	.a(word_mux0_out),
	.b(word_mux1_out),
	.f(mem_rdata)
);

mux2 #(.width(256)) pmem_wdata_mux(
	.sel(lru_out),
	.a(data0_out),
	.b(data1_out),
	.f(pmem_wdata)
);

datain_logic datain0_logic(
	.hit(hit0),
	.offset(mem_address[4:2]),
	.byte_enable(mem_byte_enable),
	.mem_wdata(mem_wdata),
	.cache_data(data0_out),
	.pmem_rdata(pmem_rdata),
	.out(data0_in)
);

datain_logic datain1_logic(
	.hit(hit1),
	.offset(mem_address[4:2]),
	.byte_enable(mem_byte_enable),
	.mem_wdata(mem_wdata),
	.cache_data(data1_out),
	.pmem_rdata(pmem_rdata),
	.out(data1_in)
);

enable_logic enable_logic(
	.valid0(valid0_out),
	.valid1(valid1_out),
	.tagcmp0(tagcmp0_out),
	.tagcmp1(tagcmp1_out),
	.mem_write(mem_write),
	.pmem_resp(pmem_resp),
	.lru(lru_out),
	.idling(idling),
	.alloc(alloc),
	.hit0(hit0),
	.hit1(hit1),
	.hit_any(hit_any),
	.tag_n_valid0_w_enable(tag_n_valid0_w_enable),
	.tag_n_valid1_w_enable(tag_n_valid1_w_enable),
	.data_n_dirty0_w_enable(data_n_dirty0_w_enable),
	.data_n_dirty1_w_enable(data_n_dirty1_w_enable)
);
 
endmodule : cache_datapath