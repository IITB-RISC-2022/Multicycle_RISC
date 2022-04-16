-----------------------------------------------------------------------------------------
-----------------------------------LEFT SHIFTER 7 BIT------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LShifter7 is
port (
    inp : in std_logic_vector (8 downto 0);
    outp : out std_logic_vector (15 downto 0)
  );
end entity LShifter7;

architecture Behav of LShifter7 is
begin
  outp(15 downto 7) <= inp;
  outp(6 downto 0) <= (others=>'0');
end Behav;

-----------------------------------------------------------------------------------------
-----------------------------------LEFT SHIFTER 1 BIT------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LShifter1 is
port (
    inp : in std_logic_vector (15 downto 0);
    outp : out std_logic_vector (15 downto 0)
  );
end entity LShifter1;

architecture Behav of LShifter1 is
begin
  outp(15 downto 1) <= inp(14 downto 0);
  outp(0) <= '0';
end Behav;
