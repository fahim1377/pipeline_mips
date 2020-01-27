module ALU(input [31:0] data1,data2,input [3:0] aluoperation,output reg [31:0] result,output reg zero,lt,gt,bcond);

  always@(aluoperation,data1,data2)
  begin
    case (aluoperation)
      4'b0000 : result = data1 + data2; // ADD
      4'b0001 : result = data1 - data2; // SUB
      4'b0010 : result = data1 & data2; // AND
      4'b0011 : result = data1 | data2; // OR
      4'b0100 : result = data1 ^ data2; // XOR
      4'b0101 : bcond = (data1==data2)?1'b1:1'b0;  //BEQ
      4'b0110 : bcond = (data1!=data2)?1'b1:1'b0;  //BNE
      4'b0111 : result = (data1<data2)?32'b1:32'b0;
      4'b1000 : result = data1 <<< data2; //SLL 
      default : result = data1 + data2; // ADD
    endcase
    
    if(data1>data2)
      begin
       gt = 1'b1;
       lt = 1'b0; 
      end else if(data1<data2)
      begin
       gt = 1'b0;
       lt = 1'b1;  
      end 
      
    if (result==32'd0) zero=1'b1;
    else zero=1'b0;
     
  end
  

endmodule

module testbench1;
  
  reg [31:0] d1,d2;  /* d1=data1, d2=data2 */
  reg [3:0] aluop;   /* aluop=aluoperation */
  
  wire [31:0] r; /* r=result */
  wire gt,lt,z; /* z=zero */
  
  ALU u0(d1, d2, aluop, r, z, lt, gt);
  
  initial begin
    
    #5
    d1=31'd1;
    d2=31'd2;
    aluop=4'b0000;
    
    #20
    aluop=4'b0011;
  end
  
  initial repeat(1000)#2 d1=d1+1;
  
endmodule;
