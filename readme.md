# Mips FPGA Processor
## Created by Ryan Leonard, Rui Tu, and Frank Arana

We have flushed out the datapath for a MIPS FPGA processor. We have done so in designing a unicycle MIPS processor following principles and implementation details suggested in ``Computer Organization and Design.''

### IP Components

The IP we created as building blocks include:

|IP Name        | Described |
|---------------|-----------|
|alu_32         | 32 bit ALU implementation supporting sufficient operations to perform Fibbonacci calculations |
|alu_control_32 | ALU control unit that takes a signal from a main control unit then sends control signals to the ALU |
|control_32     | Control unit that takes a portion of each instruction and uses it to determine control signals for the entire cpu |
|decoder_32     | A simple wire splitting module that given any R, I, or J type instruction will parse the resultant fields |
|jump_addr      | Calculates jump address given jump target and program counter |
|memory	        | GENERAL PURPOSE: memory strcture allowing one combinational read and one sequential write per clock cycle | 
|rf_32	        | 32 bit Register file allowing two combinational reads and one sequential write per clock cycle | 
|adder          | GENERAL PURPOSE: simple module that adds two values of a fixed width together without regard for overflow |
|branch_control | takes signals from CPU and control to determine whether a branch was taken or not taken |
|mux2           | GENERAL PURPOSE: choose between two values of fixed width given a one-bit `choose' signal |
|mux3	          | GENERAL PURPOSE: choose between three values of fixed width given a two-bit `choose' signal |
|pc	            | Maintains PC register throughout cycles |
|sign_extend_32	| Extends a 16-bit value to a 32-bit value in 2s compliment |

Each IP was tested individually by a testbench, e.g. tb/alu_tb.v exist for the sole purpose of testing alu.v.

TBD: Discussion about each testbench?

### IP Composition

When it came time to bring the full datapath into a single module, we discovered...

