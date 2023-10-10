module divu_I_32(
	input wire clk,
	input wire [31:0] a_net,
	input wire [31:0] b_net,
	input wire reset,
	output wire [31:0] q_net,//quotinet
	output wire [31:0] r_net,//remainder
	output finish_net
);
	reg [31:0] a;//divident
	reg [31:0] b;//divisor
	reg [31:0] q;//quotient
	reg [31:0] r;//remainder
	reg finish;
	reg [6:0] cur_state;
	reg [6:0] next_state;

	wire ai;
	assign ai = a[31];

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
			default: next_state = cur_state + 1;
		endcase
	end

	always @(posedge clk) begin
		case(next_state)
			0: begin
				a <= a_net;
				b <= b_net;
				q <= 0;
				r <= 0;
				finish <= 0;
			end
			32: begin
				if(((r<<1)+ai) >= b) begin
					q <= (q<<1)+1;
					r <= ((r<<1)+ai) - b;
				end
				else begin
					q <= (q<<1);
					r <= (r<<1)+ai;
				end
				a <= a << 1;
				finish <= 1;
			end
			33: ;
			default: begin
				if(((r<<1)+ai) >= b) begin
					q <= (q<<1)+1;
					r <= ((r<<1)+ai) - b;
				end
				else begin
					q <= (q<<1);
					r <= (r<<1)+ai;
				end
				a <= a << 1;
			end
		endcase
	end

	assign q_net = q;
	assign r_net = r;
	assign finish_net = finish;

endmodule
