import rv32i_types::*;

module L2_cache
(
	/* clk */
	input clk,
	
	/* arbiter <-> L2_cache */
	input logic mem_read,
	input logic mem_write,
	input rv32i_word mem_address,
	input [255:0] mem_wdata,
	output logic mem_resp,
	output [255:0] mem_rdata,
	
	/* L2_cache <-> pmem */
	input logic [255:0] pmem_rdata,
	input logic pmem_resp,
	output rv32i_word pmem_address,
	output logic [255:0] pmem_wdata,
	output logic pmem_read,
	output logic pmem_write
);

/* datapath <-> control */
logic idling;
logic alloc;
logic w_back;
logic hit_any;
logic dirty0_out;
logic dirty1_out;
logic dirty2_out;
logic dirty3_out;
logic [1:0] lru_out;

L2_cache_control L2_cache_control(
	.*
);

L2_cache_datapath L2_cache_datapath(
	.*
);

endmodule : L2_cache