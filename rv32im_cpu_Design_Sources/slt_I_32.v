module slt_I_32(
	input wire [31:0] a,
	input wire [31:0] b,
	output wire [31:0] o
);
	wire [31:0] sub;
	sub_I_32 sub_(.a(a),.b(b),.o(sub));
	assign o = (sub[31] == 1 ? 32'b1 : 32'b0);
endmodule
