import rv32i_types::*;


module control_rom
(
	input [2:0] funct3,
	input [6:0] funct7,
	input rv32i_opcode opcode,
	
	output rv32i_control_word ctrl
);

always_comb
begin
	/* Default assignments */
	ctrl.opcode = opcode;
	ctrl.load_regfile = 1'b0;
	ctrl.alu_input1_mux_sel = 1'b0;
	ctrl.alu_input2_mux_sel = 3'b000;
	ctrl.cmp_mux_sel = 1'b0;
	ctrl.cmpop = branch_funct3_t'(funct3);
	ctrl.ldr_op = load_funct3_t'(funct3);
	ctrl.str_op = store_funct3_t'(funct3);
	ctrl.regfile_mux_sel = 2'b00;
	ctrl.aluop = alu_ops'(funct3);
	ctrl.d_cache_read = 1'b0;
	ctrl.d_cache_write = 1'b0;
	ctrl.jump = 1'b0;
	ctrl.branch = 1'b0;
	ctrl.mem_read = 1'b0;
	ctrl.mem_write = 1'b0;
	
	/* Control signal assignments based on opcode */
	case(ctrl.opcode)
		op_lui: begin
			ctrl.load_regfile = 1;
			ctrl.regfile_mux_sel = 2; 	
		end
		
		op_auipc: begin
			ctrl.alu_input1_mux_sel = 1;
			ctrl.alu_input2_mux_sel = 1;
			ctrl.load_regfile = 1;
			ctrl.aluop = alu_add;
		end
		
		op_jal: begin
		   ctrl.load_regfile = 1;
		   ctrl.regfile_mux_sel = 3; 
		   ctrl.alu_input1_mux_sel = 1; 		
		   ctrl.alu_input2_mux_sel = 4; 		
		   ctrl.aluop = alu_add;
			ctrl.jump = 1;
		end
		
		op_jalr: begin
		   ctrl.load_regfile = 1;
		   ctrl.regfile_mux_sel = 3; 	
		   ctrl.aluop = alu_add;
		   ctrl.jump = 1;
		end
		
		op_br: begin
			ctrl.alu_input1_mux_sel = 1;
			ctrl.alu_input2_mux_sel = 2;
			ctrl.aluop = alu_add;
			ctrl.branch = 1;
		end

		op_load: begin
			ctrl.load_regfile = 1;	
			ctrl.d_cache_read = 1;
			ctrl.aluop = alu_add;
			ctrl.mem_read = 1;
		end
	
		op_store: begin
			ctrl.alu_input2_mux_sel = 3;
			ctrl.d_cache_write = 1;
			ctrl.aluop = alu_add;
			ctrl.mem_write = 1;
		end

	
		op_imm: begin
			if(funct3 == 3'b000) begin //ADDI
				;
			end
			
			else if(funct3 == 3'b001) begin //SLLI
				;
			end
			
			else if(funct3 == 3'b010) begin //SLTI
				ctrl.regfile_mux_sel = 1;
				ctrl.cmp_mux_sel = 1;
				ctrl.cmpop = blt;
			end
			
			else if(funct3 == 3'b011) begin //SLTIU
				ctrl.regfile_mux_sel = 1;
				ctrl.cmp_mux_sel = 1;
				ctrl.cmpop = bltu;
			end
			
			else if(funct3 == 3'b100) begin //XORI
				;
			end
			
			else if(funct3 == 3'b101) begin // SRAI AND SRLI
				if(funct7[5] == 1'b0) begin	//SRLI
					;	
				end
				else begin //SRA 
					ctrl.aluop = alu_sra;		
				end
			end
			
			else if(funct3 == 3'b110) begin // ORI
				;			
			end
			
			else begin // ANDI
				;		
			end
			
			ctrl.load_regfile = 1;
		end
	
		op_reg: begin
			if(funct3 == 3'b000) begin //ADD and SUB
				if(funct7[5] == 1'b0) begin
					;	
				end
				else begin
					ctrl.aluop = alu_sub;
				end
			end
			
			else if(funct3 == 3'b001) begin //SLL
				;
			end
			
			else if(funct3 == 3'b010) begin //SLT
				ctrl.regfile_mux_sel = 1;
				ctrl.cmpop = blt;
			end
			
			else if(funct3 == 3'b011) begin //SLTU
				ctrl.regfile_mux_sel = 1;
				ctrl.cmpop = bltu;
			end
			
			else if(funct3 == 3'b100) begin //XOR
				;
			end
			
			else if(funct3 == 3'b101) begin // SRA AND SRL
				if(funct7[5] == 1'b0) begin //SRLI
					;	
				end
				else begin //SRA
					ctrl.aluop = alu_sra;	
				end
			end
			
			else if(funct3 == 3'b110) begin //OR
				;					
			end
			
			else begin //AND
				;					
			end
		
			ctrl.load_regfile = 1;
			ctrl.alu_input2_mux_sel = 5;
		end

		
		default: begin
		/* Unknown opcode, set control word to zero */
			ctrl = 0;
		end	
	
	endcase

end

endmodule : control_rom