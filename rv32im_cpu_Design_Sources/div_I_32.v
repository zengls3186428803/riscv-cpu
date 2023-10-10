module div_I_32(
	input wire clk,
	input wire [31:0] a_net,
	input wire [31:0] b_net,
	input wire reset,
	output wire [31:0] q_net,
	output wire [31:0] r_net,
	output wire finish_net
);
	reg [31:0] a;//divident
	reg [31:0] b;//divisor
	reg [31:0] q;//quotient
	reg [31:0] r;//remainder
	reg finish;
	reg [5:0] cur_state;
	reg [5:0] next_state;

	always @(posedge clk) begin
		if(reset == 1) begin
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
			default: next_state = cur_state + 1;
		endcase
	end

	reg sign_result;

	wire [31:0] r1;
	assign r1 = (r<<1)+a[31];
	wire s1;//sign_before
	assign s1 = r1[31];
	wire s2;//sign_after
	wire [31:0] r1_add_b = r1 + b;
	assign s2 = r1_add_b[31];
	wire condition;//whether can sub
	assign condition = (s1 == 1 && s2 == 1 || s1 == 0 && r1 > 0 && s2 == 0 ||s1 == 1 && r1_add_b == 0 && a<<1 == 0);

	always @(posedge clk) begin
		case(next_state)
			0: begin
				q <= 0;
				a <= a_net;
				b <= (a_net[31] == b_net[31] ? (~b_net+1) : b_net);
				r <= (a_net[31] == 0 ? 32'b0 : 32'hffffffff);
				sign_result <= a_net[31] ^ b_net[31];
				finish <= 0;
			end
			32: begin
				if(condition) begin
					q <= (q<<1)+1;
					r <= r1 + b;
				end
				else begin
					q <= (q<<1);
					r <= r1;
				end
				a = a << 1;
				finish <= 1;
			end
			33: ;
			default: begin
				if(condition) begin
					q <= (q<<1)+1;
					r <= r1 + b;
				end
				else begin
					q <= (q<<1);
					r <= r1;
				end
				a = a << 1;
			end
		endcase
	end

	assign q_net = (b == 0 ? q : (sign_result == 0 ? q : (~q + 1)));
	assign r_net = r;
	assign finish_net = finish;

endmodule
