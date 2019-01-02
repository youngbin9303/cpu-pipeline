import rv32i_types::*;

module performance_counter
(
	input clk,
	
	/* cache hit */
	input logic i_cache_read, 
	input logic i_cache_write, 
	input logic i_cache_mem_resp,
	input logic d_cache_read, 
	input logic d_cache_write, 
	input logic d_cache_mem_resp,
	
	/*
	input logic L2_read, 
	input logic L2_write, 
	input logic L2_mem_resp,
	*/
	
	/* branch prediction */
	input rv32i_control_word exe_mem_ctrl, 
	input logic jump_logic_out,
	
	/* cache miss */
	input logic i_miss,
	input logic d_miss,
	
	/* stall */
	input logic load_stall,
	input logic total_stall,
	
	input logic counter_write, 
	input logic counter_read,
	input rv32i_word d_cache_address,

	
	output integer i_cache_miss_out,
	output integer i_cache_hit_out,
	output integer d_cache_miss_out,
	output integer d_cache_hit_out,
	//output integer L2_miss_out,
	//output integer L2_hit_out,
	
	output integer br_misprediction_out,
	output integer br_out,
	output integer load_stall_out,
	output integer stall_out,
	output rv32i_word counter_data
);

integer i_cache_hit;
integer i_cache_miss;
integer i_cache_hit_in;
integer i_cache_miss_in;

integer d_cache_hit;
integer d_cache_miss;
integer d_cache_hit_in;
integer d_cache_miss_in;

//integer L2_hit;
//integer L2_miss;
//integer L2_hit_in;
//integer L2_miss_in;

integer br_misprediction;
integer br_misprediction_in;

integer br;
integer br_in;

integer ld_stall;
integer load_stall_in;

integer stall;
integer stall_in;

initial
begin

	i_cache_hit = 0;
	i_cache_miss = 0;
	d_cache_hit = 0;
	d_cache_miss = 0;
	//L2_hit = 0;
	//L2_miss = 0;
	
	br_misprediction = 0;
	br = 0;
	ld_stall = 0;
	stall = 0;
	
end

always_ff @(negedge i_miss)
begin
	i_cache_miss <= i_cache_miss_in;
end

always_ff @(negedge d_miss)
begin
	d_cache_miss <= d_cache_miss_in;
end

always_ff @(posedge clk)
begin
	i_cache_hit <= i_cache_hit_in;
	d_cache_hit <= d_cache_hit_in;
	//L2_hit <= L2_hit_in;
	//L2_miss <= L2_miss_in;
	br_misprediction <= br_misprediction_in;
	br <= br_in;
	ld_stall <= load_stall_in;
	stall <= stall_in;
end

always_comb
begin

	i_cache_miss_out = i_cache_miss;
	i_cache_hit_out = i_cache_hit;
	d_cache_miss_out = d_cache_miss;
	d_cache_hit_out = d_cache_hit;
//	L2_miss_out = L2_miss;
//	L2_hit_out = L2_hit;
	
	br_misprediction_out = br_misprediction;
	br_out = br;
	load_stall_out = ld_stall;
	stall_out = stall;
end

always_comb
begin
	counter_data = 0;
	if (counter_read)
	begin
		case (d_cache_address)
		
		32'hffffffd8: begin
			counter_data = i_cache_miss_out;
		end
		32'hffffffdc: begin
			counter_data = i_cache_hit_out;
		end
		32'hffffffe0: begin
			counter_data = d_cache_miss_out;
		end
		32'hffffffe4: begin
			counter_data = d_cache_hit_out;
		end
//		32'hffffffe8: begin
//			counter_data = L2_miss_out;
//		end
//		32'hffffffec: begin
//			counter_data = L2_hit_out;
//		end
		32'hfffffff0: begin
			counter_data = br_misprediction_out;
		end
		32'hfffffff4: begin
			counter_data = br_out;
		end
		32'hfffffff8: begin
			counter_data = load_stall_out;
		end
		32'hfffffffc: begin
			counter_data = stall_out;
		end
		default:
			counter_data = 0;
		endcase
	end
end


always_comb
begin

	i_cache_hit_in = i_cache_hit;
	i_cache_miss_in = i_cache_miss;
	d_cache_hit_in = d_cache_hit;
	d_cache_miss_in = d_cache_miss;
	//L2_hit_in = L2_hit;
	//L2_miss_in = L2_miss;
	
	br_misprediction_in = br_misprediction;
	br_in = br;
	load_stall_in = ld_stall;
	stall_in = stall;
	
	if (i_miss == 1)
		i_cache_miss_in = i_cache_miss + 1;
	if (i_cache_read & i_cache_mem_resp)
		i_cache_hit_in = i_cache_hit + 1;
	if (d_miss == 1)
		d_cache_miss_in = d_cache_miss + 1;
	if ((d_cache_read | d_cache_write) & d_cache_mem_resp)
		d_cache_hit_in = d_cache_hit + 1;
	if (load_stall)
		load_stall_in = ld_stall + 1;
	if (total_stall)
		stall_in = stall + 1;
	if(((exe_mem_ctrl.opcode == op_br) | (exe_mem_ctrl.opcode == op_jal) | (exe_mem_ctrl.opcode == op_jalr)) & jump_logic_out)
		br_in = br + 1;
	if(((exe_mem_ctrl.opcode == op_br) | (exe_mem_ctrl.opcode == op_jal) | (exe_mem_ctrl.opcode == op_jalr)) & !jump_logic_out)
		br_misprediction_in = br_misprediction + 1;
	if (counter_write)
	begin
		case (d_cache_address)
		
		32'hffffffd8: begin
			i_cache_miss_in = 0;
		end
		32'hffffffdc: begin
			i_cache_hit_in = 0;
		end
		32'hffffffe0: begin
			d_cache_miss_in = 0;
		end
		32'hffffffe4: begin
			d_cache_hit_in = 0;
		end
		//32'hffffffe8: begin
		//	L2_miss_in = 0;
		//end
		//32'hffffffec: begin
		//	L2_hit_in = 0;
		//end
		
		32'hfffffff0: begin
			br_misprediction_in = 0;
		end
		32'hfffffff4: begin
			br_in = 0;
		end
		32'hfffffff8: begin
			load_stall_in = 0;
		end
		32'hfffffffc: begin
			stall_in = 0;
		end
		default: ;
			
		endcase
	end
end

endmodule: performance_counter