module CDEST(input [31:0]ir,output reg[4:0]ws,output reg we);

    always@ * begin
      case (ir[31:26])      // rtype    
                            6'b000000:
                                 begin
                                  case(ir[5:0])
                                 //  jal        jalr
                                  6'b000011,6'b001001:begin
                                       ws = 5'd31;
                                  end
                                  default:
                                      ws = ir[15:11];
                                  endcase
                                 end

                            // lw         addi      andi      ori       slti             
                            6'b100011,6'b001000,6'b001100,6'b001101,6'b001010:
                                ws = ir[20:16];
                                 
        
      endcase
    end


    always@(ir)begin
      case (ir[31:26])      // rtype      lw        addi       andi    ori        slti      jal   
                            6'b000000,6'b100011,6'b001000,6'b001100,6'b001101,6'b001010,6'b000011:
                                 begin          //jr
                                    if(ir[5:0]==6'b001001)
                                      we = 0;
                                    else
                                      we = 1;
                                 end

                                 
                            //  jump      beq         bnq     cdest
                             6'b000010,6'b000100,6'b000101,6'b101011:begin
                                    we =0;
                                end
        
      endcase
    end


endmodule