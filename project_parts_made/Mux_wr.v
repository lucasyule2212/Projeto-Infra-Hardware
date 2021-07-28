module Mux_wr (
    input wire    [2:0]     selector, 
    input wire    [31:0]    Data_0, //000
    input wire    [31:0]    Data_1, //001
    input wire    [31:0]    Data_2, //010
    input wire    [31:0]    Data_3, //011
    input wire    [31:0]    Data_4, //100
    input wire    [31:0]    Data_5, //101
    input wire    [31:0]    Data_6, //110
    output wire   [31:0]    Data_out
);

    wire [31:0] A1;
    wire [31:0] A2;

    assign A1 = selector[1] ? (selector[0] ? Data_0 : Data_1) : (selector[0] ? Data_2 : Data_3);
    assign A2 = selector[1] ? Data_6 : (selector[0] ? Data_4 : Data_5);
    assign Data_out = selector[2] ? A1 : A2;

    
endmodule
