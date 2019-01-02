import rv32i_types::*;

module sext #(parameter width = 16)
(
	input [width-1:0] in,
	output rv32i_word out
);

assign out = $signed({in});

endmodule : sext
