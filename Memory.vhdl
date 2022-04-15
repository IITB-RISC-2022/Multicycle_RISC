library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMORY is
	port(CLK, WR_Enable: in std_logic;
		  ADDR: in std_logic_vector(15 downto 0);
		  DATA: in std_logic_vector(15 downto 0);
		  OUTP: out std_logic_vector(15 downto 0));
end MEMORY;

architecture behav of MEMORY is
	type data is array(0 to 2**16 - 1) of std_logic_vector(15 downto 0);
	signal RAM: data;
begin
	process(CLK, ADDR, DATA)
	begin
	if CLK'event and (CLK = '0') then
		if WR_Enable then
			RAM(unsigned(ADDR)) <= DATA;
		end if;
			OUTP <= RAM(unsigned(ADDR));
	end if;
	end process;
end architecture;