module instruct_struct_spliter(
	input wire [31:0] instruction_in,
	output wire [6:0] opcode,
	output wire [4:0] rd,
	output wire [4:0] rs1,
	output wire [4:0] rs2,
	output wire [2:0] funct3,
	output wire [6:0] funct7,
	output wire [31:0] imm_I,
	output wire [31:0] imm_S,
	output wire [31:0] imm_B,
	output wire [31:0] imm_U,
	output wire [31:0] imm_J,
	output wire [31:0] shamt
);
	assign opcode = instruction_in[6:0];
	assign rd = instruction_in[11:7];
	assign rs1 = instruction_in[19:15];
	assign rs2 = instruction_in[24:20];
	assign funct3 = instruction_in[14:12];
	assign funct7 = instruction_in[31:25];
	sign_extend #(.IN_SIZE(12),.OUT_SIZE(32)) se_I(.data_in(instruction_in[31:20]),.data_out(imm_I));
	sign_extend #(.IN_SIZE(12),.OUT_SIZE(32)) se_S(.data_in({instruction_in[31:25], instruction_in[11:7]}),.data_out(imm_S));
	sign_extend #(.IN_SIZE(13),.OUT_SIZE(32)) se_B(.data_in({instruction_in[31],instruction_in[7],instruction_in[30:25], instruction_in[11:8],1'b0}), .data_out(imm_B));
	assign imm_U = {instruction_in[31:12], 12'h000};
	sign_extend #(.IN_SIZE(21),.OUT_SIZE(32)) se_J(.data_in({instruction_in[31],instruction_in[19:12],instruction_in[20],instruction_in[30:21],1'b0}),.data_out(imm_J));
	assign shamt = {27'd0, instruction_in[24:20]};
endmodule
