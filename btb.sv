import rv32i_types::*;

module btb
(
	/* clk */
	input clk,
	
	/* cpu -> btb */
	input rv32i_word pc,
	input logic is_jal,
	input logic write,
	input rv32i_word write_pc,
	input rv32i_word write_next_pc,
	
	/* btb -> cpu */
	output logic hit,
	output logic uncond,
	output logic resp,
	output rv32i_word next_pc
);

btb_datapath btb_datapath(
	.*
);

btb_control btb_control(
	.*
);

endmodule : btb