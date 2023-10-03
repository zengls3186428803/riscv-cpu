module add_I_32
#(
parameter width=32
)
(
	//input wire [31:0]cin;
	input wire [31:0]a,
	input wire [31:0]b,
	output wire [31:0]o
	//output reg [31:0]cout;
);
	wire [31:0]cin;
	wire [31:0]cout;
	wire [31:0]sum;
	genvar i;
	generate
		for(i=0;i<width;i=i+1) begin
			if(i==0) begin
				assign cin[i] = 0;
			end
			else begin
				assign cin[i] = cout[i-1];
			end
			full_add_1 fa1(.cin(cin[i]),.a(a[i]),.b(b[i]),.cout(cout[i]),.sum(sum[i]));
		end
	endgenerate
	assign o = sum;
endmodule

module full_add_1(
	input wire cin,
	input wire a,
	input wire b,
	output wire cout,
	output wire sum
);
    reg [1:0]result;
	always @(*) begin
		result = a+b+cin;
	end
	assign cout = result[1];
	assign sum = result[0];
endmodule

//module test();
//wire [31:0] a;
//wire [31:0] b;
//wire [31:0] o;
//add_I_32 add(.a(a),.b(b),.o(o));
//always @(*) begin

//end
//endmodule

