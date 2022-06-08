-- IITB-RISC-2022
------------------------------------------------------------------------------
-----------------------------------16 bit 2x1 MUX-----------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2x1_16bit is
port (
    inp_1 : in std_logic_vector (15 downto 0);
	 inp_2 : in std_logic_vector (15 downto 0);
    outp : out std_logic_vector (15 downto 0);
	 sel : in std_logic
  );
end entity mux_2x1_16bit;

architecture Behav of mux_2x1_16bit is
begin
	process(inp_1,inp_2,sel)
	begin
	if sel = '0' then
		outp <= inp_1;
	else
		outp <= inp_2;
	end if;
	end process;
end Behav;

------------------------------------------------------------------------------
-----------------------------------3 bit 4x1 MUX------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4x1_3bit is
port (
    inp_1 : in std_logic_vector (2 downto 0);
	 inp_2 : in std_logic_vector (2 downto 0);
	 inp_3 : in std_logic_vector (2 downto 0);
	 inp_4 : in std_logic_vector (2 downto 0);
    outp : out std_logic_vector (2 downto 0);
	 sel : in std_logic_vector(1 downto 0)
  );
end entity mux_4x1_3bit;

architecture Behav of mux_4x1_3bit is
begin
	process(inp_1,inp_2,inp_3,inp_4,sel)
	begin
	if sel = "00" then
		outp <= inp_1;
	elsif sel = "01" then
		outp <= inp_2;
	elsif sel = "10" then
		outp <= inp_3;
	else
		outp <= inp_4;
	end if;
	end process;
end Behav;

------------------------------------------------------------------------------
-----------------------------------16 bit 4x1 MUX-----------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4x1_16bit is
port (
    inp_1 : in std_logic_vector (15 downto 0);
	 inp_2 : in std_logic_vector (15 downto 0);
	 inp_3 : in std_logic_vector (15 downto 0);
	 inp_4 : in std_logic_vector (15 downto 0);
    outp : out std_logic_vector (15 downto 0);
	 sel : in std_logic_vector(1 downto 0)
  );
end entity mux_4x1_16bit;

architecture Behav of mux_4x1_16bit is
begin
	process(inp_1,inp_2,inp_3,inp_4,sel)
	begin
	if sel = "00" then
		outp <= inp_1;
	elsif sel = "01" then
		outp <= inp_2;
	elsif sel = "10" then
		outp <= inp_3;
	else
		outp <= inp_4;
	end if;
	end process;
end Behav;

------------------------------------------------------------------------------
-----------------------------------16 bit 8x1 MUX-----------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_8x1_16bit is
port (
    inp_1 : in std_logic_vector (15 downto 0);
	 inp_2 : in std_logic_vector (15 downto 0);
	 inp_3 : in std_logic_vector (15 downto 0);
	 inp_4 : in std_logic_vector (15 downto 0);
	 inp_5 : in std_logic_vector (15 downto 0);
	 inp_6 : in std_logic_vector (15 downto 0);
	 inp_7 : in std_logic_vector (15 downto 0);
	 inp_8 : in std_logic_vector (15 downto 0);
    outp : out std_logic_vector (15 downto 0);
	 sel : in std_logic_vector(2 downto 0)
  );
end entity mux_8x1_16bit;

architecture Behav of mux_8x1_16bit is
begin
	process(inp_1,inp_2,inp_3,inp_4,inp_5,inp_6,inp_7,inp_8,sel)
	begin
		case(sel) is
			when "000" =>
				outp <= inp_1;
			when "001" =>
				outp <= inp_2;
			when "010" =>
				outp <= inp_3;
			when "011" =>
				outp <= inp_4;
			when "100" =>
				outp <= inp_5;
			when "101" =>
				outp <= inp_6;
			when "110" =>
				outp <= inp_7;
			when "111" =>
				outp <= inp_8;
			when others =>
				outp <= (others=>'0');
		end case;
	end process;
end Behav;



		
