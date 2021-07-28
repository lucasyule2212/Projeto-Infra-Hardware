module Mux_to_pc (
    input wire    [1:0]     selector,
    input wire    [31:0]    Data_0,//00
    input wire    [31:0]    Data_1,//01
    input wire    [31:0]    Data_2,//10
    input wire    [31:0]    Data_3,//11
    output wire   [31:0]    Data_out
);


    assign Data_out = selector[1] ? (selector[0] ? Data_0 : Data_1) : (selector[0] ? Data_2 : Data_3);


    
endmodule
