`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pulkit Raj
// Author2: Madhuvanth G.K
// Create Date: 25.01.2026 23:24:43
// Design Name: Processor fetch
// Module Name: fetch_unit
// Project Name: SimpleRisc Architecture
// Target Devices: Arty Z7, Arria, Basys 3
// Tool Versions: 
// Description: 
// 
// Dependencies: fetch_unit, operand_fetch, branch_unit, alu, memory unit, writeback, control unit
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Modules instantiated
// Additional Comments:Fetch unit designed using top down approach
// 
//////////////////////////////////////////////////////////////////////////////////
module processor_top(
    input signals_in,
    output result_out
);
fetch_unit u1(                         //Instruction memory is read, PC increments by 4 bytes, and a mux for branch signals
    .isbranchTaken_in(isbranchTaken),      //Enable signal for branch
    .branchPC_in(branchPC),      //Here we don't go in normal order, we follow jumps for constructs like if,for
    .inst_out(instruction)          //Instruction is read from memory and given to instruction buffer register
);

operand_fetch u2(
    .instr_in(instruction),        //Instruction is input, get ra(15),rs1, rd(store the value), rs2 registers through mux in unit
    .isSt_in(isSt),       //Activates rd
    .isret_in(isret),     //control activates return address register's value
    .opcode_out(opcode),        //Send opcode 5 bits to control register and immediate bit which will be used as a sign bit or enable
    .op1_out(op1),             //First operand 
    .op2_out(op2),            //Second operand
    .branchTarget_out(branchTarget),//Signals that goes in branch unit as an input
    .immx_out(immx)            //Takes 16 bit registers, like mov r1,15 here 15 is the immediate value
);

branch_unit u3(
    .branchTarget_in(branch_target), //its taken instead op1 so its assumed that its the branch address that's given to pc, if no return
    .op1_in(op1),                    //its given to the mux, when there is return instruction
    .isret_in(isret),                //Enables return or just a branch address
    .isbeq_in(isbeq),               //If two numbers are equal we take a branch
    .isbgt_in(isbgt),               //If one number is greater than the other number branch is taken
    .flag_E_in(flag_E),              //cmp two numbers are equal sets E flag to 1
    .flag_GT_in(flag_GT),            //if first operand is greater than second than Gt, then its set to 1
    .isUBranch_in(isUBranch),          //Unconditional branch is taken
    .isbranchTaken_out(isbranchTaken),//Outputs if branch is required or not
    .branchPC_out(branchPC)             //This is the branch address
);

alu u4(
    .op1_in(op1),                   //Operand 1 is taken for execution
    .op2_in(op2),                   //Operand 2 is taken in for execution
    .immx_in(immx),                 //Operand 2 can also be an immediate value or integer(normally specified in little endian format in storage)
    .isImmediate_in(isImmediate),   //Immediate_in enables the immx output
    .aluSignals_in(aluSignals),     //This signal states the function and operations send by control signals
    .aluResult_out(aluResult),      //The result of calculation is sent as a signal
    .flag_out(flag_values)          //ALU sends the values like zero, overflow, carry and all, need to confirm on unit of flag
);

memory_unit u5(
    .op2_in(op2),                   //To store OP2 in MDR for temporary until memory operation is complete
    .aluResult_in(aluResult),       //alu result is given to MAR if we want to store any value
    .isLd_in(isLd),                 //To load the instruction from memory we give this control input
    .isSt_in(isSt),                 //To store the instruction, we give this input
    .IdResult_out(IdResult)         //Output result of the memory unit
);

writeback u6(
    .aluResult_in(aluResult),
    .ldResult_in(ldresult),
    .pc_in(pc),
    .isLd_in(isLd),
    .isCall_in(isCall),             //Useful for making a function call
    .rd_in(rd),                     //Store register value, we have to declare this assignments again in this file
    .ra_in(ra),                     //Address register
    .isWb_in(isWb),                 //Enable for write back to register
    .E_out(E_regfile),              //Values E, A, D that has to be written to register file
    .A_out(A_regfile),
    .D_out(D_regfile)
);

control_unit u7(
    .inst_in(instruction),
    .isRet_out(isRet),
    .isSt_out(isSt),
    .isWb_out(isWb),
    .isImmediate_out(isImmediate),
    .aluSignals_out(aluSignals),
    .isbeq_out(isbeq),
    .isbgt_out(isbgt),
    .isUBranch_out(isUBranch),
    .isLd_out(isLd),
    .isCall_out(isCall)
);
endmodule