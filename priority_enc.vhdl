-- IITB-RISC-2022
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PRIORITY_ENC is
		port(
		inp: in std_logic_vector(15 downto 0);
		outp: out std_logic_vector(15 downto 0);
		out_enc: out std_logic_vector(2 downto 0)
		);
end entity;

architecture Behav of PRIORITY_ENC is
	signal temp_out, diff : std_logic_vector(15 downto 0);
begin
	temp_out <= std_logic_vector(unsigned(inp)-1) and inp;
	diff <= std_logic_vector(unsigned(inp)-unsigned(temp_out));
	outp <= temp_out;
	out_enc(2) <= diff(7) or diff(6) or diff(5) or diff(4);
	out_enc(1) <= diff(2) or diff(3) or diff(6) or diff(7);
	out_enc(0) <= diff(1) or diff(3) or diff(5) or diff(7);
end architecture;