module grg(
	input wire WE,
	input wire clk,
	input wire [4:0] rs1,
	input wire [4:0] rs2,
	input wire [4:0] rd,
	input wire [31:0] data_rd_in,
	output wire [31:0] data_rs1_out,
	output wire [31:0] data_rs2_out
);
	reg [31:0] general_register_group[31:0];
	integer i=0;
	initial begin
		for(i = 0; i < 32; i = i + 1) begin
			general_register_group[i] = 0;
		end
	end
	always @(posedge clk) begin
		if(WE == 1) begin
			general_register_group[rd] <= data_rd_in;
		end
	end
	assign data_rs1_out = (rs1 != 0 ? general_register_group[rs1] : 0);
	assign data_rs2_out = (rs2 != 0 ? general_register_group[rs2] : 0);
endmodule
