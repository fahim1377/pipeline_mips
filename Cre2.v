module CRE2(input [31:0]ir,output reg re2);

    always@ * begin
      case (ir[31:26])      // rtype    sw           beq     bnq
                            6'b000000,6'b101011,6'b000101,6'b001010:
                                 begin
                                     re2 = 1;
                                 end

                                 
                            //  jump    jal           lw        addi    andi        ori    jalr         jr       slti    
                             6'b000010,6'b000011,6'b100011,6'b001000,6'b001100,6'b001101,6'b000100,6'b001001,6'b001000:begin
                                re2 =0;
                             end
        
      endcase
    end




endmodule