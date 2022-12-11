-- IITB-RISC-2022
-- A DUT entity is used to wrap your design.
--  This example shows how you can do this for the
--  Full-adder.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb IS
END ENTITY;

ARCHITECTURE DutWrap OF tb IS

	COMPONENT IITB_RISC IS
		PORT (
			CLK, RST : IN STD_LOGIC;
			R0, R1, R2, R3, R4, R5, R6, R7 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT IITB_RISC;

	SIGNAL CLK : STD_LOGIC;
	SIGNAL RST : STD_LOGIC;
	SIGNAL R0, R1, R2, R3, R4, R5, R6, R7_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
	simulate : PROCESS
	BEGIN
		CLK <= '0';
		RST <= '1';
		WAIT FOR 10 ns;

		CLK <= '1';
		RST <= '1';
		WAIT FOR 10 ns;

		CLK <= '0';
		RST <= '0';
		WAIT FOR 10 ns;

		FOR i IN 0 TO 195 LOOP
			CLK <= NOT CLK;
			WAIT FOR 10 ns;
		END LOOP;
		WAIT;
	END PROCESS;

	proc : IITB_RISC
	PORT MAP(
		CLK => CLK,
		RST => RST,
		R0 => R0,
		R1 => R1,
		R2 => R2,
		R3 => R3,
		R4 => R4,
		R5 => R5,
		R6 => R6,
		R7 => R7_PC
	);
END DutWrap;