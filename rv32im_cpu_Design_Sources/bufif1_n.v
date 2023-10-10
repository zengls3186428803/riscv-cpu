module bufif1_n
  #(
    parameter SIZE = 32
  )
  (
    output wire [31:0] data_out,
    input wire [31:0] data_in,
    input wire E
  );

  genvar i;
  generate
	  for(i = 0; i < 32; i=i+1) begin
		  bufif1(data_out[i],data_in[i],E);
	  end
  endgenerate

endmodule
