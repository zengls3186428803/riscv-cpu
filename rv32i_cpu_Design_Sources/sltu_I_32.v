module sltu_I_32(
	input wire [31:0] a,
	input wire [31:0] b,
	output wire [31:0] o
);
	assign o[0] = (a < b);
	assign o[31:1] = 31'b0;
endmodule
