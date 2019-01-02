import rv32i_types::*;

module cmp
(
    input branch_funct3_t sel,
	 input logic [31:0] a, b,
    output logic f
);

always_comb
begin
    case (sel)
        beq:  
              if(a == b)
                    f = 1'b1;
              else
                    f = 1'b0;

        bne: 
              if(a != b)
                    f = 1'b1;
              else
                    f = 1'b0;
						  
        blt:
              if($signed(a) < $signed(b))
                    f = 1'b1;
              else
                    f = 1'b0;

        bge:
              if($signed(a) >= $signed(b))
                    f = 1'b1;
              else
                    f = 1'b0;

        bltu:
              if(a < b)
                    f = 1'b1;
              else
                    f = 1'b0;

        bgeu:
              if(a >= b)
                    f = 1'b1;
              else
                    f = 1'b0;
    endcase
end

endmodule : cmp