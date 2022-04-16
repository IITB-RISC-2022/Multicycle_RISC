library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExt6 is
port (
    inp : in std_logic_vector (5 downto 0);
    outp : out std_logic_vector (15 downto 0)
  );
end entity SignExt6;

architecture Struc of SignExt9 is
begin
  outp(5 downto 0) <= inp;
  outp(15 downto 6) <= (others =>inp(5));
end Struc;
