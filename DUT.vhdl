-- IITB-RISC-2022
-- A DUT entity is used to wrap your design.
--  This example shows how you can do this for the
--  Full-adder.

library ieee;
use ieee.std_logic_1164.all;
entity DUT is
   port(input_vector: in std_logic_vector(1 downto 0);
       	output_vector: out std_logic_vector(0 downto 0));
end entity;

architecture DutWrap of DUT is
	component IITB_RISC is 
		port (CLK, RST: in std_logic);
	end component IITB_RISC;
	signal zero: std_logic_vector(0 downto 0) := "0";
begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   RISC_instance: IITB_RISC 
			port map (
					CLK => input_vector(1),
					RST => input_vector(0));

end DutWrap;

