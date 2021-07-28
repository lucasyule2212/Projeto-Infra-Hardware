module Mux_to_Mem (
    input  wire    [1:0]     selector,
    input  wire    [31:0]    Data_0,
    input  wire    [31:0]    Data_1,
    input  wire    [31:0]    Data_2,
    output wire    [31:0]    Data_out
);

   

    assign Data_out = selector[1] ? Data_2 : (selector[0] ? Data_0 : Data_1);
    
endmodule