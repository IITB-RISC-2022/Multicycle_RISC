-- IITB-RISC-2022
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMORY is
	port(CLK, WR_Enable, RW_Enable: in std_logic;
		  ADDR: in std_logic_vector(15 downto 0);
		  DATA: in std_logic_vector(15 downto 0);
		  OUTP: out std_logic_vector(15 downto 0)
	);
end MEMORY;

architecture behav of MEMORY is
	type vec_array is array(0 to 2**5 - 1) of std_logic_vector(15 downto 0);
	--0111000000000010
	signal RAM: vec_array:= (	 -- in ra rb rc	
		0 => "0111000000001010", -- lw r0, r0, 10
	 	1 => "0111001001001011", -- lw r1, r1, 11
		2 => "0111010010001100", -- lw r2, r2, 12
		3 => "0111100100000000", -- lw r4, r4, 00
		4 => "1011000000000010",
		5 => "0001000001000000",
		7 => "0001000000001000",
		--5 => "0001000010000001", 
		10 => "0000000000000101", 
		11 => "0000000000000111",
		12 => "0000000000000010", 
		others=>(others=>'1'));
	-- signal RAM: vec_array:= (others=>b"0000000000000000");

-- 00 00 000 001 002 0 00
begin
	process(CLK, ADDR, RW_Enable)
	variable out_t : std_logic_vector(15 downto 0) := (others => '1');
	begin
	if falling_edge(CLK) then
		if WR_Enable = '1' then
			RAM(to_integer(unsigned(ADDR))) <= DATA;
		end if;
	end if;
	
	if RW_Enable = '1' then
		if to_integer(unsigned(ADDR)) < 15 then
			out_t := RAM(to_integer(unsigned(ADDR)));
		else
			out_t := (others => '0');
		end if;
	end if;
	outp <= out_t;
	end process;
end architecture;