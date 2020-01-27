module control(input[5:0] opcode,functioncode,output reg [1:0]RegDst,output reg Jump,Branch,MemRead,output reg [1:0]MemReg,output reg AluSrc,RegWrite,MemWrite,output reg[3:0] AluOp );
  always @ *begin
    case (opcode)
      6'b000000 :
      begin
      case(functioncode)
      6'b100000:
      begin
      RegDst = 2'd1; // ADD
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0000;
      AluSrc = 0;
      RegWrite =1;
      MemWrite = 0;
      end
      6'b100010 :
      begin 
      RegDst = 2'd1; // SUB
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0001;
      AluSrc = 0;
      RegWrite =1;
      MemWrite = 0;
      end
      6'b100101 :
      begin 
      RegDst = 2'd1; // OR
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0011;
      AluSrc = 0;
      RegWrite =1;
      MemWrite = 0;
      end
      6'b100100 :
      begin 
      RegDst = 2'd1; // AND
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0010;
      AluSrc = 0;
      RegWrite =1;
      MemWrite = 0;
      end  
      6'b101010 :
      begin 
      RegDst = 2'd1; // SLT
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0111;
      AluSrc = 0;
      RegWrite =1;
      MemWrite = 0;
      end
    endcase
    end
      6'b101011 :begin RegDst = 2'd1; // SW
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0000;
      AluSrc = 1;
      RegWrite =0;
      MemWrite = 1;
    end
      6'b100011 :begin RegDst = 2'd0; // LW
      Jump = 0;
      Branch = 0;
      MemWrite = 0;
      MemRead = 1;
      MemReg = 1; 
      AluOp = 4'b0000;
      AluSrc = 1;
      RegWrite = 1;     
    end
      6'b001000 :begin RegDst = 2'd0; // ADDI
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0000;
      AluSrc = 1;
      RegWrite =1;
      MemWrite = 0;
    end
      6'b001100 :begin RegDst = 2'd0; // ANDI
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0010;
      AluSrc = 1;
      RegWrite =1;
      MemWrite = 0;
    end
      6'b001101 :begin RegDst = 2'd0; // ORI
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0011;
      AluSrc = 1;
      RegWrite =1;
      MemWrite = 0;
    end
      6'b000100 :begin RegDst = 2'd1; // BEQ
      Jump = 0;
      Branch = 1;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0101;
      AluSrc = 0;
      RegWrite =0;
      MemWrite = 0;
    end
      6'b000101 :begin RegDst = 2'd1; // BNE
      Jump = 0;
      Branch = 1;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0110;
      AluSrc = 0;
      RegWrite =0;
      MemWrite = 0;
    end
      6'b001010 :begin 
      RegDst = 2'd0; // SLTI
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0111;
      AluSrc = 1;
      RegWrite =1;
      MemWrite = 0;
    end
     6'b000010:begin
      RegDst = 2'd1; // JUMP
      Jump = 1;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b0110;
      AluSrc = 1;
      RegWrite =0;
      MemWrite = 0;
    end
    6'b101000:begin
      RegDst = 2'd0; // SLL
      Jump = 0;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b1000;
      AluSrc = 1;
      RegWrite =1;
      MemWrite = 0;
    end
    6'b101000:begin
      RegDst = 2'd2; // JAL
      Jump = 1;
      Branch = 0;
      MemRead = 0;
      MemReg = 2'd2; 
      AluOp = 4'b1000;
      AluSrc = 1;
      RegWrite =1;
      MemWrite = 0;
    end
    6'b101000:begin
      RegDst = 2'd2; // jalr
      Jump = 1;
      Branch = 0;
      MemRead = 0;
      MemReg = 2'd2; 
      AluOp = 4'b1000;
      AluSrc = 1;
      RegWrite =1;
      MemWrite = 0;
    end
    6'b101000:begin
      RegDst = 2'd0; // jr
      Jump = 1;
      Branch = 0;
      MemRead = 0;
      MemReg = 0; 
      AluOp = 4'b1000;
      AluSrc = 1;
      RegWrite =0;
      MemWrite = 0;
    end
    
    endcase
    end
endmodule

module tbcontrol();
  
  wire RegDst,Jump,Branch,MemRead,MemReg,AluSrc,RegWrite,MemWrite;
  wire [3:0] Aluop;
  wire [5:0] opcode;
  control cnt(opcode,RegDst,Jump,Branch,MemRead,MemReg,AluSrc,RegWrite,MemWrite,Aluop );
  
  
endmodule










