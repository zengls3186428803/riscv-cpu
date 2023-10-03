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


`define PC_WE 					5'd0 		
`define ADDR_REG_WE             5'd1
`define DATA_REG_WE             5'd2
`define INST_REG_WE             5'd3
`define REG_WE                  5'd4
`define MEM_RE                  5'd5
`define MEM_WE                  5'd6
`define SEL_PC_GRG              5'd7
`define SEL_MEM_GRG             5'd8
`define SEL_IMMI_IMMS           5'd9
`define SEL_4_B_J_RJ            5'd10
`define SEL_ALU_MEM_IMM_PCA     5'd11

module riscv_cu(
	input wire clk,
	input wire [6:0] opcode,
	output wire pc_WE_net,
	output wire addr_reg_WE_net,
	output wire data_reg_WE_net,
	output wire inst_reg_WE_net,
	output wire grg_WE_net,
	output wire mem_RE_net,
	output wire mem_WE_net
);                              
	reg pc_WE;
	reg addr_reg_WE;
	reg data_reg_WE;
	reg inst_reg_WE;
	reg grg_WE;
	reg mem_RE;
	reg mem_WE;

	reg [4:0] cur_state;//this variable is for debug
	reg [4:0] state;

	initial begin
		state = `LOAD_INST_0;
		cur_state = state;
		pc_WE = 0;
		addr_reg_WE = 0;
		data_reg_WE = 0;
		inst_reg_WE = 0;
		grg_WE = 0;
		mem_RE = 0;
		mem_WE = 0;
	end

	always @(negedge clk) begin
		cur_state <= state;
		case(state)
			`LOAD_INST_0: begin

				pc_WE <= 0;
				addr_reg_WE <= 1;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `LOAD_INST_1;
			end
			`LOAD_INST_1: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 1;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 1;
				mem_WE <= 0;

				state <= `LOAD_INST_2;
			end
			`LOAD_INST_2: begin
				$display("LOAD_INST_2,opcode=%b",opcode);
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 1;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				case(opcode)
					7'b0110011 : state <= `EXEC_R;
					7'b0010011 : state <= `EXEC_RI;
					7'b0100011 : state <= `EXEC_S_0;
					7'b0000011 : state <= `EXEC_L_0;
					7'b1100011 : state <= `EXEC_B;
					7'b1101111 : state <= `EXEC_JAL;
					7'b1100111 : state <= `EXEC_JALR;
					7'b0110111 : state <= `EXEC_LUI;
					7'b0010111 : state <= `EXEC_AUIPC;
				endcase
			end
			`EXEC_R: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `LOAD_INST_0;
			end
			`EXEC_RI: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `LOAD_INST_0;
			end
			`EXEC_S_0: begin
				pc_WE <= 1;
				addr_reg_WE <= 1;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `EXEC_S_1;
			end
			`EXEC_S_1: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 1;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `EXEC_S_2;
			end
			`EXEC_S_2: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 1;
				state <= `LOAD_INST_0;
			end
			`EXEC_L_0: begin
				pc_WE <= 1;
				addr_reg_WE <= 1;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `EXEC_L_1;
			end
			`EXEC_L_1: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 1;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 1;
				mem_WE <= 0;
				state <= `EXEC_L_2;
			end
			`EXEC_L_2: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `LOAD_INST_0;
			end
			`EXEC_B: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `LOAD_INST_0;
			end
			`EXEC_JAL: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `LOAD_INST_0;
			end
			`EXEC_JALR: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `LOAD_INST_0;
			end
			`EXEC_LUI: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `LOAD_INST_0;
			end
			`EXEC_AUIPC: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
				state <= `LOAD_INST_0;
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

endmodule
