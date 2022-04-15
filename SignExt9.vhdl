library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExt9 is
port (
    inp : in std_logic_vector (8 downto 0);
    outp : out std_logic_vector (15 downto 0)
  );
end entity SignExt9;

architecture Struc of SignExt9 is
begin
  outp(8 downto 0) <= inp;
  outp(15 downto 9) <= (others =>inp(8));
end SignedExtender;
