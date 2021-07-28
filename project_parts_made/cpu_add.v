module cpu_add (
  input wire clk,
  input wire reset
);
//Fios de Controle:
  //Flags
    wire OVERFLOW;
    wire NEGATIVO;
    wire ZERO;
    wire EQUAL;
    wire GT;
    wire LT;
  //Controladores 1bit
    wire PC_Write;
    wire PCWrite_Cond;
    wire MEM_Write;
    wire MEM_Read;
    wire MemToReg;
    wire RegDst;
    wire Reg_Write;
    wire IR_Write;
    wire RB_Write;
    wire AB_Write;
    wire ALUsrc_A;  
  //Controladores +1bit
    wire [2:0] ULA_Control; 
    wire [3:0] ALUsrc_B;
    wire [2:0] ALUOp;
    wire [2:0] PCSource
    wire [2:0] IorD
  //Controladores de Muxes:
    wire M_WRITE_REG;
  
//Partes da instrução
  wire [5:0]OPCODE;
  wire [5:0] FUNCT;
  wire [4:0] RS;
  wire [4:0] RT;
  wire [15:0] IMEDIATE;

//Fios de Dados
  //Fios de dados com 32bits
    wire[31:0] ULA_out;
    wire [31:0]PC_out;
    wire [31:0]MEM_to_IR;
    wire [31:0] RB_to_A;
    wire [31:0] RB_to_B;
    wire [31:0] A_out;
    wire [31:0] B_out;
  //Fio de dados menor de 32bits
    wire [4:0] WRITEREG_in;

//INSTÂNCIA DOS COMPONENTES:
  Registrador PC_( //Instância do Registrador
    clk, //clock
    reset, //reset
    PC_Write, //escrita
    ULA_out,
    PC_out
  );

  Memoria MEM_( //Instância da memória
    PC_out,
    clk,
    MEM_Write,
    ULA_out,
    MEM_to_IR
  );

  Instr_Reg IR_( //Registrador de instruções
    clk,
    reset,
    IR_Write,
    MEM_to_IR,
    OPCODE,
    RS,
    RT,
    IMEDIATE
  );

  Mux_wr M_WRITE_REG_( //MUX do Banco de Registradores
    Mux_wr,
    RT,
    IMEDIATE,
    WRITEREG_in
  );
  
  Banco_reg REG_BASE_(
    clk,
    reset,
    RB_Write,
    RS,
    RT,
    WRITEREG_in,
    ULA_out,
    RB_to_A,
    RB_to_B
  );

  Registrador A_( //Instância do Registrador
    clk, //clock
    reset, //reset
    AB_Write, //escrita
    RB_to_A,
    A_out
  );
  Registrador B_( //Instância do Registrador
    clk, //clock
    reset, //reset
    AB_Write, //escrita
    RB_to_B,
    B_out
  );
  //FALTA INSTANCIA DOS SEGUINTES COMPONENTES: 
  //MUX_ulaA
  //MUX_ulaB
  ula32 ULA_(
    ULA_A_in,
    ULA_B_in,
    ULA_Control,
    ULA_OUT,
    OVERFLOW,
    NEGATIVO,
    ZERO,
    EQUAL,
    GT,
    LT,
  );

  ctrl_unit CTRL_(
    clk,
    reset,
    OVERFLOW,
    NEGATIVO,
    ZERO,
    EQUAL,
    GT,
    LT,
    OPCODE,
    PC_Write,
    MEM_Write,
    IR_Write,
    RB_Write,
    AB_Write,
    ULA_Control,
    M_WREG,//sujeito à alteração
    M_ULA_A;//sujeito à alteração
    M_ULA_B,//sujeito à alteração
    reset
  );

endmodule