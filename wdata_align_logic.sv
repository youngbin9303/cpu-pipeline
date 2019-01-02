import rv32i_types::*;

module wdata_align_logic
(
	input [1:0] offset,
	input store_funct3_t str_op,
	input rv32i_word wdata,
	
	output rv32i_mem_wmask aligned_wmask,
	output rv32i_word aligned_wdata
);

always_comb
begin
	case (str_op)		
		sb: begin
			aligned_wdata = {wdata[7:0], wdata[7:0], wdata[7:0], wdata[7:0]};
			
			if (offset == 2'b00)
				aligned_wmask = 4'b0001;
			else if (offset == 2'b01)
				aligned_wmask = 4'b0010;
			else if (offset == 2'b10)
				aligned_wmask = 4'b0100;
			else
				aligned_wmask = 4'b1000;
		end
		
		sh: begin
			aligned_wdata = {wdata[15:0], wdata[15:0]};
			
			if (offset[1] == 1'b0)
				aligned_wmask = 4'b0011;
			else
				aligned_wmask = 4'b1100;
		end
		
		sw: begin
			aligned_wdata = wdata;
			aligned_wmask = 4'b1111;
		end
	endcase
end

endmodule : wdata_align_logic
