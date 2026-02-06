I have created this file to track my progress on a **RISC 32-bit single-cycle processor** using **Verilog**.  
Designing a processor answered many questions and gave me a depth of understanding that will be the foundation for many upcoming **hardware projects**.

In this design, we have five basic stages:

- **Fetch**  
- **Decode**  
- **Execute**  
- **Memory Access**  
- **Write-back**  

It is a hardware implementation of the architecture that I learned in the **Basic Computer Architecture** book.

We focused on the main components, such as designing the **ALU** and the **control unit** using our own logic.  
We found that the control unit required here is just a **simple decoder**, and there is no need to control **state transitions** in a single-cycle processor.

The ALU designed here can perform **addition, subtraction, shift operations, and bitwise logical operations**.  
One stage of the ALU uses **two 4:1 multiplexers** and a **customized adder** to accomplish these operations.

During this process, we learned that **memory modeling in Verilog** is different from registers.  
You assign it in a similar way (using the `reg` keyword), but since memory space is larger, it is synthesized as **actual hardware memory**.  
Using a similar approach, you can also design a **register file**.

After completing this processor, which is almost done and should produce results after debugging in a few weeks, the next goal is to understand processors more deeply.

We already have a basic idea, but what about **multi-cycle processors**?  
We know that **multiplication and division units** need more time to execute because their circuits are large.  
Alternatively, we may need **additional clock cycles** to loop and perform repeated additions or subtractions in one primary clock cycle.  
Based on this, we can adjust the **timing of pipeline stages**.

We can also add **pipelining** by introducing **pipeline registers (latches)** between each stage.

There are also advanced techniques related to **instruction-level parallelism**, and having a good **instruction fetch unit**.  
there are ways to deal with **in-order dependencies** and **data hazards**, and they are reputed for showing great results.
