module REG2(
    input enable,clk,
    input[31:0] in,
    output reg[31:0] out
);
    initial begin
      out = 32'dz;
    end
    always@(clk)begin
      if(enable==1)
        out = in;
    end

endmodule