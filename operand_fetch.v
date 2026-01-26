`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pulkit Raj 
// Author2: Madhuvanth G.K
// Create Date: 26.01.2026 09:59:26
// Design Name: 
// Module Name: operand_fetch
// Project Name: SimpleRisc Processor
// Target Devices: Arty Z7
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Modules instantiated
// Additional Comments:Opcode out also has instruction bit how to take that out, also we need to confirm about registers ra,rs1,rs2, how are they assigned from instruction
// Comment: How do we assign instruction[27:32] to the wire imm, and opcode
//////////////////////////////////////////////////////////////////////////////////


module operand_fetch(
    input instr_in,        //Instruction is input, get ra(15),rs1, rd(store the value), rs2 registers through mux in unit
    input isSt_in,       //Activates rd
    input isret_in,     //control activates return address register's value
    output opcode_out,        //Send opcode 5 bits to control register and immediate bit which will be used as a sign bit or enable
    output op1_out,             //First operand 
    output op2_out,            //Second operand
    output branchTarget_out,//Signals that goes in branch unit as an input
    output immx_out          //Takes 16 bit registers, like mov r1,15 here 15 is the immediate value
);
wire imm, inbit_shift;
imm_calc sb1(
    .imm_in(imm),
    .immx_out(immx)
    );

sign_2shift sb2(
    .in(inbit_shift),
    .out(shifted_value)
);

adder sb3(
    .A(shifted_value),
    .b(PC),
    .sum(branch_target)
);

mux sb4(
    .in1(ra),
    .in2(rs1),
    .sel(isRet),
    .out(Address1)
);

mux sb5(
    .in1(rd),
    .in2(rs2),
    .sel(isSt),
    .out(Address2)
);

regfile sb6(
    .A_in1(Address1),
    .A_in2(Address2),
    .D_out1(op1),
    .D_out2(op2)
);

endmodule