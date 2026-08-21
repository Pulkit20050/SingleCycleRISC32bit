# RISC Processor Development Notes

## Architecture

- In this we will test the outputs on FPGA by prespecifying the 4bit sequence to address our fixed 32 bit instructions.
- Instructions that are decoded depends upon whether its 1-address instruction, two address or 3 address instruction. // Now that dependency is removed
- We have group of instructions executed depending on the switch we put. As 4 bit input to processor.
- Fetch unit has program counter and instruction memory.
- Operand fetch has the instruction decoder.
- Instruction decoder chooses the instruction type then decodes it accordingly giving important data to operand fetch.
- **Problem:** Instruction decoder needs to be part of fetch unit in efficient manner for pipelining, to maintain consistency in execution.
- In this decoder, we take the MSB of the opcode, which is one for all the 1-address instruction and for zero address instruction we can make exception inside 1-address instruction.
- m1, m2 we get during immediate value is implemented in instruction decoder. If we put the immediate value in lower byte, we extend the sign bit, so immediate value can be meant for signed operation.
- If immediate bit is 0, rs2 address is taken and immx if immediate bit is 1.
- Processor has a clock input known as master clock, and it also has reset, reset basically clears all the registers, and program counter.
- For return address, we don't have it directly in instruction, we just assign the operand address, if we call the branch, before proceeding with branch instruction.

## Module Organization

- Idea to reduce the ports between boxes, cap the outputs in concatenated packets. Mostly common outputs.
- For load and store instruction we had, two controls that are the main bits, so isLd is mostly given in writeback unit, and isSt is given in operand fetch, with is ret.
- We want separate decoder, and we will store the data in different packets of data.
- Here we are shifting control unit and instruction decoder to fetch , so we can get the work done with internal instruction easily.
- I just realized in instruction decoder, I don't have to mention the if else constructs for 1-address, 2-address and 3-address instructions I can simply assign and use control signals to choose relevant signals. Power usage is high but area decreases, and potentially power too will decrease to some extent.
- For control input we supply direct instruction, and get opcode and Imbit from it.
- Imbit is removed as in I wouldn't prefer giving it as an output. From branch_unit, I will directly read it in my control unit.

## Control Word

- For ALU control signals I have to combine it with carry select, as uninitialized carry can cause problem, I could directly give it zero in concatenation operator.
- Our control word=

```text
control_word={is Imm, isUBranch, isbgt_out, isbeq_out, isCall_out, isRet_out,isLd,isSt, alusignals, Wb};
```

- Since in ALU we used MUX, we are in any case going to compute results as we don't want x. So we assign default that's 0 for add;
- To reduce circuitry we observe that alusignals when shifted by 1 place to left, we get unique opcode and hence we can assign the opcode itself as alu signals. This alu signals are combined with carry select bit.
- There is one more idea if we use flag register from register file, we could just call specific write option and just write the value to the register file, instead of some random register on verilog. Basically structural call to regfile.

## Branch Unit & Operand Fetch

- Combining the branch unit and operand fetch is very useful, as we import one control word at a time, its sufficient for both of the units to complete the task.
- Branch target is calculated in operand fetch, so it makes more sense to combine. As we remove output port and input port at the same time for branch target.
- In testbench we have to show the memory location and register. Or atleast figure out what we can do in that.

## Load, Store & Move

- Here in our processor, primarily the address location is given to rs1, and not rs2. And then rs1 is added with 0 in alu, or imm value, depending on the offset, and then load and store takes place.
- Move instruction we don't active load or store value instead we just write the same value added with 0 in rd.

## Stack & Register File

- We are trying to implement stack level memory in the processor, so when stack pointer shifts, up it stores continuous, and when its - it just gets the place cleared.
- Register file, Contain 6 general purpose register, and then 1 return address reg, then 1 stack pointer.

## Branching & Function Calls

- Point of innovation in processor: Branching with call. Basically call, offset is total instruction.
- After that target when calculated actually gives the detail on rs2, rs1, so we essentially map them to another set of register, so register address has to be different, but how does it know what is stored in that instruction, and what if we need some data? Main highlight we can animate it, madhuvanth will do the animation.
- So first we do some set of operations, now when we call, we need to pass some arguments, but also we can access it directly why would we even need the call function? Like I could just do it with normal repeated addressing. What if we store the footprints of the destination register output in stack. So we will have it like the outputs I assigned in function 1, can be used by function 2 in stack parts, and when we are done with function 2, the footprints gets cleared up. And in function 2, for call function when I get the address it can be prewritten as a stack address. only we mention which part of stack we plan on using first.
- So what's the specific use of it? Footprints how can they help, I could rewrite the same destination register again and again. And get the results from the stack, that is later cleared.
- What are the other benefits of footprints?
- In recursion, if want to run a program like for loop a certain number of times, i will just mention call n, means call this n times, and hence it repeats and just the final value of stack is taken out as output.
- When we call function, we basically make use of same destination register, and we can call multiple functions any number of times. And all intermediate values are cleared automatically after operation is done, so return now also returns the outputs along with going to previous location.
- main function, program counter will be be going till some value for main function, and then last few are meant for function calls.
- We are no more working on stack for now, ra_in return address is stored in 1111 location of register.

## Problems

If its a store instruction, rd is given to the register, its values are read, but then its just that I have to just pass it through alu and just store it in rd, or if its a memory unit.

So when its store instruction, we just read the contents of rd, to store previous results, and rs1 is the address part. So basically operand 2 is the data, and operand 1 is used for computing address, if we want to shift it by a immediate value, we can just give immediate value, and is immediate bit selects immediate value for ALU to get the address computed.

## Alu

- Its a 32 bit alu, which can perform operation like buffer, invert, bitwise, add, sub, 1bit left shift or right shift.
- Each stage it has 2 Mux and a full adder block.
- For future work, we want ALU to handle some explicit calculations like address, or multiplication operator. And potentially use it for matrix multiplication.

## Mysterious errors

In my control unit, its coming as 1005 which is correct,

but in processor_top its different its 100X, maybe timing issue.

One reason, control is given to too many blocks.

Its known as delta propagation delay., delta propagation delay why it happens and what it is.

Reason:

We can't have level edge triggered and single edge triggered in same place, its not synthesizable, this is my notes
