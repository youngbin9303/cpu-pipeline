import rv32i_types::*;

module cache
(
	/* clk */
	input clk,
	
	/* cpu <-> cache */
	input logic mem_read,
	input logic mem_write,
	input rv32i_word mem_address,
	input rv32i_word mem_wdata,
	input rv32i_mem_wmask mem_byte_enable,
	output logic mem_resp,
	output rv32i_word mem_rdata,
	
	/* cache <-> memory */
	input logic [255:0] pmem_rdata,
	input logic pmem_resp,
	output rv32i_word pmem_address,
	output logic [255:0] pmem_wdata,
	output logic pmem_read,
	output logic pmem_write
);

/* Internal Signals */
/* control -> datapath */
logic idling;
logic alloc;
logic w_back;

/* datapath -> control */
logic hit_any;
logic dirty0_out;
logic dirty1_out;
logic lru_out;


cache_control cache_control(
	.*
);

cache_datapath cache_datapath(
	.*
);

endmodule : cache