module ctrl_unit (
  input wire clk,
  input wire reset,
  //Flags
  input wire OVERFLOW,
  input wire NEGATIVO,
  input wire ZERO,
  input wire EQUAL,
  input wire GT,
  input wire LT,
  //OPCODE 
  input wire OPCODE,
  //FUNCT
  input wire FUNCT,
  //Controladores 1bit
    output reg PC_Write,
    output reg PCWrite_Cond,
    output reg MEM_Write,
    output reg MEM_Read,
    output reg MemToReg,
    output reg RegDst,
    output reg Reg_Write,
    output reg IR_Write,
    output reg RB_Write,
    output reg AB_Write,
    output reg ALUsrc_A, 
  //Controladores +1bit
    output reg [2:0] ULA_Control,
    output reg [3:0] ALUsrc_B,
    output reg [2:0] ALUOp,
    output reg [2:0] PCSource,
    output reg [2:0] IorD,
  //Controladores dos Muxes
  output reg M_WREG,
  output reg MUX_ULA_A,
  output reg MUX_ULA_B,
  //Controlador de Reset
  output reg rst_out,
);
//Variaveis
reg [2:0] COUNTER; //contador para checar a parte da execução
reg [27:0] STATE; //variavel que guarda a quantidade de estados (?)

//Nomes dos estados(como parametros):
  parameter ST_BUSCA = 2'b00;
  parameter ST_RESET = 2'b01;
  parameter ST_DECODE = 2'b10;

  //ex parameter ST_ADD = 2'b01;
//OPCODES como aliases: ex
  parameter OPCODE_0 = 6'b000000;
  parameter J    = 6'b000010;  
  parameter JAL  = 6'b000011;
  parameter ADDI =6'b001000 ;
  parameter ADDIU= 6'b001001;
  parameter BEQ  = 6'b000100;
  parameter BNE  = 6'b000101;
  parameter BGT  = 6'b000111;
  parameter BLE  = 6'b000110;
  parameter SLTI = 6'b001010;
  parameter BLM  = 6'b000001;
  parameter LUI  = 6'b001111;
  parameter LW   = 6'b100011;
  parameter LH   = 6'b100001;
  parameter LB   = 6'b100000;
  parameter SW   = 6'b101011;
  parameter SH   = 6'b101001;
  parameter SB   = 6'b101000;
//FUNCT como ALIASES:
  parameter ADD       = 6'b100000;
  parameter SUB       = 6'b100010; 
  parameter AND       = 6'b100100; 
  parameter MULT       = 6'b011000; 
  parameter DIV       = 6'b011010; 
  parameter MFHI      = 6'b010000; 
  parameter MFLO      = 6'b010010; 
  parameter SLL      = 6'b000000; 
  parameter SRL       = 6'b000010; 
  parameter SRA      = 6'b000011; 
  parameter SLLV      = 6'b000100; 
  parameter SRAV      = 6'b000111;
  parameter JR      = 6'b001000; 
  parameter SLT       = 6'b101010; 
  parameter BREAK       = 6'b001101; 
  parameter RTE       = 6'b010011; 
//setando o initial das variaveis
initial begin
  //O INTIAL DA RESET NA UNIDADE DE CONTROLE
  //LEMBRAR DE COLOCAR O VALOR 227 NO REG 29
  //reset inicial na máquina
  rst_out=1'b1;
end


always @(posedge clk) begin //BLOCO DA MÁQUINA DE ESTADOS
  if (reset==1'b1) begin
    if (STATE!=ST_RESET) begin
      STATE=ST_RESET;
      //Setando todos os sinais de saída pra 0
      PC_Write=1'b0
      PCWrite_Cond=1'b0
      MEM_Write=1'b0
      MEM_Read=1'b0
      MemToReg=1'b0
      RegDst=1'b0
      Reg_Write=1'b0
      IR_Write=1'b0
      RB_Write=1'b0
      AB_Write=1'b0
      ALUsrc_A=1'b0
      ULA_Control=3'b000
      ALUsrc_B=3'b000
      ALUOp=2'b00
      PCSource=2'b00
      IorD=2'b00
      M_WREG =1'b0 
      M_ULA_A =1'b0 
      M_ULA_B =1'b0;
      rst_out = 1'b1; // reset out pra 1
      //Setando o contador para a proxima operação
      COUNTER=3'b000;
    end
    else begin
      STATE=ST_BUSCA
      //Setando todos os sinais de saída pra 0
      PC_Write=1'b0
      PCWrite_Cond=1'b0
      MEM_Write=1'b0
      MEM_Read=1'b0
      MemToReg=1'b0
      RegDst=1'b0
      Reg_Write=1'b0
      IR_Write=1'b0
      RB_Write=1'b0
      AB_Write=1'b0
      ALUsrc_A=1'b0
      ULA_Control=3'b000
      ALUsrc_B=3'b000
      ALUOp=2'b00
      PCSource=2'b00
      IorD=2'b00
      M_WREG =1'b0 
      M_ULA_A =1'b0 
      M_ULA_B =1'b0;
      rst_out = 1'b0; // reset out pra 0
      //Setando o contador para a proxima operação
      COUNTER=3'b000;
    end
  end
  else begin
    //bloco switch case para cada estado que não seja o estado de reset.
    case (STATE)
      ST_BUSCA: begin //ESTADO DO FETCH
        STATE=ST_RESET
        //Setando todos os sinais de saída pra 0
        PC_Write=1'b1 ///
        PCWrite_Cond=1'b0
        MEM_Write=1'b0
        MEM_Read=1'b1  ///
        MemToReg=1'b0
        RegDst=1'b0
        Reg_Write=1'b0
        IR_Write=1'b1 ///
        RB_Write=1'b0
        AB_Write=1'b0
        ALUsrc_A=1'b0
        ULA_Control=3'b001 ///
        ALUsrc_B=3'b001  ///
        ALUOp=2'b00
        PCSource=2'b00
        IorD=2'b00
        M_WREG =1'b0 
        M_ULA_A =1'b0 
        M_ULA_B =1'b0;
        rst_out = 1'b0; 
        //Setando o contador para a proxima operação
        COUNTER=3'b000;
      end
      ST_RESET:begin //ESTADO DO RESET/WAIT
        STATE=ST_DECODE
        //Setando todos os sinais de saída pra 0
        PC_Write=1'b1 ///
        PCWrite_Cond=1'b0
        MEM_Write=1'b0
        MEM_Read=1'b0  ///
        MemToReg=1'b0
        RegDst=1'b0
        Reg_Write=1'b0
        IR_Write=1'b0  ///
        RB_Write=1'b0
        AB_Write=1'b0
        ALUsrc_A=1'b0
        ULA_Control=3'b001 ///
        ALUsrc_B=3'b001  ///
        ALUOp=2'b00
        PCSource=2'b00
        IorD=2'b00
        M_WREG =1'b0 
        M_ULA_A =1'b0 
        M_ULA_B =1'b0;
        rst_out = 1'b0; 
        //Setando o contador para a proxima operação
        COUNTER=3'b000;
      end
      ST_DECODE:begin//ESTADO DO DECODE
        case (OPCODE)
        OPCODE_0  :begin
          case (FUNCT)
            ADD:begin
              STATE:STATE_ADD
            end  
            SUB:begin
              STATE:STATE_SUB
            end 
            AND:begin
              STATE:STATE_AND
            end 
            MULT:begin
              STATE:STATE_MULT
            end 
            DIV:begin
              STATE:STATE_DIV
            end 
            MFHI:begin
              STATE:STATE_MFHI
            end 
            MFLO:begin
              STATE:STATE_MFLO
            end 
            SLL:begin
              STATE:STATE_SLL
            end 
            SRL:begin
              STATE:STATE_SRL
            end 
            SRA:begin
              STATE:STATE_SRA
            end 
            SLLV:begin
              STATE:STATE_SLLV
            end 
            SRAV:begin
              STATE:STATE_SRAV
            end 
            JR :begin
              STATE:STATE_JR
            end 
            SLT:begin
              STATE:STATE_SLT
            end 
            BREAK:begin
              STATE:STATE_BREAK
            end 
            RTE:begin
              STATE:STATE_RTE
            end  
            default: 
          endcase
        end
        J:begin
          STATE=STATE_J
        end  
        JAL:begin
          STATE=STATE_JAL
        end
        ADDI:begin
         STATE=STATE_ADDI 
        end 
        ADDIU:begin
          STATE=STATE_ADDIU
        end
        BEQ :begin
         STATE=STATE_BEQ
        end 
        BNE :begin
         STATE=STATE_ BNE
        end 
        BGT :begin
         STATE=STATE_BGT 
        end 
        BLE :begin
          STATE=STATE_BLE
        end 
        SLTI:begin
         STATE=STATE_SLTI 
        end 
        BLM :begin
         STATE=STATE_BLM 
        end 
        LUI :begin
         STATE=STATE_LUI 
        end 
        LW  :begin
         STATE=STATE_LW 
        end 
        LH  :begin
         STATE=STATE_LH 
        end 
        LB  :begin
         STATE=STATE_LB 
        end 
        SW  :begin
         STATE=STATE_SW 
        end 
        SH  :begin
         STATE=STATE_SH 
        end 
        SB  :begin
         STATE=STATE_SB 
        end 

          default: 
          STATE=STATE_OPCODE_ERROR //ESTADO QUE TRATA DA EXCEÇÃO DE OPCODE INEXISTENTE
        endcase
        //Setando todos os sinais de saída pra 0
        PC_Write=1'b0 
        PCWrite_Cond=1'b0
        MEM_Write=1'b0
        MEM_Read=1'b0 
        MemToReg=1'b0
        RegDst=1'b0
        Reg_Write=1'b0
        IR_Write=1'b0 
        RB_Write=1'b0
        AB_Write=1'b0
        ALUsrc_A=1'b0
        ULA_Control=3'b000 
        ALUsrc_B=3'b000  
        ALUOp=2'b00
        PCSource=2'b00
        IorD=2'b00
        M_WREG =1'b0 
        M_ULA_A =1'b0 
        M_ULA_B =1'b0;
        rst_out = 1'b0; 
        //Setando o contador para a proxima operação
        COUNTER=3'b000;
      end
      ST_ADD:begin
                PC_Write=1'b0 
        PCWrite_Cond=1'b0
        MEM_Write=1'b0
        MEM_Read=1'b0 
        MemToReg=1'b0
        RegDst=1'b0
        Reg_Write=1'b1
        IR_Write=1'b0 
        RB_Write=1'b1
        AB_Write=1'b0
        ALUsrc_A=1'b0
        ULA_Control=3'b000 
        ALUsrc_B=3'b000  
        ALUOp=2'b00
        PCSource=2'b00
        IorD=2'b00
        M_WREG =1'b1 
        M_ULA_A =1'b0 
        M_ULA_B =1'b0;
        rst_out = 1'b0; 
        //Setando o contador para a proxima operação
        COUNTER=3'b000;
      end
      ST_RESET:begin
        if (COUNTER==3'b000) begin
          STATE=ST_RESET;
          PC_Write=1'b0
          MEM_Write=1'b0
          IR_Write=1'b0
          RB_Write=1'b0
          AB_Write=1'b0
          ULA_Contr=3'b000
          M_WREG =1'b0 //SUJEITO A ALTERAÇÃO
          M_ULA_A =1'b0 //SUJEITO A ALTERAÇÃO
          M_ULA_B =1'b0;//SUJEITO A ALTERAÇÃO
          rst_out = 1'b1; ///reset out pra 0
          //Setando o contador para a proxima operação
          COUNTER=3'b000;
        end
      end
      default: 
    endcase
  end
end

  
endmodule