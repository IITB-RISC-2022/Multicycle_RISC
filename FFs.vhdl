-- IITB-RISC-2022
-----------------------------------------Flip Flops--------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------3 BIT FF ---------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FF3 IS
	PORT (
		D : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		EN : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		CLK : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END ENTITY FF3;

ARCHITECTURE Behav OF FF3 IS

BEGIN
	PROCESS (D, En, CLK)
	BEGIN
		IF rst = '1' THEN
			Q <= (OTHERS => '0');
		ELSIF CLK'event AND (CLK = '0') THEN
			IF EN = '1' THEN
				Q <= D;
			END IF;
		END IF;
	END PROCESS;

END ARCHITECTURE;

-----------------------------------------------------------------------------------------
-----------------------------------------1 BIT FF ---------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FF1 IS
	PORT (
		D : IN STD_LOGIC;
		EN : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		CLK : IN STD_LOGIC;
		Q : OUT STD_LOGIC);
END ENTITY FF1;

ARCHITECTURE Behav OF FF1 IS

BEGIN
	PROCESS (D, En, CLK)
	BEGIN
		IF rst = '1' THEN
			Q <= '0';
		ELSIF CLK'event AND (CLK = '0') THEN
			IF EN = '1' THEN
				Q <= D;
			END IF;
		END IF;
	END PROCESS;

END ARCHITECTURE;

-----------------------------------------------------------------------------------------
-----------------------------------------16 BIT FF --------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FF16 IS
	PORT (
		D : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		EN : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		CLK : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY FF16;

ARCHITECTURE Behav OF FF16 IS

BEGIN
	PROCESS (D, En, CLK)
	BEGIN
		IF rst = '1' THEN
			Q <= (OTHERS => '0');
		ELSIF CLK'event AND (CLK = '0') THEN
			IF EN = '1' THEN
				Q <= D;
			END IF;
		END IF;
	END PROCESS;

END ARCHITECTURE;