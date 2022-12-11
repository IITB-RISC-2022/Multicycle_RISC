-- IITB-RISC-2022
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS
	PORT (
		alu_op : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		inp_a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		inp_b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		out_c : OUT STD_LOGIC;
		out_z : OUT STD_LOGIC;
		alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY;

ARCHITECTURE behav OF ALU IS
BEGIN
	PROCESS (alu_op, inp_a, inp_b)
		-- temp_out is a temp variable that stores the output of the ALU
		VARIABLE temp_out, temp_a, temp_b : STD_LOGIC_VECTOR(16 DOWNTO 0);
	BEGIN
		temp_out := (OTHERS => '0');
		IF (alu_op = "00") THEN
			temp_a(15 DOWNTO 0) := inp_a;
			temp_b(15 DOWNTO 0) := inp_b;
			temp_a(16) := '0';
			temp_b(16) := '0';
			temp_out := STD_LOGIC_VECTOR(unsigned(temp_a) + unsigned(temp_b));
			out_c <= temp_out(16);
		ELSIF (alu_op = "01") THEN
			temp_out(15 DOWNTO 0) := inp_a XOR inp_b;
			out_c <= '0';
		ELSIF (alu_op = "10") THEN
			temp_out(15 DOWNTO 0) := inp_a NAND inp_b;
			out_c <= '0';
		ELSIF (alu_op = "11") THEN
			temp_out(15 DOWNTO 0) := STD_LOGIC_VECTOR(unsigned(inp_a) + unsigned(inp_b) - 1);
		END IF;

		IF temp_out(15 DOWNTO 0) = "0000000000000000" THEN
			out_z <= '1';
		ELSE
			out_z <= '0';
		END IF;

		alu_out <= temp_out(15 DOWNTO 0);
	END PROCESS;

END ARCHITECTURE;