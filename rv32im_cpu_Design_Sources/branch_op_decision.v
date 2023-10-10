module branch_op_decision(
	input wire [2:0] funct3,
	output reg [2:0] bop
);
	always @(*) begin
		case(funct3)
			3'b000: bop = 3'b000;
			3'b001: bop = 3'b001;
			3'b100: bop = 3'b010;
			3'b101: bop = 3'b011;
			3'b110: bop = 3'b100;
			3'b111: bop = 3'b101;
			default: bop = 0;
		endcase
	end
endmodule
