import rv32i_types::*;

module ewb_datapath
(
	input clk,
	input data_write, 
	input data_sel,
	input mem_sig,
	input rv32i_word mem_address,
	input [255:0] mem_wdata, 
	input [255:0] pmem_rdata,
	output rv32i_word pmem_address,
	output [255:0] pmem_wdata, 
	output [255:0] mem_rdata,
	output logic hit
);

rv32i_word mem_address_out;
logic [255:0] mem_data;

assign pmem_wdata = mem_data;


always_comb
begin
	if (mem_sig)
		pmem_address = mem_address_out;
	else
		pmem_address = mem_address;
end

logic mem_valid_out;

always_comb
begin
	if (mem_address == mem_address_out && mem_valid_out)
		hit = 1;
	else
		hit = 0;
end

register #(.width(256)) data
(
	.clk,
   .load(data_write),
   .in(mem_wdata),
   .out(mem_data)
);

register #(.width(32)) address
(
	.clk,
   .load(data_write),
   .in(mem_address),
   .out(mem_address_out)
);

register #(.width(1)) valid
(
	.clk,
	.load(data_write),
	.in(1'b1),
	.out(mem_valid_out)
);

mux2 #(.width(256)) data_read_mux
(
	.sel(data_sel),
	.a(mem_data),
	.b(pmem_rdata),
	.f(mem_rdata)
);
endmodule : ewb_datapath