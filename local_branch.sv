module local_branch(

	/* clk */
	input clk,
	input logic branch,
	input logic stall,
	
	/* datapath <-> control */
	input br_en,
	output logic prediction
);


enum int unsigned
{
	ST, WT, WNT, SNT
} state, next_state;

initial
begin
	state = WT;
	next_state = WT;
end

/* Current State Logic */
always_comb
begin
	case (state)
		ST: begin
			prediction = 1;
		end
		
		WT: begin
			prediction = 1;
		end

		WNT: begin
			prediction = 0;
		end
		
		SNT: begin
			prediction = 0;
		end
		
		default:
			;
	endcase
end

/* Next State Logic */
always_ff @(negedge clk) 
begin
	next_state = state;
	
	if((~stall) & branch) begin
		case (state)				
			ST: begin
				if (~br_en)
					next_state = WT;
			end
			
			WT: begin
				if (br_en)
					next_state = ST;	
				else
					next_state = WNT;
			end
			
			WNT: begin
				if (br_en)
					next_state = WT;
				else
					next_state = SNT;
			end
			
			SNT: begin
				if (br_en)
					next_state = WNT;
			end
			
			default:
				;
		endcase
	end
end

always_ff @(negedge clk)
begin
	state <= next_state;
end

endmodule : local_branch