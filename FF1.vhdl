library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FF1 is
	port(D: in std_logic;
		  EN: in std_logic;
		  RST: in std_logic;
		  CLK: in std_logic;
		  Q: out std_logic);
end entity FF1;

architecture Behav of FF1 is

begin
	process(D,En,CLK)
	begin
	if CLK'event and (CLK = '0') then
		if RST = '1' then
			Q <= '0';
		elsif EN = '1' then
			Q <= D;
		end if;
	end if;
	end process;

end architecture;