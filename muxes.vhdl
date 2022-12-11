-- IITB-RISC-2022
------------------------------------------------------------------------------
-----------------------------------16 bit 2x1 MUX-----------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_2x1_16bit IS
	PORT (
		inp_1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		sel : IN STD_LOGIC
	);
END ENTITY mux_2x1_16bit;

ARCHITECTURE Behav OF mux_2x1_16bit IS
BEGIN
	PROCESS (inp_1, inp_2, sel)
	BEGIN
		IF sel = '0' THEN
			outp <= inp_1;
		ELSE
			outp <= inp_2;
		END IF;
	END PROCESS;
END Behav;

------------------------------------------------------------------------------
-----------------------------------3 bit 4x1 MUX------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_4x1_3bit IS
	PORT (
		inp_1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		inp_2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		inp_3 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		inp_4 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		outp : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END ENTITY mux_4x1_3bit;

ARCHITECTURE Behav OF mux_4x1_3bit IS
BEGIN
	PROCESS (inp_1, inp_2, inp_3, inp_4, sel)
	BEGIN
		IF sel = "00" THEN
			outp <= inp_1;
		ELSIF sel = "01" THEN
			outp <= inp_2;
		ELSIF sel = "10" THEN
			outp <= inp_3;
		ELSE
			outp <= inp_4;
		END IF;
	END PROCESS;
END Behav;

------------------------------------------------------------------------------
-----------------------------------16 bit 4x1 MUX-----------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_4x1_16bit IS
	PORT (
		inp_1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_3 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_4 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END ENTITY mux_4x1_16bit;

ARCHITECTURE Behav OF mux_4x1_16bit IS
BEGIN
	PROCESS (inp_1, inp_2, inp_3, inp_4, sel)
	BEGIN
		IF sel = "00" THEN
			outp <= inp_1;
		ELSIF sel = "01" THEN
			outp <= inp_2;
		ELSIF sel = "10" THEN
			outp <= inp_3;
		ELSE
			outp <= inp_4;
		END IF;
	END PROCESS;
END Behav;

------------------------------------------------------------------------------
-----------------------------------16 bit 8x1 MUX-----------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_8x1_16bit IS
	PORT (
		inp_1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_3 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_4 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_5 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_6 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_7 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		inp_8 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END ENTITY mux_8x1_16bit;

ARCHITECTURE Behav OF mux_8x1_16bit IS
BEGIN
	PROCESS (inp_1, inp_2, inp_3, inp_4, inp_5, inp_6, inp_7, inp_8, sel)
	BEGIN
		CASE(sel) IS
			WHEN "000" =>
			outp <= inp_1;
			WHEN "001" =>
			outp <= inp_2;
			WHEN "010" =>
			outp <= inp_3;
			WHEN "011" =>
			outp <= inp_4;
			WHEN "100" =>
			outp <= inp_5;
			WHEN "101" =>
			outp <= inp_6;
			WHEN "110" =>
			outp <= inp_7;
			WHEN "111" =>
			outp <= inp_8;
			WHEN OTHERS =>
			outp <= (OTHERS => '0');
		END CASE;
	END PROCESS;
END Behav;