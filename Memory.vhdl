-- IITB-RISC-2022
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
	SIGNAL RAM : vec_array := (
	0 => "0111001000111101",
	1 => "0111010000111110",
	2 => "0000000110000001",
	3 => "0010001001101000",
	4 => "0001101110101000",
	5 => "0000000011000000",
	6 => "0001010011011000",
	7 => "0001110101101000",
	8 => "1000101000000010",
	9 => "1011000000000110",
	10 => "0101011000111111",
	11 => "1011000000001011",
	61 => x"0004",
	62 => x"00F8",
	OTHERS => (OTHERS => '1'));
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
END ARCHITECTURE;