module riscv_core(
	input wire clk
);
	//wires of program counter
	wire [31:0] pc_net;
	wire pc_reset_net = 0;
	wire pc_WE_net;
	wire [31:0] pc_data_in_net;
	wire [31:0] pc_a4_net;

	//wires of memory
	wire [31:0] mem_data_out_net;
	wire [31:0] mem_data_in_net;
	wire [31:0] mem_addr_net;
	wire mem_WE_net;
	wire mem_RE_net;

	//wires of arithmetic logic unit
	wire [31:0] alu_a_net;
	wire [31:0] alu_b_net;
	wire [31:0] alu_r_net;
	wire [3:0] alu_op_net;

	//wires of general register group
	wire [4:0] grg_rs1_net;
	wire [4:0] grg_rs2_net;
	wire [4:0] grg_rd_net;
	wire [31:0] grg_data_rd_in;
	wire [31:0] grg_data_rs1_out_net;
	wire [31:0] grg_data_rs2_out_net;
	wire grg_WE_net;

	//wire of register
	wire [31:0] addr_reg_data_in_net;
	wire [31:0] addr_reg_data_out_net;
	wire addr_reg_WE_net;

	wire [31:0] data_reg_data_in_net;
	wire [31:0] data_reg_data_out_net;
	wire data_reg_WE_net;

	wire [31:0] inst_reg_data_in_net;
	wire [31:0] inst_reg_data_out_net;
	wire inst_reg_WE_net;

	//iss = instruction struct spliter
	wire [31:0] iss_instruct_in_net;
	wire [6:0] iss_opcode_net;
	wire [4:0] iss_rd_net;
	wire [4:0] iss_rs1_net;
	wire [4:0] iss_rs2_net;
	wire [2:0] iss_funct3_net;
	wire [6:0] iss_funct7_net;
	wire [31:0] iss_imm_I_net;
	wire [31:0] iss_imm_S_net;
	wire [31:0] iss_imm_B_net;
	wire [31:0] iss_imm_U_net;
	wire [31:0] iss_imm_J_net;

	//branch
	wire [31:0] branch_a_net;
	wire [31:0] branch_b_net;
	wire [2:0] branch_op_net;
	wire branch_out;

	pc program_counter(
		.data_out(pc_net), 
		.data_in(pc_data_in_net),
		.WE(pc_WE_net),
		.reset(pc_reset_net),
		.clk(clk)
	);

	riscv_mem memory(
		.data_out(mem_data_out_net),
		.data_in(mem_data_in_net),
		.addr_in(mem_addr_net), 
		.RE(mem_RE_net),
		.WE(mem_WE_net),
		.clk(clk)
	);

	riscv_alu alu(
		.a_in(alu_a_net),
		.b_in(alu_b_net),
		.r_o(alu_r_net),
		.op(alu_op_net)
	);

	grg general_register_group(
		.rs1(grg_rs1_net),
		.rs2(grg_rs2_net),
		.rd(grg_rd_net),
		.data_rs1_out(grg_data_rs1_out_net),
		.data_rs2_out(grg_data_rs2_out_net),
		.data_rd_in(grg_data_rd_in),
		.WE(grg_WE_net),
		.clk(clk)
	);

	register addr_reg(
		.data_in(addr_reg_data_in_net),
		.data_out(addr_reg_data_out_net),
		.WE(addr_reg_WE_net),
		.clk(clk)
	);

	register data_reg(
		.data_in(data_reg_data_in_net),
		.data_out(data_reg_data_out_net),
		.WE(data_reg_WE_net),
		.clk(clk)
	);

	register inst_reg(
		.data_in(inst_reg_data_in_net),
		.data_out(inst_reg_data_out_net),
		.WE(inst_reg_WE_net),
		.clk(clk)
	);

	instruct_struct_spliter inst_struct_spliter(
		.instruction_in(iss_instruct_in_net),
		.opcode(iss_opcode_net),
		.rd(iss_rd_net),
		.rs1(iss_rs1_net),
		.rs2(iss_rs2_net),
		.funct3(iss_funct3_net),
		.funct7(iss_funct7_net),
		.imm_I(iss_imm_I_net),
		.imm_S(iss_imm_S_net),
		.imm_B(iss_imm_B_net),
		.imm_U(iss_imm_U_net),
		.imm_J(iss_imm_J_net)
	);


	branch branch_unit(
		.a(branch_a_net),
		.b(branch_b_net),
		.bop(branch_op_net),
		.out(branch_out)
	);

	branch_op_decision bop_decision(
		.funct3(iss_funct3_net),
		.bop(branch_op_net)
	);

	alu_op_decision alu_op_dec(
		.funct7(iss_funct7_net),
		.funct3(iss_funct3_net),
		.opcode(iss_opcode_net),
		.alu_op(alu_op_net)
	);

	//program counter
	wire [31:0] multiplex_4_B_J_RJ_net [3:0];
	wire [1:0] sel_4_B_J_RJ_net;
	assign multiplex_4_B_J_RJ_net[0] = pc_net + 4;
	assign multiplex_4_B_J_RJ_net[1] = pc_net + (branch_out == 1 ? iss_imm_B_net : 4);
	assign multiplex_4_B_J_RJ_net[2] = pc_net + iss_imm_J_net;
	assign multiplex_4_B_J_RJ_net[3] = grg_data_rs1_out_net + iss_imm_I_net;
	assign pc_data_in_net = multiplex_4_B_J_RJ_net[sel_4_B_J_RJ_net];
	assign sel_4_B_J_RJ_net = (iss_opcode_net == 7'b1100011 ? 2'b01 : (iss_opcode_net == 7'b1101111 ? 2'b10 : (iss_opcode_net == 7'b1100111 ? 2'b11 : 2'b00)));

	//branch
	assign branch_a_net = grg_data_rs1_out_net;
	assign branch_b_net = grg_data_rs2_out_net;



	//load-store
	wire [31:0] addr_grg_plus_imm_net;
	wire [31:0] multiplex_immI_immS_net[1:0];
	wire sel_immI_immS_net;
	assign multiplex_immI_immS_net[0] = iss_imm_I_net;
	assign multiplex_immI_immS_net[1] = iss_imm_S_net;
	assign addr_grg_plus_imm_net = multiplex_immI_immS_net[sel_immI_immS_net] + grg_data_rs1_out_net;
	assign sel_immI_immS_net = (iss_opcode_net == 7'b0100011 ? 1 : 0);

	//address register
	wire [31:0] multiplex_pc_grg_net[1:0];
	wire sel_pc_grg_net;
	assign multiplex_pc_grg_net[0] = pc_net;
	assign multiplex_pc_grg_net[1] = addr_grg_plus_imm_net;
	assign addr_reg_data_in_net = multiplex_pc_grg_net[sel_pc_grg_net];
	//assign sel_pc_grg_net = ((iss_opcode_net == 7'b0100011 || iss_opcode_net == 7'b0000011) ? 1 : 0);

	assign mem_addr_net = addr_reg_data_out_net;

	//data register
	wire [31:0] multiplex_mem_grg_net[1:0];
	wire sel_mem_grg_net;
	assign multiplex_mem_grg_net[0] = mem_data_out_net;
	assign multiplex_mem_grg_net[1] = grg_data_rs2_out_net;
	assign data_reg_data_in_net = multiplex_mem_grg_net[sel_mem_grg_net];
	//assign sel_mem_grg_net = (iss_opcode_net == 7'b0100011 ? 1 : 0);

	assign mem_data_in_net = data_reg_data_out_net;

	//instruction register
	assign inst_reg_data_in_net = data_reg_data_out_net;
	assign iss_instruct_in_net = inst_reg_data_out_net;

	//general register group
	assign grg_rs1_net = iss_rs1_net;
	assign grg_rs2_net = iss_rs2_net;
	assign grg_rd_net = iss_rd_net;

	wire [1:0] sel_alu_mem_imm_pca4_net;
	wire [31:0] multiplex_alu_mem_imm_pca4_net [3:0];
	assign multiplex_alu_mem_imm_pca4_net[0] = alu_r_net;//R(I)-type
	assign multiplex_alu_mem_imm_pca4_net[1] = data_reg_data_out_net;//load
	assign multiplex_alu_mem_imm_pca4_net[2] = iss_imm_U_net;//lui
	assign multiplex_alu_mem_imm_pca4_net[3] = pc_a4_net;//jal,jalr
	assign pc_a4_net = (iss_opcode_net == 7'b0010111 ? pc_net + iss_imm_U_net : pc_net + 4);
	assign grg_data_rd_in = multiplex_alu_mem_imm_pca4_net[sel_alu_mem_imm_pca4_net];
	assign sel_alu_mem_imm_pca4_net = (iss_opcode_net == 7'b0000011 ? 2'b01 : (iss_opcode_net == 7'b1101111 || iss_opcode_net == 7'b1100111 || iss_opcode_net == 7'b0010111 ? 2'b11 : (iss_opcode_net == 7'b0110111 ? 2'b10 : 2'b00)));

	//arithmatic logic unit
	assign alu_a_net = grg_data_rs1_out_net;
	wire sel_grg_imm_net;
	wire [31:0] multiplex_grg_imm_net[1:0];
	assign multiplex_grg_imm_net[0] = grg_data_rs2_out_net;
	assign multiplex_grg_imm_net[1] = iss_imm_I_net;
	assign alu_b_net = multiplex_grg_imm_net[sel_grg_imm_net];
	assign sel_grg_imm_net = (iss_opcode_net == 7'b0010011 ? 1 : 0);

	riscv_cu control_unit(
		.clk(clk),
		.opcode(iss_opcode_net),
		.pc_WE_net(pc_WE_net),
		.addr_reg_WE_net(addr_reg_WE_net),
		.data_reg_WE_net(data_reg_WE_net),
		.inst_reg_WE_net(inst_reg_WE_net),
		.grg_WE_net(grg_WE_net),
		.mem_RE_net(mem_RE_net),
		.mem_WE_net(mem_WE_net),
		.sel_pc_grg_net(sel_pc_grg_net),
		.sel_mem_grg_net(sel_mem_grg_net)
	);

endmodule
