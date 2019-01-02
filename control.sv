import rv32i_types::*; /* Import types defined in rv32i_types.sv */

module control
(
    /* Input and output port declarations */
	 input clk,
	 input rv32i_opcode opcode,
	 input [2:0] funct3,
	 input [6:0] funct7,
	 input br_en,
	 output logic load_pc,
	 output logic load_ir,
	 output logic load_regfile,
	 output logic load_mar,
	 output logic load_mdr,
	 output logic load_data_out,
	 output logic pcmux_sel,
	 output branch_funct3_t cmpop,
	 output logic alumux1_sel,
	 output logic [2:0] alumux2_sel,
	 output logic [2:0] regfilemux_sel,
	 output logic regmux1_sel,
	 output logic regmux2_sel,
	 output logic marmux_sel,
	 output logic cmpmux_sel,
	 output alu_ops aluop,
 //   output load_funct3_t loadop,
//	 output store_funct3_t storeop,
	 output logic bit30,
	 input mem_resp,
	 output reset,
	 output logic mem_read,
	 output logic mem_write,
	 output logic [3:0] mem_byte_enable
);

enum int unsigned {
    /* List of states */
    fetch1,
	 fetch2,
	 fetch3,
	 decode,
	 s_imm,
	 s_reg,
	 s_lui,
	 s_auipc,
	 br,
	 calc_addr_ld,
	 calc_addr_st,
	 s_load,
	 s_store,
	 ldr1,
	 ldr2,
	 str1,
	 str2,
	 jal,

	 jalr

} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    /* Actions for each state */
	 load_pc = 1'b0;
	 load_ir = 1'b0;
	 load_regfile = 1'b0;
	 load_mar = 1'b0;rv32i_word mdr8_out;
rv32i_word mdr16_out;
rv32i_word regmux1_out;
rv32i_word regmux2_out;
	 load_mdr = 1'b0;
	 load_data_out = 1'b0;
	 pcmux_sel = 1'b0;
	 cmpop = branch_funct3_t'(funct3);
	 alumux1_sel = 1'b0;
	 alumux2_sel = 3'b0;
	 regmux1_sel = 1'b0;
	 regmux2_sel = 1'b0;
	 regfilemux_sel = 3'b000;
	 marmux_sel = 1'b0;
	 cmpmux_sel = 1'b0;
	 aluop = alu_ops'(funct3);
//	 loadop = load_funct3_t'(funct3);
//	 storeop = store_funct3_t'(funct3);
	 mem_read = 1'b0;
	 mem_write = 1'b0;
	 mem_byte_enable = 4'b1111;
	 bit30 = funct7[5];
	 reset = 1'b0;
	 
	 
	 case(state)
	     fetch1: begin
		      load_mar = 1;
		  end
		  
		  fetch2: begin
		      load_mdr = 1;
				mem_read = 1;
		  end
		  
		  fetch3: begin
		      load_ir = 1;
		  end
		  
		  decode: /* Do nothing */;
		  
		  s_imm: begin
		      case(funct3)
				    slt: begin
					     load_regfile = 1;
						  load_pc = 1;
						  cmpop = blt;
						  regfilemux_sel = 1;
						  cmpmux_sel = 1;
					 end
					 
					 sltu: begin
					     load_regfile = 1;
						  load_pc = 1;
						  cmpop = bltu;
						  regfilemux_sel = 1;
						  cmpmux_sel = 1;
					 end
					 
					 sr: begin
						  case(bit30)
								1'b0: begin
									load_regfile = 1;
									load_pc = 1;
									aluop = alu_srl;
								end
								1'b1: begin
									load_regfile = 1;
									load_pc = 1;
									aluop = alu_sra;
								end
						  endcase
					 end
					 
					 default: begin
					     load_regfile = 1;
						  load_pc = 1;
						  aluop = alu_ops'(funct3);
				    end
		      endcase
		  end
		  
		  s_reg: begin
		      case(funct3)
					 slt: begin
						  load_regfile = 1;
						  load_pc = 1;
						  cmpop = blt;
						  regfilemux_sel = 1;
						  alumux2_sel = 5;
						  cmpmux_sel = 0;
					 end

					 sltu: begin
						  load_regfile = 1;
						  load_pc = 1;
						  cmpop = bltu;
						  regfilemux_sel = 1;
						  alumux2_sel = 5;
						  cmpmux_sel = 0;
					 end
				
					 sr: begin
						  case(bit30)
								1'b0: begin
									load_regfile = 1;
									load_pc = 1;
									alumux2_sel = 5;
									aluop = alu_srl;
								end
								1'b1: begin
									load_regfile = 1;
									load_pc = 1;
									alumux2_sel = 5;
									aluop = alu_sra;
								end
						  endcase
					 end
							
					 add: begin
						  case(bit30)
								1'b0: begin
									load_regfile = 1;
									load_pc = 1;
									alumux2_sel = 5;
									aluop = alu_add;
								end
								1'b1: begin
									load_regfile = 1;
									load_pc = 1;
									alumux2_sel = 5;
									aluop = alu_sub;
								end
						  endcase
					 end
				
					 default: begin
						  load_regfile = 1;
						  load_pc = 1;
						  alumux2_sel = 5;
						  aluop = alu_ops'(funct3);
					 end
		      endcase
		  end		  
		  
		  br: begin
		      pcmux_sel = br_en;
				load_pc = 1;
				alumux1_sel = 1;
				alumux2_sel = 2;
				reset = 1;
				aluop = alu_add;
		  end
		  
		  calc_addr_ld: begin
		      aluop = alu_add;
				load_mar = 1;
				marmux_sel = 1;
		  end		/*
		  str1: begin
		      mem_write = 1;
		  end
		  */
		  
		  ldr1: begin
		      load_mdr = 1;
				mem_read = 1;
		  end
		 /* 	 
		  ldr2: begin
		      regfilemux_sel = 3;
				load_regfile = 1;
				load_pc = 1;
		  end
		 */
		s_load: begin
			case(funct3)
				lb: begin
					regfilemux_sel = 6;
					regmux1_sel = 1;
					load_regfile = 1;
					load_pc = 1;
				end

				lh: begin
					regfilemux_sel = 7;
					regmux2_sel = 1;
					load_regfile = 1;
					load_pc = 1;
				end
				
				lw: begin
					regfilemux_sel = 3;
					load_regfile = 1;
					load_pc = 1;
				end
				
				lbu: begin
					regfilemux_sel = 6;
					regmux1_sel = 0;
					load_regfile = 1;
					load_pc = 1;
				end

				default: begin //lhu
					regfilemux_sel = 7;
					regmux2_sel = 0;
					load_regfile = 1;
					load_pc = 1;
				end
				
			endcase
		end

		  calc_addr_st: begin
		      alumux2_sel = 3;
				aluop = alu_add;
				load_mar = 1;
				load_data_out = 1;
				marmux_sel = 1;
		  end
/*			
		  str1: begin
		      mem_write = 1;
		  end
*/		  	  
			str1: begin
				case(funct3)
					sb: begin
						mem_byte_enable = 4'b0001;
						mem_write = 1;
					end

					sh: begin
						mem_byte_enable = 4'b0011;
						mem_write = 1;
					end
					
					default: begin
						mem_write = 1;
					end
					
				endcase
			end
		
		  str2: begin
		      load_pc = 1;
		  end



		  s_auipc: begin
		      alumux1_sel = 1;
				alumux2_sel = 1;
				load_regfile = 1;
				load_pc = 1;
				aluop = alu_add;
		  end
		  
		  s_lui: begin
		      load_regfile = 1;
				load_pc = 1;
				regfilemux_sel = 2;
		  end

		  jal: begin
		      load_pc = 1;
		      load_regfile = 1;
		      regfilemux_sel = 4; 
		      alumux1_sel = 1; 		
		      alumux2_sel = 4; 		
		      aluop = alu_add;
				pcmux_sel = 1;
		  end
		  
		  jalr: begin
		      load_pc = 1;
		      load_regfile = 1;
		      regfilemux_sel = 5; 
		      alumux1_sel = 0; 		
		      alumux2_sel = 0; 		
		      aluop = alu_add;
		      pcmux_sel = 1;
			end
		 
		  default: /* Do nothing */;
	 endcase	 		  
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
	  next_state = state;
	      case(state)
			    fetch1: next_state = fetch2;
				 fetch2: if(mem_resp) next_state = fetch3;
				 fetch3: next_state = decode;
				 decode: begin
                 case(opcode)
                     op_auipc: next_state = s_auipc;
							op_lui: next_state = s_lui;
							op_load: next_state = calc_addr_ld;
							op_store: next_state = calc_addr_st;
							op_br: next_state = br;
							op_imm: next_state = s_imm;
							op_reg: next_state = s_reg;
							op_jal: next_state = jal;
							op_jalr: next_state = jalr;
                     default: $display("Unknown␣opcode");
                 endcase
             end
				 
				 calc_addr_ld: next_state = ldr1;
				 calc_addr_st: next_state = str1;
				 
				 ldr1: if(mem_resp) next_state = s_load;
				 str1: if(mem_resp) next_state = str2;
				 
				 
				 default: next_state = fetch1;
	      endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : control