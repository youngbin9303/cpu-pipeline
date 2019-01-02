import rv32i_types::*;

module MEM_WB_reg
(
	input clk,
	input logic load,
	input rv32i_word rd_data_in,
	input rv32i_word d_cache_data_in,
	input rv32i_control_word control_rom_in,
	input rv32i_reg rd_in,
	output rv32i_word rd_data_out,
	output rv32i_word d_cache_data_out,
	output rv32i_control_word control_rom_out,
	output rv32i_reg rd_out
);

rv32i_word rd_data_data;
rv32i_word d_cache_data;
rv32i_control_word control_rom_data;
rv32i_reg rd_data;

initial
begin
	rd_data_data = 0;
	d_cache_data = 0;
	control_rom_data = 0;
	rd_data = 0;
end

always_ff @(posedge clk)
begin
	if(load) begin
		rd_data_data <= rd_data_in;
		d_cache_data <= d_cache_data_in;
		control_rom_data <= control_rom_in;
		rd_data <= rd_in;
	end
	else begin
		rd_data_data <= rd_data_data;
		d_cache_data <= d_cache_data;
		control_rom_data <= control_rom_data;
		rd_data <= rd_data;
	end
end

always_comb
begin
	rd_data_out = rd_data_data;
	d_cache_data_out = d_cache_data;
	control_rom_out = control_rom_data;
	rd_out = rd_data;
end

endmodule : MEM_WB_reg