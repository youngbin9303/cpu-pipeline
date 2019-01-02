module L2_cache_control(
	/* clk */
	input clk,

	/* datapath <-> control */
	input logic hit_any,
	input logic dirty0_out,
	input logic dirty1_out,
	input logic dirty2_out,
	input logic dirty3_out,
	input logic [1:0] lru_out,
	output logic idling,
	output logic alloc,
	output logic w_back,

	/* cpu <-> cache */
	input logic mem_read,
	input logic mem_write,
	output logic mem_resp,
	
	/* cache <-> memory */
	input logic pmem_resp,
	output logic pmem_read,
	output logic pmem_write
);

logic resp_on;
logic resp_hold;

enum int unsigned
{
	idle, allocate, write_back
} state, next_state;

/* Current State Logic */
always_comb
begin
	/* Default */
	alloc = 1'b0;
	idling = 1'b0;
	w_back = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	mem_resp = 1'b0;
	
	unique case (state)
		idle: begin
			idling = 1;
			if ((mem_read || mem_write) && (hit_any)) begin
				mem_resp = 1;
			end
		end
		
		allocate: begin
			alloc = 1;
			pmem_read = 1;
		end

		write_back: begin
			w_back = 1;
			pmem_write = 1;
		end
		
		default:
			;
	endcase
end

/* Next State Logic */
always_comb
begin
	next_state = state;
	
	unique case (state)
		idle: begin
			if (mem_read | mem_write) begin
				if (~hit_any) begin
					if (((~lru_out[1]) & (~lru_out[0]) & dirty0_out) | ((~lru_out[1]) & (lru_out[0]) & dirty1_out) | ((lru_out[1]) & (~lru_out[0]) & dirty2_out) | ((lru_out[1]) & (lru_out[0]) & dirty3_out))
						next_state = write_back;
					else
						next_state = allocate;
				end
				
			end
		end
			
		allocate: begin
			if (pmem_resp)
				next_state = idle;
		end
		
		write_back: begin
			if (pmem_resp)
				next_state = allocate;
		end
			
		default:
			;
	endcase
end

always_ff @(posedge clk)
begin
	state <= next_state;
	/*resp_hold <= resp_on;*/
end
/*
assign mem_resp = resp_hold != resp_on && (resp_on);
*/
endmodule : L2_cache_control