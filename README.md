# IITB-RISC-22 - Multicycle Reduced Instruction Set Computer

## Course Project - EE 309 - Microprocessors - Indian Institute of Technology Bombay

#### Course Instructor : Prof Virendra Singh

## Datapath

![Datapath](https://user-images.githubusercontent.com/46604893/172542384-4dd88abb-9760-4340-b88e-ed07ac8a7b4d.jpg)
*The detailed schematic can be found [here](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/Datapath.pdf)*

## Architecture

The **IITB-RISC-22** is a **16-bit** computer system which performs **17** instructions with **8** general purpose registers (R0 to R7).  The register R7 serves as the program counter as well. The architecture also has a carry flag and a zero flag, two 16 bit ALUs, one 16 bit priority encoder that gives a 16 bit output and 3bit register address. There are two Sign Extenders SE6 and SE9 for 6 and 9 bit inputs giving 16 bit outputs. There are two left bit shifters Lshifter7 and Lshifter1 which respectively shift the input by 7 and 1 bit(s) to the left appending 0s to the right giving a 16 bit output. There are four temporary registers TA, TB, TC, TD, where TA, TB and TC are 16 bit and TD is 3 bit. It has a 128 byte (64 word addresible) random access memory.

- The information regarding the **28** states of the FSM can be
  found in the file [FSM States](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/FSM%20States.pdf) and the state transition flows of the Finite
- State Machine can be found in the file [State Transition Diagram](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/State%20Transition%20Diagram.pdf).
- The control decode logic for each instruction can be found in the file [Decoding Logic](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/Decoding%20Logic.pdf).
- The control words for each of the states can be found in the file [Control Words](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/Control%20Words.pdf).

### This repository consists of all the Hardware Descriptions in **VHDL** required for simulating each instruction using a waveform analyzer such as GTKWave

## Instruction Set Architecture

The **IITB-RISC-22** has a **Turing Complete ISA** and the **17** instructions supported by the **IITB-RISC-22**, their assembly notation and encoding can be found in the [Problem Statement](https://github.com/IITB-RISC-2022/Multicycle_RISC/blob/master/Documentation/Multicycle%20Problem%20Statement.pdf).

We noticed that `LHI` has the same encoding as `ADI` hence we decided to assign `LHI` an opcode of 0011

## Software Requirements

- [GHDL](https://github.com/ghdl/ghdl)
- [GTKWave](http://gtkwave.sourceforge.net/)
- Python 3.x

## Assembler

An assembler for the **IITB-RISC-22** was designed in Python to convert any input program stored as  `.asm` into a sequence of machine level 16 bit word instructions stored in   `source.bin` . The source code for it can be found in `./assembler.py.` The assembler also provides support for both **inline** and **out of** **line comments** for documentation to be present in the `.asm` file.

To assemble the code for a file called `code.asm` in the same directory as `assembler.py` can be done in the following way.

````bash
python assembler.py code
````

## Bootloader

An software emulated bootloader for the **IITB-RISC-22** was designed in Python to dump the binary file into the memory of the **IITB-RISC-22**. The source code for it can be found in `./bootloader.py` . It takes as input the binary file `source.bin` and loads the instructions into the file `./Memory.vhdl`.

*It also has an additional feature to initialize values into the memory locations 61 and 62 of the memory before the start of processor execution. This functionality was introduced to allow initializing the two numbers to be multiplied in the benchmark code, which can be found later below.*

To load the binary file `source.bin` into memory without initializing the values of memory location 61 and 62 do the following

```bash
python bootloader.py code
```

To load the binary file `source.bin` into memory, initializing the values of memory location 61 and 62 to $m_1$ and $m_2$, where $m_1$, $m_2 \in [0, 65535]$ are decimal numbers do the following

```bash
python bootloader.py m1 m2
```

## Preliminary Testing of Instructions

- The instructions listed in `tested.txt` were run by placing them in memory and the results seen were as expected by the ISA and design specifications.

## Benchmark Code Tested on the Processor

An assembly `benchmark.asm` code to load two numbers from memory and multiply them using repeated addition and store the result in memory was used to test the processor as well as get an idea about its performance.

```assembly
; benchmark code to multiply two numbers stored in mem addresses 61, 62 and store result in 63
; we use r0 to store 0
lw r1,r0,61                 ; load in r1
lw r2,r0,62                 ; load in r2   
adi r6,r0,1                 ; load 1 in r6
ndu r5,r1,r1                ; store 1s complement of r1 in r5
add r5,r5,r6                ; store 2s complement of r1 in r5
adi r3,r0,0                 ; use r3 to store result
; start iterating from here
add r3,r2,r3                ; add the second number
add r5,r6,r5                ; increment loop variable r5
beq r5,r0,2                 ; terminate loop if r5 becomes 0
jri r0,6
sw r3,r0,63
; program completed so maintain the state
jri r0,11
```

This was tested using a testbench clock frequency of 1 GHz. The testing was done in the following way. For M[61] = 0x04 and M[62] = 0xF8

```bash
python assembler.py benchmark
python bootloader.py 4 248
./compile.sh
```

Here is the waveform obtained after simulation of the processor, we see that after 1760 ns the correct result of 0x04 * 0xF8 is stored in the memory location 63, which is 0x3E0. The processor works as intended by the program. The processor performs 23 instructions (after taking into account the iterations) for repetitive additions in 1760 ns (176 cycles). The performance in **CPI** **(Cycles Per Instruction)** is given by **7.652**. The performance of the processor in **MIPS (Million Instructions Per Second)** for this benchmark code is 23/1.760 = **13.06 MIPS.**

![waveform.jpg](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/Lenovo/OneDrive/Desktop/waveform.jpg?nonce%3D1670786213078)

## A guide on how to program the IITB-RISC-22

- Follow the ISA to program the processor in assembly, in a similar manner as programming the 8051 or 8085 making use of the 17 instructions. Make sure to not keep gaps between operands seperated by the ',' character for example `add r1,r0,r2` adds the contents of `r0` and `r2` and stores it into `r1`.
- Write your code for the application and store it in a file with a `.asm` extension (for example say `program.asm`).
- Run the assembler and the bootloader to get the binary file and also to load the binary file into memory.vhdl, now all that's left is the simulation.

## Guidelines on simulation of programs transferred into the IITB-RISC-22 for execution

- First Install **GHDL**
- Now after installation test: `ghdl --version`
- Once **GHDL** installed the project directory can be opened and the following code should be run: `sh ./compile.sh`

> `compile.sh` is a script provided in the project directory to compile all of the VHDL files and produce waveforms for the processor, corresponding to the instructions stored in `Memory.vhdl`

- Open `./result.ghw` with GTKWave

> Waveform files contain the data/signal plot of all the internal signals and ports for each entity instance as a function of time

*Note: You may have to increase the number of iterations of the for loop in `testbench.vhdl` incase your code takes more than 196 clock cycles to execute. Change the 195 in the for loop to a larger number, say 300 for example*

### Finally, meet those who made IITB-RISC-22 possible!

- Rohan Kalbag
- Jujhaar Singh
- Asif Shaikh
- Sankalp Bhamare
