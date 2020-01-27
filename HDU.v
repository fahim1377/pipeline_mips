  module HDU(
      input [31:0]F2Dir,
      D2EXir,
      input [4:0]wsex,wsmem,rs,rt,
      input weex,wemem,re1,re2,bcond,
      output reg pcEn,F2DirEn,mux2sel,mux1sel,
      output reg [1:0]mux0sel
      
  );

   initial begin
        mux1sel = 0;
        mux2sel  = 0;
        mux0sel = 2'd0;
   end
  
  always@ * begin                                                            //  lw
    if(    (  ((rs==wsex) && re1 && weex )   ||   ((rt==wsex) && re2 && weex ) )  &&  D2EXir[31:26] == 6'b100011     &&  rt!=6'd0  )begin
        pcEn = 1'b0;
        F2DirEn = 1'b0;
        mux2sel = 1'b1;
    end
    else begin
        pcEn = 1'b1;
        F2DirEn = 1'b1;
        mux2sel = 1'b0;
    end
    
//                          beq                             bnq           kil
    if(   (D2EXir[31:26]==6'b000100  ||  D2EXir[31:26]==6'b000101)  && bcond == 1  )begin
        mux1sel = 1;
        mux2sel = 1;
        mux0sel = 2'd3;
    end
          ///                     jump                       jal                          jalr                    jr        kill
    else if(   F2Dir[31:26]== 6'b000010 ||  F2Dir[31:26]==6'b000011  || 
                (  (F2Dir[5:0]==6'b001001  ||  F2Dir[5:0]==6'b001000)  &&  F2Dir[31:26]==6'd0  ) )begin
        mux1sel = 1;
        mux2sel  = 0;        //  jump                       jal
        if(   F2Dir[31:26]== 6'b000010 ||  F2Dir[5:0]==6'b000011  )
            mux0sel = 2'd2;
        else // jalr     jr
            mux0sel = 2'd1;    
    end
    else begin
        mux1sel = 0;
        mux2sel  = 0;
        mux0sel = 2'd0;
    end


  end



  endmodule