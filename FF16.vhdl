library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FF16 is
	port(D: in std_logic_vector(15 downto 0);
		  EN: in std_logic;
		  RST: in std_logic;
		  CLK: in std_logic;
		  Q: out std_logic_vector(15 downto 0));
end entity FF16;

architecture Behav of FF16 is

begin
	process(D,En,CLK)
	begin
	if CLK'event and (CLK = '0') then
		if RST = '1' then
			Q <= (others =>'0');
		elsif EN = '1' then
			Q <= D;
		end if;
	end if;
	end process;

end architecture;