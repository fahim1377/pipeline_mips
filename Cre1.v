module CRE1(input [31:0]ir,output reg re1);

    always@ * begin
      case (ir[31:26])      // rtype    sw         lw        addi       andi    ori         beq     bnq       slti      jalr        jr
                            6'b000000,6'b101011,6'b100011,6'b001000,6'b001100,6'b001101,6'b000100,6'b000101,6'b001010,6'b001001,6'b001000:
                                 begin
                                   if(!ir[5:0]==6'd0)
                                     re1 = 1;
                                      
                                   else
                                     re1 = 0;
                                 end

                                 
                            //  jump    jal         
                             6'b000010,6'b000011:begin
                                re1 =0;
                             end
        
      endcase
    end



endmodule