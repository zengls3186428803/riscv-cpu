`define BRANCH_BEQ 3'b000
`define BRANCH_BNE 3'b001
`define BRANCH_BLT 3'b010
`define BRANCH_BGE 3'b011
`define BRANCH_BLTU 3'b100
`define BRANCH_BGEU 3'b101


module branch(
	input wire [31:0] a,
	input wire [31:0] b,
	input wire [2:0] bop,
	output wire out
);
	wire beq;
	wire bne;
	wire blt;
	wire bge;
	wire bltu;
	wire bgeu;

	assign beq = (a == b? 32'b1 : 32'b0);
	assign bne = (a != b ? 32'b1 : 32'b0);
	assign blt = (a[31] == 0 && b[31] == 1 ? 32'b0 : (a[31] == 32'b1 && b[31] == 32'b0 ? 32'b1 : (a < b ? 32'b1 : 32'b0)));
	assign bge = !blt && !bne ? 32'b1 : 32'b0;
	assign bltu = a < b ? 32'b1 : 32'b0;
	assign bgeu = a > b ? 32'b1 : 32'b0;
	wire multiplex[5:0];
	assign multiplex[0] = beq;
	assign multiplex[1] = bne;
	assign multiplex[2] = blt;
	assign multiplex[3] = bge;
	assign multiplex[4] = bltu;
	assign multiplex[5] = bgeu;
	assign out = multiplex[bop];

endmodule
