`define LOAD_INST_0 	5'd0
`define LOAD_INST_1 	5'd1
`define LOAD_INST_2 	5'd2
`define EXEC_R			5'd3
`define EXEC_RI			5'd4
`define EXEC_S_0		5'd5
`define EXEC_S_1		5'd6
`define EXEC_S_2		5'd7
`define EXEC_L_0		5'd8
`define EXEC_L_1		5'd9
`define EXEC_L_2		5'd10
`define EXEC_B			5'd11
`define EXEC_JAL		5'd12
`define EXEC_JALR		5'd13
`define EXEC_LUI		5'd14
`define EXEC_AUIPC		5'd15
`define IDLE			5'd31

module riscv_cu(
	input wire clk,
	input wire [6:0] opcode,
	input wire [2:0] funct3,
	output wire pc_WE_net,
	output wire addr_reg_WE_net,
	output wire data_reg_WE_net,
	output wire inst_reg_WE_net,
	output wire grg_WE_net,
	output wire mem_RE_net,
	output wire mem_WE_net,
	output wire sel_pc_grg_net,
	output wire sel_mem_grg_net,
	output wire [1:0] mem_by_net,
	output wire [2:0] sel_b_h_w_bu_hu_net
);                              
	reg pc_WE;
	reg addr_reg_WE;
	reg data_reg_WE;
	reg inst_reg_WE;
	reg grg_WE;
	reg mem_RE;
	reg mem_WE;

	reg sel_pc_grg;
	reg sel_mem_grg;
	reg [2:0] sel_b_h_w_bu_hu;

	reg [1:0] mem_by;

	reg [4:0] cur_state;
	reg [4:0] next_state;

	initial begin
		cur_state = `IDLE;
		pc_WE = 0;
		addr_reg_WE = 0;
		data_reg_WE = 0;
		inst_reg_WE = 0;
		grg_WE = 0;
		mem_RE = 0;
		mem_WE = 0;
		sel_pc_grg = 0;
		sel_mem_grg = 0;
		sel_b_h_w_bu_hu = 0;
	end

	//state update;
	always @(negedge clk) begin
		cur_state <= next_state;
	end

	//determine next state;
	always @(*) begin
		case(cur_state)
			`LOAD_INST_0: begin
				next_state = `LOAD_INST_1;
			end
			`LOAD_INST_1: begin
				next_state = `LOAD_INST_2;
			end
			`LOAD_INST_2: begin
				case(opcode)
					7'b0110011 : next_state = `EXEC_R;
					7'b0010011 : next_state = `EXEC_RI;
					7'b0100011 : next_state = `EXEC_S_0;
					7'b0000011 : next_state = `EXEC_L_0;
					7'b1100011 : next_state = `EXEC_B;
					7'b1101111 : next_state = `EXEC_JAL;
					7'b1100111 : next_state = `EXEC_JALR;
					7'b0110111 : next_state = `EXEC_LUI;
					7'b0010111 : next_state = `EXEC_AUIPC;
					default : next_state = `IDLE;
				endcase
			end
			`EXEC_R: begin
				next_state = `LOAD_INST_0;
			end
			`EXEC_RI: begin
				next_state = `LOAD_INST_0;
			end
			`EXEC_S_0: begin
				next_state = `EXEC_S_1;
			end
			`EXEC_S_1: begin
				next_state = `EXEC_S_2;
			end
			`EXEC_S_2: begin
				next_state = `LOAD_INST_0;
			end
			`EXEC_L_0: begin
				next_state = `EXEC_L_1;
			end
			`EXEC_L_1: begin
				next_state = `EXEC_L_2;
			end
			`EXEC_L_2: begin
				next_state = `LOAD_INST_0;
			end
			`EXEC_B: begin
				next_state = `LOAD_INST_0;
			end
			`EXEC_JAL: begin
				next_state = `LOAD_INST_0;
			end
			`EXEC_JALR: begin
				next_state = `LOAD_INST_0;
			end
			`EXEC_LUI: begin
				next_state = `LOAD_INST_0;
			end
			`EXEC_AUIPC: begin
				next_state = `LOAD_INST_0;
			end
			`IDLE: begin
				next_state = `LOAD_INST_0;
			end
			default: next_state = `IDLE;
		endcase
	end

	//determine output(modify "real"-state)
	always @(negedge clk) begin
		case(next_state)
			`LOAD_INST_0: begin
				pc_WE <= 0;
				addr_reg_WE <= 1;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				sel_pc_grg <= 0;
			end
			`LOAD_INST_1: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 1;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 1;
				mem_WE <= 0;
				mem_by <= 2;
				sel_b_h_w_bu_hu <= 2;
			end
			`LOAD_INST_2: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 1;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_R: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_RI: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_S_0: begin
				pc_WE <= 1;
				addr_reg_WE <= 1;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				sel_pc_grg <= 1;
			end
			`EXEC_S_1: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 1;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				sel_mem_grg <= 1;
			end
			`EXEC_S_2: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 1;
				sel_mem_grg <= 0;
				mem_by <= funct3[1:0];
			end
			`EXEC_L_0: begin
				pc_WE <= 1;
				addr_reg_WE <= 1;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				sel_pc_grg <= 1;
			end
			`EXEC_L_1: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 1;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 1;
				mem_WE <= 0;
				mem_by <= funct3[1:0];
				sel_b_h_w_bu_hu <= (funct3 == 0 ? 0 : (funct3 == 1 ? 1 : (funct3 == 2 ? 2 : (funct3 == 4 ? 3 : (funct3 == 5 ? 4 : 4)))));
			end
			`EXEC_L_2: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_B: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_JAL: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_JALR: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_LUI: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_AUIPC: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`IDLE: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			default: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
			end
		endcase
	end

	assign pc_WE_net = pc_WE;
	assign addr_reg_WE_net = addr_reg_WE;
	assign data_reg_WE_net = data_reg_WE;
	assign inst_reg_WE_net = inst_reg_WE;
	assign grg_WE_net = grg_WE;
	assign mem_RE_net = mem_RE;
	assign mem_WE_net = mem_WE;
	assign sel_pc_grg_net = sel_pc_grg;
	assign sel_mem_grg_net = sel_mem_grg;
	assign mem_by_net = mem_by;
	assign sel_b_h_w_bu_hu_net = sel_b_h_w_bu_hu;

endmodule
