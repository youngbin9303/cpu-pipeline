import rv32i_types::*;

module add
(
    input rv32i_word a,
	 input rv32i_word b,
    output rv32i_word out
);

assign out = a + b;

endmodule : add
