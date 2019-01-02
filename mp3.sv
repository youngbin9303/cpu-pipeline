import rv32i_types::*;

module mp3
(
	/* clk */
	input logic clk,
	
	/* pmem <-> L2 */
	input logic [255:0] pmem_rdata,
	input logic pmem_resp,
	
	output rv32i_word pmem_address,
	output logic [255:0] pmem_wdata,
	output logic pmem_read,
	output logic pmem_write
);

/* Internal Signals */
/* cpu <-> i_cache */
rv32i_word i_cache_address;
logic i_cache_read;
logic i_cache_write;
rv32i_mem_wmask i_cache_wmask;
logic i_cache_resp;
rv32i_word i_cache_rdata;
rv32i_word i_cache_wdata;

/* cpu <-> d_cache */
rv32i_word d_cache_address;
logic d_cache_read;
logic d_cache_write;
rv32i_mem_wmask d_cache_wmask;
logic d_cache_resp;
rv32i_word d_cache_rdata;
rv32i_word d_cache_wdata;

/* i_cache <-> arbiter */
rv32i_word i_cache_arbiter_addr;
logic i_cache_arbiter_read;
logic i_cache_arbiter_write;
logic [255:0] i_cache_arbiter_wdata;
logic arbiter_i_cache_resp;
logic [255:0] i_arbiter_rdata;

/* d_cache <-> arbiter */
rv32i_word d_cache_arbiter_addr;
logic d_cache_arbiter_read;
logic d_cache_arbiter_write;
logic [255:0] d_cache_arbiter_wdata;
logic arbiter_d_cache_resp;
logic [255:0] d_arbiter_rdata;

/* arbiter <--> cache_latch */
rv32i_word cache_latch_addr;
logic cache_latch_read;
logic cache_latch_write;
logic [255:0] cache_latch_rdata;
logic [255:0] cache_latch_wdata;
logic cache_latch_resp;

/* cache_latch <-> L2 cache */
rv32i_word L2_cache_addr;
logic L2_cache_read;
logic L2_cache_write;
logic [255:0] L2_cache_rdata;
logic [255:0] L2_cache_wdata;
logic L2_cache_resp;


/* L2 cache <-> ewb */
rv32i_word ewb_cache_addr;
logic ewb_cache_read;
logic ewb_cache_write;
logic [255:0] ewb_cache_rdata;
logic [255:0] ewb_cache_wdata;
logic ewb_cache_resp;


cpu cpu
(
	.*
);

cache i_cache
(
	/* clk */
	.clk(clk),
	
	/* cpu -> i_cache */
	.mem_address(i_cache_address),
	.mem_read(i_cache_read),
	.mem_write(i_cache_write),
	.mem_byte_enable(i_cache_wmask),
	.mem_wdata(i_cache_wdata),
	
	/* i_cache -> cpu */
	.mem_resp(i_cache_resp),
	.mem_rdata(i_cache_rdata),
	
	/* arbiter -> i_cache */
	.pmem_resp(arbiter_i_cache_resp),
	.pmem_rdata(i_arbiter_rdata),
	
	/* i_cache -> arbiter */
	.pmem_address(i_cache_arbiter_addr),
	.pmem_read(i_cache_arbiter_read),
	.pmem_write(i_cache_arbiter_write),
	.pmem_wdata(i_cache_arbiter_wdata)
);

cache d_cache
(
	/* clk */
	.clk(clk),
	
	/* cpu -> d_cache */
	.mem_address(d_cache_address),
	.mem_read(d_cache_read),
	.mem_write(d_cache_write),
	.mem_byte_enable(d_cache_wmask),
	.mem_wdata(d_cache_wdata),
	
	/* d_cache -> cpu */
	.mem_resp(d_cache_resp),
	.mem_rdata(d_cache_rdata),
	
	/* arbiter -> d_cache */
	.pmem_resp(arbiter_d_cache_resp),
	.pmem_rdata(d_arbiter_rdata),
	
	/* d_cache -> arbiter */
	.pmem_address(d_cache_arbiter_addr),
	.pmem_read(d_cache_arbiter_read),
	.pmem_write(d_cache_arbiter_write),
	.pmem_wdata(d_cache_arbiter_wdata)	
);

arbiter arbiter(
	/* clk */
	.clk,
	
	/* i_cache <-> arbiter */
	.cache1_address(i_cache_arbiter_addr),
	.cache1_read(i_cache_arbiter_read),
	.cache1_write(i_cache_arbiter_write),
	.cache1_wdata(i_cache_arbiter_wdata),
	.cache1_resp(arbiter_i_cache_resp),
	.cache1_rdata(i_arbiter_rdata),
	
	/* d_cache <-> arbiter */
	.cache2_address(d_cache_arbiter_addr),
	.cache2_read(d_cache_arbiter_read),
	.cache2_write(d_cache_arbiter_write),
	.cache2_wdata(d_cache_arbiter_wdata),
	.cache2_resp(arbiter_d_cache_resp),
	.cache2_rdata(d_arbiter_rdata),
	
	/* arbiter <-> cache_latch */
	.pmem_rdata(cache_latch_rdata),
	.pmem_resp(cache_latch_resp),
	.pmem_wdata(cache_latch_wdata),
	.pmem_address(cache_latch_addr),
	.pmem_read(cache_latch_read),
	.pmem_write(cache_latch_write)
);

cache_latch cache_latch
(
	.clk,
	/* L1 and Arbiter <---> Latch */
	.addr_in(cache_latch_addr),
	.read_in(cache_latch_read),
	.write_in(cache_latch_write), 
	.wdata_in(cache_latch_wdata),
	.rdata_out(cache_latch_rdata),
	.mem_resp_out(cache_latch_resp),
	
	/* cache_latch <---> L2 */
	.addr_out(L2_cache_addr),
	.read_out(L2_cache_read),
	.write_out(L2_cache_write),
	.wdata_out(L2_cache_wdata),
	.rdata_in(L2_cache_rdata),
	.mem_resp_in(L2_cache_resp)
);

L2_cache L2_cache
(
	.clk,
	/* arbiter <-> L2_cache */
	.mem_read(L2_cache_read),
	.mem_write(L2_cache_write),
	.mem_address(L2_cache_addr),
	.mem_wdata(L2_cache_wdata),
	.mem_resp(L2_cache_resp),
	.mem_rdata(L2_cache_rdata),
	
	/* L2_cache <-> ewb */
	
	.pmem_rdata(ewb_cache_rdata),
	.pmem_resp(ewb_cache_resp),
	.pmem_address(ewb_cache_addr),
	.pmem_wdata(ewb_cache_wdata),
	.pmem_read(ewb_cache_read),
	.pmem_write(ewb_cache_write)
		
	
);

ewb ewb
(
	.clk,
	/* L2_cache <-> ewb */
	.mem_read(ewb_cache_read),
	.mem_write(ewb_cache_write),
	.mem_address(ewb_cache_addr),
	.mem_wdata(ewb_cache_wdata),
	.mem_resp(ewb_cache_resp),
	.mem_rdata(ewb_cache_rdata),   
	
	/* ewb <-> pmem */
	.pmem_rdata,
	.pmem_resp,
	.pmem_address,
	.pmem_wdata,
	.pmem_read,
	.pmem_write
);



endmodule : mp3