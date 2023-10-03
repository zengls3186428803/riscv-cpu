module alu_op_decision(
	input wire [6:0] funct7,
	input wire [2:0] funct3,
	input wire [6:0] opcode,
	output reg [3:0] alu_op
);
	wire [16:0] in;
	assign in = {funct7, funct3, opcode};
//	wire [9:0] in_;
//	assign in_ = {funct3, opcode};
	always @(*) begin
		casez(in)
			//R-type
			17'b00000000000110011 : alu_op = 4'b0000;
			17'b01000000000110011 : alu_op = 4'b0001;
			17'b00000000010110011 : alu_op = 4'b0010;
			17'b00000000100110011 : alu_op = 4'b0011;
			17'b00000000110110011 : alu_op = 4'b0100;
			17'b00000001000110011 : alu_op = 4'b0101;
			17'b00000001010110011 : alu_op = 4'b0110;
			17'b01000001010110011 : alu_op = 4'b0111;
			17'b00000001100110011 : alu_op = 4'b1000;
			17'b00000001110110011 : alu_op = 4'b1001;

			//RI-type
			17'b00000000010010011 : alu_op = 4'b0010;
			17'b00000001010010011 : alu_op = 4'b0110;
			17'b01000001010010011 : alu_op = 4'b0111;


			17'bzzzzzzz0000010011 : alu_op = 4'b0000;
			17'bzzzzzzz0100010011 : alu_op = 4'b0011;
			17'bzzzzzzz0110010011 : alu_op = 4'b0100;
			17'bzzzzzzz1000010011 : alu_op = 4'b0101;
			17'bzzzzzzz1100010011 : alu_op = 4'b1000;
			17'bzzzzzzz1110010011 : alu_op = 4'b1001;
			default : alu_op = 4'b0000;
		endcase
		/*	
		case(in_)
		//RI-type
		10'b0000010011 : alu_op = 4'b0000;
		10'b0100010011 : alu_op = 4'b0011;
		10'b0110010011 : alu_op = 4'b0100;
		10'b1000010011 : alu_op = 4'b0101;
		10'b1100010011 : alu_op = 4'b1000;
		10'b1110010011 : alu_op = 4'b1001;
		default : alu_op = 4'b0000;
		endcase
		*/		
	end
endmodule
