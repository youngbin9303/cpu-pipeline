import rv32i_types::*;

module cache_latch
(
	input clk,
	
	/* L1 and Arbiter <---> Latch */
	input rv32i_word addr_in,
	input read_in,
	input write_in, 
	input [255:0] wdata_in,
	output logic [255:0] rdata_out,
	output logic mem_resp_out,
	
	/* Latch <---> L2 */
	output logic [31:0] addr_out,
	output logic read_out,
	output logic write_out,
	output logic [255:0] wdata_out,
	input [255:0] rdata_in,
	input mem_resp_in
);

logic [255:0] rdata;
logic [255:0] wdata;
logic read;
logic write;
logic mem_resp;
logic resp_on;
logic temp;
rv32i_word addr;

always_ff @(posedge clk)
begin
	rdata <= rdata_in;
	wdata <= wdata_in;
	read <= read_in;
	write <= write_in;
	resp_on <= mem_resp_in;
	temp <= mem_resp;
	addr <= addr_in;
end

assign mem_resp = resp_on != mem_resp_in && (mem_resp_in);

always_comb
begin
	addr_out = addr;
	read_out = read;
	write_out = write;
	wdata_out = wdata;
	rdata_out = rdata;
	mem_resp_out = temp;
end

endmodule : cache_latch