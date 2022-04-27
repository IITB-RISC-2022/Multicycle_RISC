#!/bin/zsh

echo "Hi"

setopt aliases

ghdl -a ALU.vhdl
ghdl -e ALU

ghdl -a Decoder.vhdl
ghdl -e MemoryDecoder
ghdl -e RFDecoder
ghdl -e AluyDecoder 
ghdl -e AluxDecoder 
ghdl -e PCDecoder 
ghdl -e R7Decoder 
ghdl -e TADecoder 
ghdl -e TBDecoder  
ghdl -e TCDecoder  
ghdl -e TDDecoder  
ghdl -e IRDecoder    
ghdl -e Decoder    

ghdl -a FFs.vhdl
ghdl -e FF16
ghdl -e FF3
ghdl -e FF1

ghdl -a Lshifters.vhdl
ghdl -e Lshifter7
ghdl -e Lshifter1

ghdl -a Memory.vhdl
ghdl -e MEMORY 

ghdl -a next_state.vhdl
ghdl -e next_state

ghdl -a priority_enc.vhdl
ghdl -e PRIORITY_ENC

ghdl -a register_file.vhdl
ghdl -e REG_FILE

ghdl -a SignExtenders.vhdl
ghdl -e SignExt9
ghdl -e SignExt6

ghdl -a control_word.vhdl
ghdl -e control_word

ghdl -a FSM.vhdl
ghdl -e FSM

ghdl -a Datapath.vhdl
ghdl -e DATAPATH

ghdl -a IITB_RISC.vhdl
ghdl -e IITB_RISC

ghdl -a DUT.vhdl
ghdl -e DUT

ghdl -a Testbench.vhdl
ghdl -e Testbench

echo "End"