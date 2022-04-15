library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LShifter7 is
port (
    ip : in std_logic_vector (8 downto 0);
    op : out std_logic_vector (15 downto 0)
  );
end entity LShifter7;

architecture Behav of LShifter7 is
begin
  op(15 downto 7) <= ip;
  op(6 downto 0) <= (others=>'0');
end SignedExtender;
