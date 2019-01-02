module enable_logic(
	input logic valid0,
	input logic valid1,
	input logic tagcmp0,
	input logic tagcmp1,
	input logic mem_write,
	input logic pmem_resp,
	input logic lru,
	input logic idling,
	input logic alloc,
	output logic hit0,
	output logic hit1,
	output logic hit_any,
	output logic tag_n_valid0_w_enable,
	output logic tag_n_valid1_w_enable,
	output logic data_n_dirty0_w_enable,
	output logic data_n_dirty1_w_enable
);

assign hit0 = valid0 & tagcmp0 & idling;
assign hit1 = valid1 & tagcmp1 & idling;
assign hit_any = hit0 | hit1;
assign tag_n_valid0_w_enable = pmem_resp & (~lru) & alloc;
assign tag_n_valid1_w_enable = pmem_resp & lru & alloc;
assign data_n_dirty0_w_enable = (hit0 & mem_write) | tag_n_valid0_w_enable;
assign data_n_dirty1_w_enable = (hit1 & mem_write) | tag_n_valid1_w_enable;

endmodule : enable_logic