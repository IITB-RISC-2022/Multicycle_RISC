library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------DECODER FOR REG FILE -----------------------------
--------------------------------------------------------------------------
entity reg_file_decoder is
	port (add: in std_logic_vector(2 downto 0);
			wr_en: in std_logic;
			en: out std_logic_vector(7 downto 0));
end entity;

architecture beh of reg_file_decoder is
begin
	process(add, wr_en)
		variable temp_en : std_logic_vector(7 downto 0);
	begin
		temp_en := (others => '0');
		temp_en(to_integer(unsigned(add))) := wr_en;
		en <= temp_en;
	end process;
end architecture;
--------------------------------------------------------------------------
-------------------------------REG FILE-----------------------------------
--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG_FILE is
		port(CLK, RST : in std_logic;
			  WR_EN, r7_en : in std_logic;
			  RF_A1 : in std_logic_vector(2 downto 0);
			  RF_A2 : in std_logic_vector(2 downto 0);
			  RF_A3 : in std_logic_vector(2 downto 0);
			  RF_D3 : in std_logic_vector(15 downto 0);
			  R7_IN : in std_logic_vector(15 downto 0);
			  RF_D1 : out std_logic_vector(15 downto 0);
			  RF_D2 : out std_logic_vector(15 downto 0));
end REG_FILE;

architecture Behav of REG_FILE is
	type regs is array(0 to 7) of std_logic_vector(15 downto 0);
	signal reg_file_in, reg_file_out : regs;
	
	signal write_en: std_logic_vector(7 downto 0);
	
	component reg_file_decoder is
		port (add: in std_logic_vector(2 downto 0);
				wr_en: in std_logic;
				en: out std_logic_vector(7 downto 0));
	end component;
	
	component FF16 is
		port(D: in std_logic_vector(15 downto 0);
			  EN: in std_logic;
			  RST: in std_logic;
			  CLK: in std_logic;
			  Q: out std_logic_vector(15 downto 0));
	end component FF16;
	
begin
	
	rf_d1 <= reg_file_out(to_integer(unsigned(RF_A1)));
	rf_d2 <= reg_file_out(to_integer(unsigned(RF_A2)));
	
	dec: reg_file_decoder port map(add => RF_A3, wr_en => WR_EN, en => write_en);
	
	reg_file_in(0 to 6) <= (others =>RF_D3);
	with r7_en select reg_file_in(7) <= 
			RF_D3 when '0',
			R7_IN when '1',
			(others => '0') when others;
			
	Rs: for i in 0 to 7 generate 
		reg: FF16 port map(D => reg_file_in(i), EN => write_en(i), RST => RST, CLK => CLK, Q => reg_file_out(i));
	end generate;
end architecture;