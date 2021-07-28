module shift_left2_32(

	 input [31:0]  Data_0,
    output reg[31:0]  Data_out
);

   

always @(*)
begin
      Data_out[31:0] <= Data_0[31:0] << 2'd0;
end

endmodule