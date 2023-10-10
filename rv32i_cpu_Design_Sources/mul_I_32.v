//total 34 clocks
//if clk = 0, reset=1; else reset = 0;
module mul_I_32(
	input wire clk,
	input wire [31:0] a_net,
	input wire [31:0] b_net,
	input wire reset,
	output wire [31:0] o_high_net,
	output wire [31:0] o_low_net,
	output wire finish_net
);
	reg [63:0] a;
	reg [63:0] b;
	reg [63:0] result;
	reg finish;


	reg [5:0] cur_state;//0,1-32,3f
	reg [5:0] next_state;

	always @(posedge clk) begin
		if(reset==1) begin
			cur_state <= 6'h3f;
		end
		else begin
			cur_state <= next_state;
		end
	end

	always @(*) begin
		case(cur_state)
			6'h3f: next_state = 0;
			33: next_state = 33;
			default: begin 
				next_state = cur_state + 1;
			end
		endcase
	end

	always @(posedge clk) begin
		case(next_state)
			0: begin
				a <= {32'b0,a_net};
				b <= {32'b0,b_net};
				result <= 0;
				finish <= 0;
			end
			32: begin
				result <= result + ((b&1) == 0 ? 0 : a);
				a <= a << 1;
				b <= b >> 1;
				finish <= 1;
			end
			33: ;
			default: begin
				result <= result + ((b&1) == 0 ? 0 : a);
				a <= a << 1;
				b <= b >> 1;
			end
		endcase
	end
	assign o_high_net =  result[63:32];
	assign o_low_net[31:0] = result[31:0];
	assign finish_net = finish;

endmodule
