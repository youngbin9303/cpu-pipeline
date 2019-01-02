import rv32i_types::*;

/* L2 has 16 sets, so we need 4 bits for index */
/* For L2 addr is split like this [tag 31:9][index 8:5][offset 4:0], tag is now 23 bits */

module L2_cache_datapath(
	/* clk */
	input clk,

	/* datapath <-> control */
	input logic idling,
	input logic alloc,
	input logic w_back,
	output logic hit_any,
	output logic dirty0_out,
	output logic dirty1_out,
	output logic dirty2_out,
	output logic dirty3_out,
	output logic [1:0] lru_out,
	
	/* arbiter <-> cache */
	input logic mem_read,
	input logic mem_write,
	input rv32i_word mem_address,
	input [255:0] mem_wdata,
	output logic [255:0] mem_rdata,
	
	/* cache <-> memory */
	input logic [255:0] pmem_rdata,
	input logic pmem_resp,
	output rv32i_word pmem_address,
	output logic [255:0] pmem_wdata
);

logic [2:0] lru_logic_out;
logic [2:0] lru_arr_out;
logic [1:0] lru_sel;
logic tag_n_valid0_w_enable;
logic tag_n_valid1_w_enable;
logic tag_n_valid2_w_enable;
logic tag_n_valid3_w_enable;
logic data_n_dirty0_w_enable;
logic data_n_dirty1_w_enable;
logic data_n_dirty2_w_enable;
logic data_n_dirty3_w_enable;
logic hit0;
logic hit1;
logic hit2;
logic hit3;
logic [22:0] tag0_out;
logic [22:0] tag1_out;
logic [22:0] tag2_out;
logic [22:0] tag3_out;
logic valid0_out;
logic valid1_out;
logic valid2_out;
logic valid3_out;
logic tagcmp0_out;
logic tagcmp1_out;
logic tagcmp2_out;
logic tagcmp3_out;
logic [255:0] data_in;
logic [255:0] data0_out;
logic [255:0] data1_out;
logic [255:0] data2_out;
logic [255:0] data3_out;

assign lru_out = lru_sel;

mux8 #(.width(32)) pmem_addr_mux(
	.sel({w_back, lru_sel}),
	.a(mem_address),
	.b(mem_address),
	.c(mem_address),
	.d(mem_address),
	.e({tag0_out,mem_address[8:0]}),
	.g({tag1_out,mem_address[8:0]}),
	.h({tag2_out,mem_address[8:0]}),
	.i({tag3_out,mem_address[8:0]}),
	.f(pmem_address)
);

L2_array #(.width(256)) data0(
	.clk(clk),
   .write(data_n_dirty0_w_enable),
   .index(mem_address[8:5]),
   .datain(data_in),
   .dataout(data0_out)
);

L2_array #(.width(256)) data1(
	.clk(clk),
   .write(data_n_dirty1_w_enable),
   .index(mem_address[8:5]),
   .datain(data_in),
	.dataout(data1_out)
);

L2_array #(.width(256)) data2(
	.clk(clk),
   .write(data_n_dirty2_w_enable),
   .index(mem_address[8:5]),
   .datain(data_in),
	.dataout(data2_out)
);

L2_array #(.width(256)) data3(
	.clk(clk),
   .write(data_n_dirty3_w_enable),
   .index(mem_address[8:5]),
   .datain(data_in),
	.dataout(data3_out)
);

L2_array #(.width(23)) tag0(
	.clk(clk),
   .write(tag_n_valid0_w_enable),
   .index(mem_address[8:5]),
   .datain(mem_address[31:9]),
	.dataout(tag0_out)
);

L2_array #(.width(23)) tag1(
	.clk(clk),
   .write(tag_n_valid1_w_enable),
   .index(mem_address[8:5]),
   .datain(mem_address[31:9]),
	.dataout(tag1_out)
);

L2_array #(.width(23)) tag2(
	.clk(clk),
   .write(tag_n_valid2_w_enable),
   .index(mem_address[8:5]),
   .datain(mem_address[31:9]),
	.dataout(tag2_out)
);

L2_array #(.width(23)) tag3(
	.clk(clk),
   .write(tag_n_valid3_w_enable),
   .index(mem_address[8:5]),
   .datain(mem_address[31:9]),
	.dataout(tag3_out)
);


L2_array #(.width(1)) valid0(
	.clk(clk),
	.write(tag_n_valid0_w_enable),
	.index(mem_address[8:5]),
	.datain(alloc),
	.dataout(valid0_out)
);

L2_array #(.width(1)) valid1(
	.clk(clk),
	.write(tag_n_valid1_w_enable),
	.index(mem_address[8:5]),
	.datain(alloc),
	.dataout(valid1_out)
);

L2_array #(.width(1)) valid2(
	.clk(clk),
	.write(tag_n_valid2_w_enable),
	.index(mem_address[8:5]),
	.datain(alloc),
	.dataout(valid2_out)
);

L2_array #(.width(1)) valid3(
	.clk(clk),
	.write(tag_n_valid3_w_enable),
	.index(mem_address[8:5]),
	.datain(alloc),
	.dataout(valid3_out)
);

L2_array #(.width(1)) dirty0(
	.clk(clk),
	.write(data_n_dirty0_w_enable),
	.index(mem_address[8:5]),
	.datain(~alloc),
	.dataout(dirty0_out)
);

L2_array #(.width(1)) dirty1(
	.clk(clk),
	.write(data_n_dirty1_w_enable),
	.index(mem_address[8:5]),
	.datain(~alloc),
	.dataout(dirty1_out)
);

L2_array #(.width(1)) dirty2(
	.clk(clk),
	.write(data_n_dirty2_w_enable),
	.index(mem_address[8:5]),
	.datain(~alloc),
	.dataout(dirty2_out)
);

L2_array #(.width(1)) dirty3(
	.clk(clk),
	.write(data_n_dirty3_w_enable),
	.index(mem_address[8:5]),
	.datain(~alloc),
	.dataout(dirty3_out)
);

L2_array #(.width(3)) LRU(
	.clk(clk),
	.write(hit_any),
	.index(mem_address[8:5]),
	.datain(lru_logic_out), /* hit0 */
	.dataout(lru_arr_out)
);

lru_logic lru_logic
(
	.hit0(hit0),
	.hit1(hit1),
	.hit2(hit2),
	.hit3(hit3),
	.lru_datain(lru_arr_out),
	.lru_logic_out(lru_logic_out)
);

lru_mux lru_mux
(
	.lru_in(lru_arr_out),
	.lru_sel(lru_sel)
);

tagcmp #(.width(23)) tagcmp0(
	.a(tag0_out),
	.b(mem_address[31:9]),
	.f(tagcmp0_out)
);

tagcmp #(.width(23)) tagcmp1(
	.a(tag1_out),
	.b(mem_address[31:9]),
	.f(tagcmp1_out)
);

tagcmp #(.width(23)) tagcmp2(
	.a(tag2_out),
	.b(mem_address[31:9]),
	.f(tagcmp2_out)
);

tagcmp #(.width(23)) tagcmp3(
	.a(tag3_out),
	.b(mem_address[31:9]),
	.f(tagcmp3_out)
);

mux4 #(.width(256)) mem_rdata_mux(
	.sel({hit2 | hit3, hit1 | hit3}),
	.a(data0_out),
	.b(data1_out),
	.c(data2_out),
	.d(data3_out),
	.f(mem_rdata)
);

mux4 #(.width(256)) pmem_wdata_mux(
	.sel(lru_sel),
	.a(data0_out),
	.b(data1_out),
	.c(data2_out),
	.d(data3_out),
	.f(pmem_wdata)
);

mux2 #(.width(256)) data_to_arr0
(
	.sel((alloc)),
	.a(mem_wdata),
	.b(pmem_rdata),
	.f(data_in)
);

L2_enable_logic L2_enable_logic(
	.valid0(valid0_out),
	.valid1(valid1_out),
	.valid2(valid2_out),
	.valid3(valid3_out),
	.tagcmp0(tagcmp0_out),
	.tagcmp1(tagcmp1_out),
	.tagcmp2(tagcmp2_out),
	.tagcmp3(tagcmp3_out),
	.mem_write(mem_write),
	.pmem_resp(pmem_resp),
	.lru(lru_sel),
	.idling(idling),
	.alloc(alloc),
	.hit0(hit0),
	.hit1(hit1),
	.hit2(hit2),
	.hit3(hit3),
	.hit_any(hit_any),
	.tag_n_valid0_w_enable(tag_n_valid0_w_enable),
	.tag_n_valid1_w_enable(tag_n_valid1_w_enable),
	.tag_n_valid2_w_enable(tag_n_valid2_w_enable),
	.tag_n_valid3_w_enable(tag_n_valid3_w_enable),
	.data_n_dirty0_w_enable(data_n_dirty0_w_enable),
	.data_n_dirty1_w_enable(data_n_dirty1_w_enable),
	.data_n_dirty2_w_enable(data_n_dirty2_w_enable),
	.data_n_dirty3_w_enable(data_n_dirty3_w_enable)
);
endmodule : L2_cache_datapath