# Mips FPGA Processor
## Created by Ryan Leonard, Rui Tu, and Frank Arana

We have flushed out the datapath for a MIPS FPGA processor. We have done so in designing a unicycle MIPS processor following principles and implementation details suggested in ``Computer Organization and Design.''

### IP Components

The IP we created as building blocks include:

|IP Name        | Described |
|---------------|-----------|
|alu_32         | 32 bit ALU implementation supporting sufficient operations to perform Fibbonacci calculations |
|alu_control_32 | ALU control unit that takes a signal from a main control unit then sends control signals to the ALU |
|control_32     | Control unit that takes a portion of each instruction and uses it to determine control signals for the entire cpu.
|decoder_32     |
|jump_addr      |
|memory	        |
|rf_32	        |
|adder          |
|branch_control |
|mux2           |
|mux3	          |
|pc	            |
|sign_extend_32	|

Each IP was tested individually by a testbench, e.g. tb/alu_tb.v exist for the sole purpose of testing alu.v.

### IP Composition

When it came time to bring the full datapath into a single module, we discovered...

