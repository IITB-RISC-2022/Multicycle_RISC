# Multicycle Reduced Instruction Set Computer

## Course Project - EE 309 - Microprocessors

> *Course Instructor - Prof. Virendra Singh*

## Datapath

![Datapath](https://user-images.githubusercontent.com/46604893/172542384-4dd88abb-9760-4340-b88e-ed07ac8a7b4d.jpg)
*The detailed schematic can be found [here](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/Datapath.pdf)*

## Architecture

The **IITB-RISC-22** is a **16-bit** computer system which performs **17** instructions with **8** general purpose registers (R0 to R7). The architecture also has a carry flag and a zero flag, two 16 bit ALUs, one 16 bit priority encoder that
gives a 16 bit output and 3bit register address. There are two Sign Extenders
SE6 and SE9 for 6 and 9 bit inputs giving 16 bit outputs. There are two left bit
shifters Lshifter7 and Lshifter1 which respectively shift the input by 7 and 1 bit
(s) to the left appending 0s to the right giving a 16 bit output. There are four
temporary registers TA, TB, TC, TD, where TA, TB and TC are 16 bit and TD
is 3 bit.
The information regarding the **27** states of the FSM can be
found in the file [FSM States](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/FSM%20States.pdf) and the state transition flows of the Finite
State Machine can be found in the file [State Transition Diagram](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/State%20Transition%20Diagram.pdf). The
control decode logic for each instruction can be found in the file [Decoding Logic](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/Decoding%20Logic.pdf).
The control words for each of the states can be found in the file [Control Words](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/Control%20Words.pdf).

### This repository consists of all the Hardware Descriptions in **VHDL** required for simulating each instruction using a waveform analyzer

## Instruction Set Architecture

Information for the **17** instructions supported by the **IITB-RISC-22**, their encoding can be found in the [Problem Statement](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/Documentation/Multicycle%20Problem%20Statement.pdf).

We noticed that `LHI` has the same encoding as `ADI` hence we decided to assign `LHI` an opcode of 0011

## Software Requirements

- [GHDL](https://github.com/ghdl/ghdl)
- [GTKWave](http://gtkwave.sourceforge.net/)

## Guidelines on Microprocessor Programming

- Open `./Memory.vhdl` file in this we have a `RAM` array at line 16, edit the 16 bit words to set instructions and then simulate to get the desired output.
- 16 bit instructions can be assigned here using the following port mapping `<index> => <16bit instruction>` .

> for example for `lw r0, r0, 1` to be the first instruction we write `0 => "0111000000000001"`

## Guidelines on Simulation

- First Install GHDL
- Now after installation test: `ghdl --version`
- Once GHDL installed the project directory can be opened and the following code should be run: `sh ./compile.sh`

> `compile.sh` is a script provided in the project directory to compile all of the VHDL entities

- After VHDL compiles with no error. Use following command to run simulation `ghdl -r testbench --wave=waveform.ghw`
- Open `./waveform.ghw` with GTKWave

> Waveform files contain the data/signal plot of all the internal signals and ports for each entity instance as a function of time

## Preliminary Testing

- The instructions listed in [waves.txt](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/blob/master/waves.txt) were run by placing them in memory and the waveforms were captured and placed in the folder [Instructions Waveforms](https://github.com/rohankalbag/Multicycle-RISC-Microprocessor/tree/master/Instruction%20Waveforms)

### Contributors

- Rohan Kalbag
- Jujhaar Singh
- Asif Shaikh
- Sankalp Bhamare
