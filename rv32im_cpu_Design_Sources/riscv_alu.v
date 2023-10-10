`define ADD_INT_32  4'b0000
`define SUB_INT_32  4'b0001
`define SLL_INT_32  4'b0010
`define SLT_INT_32  4'b0011
`define SLTU_INT_32 4'b0100
`define XOR_INT_32  4'b0101
`define SRL_INT_32  4'b0110
`define SRA_INT_32  4'b0111
`define OR_INT_32   4'b1000
`define AND_INT_32  4'b1001


module riscv_alu(
	input wire [31:0] a_in,
	input wire [31:0] b_in,
	input wire [3:0] op,
	output wire [31:0] r_o //result_out
);
	wire [31:0] result[9:0];
	add_I_32 add(.a(a_in), .b(b_in), .o(result[`ADD_INT_32]));
	sub_I_32 sub(.a(a_in), .b(b_in), .o(result[`SUB_INT_32]));
	sll_I_32 sll(.a(a_in), .b(b_in), .o(result[`SLL_INT_32]));
	slt_I_32 slt(.a(a_in), .b(b_in), .o(result[`SLT_INT_32]));
	sltu_I_32 sltu(.a(a_in), .b(b_in), .o(result[`SLTU_INT_32]));
	xor_I_32 xor_(.a(a_in), .b(b_in), .o(result[`XOR_INT_32]));
	srl_I_32 srl(.a(a_in), .b(b_in), .o(result[`SRL_INT_32]));
	sra_I_32 sra(.a(a_in), .b(b_in), .o(result[`SRA_INT_32]));
	or_I_32 or_(.a(a_in), .b(b_in), .o(result[`OR_INT_32]));
	and_I_32 and_(.a(a_in), .b(b_in), .o(result[`AND_INT_32]));
	
	assign r_o = result[op];
endmodule

