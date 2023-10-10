module register(
	input wire [31:0]data_in,
	input wire WE,
	input wire clk,
	output wire [31:0] data_out
);
	reg [31:0] data;
	initial begin
	    data=0;
	end
	always @(posedge clk) begin
		if(WE == 1'b1) begin
			data <= data_in;
		end
	end
	assign data_out = data;
endmodule
