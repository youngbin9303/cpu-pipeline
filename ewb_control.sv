import rv32i_types::*;

module ewb_control
(
	input clk,
	input pmem_resp,
	input mem_write,
	input mem_read,
	input hit,
	output logic pmem_write, 
	output logic data_write, 
	output logic mem_sig, 
	output logic mem_resp,
	output logic data_sel,
	output logic pmem_read
);

enum int unsigned {
    idle,		
    stall,			
	 data_in,
	 empty
} state, next_state;

always_comb
begin
	next_state = state;
	case(state)
	idle: begin
		if (mem_write)
			next_state = empty;
		else if (mem_read && hit)
			next_state = empty;
		else if (mem_read && !hit)
			next_state = data_in;
	end

	stall: begin
		if (pmem_resp)
			next_state = idle;
	end

	data_in: begin
		if (pmem_resp)
			next_state = empty;
	end

	empty: begin
		if (mem_write || mem_read && hit)
			next_state = stall;
		else 
			next_state = idle;
	end
	
	default: next_state = idle;

	endcase
end

always_comb
begin
	data_write = 0;
	mem_resp = 0;
	pmem_write = 0;
	pmem_read = 0;
	data_sel = 1;
	mem_sig = 0;

	case(state)
	idle: begin
		if (mem_write)
		begin
			data_write = 1;
			mem_resp = 1;
		end
		else if (mem_read && hit)
		begin
			mem_resp = 1;
			data_sel = 0;
		end
	end

	stall: begin
		pmem_write = 1;
		mem_sig = 1;
	end

	data_in: begin
		pmem_read = 1;
		if (pmem_resp)
			mem_resp = 1;
	end
	
	empty: begin 
		if (mem_read && hit)
			data_sel = 0;
	end
	default: ;
	endcase
end


always_ff @(posedge clk)
begin: next_state_assignment
	/* Assignment of next state on clock edge */
	state <= next_state;
end

endmodule : ewb_control