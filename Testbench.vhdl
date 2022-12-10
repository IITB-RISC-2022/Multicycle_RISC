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
		PORT (CLK, RST : IN STD_LOGIC);
	END COMPONENT IITB_RISC;

	SIGNAL CLK : STD_LOGIC;
	SIGNAL RST : STD_LOGIC;

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

		FOR i IN 0 TO 50 LOOP
			CLK <= NOT CLK;
			WAIT FOR 10 ns;
		END LOOP;
		WAIT;
	END PROCESS;

	proc : IITB_RISC
	PORT MAP(
		CLK => CLK,
		RST => RST
	);

END DutWrap;