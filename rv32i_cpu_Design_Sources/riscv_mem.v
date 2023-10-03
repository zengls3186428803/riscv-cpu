`define MEM_SIZE 1024*1024-1

module riscv_mem
	#(
		parameter MEM_SIZE=8 * 1024*1024 - 1
	)
	(
		input wire[31:0] addr_in,
		input wire[31:0] data_in,
		input wire RE,//read enable
		input wire WE,//write enable
		input wire clk,
		output wire [31:0] data_out
	);
	reg [31:0] m[MEM_SIZE:0];
	wire [31:0] data_o;

	integer i;
	initial begin
	    for(i = 0; i <= MEM_SIZE; i = i + 1 ) begin
	       m[i] = 0;
	    end
		$readmemh("/home/zengls/code/c/final_hex.txt", m, 0);
//		$display("memory:");
//		for(i = 0; i < 34; i = i + 1) begin
//			$display("%h: %b",i*4,m[i]);
//		end
	end

	always @(posedge clk) begin
		if(WE == 1) begin
			m[addr_in>>2] = data_in;
		end
	end
	bufif1_n bufif(data_o, m[addr_in>>2], RE);
	assign data_out = data_o;
endmodule
