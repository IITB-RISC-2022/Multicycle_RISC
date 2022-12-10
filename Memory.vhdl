-- IITB-RISC-2022
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MEMORY IS
	PORT (
		CLK, WR_Enable, RW_Enable : IN STD_LOGIC;
		ADDR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END MEMORY;

ARCHITECTURE behav OF MEMORY IS
	TYPE vec_array IS ARRAY(0 TO 256) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL RAM : vec_array := (-- in ra rb rc	
	0 => "0111000000001010", -- lw r0, r0, 10
	1 => "0111001001001011", -- lw r1, r1, 11
	2 => "0111010010001100", -- lw r2, r2, 12
	3 => "0111100100000000", -- lw r4, r4, 00
	4 => "1011000000000010",
	5 => "0001000001000000",
	7 => "0001000000001000",
	10 => "0000000000000101",
	11 => "0000000000000111",
	12 => "0000000000000010",
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
			IF to_integer(unsigned(ADDR)) < 15 THEN
				out_t := RAM(to_integer(unsigned(ADDR)));
			ELSE
				out_t := (OTHERS => '0');
			END IF;
		END IF;
		outp <= out_t;
	END PROCESS;
END ARCHITECTURE;