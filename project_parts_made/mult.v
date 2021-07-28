module mult (
    input wire            clk,
    input wire            reset,
    input wire   [31:0]   Multiplicando,  // Dado que vem de A
    input wire   [31:0]   Multiplicador, //  Dado que vem de B   
    output wire  [31:0]   hi,
    output wire  [31:0]   lo
);

reg [31:0] A;   //Deve ter a quantidade de bits do multiplicando (A qt de bits máx do fator é 32)
reg [31:0] Q;
reg [31:0] M;
reg Q_menos_1;    //1 bit
reg [0:5] count; //deve ter no máximo 6 bits pra poder armazenar o n° 32 (qt de bits máx do fator)
reg bitMoreSign_shift;
reg bitLessSign_shift;  
reg [0:31] auxhi;
reg [0:31] auxlo;  
reg break;

initial begin //As variáveis iniciam com esses valores:
    A = 32'b00000000000000000000000000000000;
    Q = Multiplicador;
    M = Multiplicando;
    Q_menos_1 = 1'b0;
    count = 6'b100000; // Representando  a quantidade de ciclo máximo do algoritmo.
    bitMoreSign_shift = 1'b0;   //Seu valor não importa agora...
    bitLessSign_shift = 1'b0;   //Seu valor não importa agora...
    auxhi = 32'b00000000000000000000000000000000;
    auxlo = 32'b00000000000000000000000000000000;
    break = 1'b0;
end


always @(posedge clk) begin

    if (reset == 1'b1) begin   // RESETA TUDO
        A = 32'b00000000000000000000000000000000;
        Q = Multiplicador;
        M = Multiplicando;
        Q_menos_1 = 1'b0;
        count = 6'b100000; 
        bitMoreSign_shift = 1'b0; 
        bitLessSign_shift = 1'b0;   
        auxhi = 32'b00000000000000000000000000000000;
        auxlo = 32'b00000000000000000000000000000000;
        break = 1'b0;
    end

    else begin

        if (Q_menos_1 == Q[0]) begin  
            //Não faz nenhuma operação 
        end
        else if (Q_menos_1 == 1'b0 && Q[0] == 1'b1) begin
            A = A - M;        
        end
        else  //(Q_menos_1 == 1 && Q[0] == 0)
            A = A + M;
        end
    

//.............................DESLOCAMENTO de A, Q e Q_menos_1................................

/*Deslocamento de A preservando seu bit mais significativo e o menos significativo antes do shift*/
bitMoreSign_shift = A[31];
bitLessSign_shift = A[0];
A = A >> 1;
A[31] =  bitMoreSign_shift;

/*Deslocamento de Q preservando seu bit mais significativo e o menos significativo antes do shift*/
/*O bit menos significativo de A passará a ser o bit mais significativo de Q*/
bitMoreSign_shift = bitLessSign_shift;
bitLessSign_shift = Q[0];
Q = Q >> 1;
Q[31] =  bitMoreSign_shift;

/*Deslocamento de Q-1*/
/*O bit menos significativo de Q passará a ser Q-1*/
Q_menos_1 = bitLessSign_shift;


//................................DECREMENTO DO COUNT.................................
count = count - 1;
if (count == 6'b000000) begin
    break = 1'b1;
    auxhi = A;
    auxlo = Q;
end

end

assign hi = (break) ? auxhi : 32'b00000000000000000000000000000000;
assign lo = (break) ? auxlo : 32'b00000000000000000000000000000000;

endmodule 