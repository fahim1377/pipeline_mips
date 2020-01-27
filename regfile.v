module RegFile (clk, readreg1, readreg2, writereg, writedata, RegWrite, readdata1, readdata2);
  input [4:0] readreg1, readreg2, writereg;
  input [31:0] writedata;
  input clk, RegWrite;
  output [31:0] readdata1, readdata2;

  reg[31:0]min,max;

  reg [31:0] regfile [31:0];

  integer i;
  initial 
  begin
      for (i=0; i<32; i=i+1)   
      regfile[i]=32'd0;
  end

  always @( clk)
  begin
    regfile[0]=0;
		  	if (RegWrite) 
	 				regfile[writereg] <= writedata;
          max = regfile[2];
          min = regfile[3];
  end

  assign readdata1 = regfile[readreg1];
  assign readdata2 = regfile[readreg2];
endmodule;

module testbench;
  reg clk,rw;              /* rw=RegWrite */
  reg [4:0] rr1, rr2, wr;   /* rr1=readreg1, rr2=readreg2, wr=writereg */
  reg [31:0] wd;  /* wd=writedata */
  wire [31:0] rd1, rd2; /* rd1=readdata1, rd2=readdata2 */
  
  RegFile u0(clk, rr1, rr2, wr, wd, rw, rd1, rd2);
  
  initial begin
    clk=1'b0;
    
    #5
    wr=4'd1;
    rr1=4'd0;
    rr2=4'd0;
    wd=16'd10;
    
    #1
    rw=1'b1;
  end
  
  initial repeat(1000)#2 clk=~clk;
  initial repeat(15)#4 wr=wr+1;
  initial repeat(15)#4 wd=wd+10;
  initial repeat(100)#4 rr1=rr1+1;
  initial repeat(100)#4 rr2=rr2+1;
endmodule;
 