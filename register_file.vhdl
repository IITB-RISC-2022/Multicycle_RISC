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
			  WR_EN : in std_logic;
			  RF_A1 : in std_logic_vector(2 downto 0);
			  RF_A2 : in std_logic_vector(2 downto 0);
			  RF_A3 : in std_logic_vector(2 downto 0);
			  RF_D3 : in std_logic_vector(15 downto 0);
			  RF_D1 : out std_logic_vector(15 downto 0);
			  RF_D2 : out std_logic_vector(15 downto 0);
			  PC_D : in std_logic_vector(15 downto 0); 
			  PC_EN : in std_logic;
			  PC_Q : out std_logic_vector(15 downto 0)
		);
end REG_FILE;

architecture Behav of REG_FILE is
	type regs is array(0 to 7) of std_logic_vector(15 downto 0);
	signal reg_file_q : regs;
	
	signal write_en: std_logic_vector(7 downto 0);
	
	component reg_file_decoder is
		port (add: in std_logic_vector(2 downto 0);
				wr_en: in std_logic;
				en: out std_logic_vector(7 downto 0));
	end component;
begin
	process(wr_en, rf_a1, rf_a2, rf_a3, rf_d3, pc_d, pc_en, clk, rst)
	begin
		if rst='1' then
			reg_file_q <= (others => (others => '0'));
		end if;
		if falling_edge(clk) and wr_en = '1' then
				reg_file_q(to_integer(unsigned(rf_a3))) <= rf_d3;
		end if;
		rf_d1 <= reg_file_q(to_integer(unsigned(rf_a1)));
		rf_d2 <= reg_file_q(to_integer(unsigned(rf_a2)));
		
		if falling_edge(clk) and pc_en = '1' then
				reg_file_q(7) <= PC_D;
		end if;
		pc_q <= reg_file_q(7);
	end process;
end architecture;