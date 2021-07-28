module shift_left2(

	input [25:0] Data_0, 
    output reg [27:0]  Data_out
);

    

always @(*)
begin
    Data_out[27:0] <= Data_0[25:0] << 2'd0;
end

endmodule