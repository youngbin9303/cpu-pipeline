module L2_enable_logic(
	input logic valid0,
	input logic valid1,
	input logic valid2,
	input logic valid3,
	input logic tagcmp0,
	input logic tagcmp1,
	input logic tagcmp2,
	input logic tagcmp3,
	input logic mem_write,
	input logic pmem_resp,
	input logic [1:0] lru,
	input logic idling,
	input logic alloc,
	output logic hit0,
	output logic hit1,
	output logic hit2,
	output logic hit3,
	output logic hit_any,
	output logic tag_n_valid0_w_enable,
	output logic tag_n_valid1_w_enable,
	output logic tag_n_valid2_w_enable,
	output logic tag_n_valid3_w_enable,
	output logic data_n_dirty0_w_enable,
	output logic data_n_dirty1_w_enable,
	output logic data_n_dirty2_w_enable,
	output logic data_n_dirty3_w_enable
);

always_comb
begin
	if (~valid0 & alloc & pmem_resp) begin
		data_n_dirty0_w_enable = 1;
		data_n_dirty1_w_enable = 0;
		data_n_dirty2_w_enable = 0;
		data_n_dirty3_w_enable = 0;
		tag_n_valid0_w_enable = 1;
		tag_n_valid1_w_enable = 0;
		tag_n_valid2_w_enable = 0;
		tag_n_valid3_w_enable = 0;
	end
	else if (~valid1 & alloc & pmem_resp) begin
		data_n_dirty0_w_enable = 0;
		data_n_dirty1_w_enable = 1;
		data_n_dirty2_w_enable = 0;
		data_n_dirty3_w_enable = 0;
		tag_n_valid0_w_enable = 0;
		tag_n_valid1_w_enable = 1;
		tag_n_valid2_w_enable = 0;
		tag_n_valid3_w_enable = 0;
	end
	else if (~valid2 & alloc & pmem_resp) begin
		data_n_dirty0_w_enable = 0;
		data_n_dirty1_w_enable = 0;
		data_n_dirty2_w_enable = 1;
		data_n_dirty3_w_enable = 0;
		tag_n_valid0_w_enable = 0;
		tag_n_valid1_w_enable = 0;
		tag_n_valid2_w_enable = 1;
		tag_n_valid3_w_enable = 0;
	end
	else if (~valid3 & alloc & pmem_resp) begin
		data_n_dirty0_w_enable = 0;
		data_n_dirty1_w_enable = 0;
		data_n_dirty2_w_enable = 0;
		data_n_dirty3_w_enable = 1;
		tag_n_valid0_w_enable = 0;
		tag_n_valid1_w_enable = 0;
		tag_n_valid2_w_enable = 0;
		tag_n_valid3_w_enable = 1;
	end
	else begin
		data_n_dirty0_w_enable = (hit0 & mem_write) | tag_n_valid0_w_enable;
		data_n_dirty1_w_enable = (hit1 & mem_write) | tag_n_valid1_w_enable;
		data_n_dirty2_w_enable = (hit2 & mem_write) | tag_n_valid2_w_enable;
		data_n_dirty3_w_enable = (hit3 & mem_write) | tag_n_valid3_w_enable;
		tag_n_valid0_w_enable = (pmem_resp & (~lru[1]) & (~lru[0]) & alloc);
		tag_n_valid1_w_enable = (pmem_resp & (~lru[1]) & lru[0] & alloc);
		tag_n_valid2_w_enable = (pmem_resp & lru[1] & (~lru[0]) & alloc);
		tag_n_valid3_w_enable = (pmem_resp & lru[1] & lru[0] & alloc);
	end
end

assign hit0 = valid0 & tagcmp0 & idling;
assign hit1 = valid1 & tagcmp1 & idling;
assign hit2 = valid2 & tagcmp2 & idling;
assign hit3 = valid3 & tagcmp3 & idling;
assign hit_any = hit0 | hit1 | hit2 | hit3;
/*
assign tag_n_valid0_w_enable = (pmem_resp & (~lru[1]) & (~lru[0]) & alloc);
assign tag_n_valid1_w_enable = (pmem_resp & (~lru[1]) & lru[0] & alloc);
assign tag_n_valid2_w_enable = (pmem_resp & lru[1] & (~lru[0]) & alloc);
assign tag_n_valid3_w_enable = (pmem_resp & lru[1] & lru[0] & alloc);

assign data_n_dirty0_w_enable = (hit0 & mem_write) | tag_n_valid0_w_enable;
assign data_n_dirty1_w_enable = (hit1 & mem_write) | tag_n_valid1_w_enable;
assign data_n_dirty2_w_enable = (hit2 & mem_write) | tag_n_valid2_w_enable;
assign data_n_dirty3_w_enable = (hit3 & mem_write) | tag_n_valid3_w_enable;
*/
endmodule : L2_enable_logic