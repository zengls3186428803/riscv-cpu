module sll_I_32(
	input wire [31:0] a,
	input wire [31:0] b,
	output wire [31:0] o
);
	assign o = a << b[4:0];
endmodule