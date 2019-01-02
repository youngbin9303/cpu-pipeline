module tournament(

	/* clk */
	input clk,
	input logic branch,
	input logic stall,
	input [1:0] correctness, 
	input [1:0] history,
	output logic tournament_result
);


enum int unsigned
{
	L1, L2, G1, G2
} state, next_state;

/* Current State Logic */
always_comb
begin
	tournament_result = 0;
	case (state)
		L1: begin
			tournament_result = history[1];
		end
		
		L2: begin
			if(correctness == 2'b00 | correctness == 2'b11 | correctness == 2'b10)
				tournament_result = history[1];
			else if(correctness == 2'b01)
				tournament_result = history[0];
		end
		
		G1: begin
			tournament_result = history[0];
		end

		G2: begin
			if(correctness == 2'b00 | correctness == 2'b11 | correctness == 2'b01)
				tournament_result = history[0];
			else if(correctness == 2'b10)
				tournament_result = history[1];
		end
		default:
			;
	endcase
end

/* Next State Logic */
always_ff @(posedge clk)
begin
	next_state = state;
	
	if((~stall) & branch) begin
		case (state)
			L1: begin
				if(correctness == 2'b01)
					next_state = L2;
			end
			
			L2: begin
				if(correctness == 2'b01)
					next_state = G2;
				else if(correctness == 2'b10)
					next_state = L1;
			end	
			
			G1: begin
				if(correctness == 2'b10)
					next_state = G2;
			end
			
			G2: begin
				if(correctness == 2'b01)
					next_state = G1;
				else if(correctness == 2'b10)
					next_state = L2;
			end
			
			default:
				;
		endcase
	end
end

always_ff @(posedge clk)
begin
	state <= next_state;
end

endmodule : tournament