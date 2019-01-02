module arbiter_control(
	/* clk */
	input clk,

	/* cache1 <-> arbiter */
	input logic cache1_read,
	input logic cache1_write,
	output logic cache1_resp,
	output logic [255:0] cache1_rdata,
	
	/* cache2 <-> arbiter */
	input logic cache2_read,
	input logic cache2_write,
	output logic cache2_resp,
	output logic [255:0] cache2_rdata,
	
	/* control -> datapath */
	output logic cache_sel,
	
	/* arbiter <-> memory */
	input logic pmem_resp,
	input [255:0] pmem_rdata,
	output logic pmem_read,
	output logic pmem_write
);

enum int unsigned
{
	idle, serve_cache1, serve_cache2
} state, next_state;

/* Current State Logic */
always_comb
begin
	/* Default */
	cache1_resp = 1'b0;
	cache2_resp = 1'b0;
	cache_sel = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	cache1_rdata = 0;
	cache2_rdata = 0;

	unique case (state)
		idle: begin
			/* Maintain Default */;
		end
		
		serve_cache1: begin
			cache_sel = 0;
			pmem_read = cache1_read;
			pmem_write = cache1_write;
			cache1_resp = pmem_resp;
			cache1_rdata = pmem_rdata;
		end

		serve_cache2: begin
			cache_sel = 1;
			pmem_read = cache2_read;
			pmem_write = cache2_write;
			cache2_resp = pmem_resp;
			cache2_rdata = pmem_rdata;
		end
		
		default:
			/* Default */;
	endcase
end

/* Next State Logic */
always_comb
begin
	next_state = state;
	
	unique case (state)
		idle: begin
			if (cache1_read | cache1_write)
				next_state = serve_cache1;
				
			else if (cache2_read | cache2_write)
				next_state = serve_cache2;
			
			else
				next_state = idle;
		end
			
		serve_cache1: begin
			if (pmem_resp) begin
				if (cache2_read | cache2_write)
					next_state = serve_cache2;	
					
				else
					next_state = idle;
			end 
			
			else
				next_state = serve_cache1;
		end
		
		serve_cache2: begin
			if (pmem_resp) begin
				if (cache1_read | cache1_write)
					next_state = serve_cache1;	
					
				else
					next_state = idle;
			end 
			
			else
				next_state = serve_cache2;
		end
			
		default:
			/* Default */;
	endcase
end

always_ff @(posedge clk)
begin
	state <= next_state;
end

endmodule : arbiter_control