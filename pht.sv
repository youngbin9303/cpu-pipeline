module pht #(parameter width = 16)
(
    input clk,
    input write,
	 input [3:0] index,
	 input last_branch,
	 output logic branch_predict
);

logic [1:0] data [width-1:0] /* synthesis ramstyle = "logic" */;

/* Initialize array */
initial
begin
    for (int i = 0; i < $size(data); i++)
    begin
        data[i] = 2'b01; /* intialized to weakly not taken */
    end
end

always_ff @(negedge clk)
begin
	if (write) begin
		if ((last_branch == 1) && (data[index] < 3)) begin
			data[index] = data[index] + 2'b01;
		end
		else if ((last_branch == 0) && (data[index] > 0)) begin
			data[index] = data[index] - 2'b01;
		end
   end
end

always_comb
begin
	if (data[index] >= 2) begin
		branch_predict = 1;
	end
	else begin
		branch_predict = 0;
	end
end

endmodule : pht