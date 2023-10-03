module sub_I_32(
input wire [31:0] a,
input wire [31:0] b,
output wire [31:0] o
);
add_I_32 add(.a(a),.b(~b+1),.o(o));
endmodule