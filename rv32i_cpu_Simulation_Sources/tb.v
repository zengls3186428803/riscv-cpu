`timescale 10ns/1ns

module tb(
);
	reg clk;
	riscv_core core(clk);
	ff f(clk);
	integer i;
	initial begin
		clk = 0;
		for(i = 0; i < 8000; i = i + 1) begin
			$display("*******************************************");
			$display("i=%d",i);
			$display("grg[ra]=%X",core.general_register_group.general_register_group[1]);
			$display("alu_out= %X",core.alu_r_net);
			$display("pc=%X\naddr=%X\ndata=%X\ninst=%X",
				core.program_counter.program_counter,
				core.addr_reg.data,
				core.data_reg.data,
				core.inst_reg.data
			);
			$display("%s,state=%d,opcode=%b:pc_WE=%d,addr_WE=%d,data_WE=%d,inst_WE=%d,grg_WE=%d,mem_RE=%d,mem_WE=%d,sel_pc_grg=%d,sel_mem_grg=%d",
				(clk == 0 ? "clk=0":"clk=1"),
				core.control_unit.cur_state,
				core.control_unit.opcode,
				core.control_unit.pc_WE,
				core.control_unit.addr_reg_WE,
				core.control_unit.data_reg_WE,
				core.control_unit.inst_reg_WE,
				core.control_unit.grg_WE,
				core.control_unit.mem_RE,
				core.control_unit.mem_WE,
				core.control_unit.sel_pc_grg,
				core.control_unit.sel_mem_grg
			);
			clk = ~clk;
			#1 ;
		end
		$display("===============================================\n");
		$display("grg[sp]=%X",core.general_register_group.general_register_group[2]);
		$display("m[0X100]=%X",core.memory.m[256/4]);
		$display("===============================================\n");
	end
endmodule