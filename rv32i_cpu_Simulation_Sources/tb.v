`timescale 10ns/1ns

module tb(
);
	reg clk;
	riscv_core core(clk);
	ff f(clk);
	integer i;
	reg [1:0] by;
	reg [31:0] addr;


	integer fptr;
	reg [7:0] x;
	initial begin
		fptr = $fopen("/home/zengls/code/c/final_ld.bin","r");
		for(i = 0; i <= 1024*1024-1; i = i + 1 ) begin
			core.memory.m0.m[i] = 0;
			core.memory.m1.m[i] = 0;
			core.memory.m2.m[i] = 0;
			core.memory.m3.m[i] = 0;
		end
		
		for(i = 0; i < 264 && !$feof(fptr); i = i + 1) begin
			if(i%4 == 0) begin
				$fread(x,fptr);
				core.memory.m0.m[i/4]=x;
			end
			else if(i%4==1) begin
				$fread(x,fptr);
				core.memory.m1.m[i/4]=x;
			end
			else if(i%4==2) begin
				$fread(x,fptr);
				core.memory.m2.m[i/4]=x;
			end
			else begin
				$fread(x,fptr);
				core.memory.m3.m[i/4]=x;
				$display("%b",{core.memory.m3.m[i/4],core.memory.m2.m[i/4],core.memory.m1.m[i/4],core.memory.m0.m[i/4]});
			end
		end
		/*
		for(i = 0; i < 264 && !$feof(fptr); i = i + 1) begin
			if(i%4 == 0) begin
				$fread(core.memory.m0.m,fptr,i/4,1);
			end
			else if(i%4==1) begin
				$fread(core.memory.m1.m,fptr,i/4,1);
			end
			else if(i%4==2) begin
				$fread(core.memory.m2.m,fptr,i/4,1);
			end
			else if(i%4==3) begin
				$fread(core.memory.m3.m,fptr,i/4,1);
				$display("%b",{core.memory.m3.m[i/4],core.memory.m2.m[i/4],core.memory.m1.m[i/4],core.memory.m0.m[i/4]});
			end
		end
        */
		$fclose(fptr);
//	end

//	initial begin
		clk = 0;
		by = 2'b10;
		addr = 31'b1101;
		for(i = 0; i < 8000; i = i + 1) begin
			$display("*******************************************");
			$display("i=%d",i);
			$display("grg[ra]=%X",core.general_register_group.general_register_group[1]);
			$display("alu_out= %X",core.alu_r_net);
			$display("addr_align=%X,addr_in=%X",core.memory.addr_align, core.memory.addr_in);
			$display("pc=%X\naddr=%X\ndata=%X\ninst=%X",
				core.program_counter.program_counter,
				core.addr_reg.data,
				core.data_reg.data,
				core.inst_reg.data
			);
			$display("%s,state=%d,opcode=%b:pc_WE=%d,addr_WE=%d,data_WE=%d,inst_WE=%d,grg_WE=%d,mem_RE=%d,mem_WE=%d,sel_pc_grg=%d,sel_mem_grg=%d,sel_b_h_w_bu_hu=%d",
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
				core.control_unit.sel_mem_grg,
				core.control_unit.sel_b_h_w_bu_hu
			);
			clk = ~clk;
			#1 ;
		end
		//		$display("===============================================\n");
		//		$display("grg[sp]=%X",core.general_register_group.general_register_group[2]);
		$display("m[0X100]=%X",{core.memory.m3.m[64],core.memory.m2.m[64],core.memory.m1.m[64],core.memory.m0.m[64]});
		//		$display("===============================================\n");
	end
endmodule
