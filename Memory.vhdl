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
	signal RAM: vec_array:= (0 =>"0111000000000010", 1 => "0101000000000000", 2=>"0010000000000011", others=>"0000000000000001");
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