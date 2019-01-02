import rv32i_types::*;

module rdata_align_logic
(
	input [1:0] offset,
	input load_funct3_t ldr_op,
	input rv32i_word rdata,
	
	output rv32i_word aligned_rdata
);

logic [7:0] lb_mux_out;
logic [15:0] lh_mux_out;
rv32i_word lb_out;
rv32i_word lbu_out;
rv32i_word lh_out;
rv32i_word lhu_out;

mux4 #(.width(8)) lb_mux(
    .sel(offset),
	 .a(rdata[7:0]),
	 .b(rdata[15:8]),
	 .c(rdata[23:16]),
	 .d(rdata[31:24]),
	 .f(lb_mux_out)
);

mux2 #(.width(16)) lh_mux(
    .sel(offset[1]),
	 .a(rdata[15:0]),
	 .b(rdata[31:16]),
	 .f(lh_mux_out)
);

sext #(.width(8)) sext8(
	.in(lb_mux_out),
	.out(lb_out)
);

zext #(.width(8)) zext8(
	.in(lb_mux_out),
	.out(lbu_out)
);

sext sext16(
	.in(lh_mux_out),
	.out(lh_out)
);

zext zext16(
	.in(lh_mux_out),
	.out(lhu_out)
);

mux8 aligned_rdata_mux
(
    .sel(ldr_op),
	 .a(lb_out),
	 .b(lh_out),
	 .c(rdata),
	 .d(lbu_out),
	 .e(lhu_out),
	 .g(32'b0),
	 .h(32'b0),
	 .i(32'b0),
	 .f(aligned_rdata)
);

endmodule : rdata_align_logic
