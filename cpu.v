module CPU(input clk);
wire [31:0] instruction;
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] aluResult;
wire [31:0] RdataDM;
wire [31:0] adder1Result;
wire [31:0] adder2Result;
wire dntCare;
wire lt,gt,bcond;
wire re1,re2,we1,we2,we3;
wire [4:0]ws1,ws2,ws3;



wire pcEn;
wire F2DirEn;
wire mux2sel;
wire mux1sel;
wire [1:0]mux3sel;
wire [1:0]mux4sel;
wire [31:0]outPC;
wire [31:0]IF2IDinstructionout;
wire [1:0]mux0sel;
wire [31:0] jumpValue;
wire [13:0] controlSignals;

REG PC(pcEn,clk,mux0sel[1]? (  mux0sel[0]?adder2Result:jumpValue  ): (  mux0sel[0]?readData1:adder1Result  ) ,outPC);

                      


REG2 IF2IDinstruction(F2DirEn,clk,mux1sel?32'd32:instruction,IF2IDinstructionout);


reg [31:0] ID2EXa;
reg [31:0] ID2EXb;
reg [31:0] EX2MEMb;                     
reg [31:0] ID2EXinstruction;
reg [31:0] EX2MEMir;
reg [31:0] MEM2WBinstruction;
reg [31:0] NpcF2D;
reg [31:0] NpcD2EX;
reg [31:0] NpcEX2M;
reg [13:0]MEM2WBcontrolSignals;
reg [13:0]ID2EXcontrolSignals;
reg [13:0]EX2MEMcontrolSignals;
reg [31:0]EX2MEMaluResult;
reg [31:0]MEM2WBoutMux;

assign jumpValue = {  NpcF2D[31:28] ,(IF2IDinstructionout[25:0]<<<2) }  ;

initial begin
  #20
    ID2EXinstruction = 32'dz;
    EX2MEMir = 32'dz;
    MEM2WBinstruction = 32'dz;
                                    
end
///////////////////////
IMemBank instrMem(1'b1,outPC,instruction);
ALU adder1(outPC,32'd4,4'b0000,adder1Result,dntCare,dntCare,dntCare,dntCare);
///////////////////////

//                        nop =31'd31
//assign                        controlSignals[0] = RegDst                  ;
//assign                        controlSignals[1] = Jump;
//assign                        controlSignals[2] = Branch;
//assign                        controlSignals[3] = MemRead;
//assign                        controlSignals[4] = MemReg[0];
//assign                        controlSignals[5] = AluSrc;
//assign                        controlSignals[6] = RegWrite;
//assign                        controlSignals[7] = MemWrite;
//assign                        controlSignals[8] = Aluop[0];
//assign                        controlSignals[9] = Aluop[1];
//assign                        controlSignals[10] = Aluop[2];
//assign                        controlSignals[11] = Aluop[3];
//assign                        controlSignals[12] = RegDst[1];
//assign                        controlSignals[13] = MemReg[1];
//                                                                         RegDst            Jump                 Branch      
control control1(IF2IDinstructionout[31:26],IF2IDinstructionout[5:0],{controlSignals[12],controlSignals[0]},controlSignals[1],controlSignals[2],
controlSignals[3],{controlSignals[13],controlSignals[4]},
controlSignals[5],controlSignals[6],controlSignals[7],{controlSignals[11],controlSignals[10],controlSignals[9],controlSignals[8]});
RegFile registerFile(clk,IF2IDinstructionout[25:21],IF2IDinstructionout[20:16], MEM2WBcontrolSignals[12]?(5'd31):(MEM2WBcontrolSignals[0]?MEM2WBinstruction[15:11]:MEM2WBinstruction[20:16]),
                    MEM2WBoutMux ,MEM2WBcontrolSignals[6],readData1,readData2);

CRE1 cre1(IF2IDinstructionout,re1);
CRE2 cre2(IF2IDinstructionout,re2);
CDEST cdest1(ID2EXinstruction,ws1,we1);
CDEST cdest2(EX2MEMir,ws2,we2);

HDU hdu(IF2IDinstructionout,ID2EXinstruction,ws1,ws2,IF2IDinstructionout[25:21],IF2IDinstructionout[20:16],we1,we2,re1,re2,bcond,pcEn,F2DirEn,mux2sel,mux1sel,mux0sel);
assign ws3 = MEM2WBcontrolSignals[12]?(5'd31):(MEM2WBcontrolSignals[0]?MEM2WBinstruction[15:11]:MEM2WBinstruction[20:16]);//ws3
assign we3 = MEM2WBcontrolSignals[6];
FU fu(IF2IDinstructionout,ID2EXinstruction,EX2MEMir,MEM2WBinstruction,ws1,ws2,ws3,IF2IDinstructionout[25:21],IF2IDinstructionout[20:16],we1,we2,we3,re1,re2,mux3sel,mux4sel);
////////////////////////////
ALU adder2(NpcD2EX,32'(signed'(ID2EXinstruction[15:0]))<<<2,4'b0000,adder2Result,dntCare,dntCare,dntCare,dntCare);
ALU alu(ID2EXa,(ID2EXcontrolSignals[5]?32'(signed'(ID2EXinstruction[15:0])):ID2EXb),ID2EXcontrolSignals[11:8],aluResult,zero,lt,gtl,bcond);
/////////////////////
DMemBank DMem(EX2MEMcontrolSignals[3],EX2MEMcontrolSignals[7],EX2MEMaluResult[7:0],EX2MEMb,RdataDM);
///////////////////////

wire [31:0] outmux5;
assign outmux5 = EX2MEMcontrolSignals[13]?( NpcEX2M ) : ( EX2MEMcontrolSignals[4]?(RdataDM) : (EX2MEMaluResult) ) ;

always@(clk)
begin

    //  Fetch
      NpcF2D <= adder1Result;
    //

    //Decode
      NpcD2EX <= NpcF2D;
      ID2EXcontrolSignals <= mux2sel?14'b00000000000000:controlSignals;
      ID2EXa <= mux3sel[1]? ( mux3sel[0]?(MEM2WBoutMux) : (outmux5) ) : ( mux3sel[0]?(aluResult) : (readData1) ) ;
      ID2EXb <= mux4sel[1]? ( mux4sel[0]?(MEM2WBoutMux) : (outmux5) ) : ( mux4sel[0]?(aluResult) : (readData2) ) ;
      ID2EXinstruction <= IF2IDinstructionout;


    //

    //Execute
      NpcEX2M <= NpcD2EX;
      EX2MEMcontrolSignals <= ID2EXcontrolSignals;
      EX2MEMaluResult <= aluResult;
      EX2MEMir <= ID2EXinstruction;
      EX2MEMb <= ID2EXb;
    //

    // MEM
      MEM2WBcontrolSignals <= EX2MEMcontrolSignals;
      MEM2WBoutMux <= outmux5;
      MEM2WBinstruction <= EX2MEMir;


    //

end


endmodule

module CpuTB();

reg clock = 1'b0;
CPU cpu(clock);

initial begin 

forever begin
#50 clock = ~clock;
end
end

endmodule