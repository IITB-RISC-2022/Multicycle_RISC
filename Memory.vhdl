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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE STD.textio.ALL;

ENTITY MEMORY IS
	PORT (
		CLK, WR_Enable, RW_Enable : IN STD_LOGIC;
		BOOT : IN STD_LOGIC;
		ADDR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END MEMORY;

ARCHITECTURE behav OF MEMORY IS

	TYPE vec_array IS ARRAY(0 TO 63) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL RAM : vec_array;
	SIGNAL BOOTED: STD_LOGIC := '0';

	FUNCTION to_std_logic_vector(x : bit_vector) RETURN STD_LOGIC_VECTOR IS
		ALIAS lx : bit_vector(1 TO x'length) IS x;
		VARIABLE ret_val : STD_LOGIC_VECTOR(1 TO x'length);
	BEGIN
		FOR I IN 1 TO x'length LOOP
			IF (lx(I) = '1') THEN
				ret_val(I) := '1';
			ELSE
				ret_val(I) := '0';
			END IF;
		END LOOP;
		RETURN ret_val;
	END to_std_logic_vector;

BEGIN
	PROCESS (CLK, ADDR, RW_Enable, BOOT)
		FILE src : text open read_mode is "source.bin";
		VARIABLE out_t : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '1');
		VARIABLE count : INTEGER := 0;
		VARIABLE input_word : bit_vector(15 DOWNTO 0);
		VARIABLE testvector : Line;
	BEGIN

		IF rising_edge(CLK) THEN
			IF BOOT = '1' THEN
				-- boot the source bin file (bootloader functionality)
				readLine(src, testvector);
				WHILE NOT endfile(src) LOOP
					read(testvector, input_word);
					RAM(count) <= to_std_logic_vector(input_word);
					count := count + 1;
				END LOOP;
				BOOTED <= '1';
			END IF;
		END IF;

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