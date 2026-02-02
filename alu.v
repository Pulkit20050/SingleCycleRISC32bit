module alu(
    input [31:0]A,
    input [31:0]B,
    input [3:0]Sel,
    input sel1,
    output [31:0]res
);
wire [31:0]c;
genvar i;
generate
    for(i=1; i<31; i=i+1)begin : GEN
        arithmeticunit u(A[i], B[i],c[i-1], Sel, A[i-1], A[i+1], c[i], res[i]);
    end
endgenerate
arithmeticunit a1(A[0], B[0],sel1, Sel, 0, A[1], c[0], res[0]);
arithmeticunit a4(A[31], B[31],c[30], Sel, A[30], 0, c[31], res[31]);
endmodule
