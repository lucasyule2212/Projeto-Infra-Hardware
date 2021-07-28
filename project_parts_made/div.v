// O Algoritmo usado é divisão de inteiros sem sinal, mas na especificação pede com sinal!!!
// Dúvida sobre a condição de parada.
module div (
    input wire            clk,
    input wire            reset,
    input wire   [31:0]   Dividendo,  // Dado que vem de A
    input wire   [31:0]   Divisor, //  Dado que vem de B   
    output wire  [31:0]   hi,
    output wire  [31:0]   lo,
    output wire  [7:0]    erro  //Houve divisão por zero = 255 = 8'b11111111 em bin
);


reg [31:0] N;      //Numerador
reg [5:0]  i;     //Contador
reg [31:0] D;    //Divisor
reg [31:0] R;   //Resto
reg [31:0] Q;  //Quociente
reg [31:0] auxhi;
reg [31:0] auxlo;
reg AnaliseErro;
reg break;

initial begin //As variáveis iniciam com esses valores:

    i = 6'b011111;  //i = 31 (QtDeBitsDeN - 1)
    N = Dividendo;
    D = Divisor;  
    R = 32'b00000000000000000000000000000000;
    Q = 32'b00000000000000000000000000000000;
    auxhi = 32'b00000000000000000000000000000000;
    auxlo = 32'b00000000000000000000000000000000;
    AnaliseErro = 1'b0;
   
end


always @(posedge clk) begin

    if (reset == 1'b1) begin

        i = 6'b011111;  //i = 31 (QtDeBitsDeN - 1)
        N = Dividendo;
        D = Divisor;  
        R = 32'b00000000000000000000000000000000;
        Q = 32'b00000000000000000000000000000000;
        auxhi = 32'b00000000000000000000000000000000;
        auxlo = 32'b00000000000000000000000000000000;
        AnaliseErro = 1'b0;

    end

    else begin 

        if (D == 32'b00000000000000000000000000000000) begin
            AnaliseErro = 1'b0;
        end

        else begin
            R = R << 1;  
            R[i] = N[i];

            if (R >= D) begin
                R = R - D;
                Q[i] = 1;
            end


        end

        i = i - 1;
        if (i == 6'b000000) begin
            break = 1'b1;
            auxhi = R;
            auxlo = Q;
        end



    end

end

assign erro = (AnaliseErro) ? 8'b11111111 : 8'b00000000;
assign hi = (break) ? auxhi : 32'b00000000000000000000000000000000;
assign lo = (break) ? auxlo : 32'b00000000000000000000000000000000;

endmodule