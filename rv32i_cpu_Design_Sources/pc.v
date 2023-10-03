module pc(
	input wire [31:0] data_in,
	input wire reset,
	input wire clk,
	input wire WE,
	output wire [31:0] data_out
);
	reg [31:0] program_counter;
	initial begin
		program_counter = 0;
	end
	always @(posedge clk) begin
		if(WE == 1) begin 
			if(reset == 0) begin
				program_counter = data_in;
			end
			else begin
				program_counter = 0;
			end
		end
	end
	assign data_out = program_counter;
endmodule
