-- IITB-RISC-2022
-----------------------------------------------------------------------------------------
-----------------------------------LEFT SHIFTER 7 BIT------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LShifter7 IS
  PORT (
    inp : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
    outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
  );
END ENTITY LShifter7;

ARCHITECTURE Behav OF LShifter7 IS
BEGIN
  outp(15 DOWNTO 7) <= inp;
  outp(6 DOWNTO 0) <= (OTHERS => '0');
END Behav;

-----------------------------------------------------------------------------------------
-----------------------------------LEFT SHIFTER 1 BIT------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LShifter1 IS
  PORT (
    inp : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
  );
END ENTITY LShifter1;

ARCHITECTURE Behav OF LShifter1 IS
BEGIN
  outp(15 DOWNTO 1) <= inp(14 DOWNTO 0);
  outp(0) <= '0';
END Behav;