import rv32i_types::*;

module arbiter(
	/* clk */
	input clk,
	
	/* cache1 <-> arbiter */
	input rv32i_word cache1_address,
	input logic cache1_read,
	input logic cache1_write,
	input logic [255:0] cache1_wdata,
	output logic cache1_resp,
	output logic [255:0] cache1_rdata,
	
	/* cache2 <-> arbiter */
	input rv32i_word cache2_address,
	input logic cache2_read,
	input logic cache2_write,
	input logic [255:0] cache2_wdata,
	output logic cache2_resp,
	output logic [255:0] cache2_rdata,
	
	/* arbiter <-> memory */
	input [255:0] pmem_rdata,
	input logic pmem_resp,
	output logic [255:0] pmem_wdata,
	output rv32i_word pmem_address,
	output logic pmem_read,
	output logic pmem_write
);

/* control -> datapath */
logic cache_sel;

arbiter_datapath aribiter_datapath(
	.*
);

arbiter_control arbiter_control(
	.*
);

endmodule : arbiter