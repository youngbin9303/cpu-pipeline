import rv32i_types::*;

module btb_datapath(
	/* clk */
	input clk,
	
	/* cpu <-> btb */
	input logic write,
	input logic is_jal,
	input rv32i_word pc,
	input rv32i_word write_pc,
	input rv32i_word write_next_pc,
	output logic hit,
	output logic uncond,
	output rv32i_word next_pc
);

logic [22:0] tag_out;
logic valid_out;
logic btb_tagcmp_out;
logic [6:0] index_mux_out;

mux2 #(.width(7)) index_mux(
	.sel(write),
	.a(pc[8:2]),
	.b(write_pc[8:2]),
	.f(index_mux_out)
);

btb_array #(.width(32)) data(
	.clk(clk),
   .write(write),
   .index(index_mux_out),
   .datain(write_next_pc),
   .dataout(next_pc)
);

btb_array #(.width(23)) tag(
	.clk(clk),
   .write(write),
   .index(index_mux_out),
   .datain(write_pc[31:9]),
	.dataout(tag_out)
);

btb_array #(.width(1)) valid(
	.clk(clk),
   .write(write),
   .index(index_mux_out),
   .datain(write),
	.dataout(valid_out)
);

btb_array #(.width(1)) unconditional(
	.clk(clk),
   .write(write),
   .index(index_mux_out),
   .datain(is_jal),
	.dataout(uncond)
);

tagcmp #(.width(23)) tagcmp(
	.a(tag_out),
	.b(pc[31:9]),
	.f(btb_tagcmp_out)
);

assign hit = btb_tagcmp_out & valid_out & (~write);

endmodule : btb_datapath