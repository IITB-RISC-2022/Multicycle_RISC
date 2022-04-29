-----------------------------------------------------------------------------------------
-----------------------------------------3 BIT FF ---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FF3 is
	port(D: in std_logic_vector(2 downto 0);
		  EN: in std_logic;
		  RST: in std_logic;
		  CLK: in std_logic;
		  Q: out std_logic_vector(2 downto 0));
end entity FF3;

architecture Behav of FF3 is

begin
	process(D,En,CLK)
	begin
	if rst = '1' then
		Q <= (others =>'0');
	elsif CLK'event and (CLK = '0') then
		if EN = '1' then
			Q <= D;
		end if;
	end if;
	end process;

end architecture;

-----------------------------------------------------------------------------------------
-----------------------------------------1 BIT FF ---------------------------------------

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
		if rst = '1' then
			Q <= '0';
		elsif CLK'event and (CLK = '0') then
			if EN = '1' then
				Q <= D;
			end if;
		end if;
	end process;

end architecture;

-----------------------------------------------------------------------------------------
-----------------------------------------16 BIT FF --------------------------------------

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
		if rst = '1' then
			Q <= (others =>'0');
		elsif CLK'event and (CLK = '0') then
			if EN = '1' then
				Q <= D;
			end if;
		end if;
	end process;

end architecture;