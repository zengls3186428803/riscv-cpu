module sign_extend
	#(
		parameter IN_SIZE=11,
		parameter OUT_SIZE=32
	)
	(
		input wire [IN_SIZE-1:0] data_in,
		output wire [OUT_SIZE-1:0] data_out
	);
	reg [OUT_SIZE - IN_SIZE - 1:0] prefix;
	integer i;

	always @(*) begin
		for(i = 0; i < OUT_SIZE - IN_SIZE; i = i + 1) begin
			if(data_in[IN_SIZE - 1] == 1) begin 
				prefix[i] = 1;
			end
			else begin
				prefix[i] = 0;
			end
		end
	end
	assign data_out = {prefix, data_in};
endmodule
