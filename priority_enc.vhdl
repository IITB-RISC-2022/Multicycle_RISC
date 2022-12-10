-- IITB-RISC-2022
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PRIORITY_ENC IS
	PORT (
		inp : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		outp : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		out_enc : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE Behav OF PRIORITY_ENC IS
	SIGNAL temp_out, diff : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
	temp_out <= STD_LOGIC_VECTOR(unsigned(inp) - 1) AND inp;
	diff <= STD_LOGIC_VECTOR(unsigned(inp) - unsigned(temp_out));
	outp <= temp_out;
	out_enc(2) <= diff(7) OR diff(6) OR diff(5) OR diff(4);
	out_enc(1) <= diff(2) OR diff(3) OR diff(6) OR diff(7);
	out_enc(0) <= diff(1) OR diff(3) OR diff(5) OR diff(7);
END ARCHITECTURE;