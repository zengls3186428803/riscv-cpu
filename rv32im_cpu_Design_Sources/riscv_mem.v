module riscv_mem
	#(
		parameter MEM_SIZE=1024*1024-1
	)
	(
		output wire [31:0] data_out,
		input wire [31:0] addr,
		input wire [1:0] by,//byte:00,half_word:01,word:10
		input wire [31:0] data_in,
		input wire RE,//read enable
		input wire WE,//write enable
		input wire clk
	);

	wire [31:0] addr_align;
	assign addr_align = (by == 2'b00 ? addr : (by == 2'b01 ? (addr & ~(32'b1)) : (by == 2'b10 ? (addr & ~(32'b11)) : (addr & ~(32'b11)))));
	wire [31:0] addr_in;
	assign addr_in = addr_align>>2;

	wire [31:0] data_o;

	mem_1_byte m3(
		.clk(clk),
		.addr(addr_in),
		.data_in(data_in[31:24]),
		.data_out(data_o[31:24]),
		.WE(we[3])
	);

	mem_1_byte m2(
		.clk(clk),
		.addr(addr_in),
		.data_in(data_in[23:16]),
		.data_out(data_o[23:16]),
		.WE(we[2])
	);

	mem_1_byte m1(
		.clk(clk),
		.addr(addr_in),
		.data_in(data_in[15:8]),
		.data_out(data_o[15:8]),
		.WE(we[1])
	);

	mem_1_byte m0(
		.clk(clk),
		.addr(addr_in),
		.data_in(data_in[7:0]),
		.data_out(data_o[7:0]),
		.WE(we[0])
	);


	reg [3:0] we;

	wire [1:0] addr_in_word = addr_align[1:0];

	always @(*) begin
		if(WE==1) begin
			case(addr_in_word)
				2'b00:begin
					case(by)
						2'b00:begin
							we[0] = 1;
							we[3:1] = 0;
						end
						2'b01:begin
							we[1:0] = 2'b11;
							we[3:2] = 0;
						end
						2'b10:begin
							we[3:0] = 4'b1111;
						end
						default:begin
							we[3:0] = 4'b1111;
						end
					endcase
				end
				2'b01:begin
					case(by)
						2'b00:begin
							we[0] = 0;
							we[1] = 1;
							we[3:2] = 0;
						end
						default:begin
							we[0] = 0;
							we[1] = 1;
							we[3:2] = 0;
						end
					endcase
				end
				2'b10:begin
					case(by)
						2'b00:begin
							we[1:0] = 0;
							we[2] = 1;
							we[3] = 0;
						end
						2'b01:begin
							we[1:0] = 0;
							we[3:2] = 2'b11;
						end
						default:begin
							we[1:0] = 0;
							we[3:2] = 2'b11;
						end
					endcase
				end
				2'b11:begin
					case(by)
						2'b00:begin
							we[2:0] = 0;
							we[3] = 1;
						end
						default:begin
							we[2:0] = 0;
							we[3] = 1;
						end
					endcase
				end
			endcase
		end
		else begin
			we = 0;
		end
	end


	bufif1_n bufif(.data_out(data_out), .data_in(data_o), .E(RE));

endmodule


module mem_1_byte
	#(
		parameter MEM_SIZE=1024*1024-1
	)
	(
		output wire [7:0] data_out,
		input wire [7:0] data_in,
		input wire [31:0] addr,
		input wire WE,//write enable
		input wire clk
	);
	reg [7:0] m[MEM_SIZE:0];
	always @(posedge clk) begin
		if(WE == 1) begin
			m[addr] <= data_in;
		end
	end
	assign data_out = m[addr];
endmodule
