//memory unit
module DMemBank(input memread, input memwrite, input [7:0] address, input [31:0] writedata, output reg [31:0] readdata);
 
  reg [31:0] mem_array [63:0];
  integer i;
  initial 
  begin
      for (i=0; i<64; i=i+1)   
     mem_array[i]=i*10;
  end
 
  always@(memread, memwrite, address, mem_array[address], writedata)
  begin
    if(memread)begin
      readdata=mem_array[address>>>2];
    end

    else if(memwrite)
    begin
      mem_array[address>>>2]= writedata;
    end

  end

endmodule

module testbench;
  reg memread, memwrite;              /* rw=RegWrite */
  reg [7:0] adr;  /* adr=address */
  wire [31:0] rd; /* rd=readdata */
  reg [31:0] wd;
  
  memBank u0(memread, memwrite, adr, wd, rd);
  
  initial begin
    memread=1'b0;
    adr=16'd0;
    
    #5
    memread=1'b1;
    adr=16'd0;
  end
  
  initial repeat(127)#4 adr=adr+1;
  
endmodule;
