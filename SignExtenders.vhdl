-- IITB-RISC-2022
-----------------------------------------------------------------------------------------
-----------------------------------SIGN EXTENDER 6 BIT-----------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SignExt6 IS
  PORT (
    inp : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
    outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
  );
END ENTITY SignExt6;

ARCHITECTURE Struc OF SignExt6 IS
BEGIN
  outp(5 DOWNTO 0) <= inp;
  outp(15 DOWNTO 6) <= (OTHERS => '0');
END ARCHITECTURE;
-----------------------------------------------------------------------------------------
-----------------------------------SIGN EXTENDER 9 BIT-----------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SignExt9 IS
  PORT (
    inp : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
    outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
  );
END ENTITY SignExt9;

ARCHITECTURE Struc OF SignExt9 IS
BEGIN
  outp(8 DOWNTO 0) <= inp;
  outp(15 DOWNTO 9) <= (OTHERS => '0');
END ARCHITECTURE;