# MIPS FPGA Processor
## Created by Ryan Leonard, Rui Tu, and Frank Arana

We have flushed out the datapath for a MIPS FPGA processor. We have done so in designing a unicycle MIPS processor following principles and implementation details suggested in "Computer Organization and Design."

### IP Components

The IP we created as building blocks include:

|IP Name        | Described |
|---------------|-----------|
|alu_32         | 32 bit ALU implementation supporting sufficient operations to perform Fibonacci calculations |
|alu_control_32 | ALU control unit that takes a signal from a main control unit then sends control signals to the ALU |
|control_32     | Control unit that takes a portion of each instruction and uses it to determine control signals for the entire cpu |
|decoder_32     | A simple wire splitting module that given any R, I, or J type instruction will parse the resultant fields |
|jump_addr      | Calculates jump address given jump target and program counter |
|memory	        | GENERAL PURPOSE: memory structure allowing one combinational read and one sequential write per clock cycle | 
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

We've gone through several iterations of composition:

1. A Register File + ALU.
2. A Register File + ALU + Instruction Memory.
3. A complete MIPS processor employing all 13 IP modules, including: 18 instantiations of these modules, ~50 interconnect nets to setup the datapaths, along with a driving clock port and a reset port which resets the PC to point back to the 0th instruction.
4. A complete MIPS processor with and internal instruction memory loading module and wrapped into a FPGA driver module.

We will discuss the latter two iterations as they contained the most interesting compositional hurdles.

#### Composing CPU and Simulation Testbench

When it came time to bring the full datapath into a single module, we began by physically portraying the complex system via sheets of scratch paper and sticky notes. We found this to be an effective way of determining good names for each module instantiation as well as the names of the connections between each instantiation. Furthermore, we found this to be an effective method for visualizing our overall dataflow to discover our critical path's before each module would gain stability. These were valuable insights if we were to attempt to recompose these modules into a pipelined or asynchronous architecture.

For testing this fully composed cpu module, we have to be able to provide inputs into the Instruction memory which is traditionally a read only memory component. The two hurdles are (1) assembling instructions and (2) injecting those instructions into instruction memory. To assemble the instructions, we simply used an online assembler which was verified by Rui Tu. To bypass the hurdle of having read-only memory for the sake of simulation and testing, we simply gain access to the instruction memory using the object-oriented dot-syntax of verilog, e.g. "dut.instr_memory.data[0] = noop_instruction; dut.instr_memory.data[1] = jump_to_0th_instruction" Obviously this will not hold up when it comes to synthesis, but it makes it simple to validate our design.

Once we had the ability to push instructions into instruction memory and begin their execution, We ran several iterations of basic instruction sequences. 
First we ran several instructions for basic R-type instructions. 
As a second iteration of instruction testing, we ran R-type instructions and all of our implemented J-type instructions including J, JAL, and JR. 
Third, we performed testing of our branch instructions in conjunction with R-type instructions. 
Finally we assembled all of a Fibonacci implementation for testing and found that it achieved the correct result for several hardcoded test input values ranging from 4 to 32.

<!-- #### Adding Loader and building "FPGA Driver" Moudle -->
