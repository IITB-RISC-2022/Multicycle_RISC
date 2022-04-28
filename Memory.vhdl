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
	signal RAM: vec_array:= (
		0 => "0111000000000101", -- lw r0, r0, 5
	 	1 => "0111001000000100", -- lw r1, r0, 4
		2 => "0001000001000000", -- add r0, r1, r0
		3 => "0001000001011011", -- adl r0, r1, r3
		4 => "0111000000000111",
		5 => "0000000000000010",
		6 => "0000000000000100", 
		-- 10 => "0000000000000101",
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
		out_t := RAM(to_integer(unsigned(ADDR)));
	end if;
	outp <= out_t;
	end process;
end architecture;