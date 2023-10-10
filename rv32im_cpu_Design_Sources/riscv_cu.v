`define IDLE			5'd31
`define LOAD_INST_0 	5'd0//addr_reg
`define LOAD_INST_1 	5'd1//data_reg
`define LOAD_INST_2 	5'd2//inst_reg
`define EXEC_R			5'd3
`define EXEC_RI			5'd4
`define EXEC_S_0		5'd5//addr_reg
`define EXEC_S_1		5'd6//data_reg
`define EXEC_S_2		5'd7//memory
`define EXEC_L_0		5'd8//addr_reg
`define EXEC_L_1		5'd9//data_reg
`define EXEC_L_2		5'd10//grg_reg
`define EXEC_B			5'd11
`define EXEC_JAL		5'd12
`define EXEC_JALR		5'd13
`define EXEC_LUI		5'd14
`define EXEC_AUIPC		5'd15
`define EXEC_R_M_0		5'd16//initialize function unit
`define EXEC_R_M_1		5'd17//init state
`define EXEC_R_M_2 		5'd18//calculate and listening "finish"
`define EXEC_R_M_3		5'd19//write result
`define EXEC_R_D_0		5'd20
`define EXEC_R_D_1		5'd21
`define EXEC_R_D_2		5'd22
`define EXEC_R_D_3		5'd23
`define EXEC_R_DU_0		5'd24
`define EXEC_R_DU_1 	5'd25
`define EXEC_R_DU_2		5'd26
`define EXEC_R_DU_3		5'd27

module riscv_cu(
	input wire clk,
	input wire [6:0] opcode,
	input wire [2:0] funct3,
	input wire [6:0] funct7,

	output wire pc_WE_net,
	output wire addr_reg_WE_net,
	output wire data_reg_WE_net,
	output wire inst_reg_WE_net,
	output wire grg_WE_net,
	output wire mem_RE_net,
	output wire mem_WE_net,
	output wire [1:0] mem_by_net,

	output wire sel_pc_grg_net,
	output wire sel_mem_grg_net,
	output wire [2:0] sel_b_h_w_bu_hu_net,

	output wire mul_rst_net,
	input wire mul_finish_net,
	output wire divu_rst_net,
	input wire divu_finish_net,
	output wire div_rst_net,
	input wire div_finish_net

);                              
	reg pc_WE;
	reg addr_reg_WE;
	reg data_reg_WE;
	reg inst_reg_WE;
	reg grg_WE;
	reg mem_RE;
	reg mem_WE;
	reg [1:0] mem_by;

	reg sel_pc_grg;
	reg sel_mem_grg;
	reg [2:0] sel_b_h_w_bu_hu;

	reg mul_rst;
	reg div_rst;
	reg divu_rst;

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
					7'b0110011 : begin
						if(funct7 == 1) begin
							case(funct3)
								0,1,2,3: next_state = `EXEC_R_M_0;
								4,6: next_state = `EXEC_R_D_0;
								5,7: next_state = `EXEC_R_DU_0;
							endcase
						end
						else begin
							next_state = `EXEC_R;
						end
					end
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
			`EXEC_R_M_0: begin
				next_state = `EXEC_R_M_1;
			end
			`EXEC_R_M_1: begin
				next_state = `EXEC_R_M_2;
			end
			`EXEC_R_M_2: begin
				if(mul_finish_net == 1) begin
					next_state = `EXEC_R_M_3;
				end
				else begin
					next_state = `EXEC_R_M_2;
				end
			end
			`EXEC_R_M_3: begin
				next_state = `LOAD_INST_0;
			end
			`EXEC_R_D_0: begin
				next_state = `EXEC_R_D_1;
			end
			`EXEC_R_D_1: begin
				next_state = `EXEC_R_D_2;
			end
			`EXEC_R_D_2: begin
				if(div_finish_net == 1) begin
					next_state = `EXEC_R_D_3;
				end
				else begin
					next_state = `EXEC_R_D_2;
				end
			end
			`EXEC_R_D_3: begin
				next_state = `LOAD_INST_0;
			end
			`EXEC_R_DU_0: begin
				next_state = `EXEC_R_DU_1;
			end
			`EXEC_R_DU_1: begin
				next_state = `EXEC_R_DU_2;
			end
			`EXEC_R_DU_2: begin
				if(divu_finish_net == 1) begin
					next_state = `EXEC_R_DU_3;
				end
				else begin
					next_state = `EXEC_R_DU_2;
				end
			end
			`EXEC_R_DU_3: begin
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
			`EXEC_R_M_0: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				mul_rst <= 1;
			end
			`EXEC_R_M_1: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				mul_rst <= 0;
			end
			`EXEC_R_M_2: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_R_M_3: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_R_D_0: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				div_rst <= 1;
			end
			`EXEC_R_D_1: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				div_rst <= 0;
			end
			`EXEC_R_D_2: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_R_D_3: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 1;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_R_DU_0: begin
				pc_WE <= 1;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				divu_rst <= 1;
			end
			`EXEC_R_DU_1: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				divu_rst <= 0;
			end
			`EXEC_R_DU_2: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 0;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
			end
			`EXEC_R_DU_3: begin
				pc_WE <= 0;
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
	assign mul_rst_net = mul_rst;
	assign divu_rst_net = divu_rst;
	assign div_rst_net = div_rst;


endmodule
