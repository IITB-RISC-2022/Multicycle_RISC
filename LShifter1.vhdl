library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LShifter1 is
port (
    ip : in std_logic_vector (15 downto 0);
    op : out std_logic_vector (15 downto 0)
  );
end entity LShifter1;

architecture Behav of LShifter1 is
begin
  op(15 downto 1) <= ip(14 downto 0);
  op(0) <= '0';
end Behav;
