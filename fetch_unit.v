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
// Dependencies: Instruction memory, Program counter, Adder, Mux
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Modules instantiated
// Additional Comments:Fetch unit designed using top down approach
// 
//////////////////////////////////////////////////////////////////////////////////

module fetch_unit(
    input isbranchTaken_in,      //Enable signal for branch
    input branchPC_in,      //Here we don't go in normal order, we follow jumps for constructs like if,for
    output inst_out        //Instruction is read from memory and given to instruction buffer register
);
program_counter sb1(
    .address_in(pc_in),
    .address_out(pc_out)
);

adder sb2(
    .A(pc_out),
    .sum(mux_in)
);

mux sb3(
    .in1(mux_in),
    .in2(branchPC),
    .sel(isbranchTaken),
    .out(pc_in)
);

instruction_memory sb4(
    .inA(pc_out),
    .data_out(instruction)
);
endmodule

