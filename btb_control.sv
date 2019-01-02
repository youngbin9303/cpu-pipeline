module btb_control(
	/* clk */
	input clk,

	/* cpu <-> btb */
	input logic write,
	output logic resp
);

enum int unsigned
{
	idle, respond
} state, next_state;

/* Current State Logic */
always_comb
begin
	/* Default */
	resp = 1'b0;
	
	unique case (state)
		idle: begin
			;
		end
		
		respond: begin
			resp = 1;
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
			if (write)
				next_state = respond;
		end
			
		respond: begin
			next_state = idle;
		end
			
		default:
			;
	endcase
end

always_ff @(posedge clk)
begin
	state <= next_state;
end

endmodule : btb_control