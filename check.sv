import rv32i_types::*;

module data_forwarding
(
	input rv32i_control_word ex_control,
	input rv32i_control_word mem_control,
	input rv32i_control_word wb_control,
	input rv32i_reg mem_dest,
	input rv32i_reg wb_dest,
	input rv32i_reg ex_src_A,
	input rv32i_reg ex_src_B,
	output logic[1:0] sel_A,
	output logic[1:0] sel_B,
	output logic[1:0] sel_C,
	output logic sel_D
);

always_comb
begin
	sel_A = 2'b00;
	sel_B = 2'b00;
	sel_C = 2'b00;
	sel_D = 1'b0;

		/* 2 regs */
		/* R type */
		if((ex_control.opcode == op_reg)) begin
			if(((ex_src_A == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_control.opcode != op_load) && (mem_dest != 0)) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_A == wb_dest) && (wb_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_B == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_B == wb_dest) && (wb_dest != 0)))) begin
				sel_A = 2'b10;
				sel_B = 2'b00;
				sel_C = 2'b00;
			end
			else if(((ex_src_B == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_control.opcode != op_load) && (mem_dest != 0)) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_B == wb_dest) && (wb_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_A == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_A == wb_dest) && (wb_dest != 0)))) begin
				sel_A = 2'b00;
				sel_B = 2'b10;
				sel_C = 2'b00;
			end
			else if(((ex_src_A == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_A == mem_dest) && (mem_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_B == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_B == wb_dest) && (wb_dest != 0)))) begin
				sel_A = 2'b01;
				sel_B = 2'b00;
				sel_C = 2'b00;
			end
			else if(((ex_src_B == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_B == mem_dest) && (mem_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_A == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_A == wb_dest) && (wb_dest != 0)))) begin
				sel_A = 2'b00;
				sel_B = 2'b01;
				sel_C = 2'b00;
			end
			else if(((ex_src_A == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0)) && ((ex_src_B == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0))) begin
				sel_A = 2'b10;
				sel_B = 2'b10;
				sel_C = 2'b00;
			end
			else if(((ex_src_A == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && ((ex_src_B == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0))) begin
				sel_A = 2'b01;
				sel_B = 2'b01;
				sel_C = 2'b00;
			end
			else if(((ex_src_B == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && ((ex_src_A == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0))) begin
				sel_A = 2'b10;
				sel_B = 2'b01;
				sel_C = 2'b00;
			end
			else if(((ex_src_A == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && ((ex_src_B == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0))) begin
				sel_A = 2'b01;
				sel_B = 2'b10;
				sel_C = 2'b00;
			end
		end
		/* S type */
		else if((ex_control.opcode == op_store)) begin
			if(((ex_src_A == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_control.opcode != op_load) && (mem_dest != 0)) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_A == wb_dest) && (wb_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_B == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_B == wb_dest) && (wb_dest != 0)))) begin
				sel_A = 2'b10;
				sel_B = 2'b00;
			end
			else if(((ex_src_B == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_control.opcode != op_load) && (mem_dest != 0)) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_B == wb_dest) && (wb_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_A == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_A == wb_dest) && (wb_dest != 0)))) begin
				sel_A = 2'b00;
				sel_B = 2'b00;	
			end
			else if(((ex_src_A == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_A == mem_dest) && (mem_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_B == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_B == wb_dest) && (wb_dest != 0)))) begin
				sel_A = 2'b01;
				sel_B = 2'b00;
			end
			else if(((ex_src_B == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_B == mem_dest) && (mem_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_A == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_A == wb_dest) && (wb_dest != 0)))) begin
				sel_A = 2'b00;
				sel_B = 2'b00;
			end
			else if(((ex_src_A == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0)) && ((ex_src_B == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0))) begin
				sel_A = 2'b10;
				sel_B = 2'b00;
			end
			else if(((ex_src_A == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && ((ex_src_B == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0))) begin
				sel_A = 2'b01;
				sel_B = 2'b00;
			end
			else if(((ex_src_B == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && ((ex_src_A == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0))) begin
				sel_A = 2'b10;
				sel_B = 2'b00; 
			end
			else if(((ex_src_A == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && ((ex_src_B == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0))) begin
				sel_A = 2'b01;
				sel_B = 2'b00;
			end
		end
		/* 1 reg */
		/* I type */
		else if((ex_control.opcode == op_jalr) | (ex_control.opcode == op_load) | (ex_control.opcode == op_imm)) begin
			/* exe hazard */
			if(((ex_src_A == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_control.opcode != op_load)) && (mem_dest != 0)) begin
				sel_A = 2'b10;
			end
			/* mem hazard */
			else if((ex_src_A == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_A == mem_dest) && (mem_dest != 0)))) begin
				sel_A = 2'b01;
			end
		end	
		

		/* B type */
		else if((ex_control.opcode == op_br)) begin
			/* only one reg matches */
			if(((ex_src_A == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_control.opcode != op_load) && (mem_dest != 0)) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_A == wb_dest) && (wb_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_B == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_B == wb_dest) && (wb_dest != 0)))) begin
				sel_A = 2'b10;
				sel_C = 2'b00;
			end
			else if(((ex_src_B == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_control.opcode != op_load) && (mem_dest != 0)) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_B == wb_dest) && (wb_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_A == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_A == wb_dest) && (wb_dest != 0)))) begin
				sel_B = 2'b00;
				sel_C = 2'b10;
			end
			else if(((ex_src_A == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_A == mem_dest) && (mem_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_B == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_B == wb_dest) && (wb_dest != 0)))) begin
				sel_A = 2'b01;
				sel_C = 2'b00;
			end
			else if(((ex_src_B == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_B == mem_dest) && (mem_dest != 0))) && (~((mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (ex_src_A == mem_dest) && (mem_dest != 0))) && (~((wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (ex_src_A == wb_dest) && (wb_dest != 0)))) begin
				sel_B = 2'b00;
				sel_C = 2'b01;
			end
			/* both reg matches */
			else if(((ex_src_A == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && ((ex_src_B == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0))) begin
				sel_A = 2'b01;
				sel_B = 2'b00;
				sel_C = 2'b10;
			end
			else if(((ex_src_B == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && ((ex_src_A == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0))) begin
				sel_A = 2'b10;
				sel_B = 2'b00;
				sel_C = 2'b01;
			end
			else if(((ex_src_A == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0)) && ((ex_src_B == mem_dest) && (mem_control.opcode != op_store) && (mem_control.opcode != op_br) && (mem_dest != 0))) begin
				sel_A = 2'b10;
				sel_B = 2'b00;
				sel_C = 2'b10;
			end
			else if(((ex_src_A == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0)) && ((ex_src_B == wb_dest) && (wb_control.opcode != op_store) && (wb_control.opcode != op_br) && (wb_dest != 0))) begin
				sel_A = 2'b01;
				sel_B = 2'b00;
				sel_C = 2'b01;
			end
		end
	
		if((mem_control.opcode == op_load) && ((ex_src_A == mem_dest)|(ex_src_B == mem_dest)) && (ex_control.opcode != op_lui) && (ex_control.opcode != op_auipc) && (ex_control.opcode != op_jal))
			sel_D = 1'b1;

end
			
endmodule : data_forwarding
			