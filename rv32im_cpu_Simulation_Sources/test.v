`timescale 1ns / 1ps

module test(
);
	reg [31:0] addr;
	reg clk;
	reg [31:0] data_in;
	wire [31:0] data_out;
	reg [1:0] by;
	reg WE;
	reg RE;

	riscv_mem mem(
		.clk(clk),
		.data_in(data_in),
		.data_out(data_out),
		.addr(addr),
		.WE(WE),
		.RE(RE),
		.by(by)
	);
	integer i;
	initial begin
		clk = 1;
		addr = 3;
		data_in = 5;
		RE = 1;
		WE = 1;
		by = 2;
		for(i = 0; i < 20; i = i + 1) begin
			$display("data_out=%b,m[addr]=%b",data_out,mem.m[addr]);
			clk = ~clk;
			#1;
			clk = ~clk;
			#1;
		end
	end
endmodule

/*
module test(
);
	
	reg clk;
	reg [31:0] a;
	reg [31:0] b;
	wire [31:0] q_net;
	wire [31:0] r_net;
	reg reset;

	div_I_32 div(
		.clk(clk),
		.a_net(a),
		.b_net(b),
		.q_net(q_net),
		.r_net(r_net),
		.reset(reset)
	);
	integer i=0;
	initial begin
		a = -23;
		b = -5;
		clk = 0;
		for(i = 0; i < 40; i = i + 1) begin
			if(i==0) reset=1;
			else reset=0;
			$display("clk=%d,cur_state=%d,next_state=%d,q=%b,r=%b,a=%b,b=%b",clk,div.cur_state,div.next_state,q_net,r_net,div.a,div.b);
			clk = ~clk;
			#1;
			clk = ~clk;
			#1;
		end
	end
	
endmodule
*/

//module test(

//);
//	reg clk;
//	reg [31:0] a;
//	reg [31:0] b;
//	wire [31:0] o_h;
//	wire [31:0] o_l;
//	reg reset;
//	mul_I_32 mul(
//		.clk(clk),
//		.a_net(a),
//		.b_net(b),
//		.reset(reset),
//		.o_high_net(o_h),
//		.o_low_net(o_l)
//	);
//	integer i=0;
//	initial begin
//		a = -33;
//		b = -20;
//		clk = 0;
//		for(i = 0; i < 35; i = i + 1) begin
//			if(i < 1) reset = 1;
//			else reset = 0;
//			$display("i = %d, clk = %d,cur_state=%d,next_state=%d",i,clk,mul.cur_state,mul.next_state);
//			$display("o_h=%d\no_l=%d",o_h,o_l);
//			clk = ~clk;
//			#1;
//			clk = ~clk;
//			#1;
//		end
//	end
//endmodule
