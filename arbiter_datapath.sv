import rv32i_types::*;

module arbiter_datapath(
	/* cache1 -> arbiter */
	input rv32i_word cache1_address,
	input logic [255:0] cache1_wdata,
	
	/* cache2 -> arbiter */
	input rv32i_word cache2_address,
	input logic [255:0] cache2_wdata,
	
	/* control -> datapath */
	input logic cache_sel,
	
	/* arbiter -> memory */
	output rv32i_word pmem_address,
	output logic [255:0] pmem_wdata
	 
 /*
	input [255:0] pmem_rdata,
	output logic [255:0] cache1_rdata,
	output logic [255:0] cache2_rdata */
);


mux2 pmem_address_mux
(
	.sel(cache_sel),
	.a(cache1_address),
	.b(cache2_address),
	.f(pmem_address)
);

mux2 #(.width(256)) pmem_wdata_mux
(
	.sel(cache_sel),
	.a(cache1_wdata),
	.b(cache2_wdata),
	.f(pmem_wdata)
);

endmodule : arbiter_datapath