import rv32i_types::*;

module ewb
(
	 /* clk */
    input clk,
	 
    /* L2_cache <-> ewb */
	 input mem_read,
	 input mem_write,
	 input rv32i_word mem_address,
	 input [255:0] mem_wdata,
	 output logic mem_resp,
	 output [255:0] mem_rdata,

    /* ewb <-> pmem */
	 input [255:0] pmem_rdata,
	 input pmem_resp,
	 output rv32i_word pmem_address, 
	 output [255:0] pmem_wdata,
	 output logic pmem_write,
	 output logic pmem_read
);

logic data_write;
logic hit;
logic data_sel;
logic mem_sig;

ewb_datapath ewb_datapath
(
	.*
);

ewb_control ewb_control
(
	.*
);

endmodule : ewb