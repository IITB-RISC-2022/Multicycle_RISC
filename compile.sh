#!/bin/zsh

echo "Starting Compilation"

ghdl -a *.vhdl
ghdl -e tb
ghdl -r tb --wave=result.ghw

echo "Compiled Successfully"
