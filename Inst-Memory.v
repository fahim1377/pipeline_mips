//memory unit
module IMemBank(input memread, input [7:0] address, output reg [31:0] readdata);
 
  reg [31:0] mem_array [63:0];
  
  initial begin

      mem_array[0] = 32'b00100000000000010000000000000001;
      mem_array[1] = 32'b00100000000000100000000000000010;
      mem_array[2] = 32'b00100000000000110000000000000011;
      mem_array[3] = 32'b00100000000001000000000000000100;
      mem_array[4] = 32'b00000000010000110000100000100000;
      mem_array[5] = 32'b00000000010000110000100000100100;
      mem_array[6] = 32'b00000000010000110000100000101010;
      mem_array[7] = 32'b00110100100000110000000000000010;
      mem_array[8] = 32'b00000000001000110000100000100000;
      mem_array[9] = 32'b00000000001000110000100000100000;
      mem_array[10] = 32'b00000000001000110000100000100000;
      mem_array[11] = 32'b00000000001000110000100000100000;
      mem_array[12] = 32'b10101100100001100000000000001000;
      mem_array[13] = 32'b10001100100001100000000000000100;
      mem_array[14] = 32'b00010000001000110000000000010000;
      mem_array[15] = 32'b00010100001000110000000000000000;
      mem_array[16] = 32'b00001000000000000000000000001010;
     

  end
 
  always@(memread, address, mem_array[address])
  begin
    if(memread)begin
      readdata=mem_array[address>>>2];
    end
  end

endmodule

module testbench;
  reg memread;              /* rw=RegWrite */
  reg [7:0] adr;  /* adr=address */
  wire [31:0] rd; /* rd=readdata */
  
  memBank u0(memread, adr, rd);
  
  initial begin
    memread=1'b0;
    adr=16'd0;
    
    #5
    memread=1'b1;
    adr=16'd0;
  end
  
  initial repeat(127)#4 adr=adr+1;
  
endmodule;
