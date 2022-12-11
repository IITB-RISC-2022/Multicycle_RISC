# IITB RISC SOFTWARE BOOTLOADER

import sys

memfile_start = '''-- IITB-RISC-2022
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MEMORY_SYNTH IS
	PORT (
		CLK, WR_Enable, RW_Enable : IN STD_LOGIC;
		ADDR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END MEMORY_SYNTH;

ARCHITECTURE behav OF MEMORY_SYNTH IS
	TYPE vec_array IS ARRAY(0 TO 63) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL RAM : vec_array := (\n'''

memfile_end = '''
BEGIN
	PROCESS (CLK, ADDR, RW_Enable)
		VARIABLE out_t : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '1');
	BEGIN
		IF falling_edge(CLK) THEN
			IF WR_Enable = '1' THEN
				RAM(to_integer(unsigned(ADDR))) <= DATA;
			END IF;
		END IF;

		IF RW_Enable = '1' THEN
			IF to_integer(unsigned(ADDR)) < 64 THEN
				out_t := RAM(to_integer(unsigned(ADDR)));
			ELSE
				out_t := (OTHERS => '0');
			END IF;
		END IF;
		outp <= out_t;
	END PROCESS;
END ARCHITECTURE;'''

if __name__ == '__main__':
	words = []
	params = sys.argv
	n1 = 4
	n2 = 248
	if(len(params) == 1):
		n1 = hex(n1)[2:].zfill(4).upper()
		n2 = hex(n2)[2:].zfill(4).upper()

	elif(len(params) <= 2):
		print("Enter two valid numbers 0 <= n <= 65535 for location 61, 62")
		exit()

	else:
		n1 = int(params[1]) 
		n2 = int(params[2])
		if(n1 > 65535 or n2 > 65535 or n1 < 0 or n2 < 0):
			print("Enter two valid numbers 0 <= n <= 65535 for location 61, 62")
			exit()
		else:
			n1 = hex(n1)[2:].zfill(4).upper()
			n2 = hex(n2)[2:].zfill(4).upper()

	with open('source.bin', 'r') as file:
		binary = file.read()
		word = ''
		inst_count = 0
		for i,j in enumerate(binary):
			if(i%16 != 0 or i == 0):
				word += j
			else:
				words.append(f'\t{inst_count} => "' + word + '",\n')
				word = binary[i]
				inst_count += 1
		words.append(f'\t{inst_count} => "' + word + '",\n')
	if(len(words) > 64):
		print("Memory insuffient to load the instructions")
		exit()

	#adding values of inp1, inp2 to mem locations 61 and 62 to test benchmark.asm
	words.append(f'\t61 => x"{n1}",\n')
	words.append(f'\t62 => x"{n2}",\n')
	if(len(words) < 64):
		words.append("\tOTHERS => (OTHERS => '1'));")
    
	words = ''.join(words)
	
	with open('memory.vhdl', 'w') as file:
		file.write(memfile_start + words + memfile_end)
		print("Booted into Memory Successfully")



