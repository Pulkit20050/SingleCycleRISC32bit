I have created this file to track my progress on a RISC 32-bit single-cycle processor. Designing a processor answered many questions and gave me a depth of understanding that will be the foundation for many upcoming hardware projects.

In this design, we have five basic stages: fetch, decode, execute, memory access, and write-back. It is a hardware implementation of the architecture that I learned in the Basic Computer Architecture book.

We focused on the main components, such as designing the ALU and the control unit using our own logic. We found that the control unit required here is just a simple decoder, and there is no need to control state transitions in a single-cycle processor.

The ALU designed here can perform addition, subtraction, shift operations, and bitwise logical operations. One stage of the ALU uses two 4:1 multiplexers and a customized adder to accomplish these operations.

During this process, we learned that memory in Verilog is different from registers. You assign it in a similar way (using reg keyword), but since memory space is larger in space, it is synthesized as actual memory. Using a similar approach, you can also design a register file.

After completing this processor, which is almost done and should produce results after debugging in a few weeks, the next goal is to understand processors more deeply.

We already have a basic idea, but what about multi-cycle processors? We know that multiplication and division operations need more time to execute because their circuits are large. Alternatively, we may need additional secondary clock to loop and perform repeated additions or subtractions in one primary clock cycle. Based on this, we can adjust the timing of the main stages.

We can also add pipelining by introducing registers, known as pipeline latches, between each stage.

There are also advanced techniques that are related to executing instructions in parallel, and having a good fetch unit. There are ways to deal with in order dependencies, and also its reputed for showing great results.
