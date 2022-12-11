-- IITB-RISC-2022
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
------------------------DECODER FOR REG FILE -----------------------------
--------------------------------------------------------------------------
ENTITY reg_file_decoder IS
	PORT (
		add : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		wr_en : IN STD_LOGIC;
		en : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;

ARCHITECTURE beh OF reg_file_decoder IS
BEGIN
	PROCESS (add, wr_en)
		VARIABLE temp_en : STD_LOGIC_VECTOR(7 DOWNTO 0);
	BEGIN
		temp_en := (OTHERS => '0');
		temp_en(to_integer(unsigned(add))) := wr_en;
		en <= temp_en;
	END PROCESS;
END ARCHITECTURE;
--------------------------------------------------------------------------
-------------------------------REG FILE-----------------------------------
--------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY REG_FILE IS
	PORT (
		CLK, RST : IN STD_LOGIC;
		WR_EN : IN STD_LOGIC;
		RF_A1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		RF_A2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		RF_A3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		RF_D3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		RF_D1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		RF_D2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		PC_D : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		PC_EN : IN STD_LOGIC;
		PROC_STATE : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
		PC_Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END REG_FILE;

ARCHITECTURE Behav OF REG_FILE IS
	TYPE regs IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg_file_q : regs;
	COMPONENT reg_file_decoder IS
		PORT (
			add : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			wr_en : IN STD_LOGIC;
			en : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;
BEGIN
	PROCESS (wr_en, rf_a1, rf_a2, rf_a3, rf_d3, pc_d, pc_en, clk, rst)
	BEGIN
		IF rst = '1' THEN
			reg_file_q <= (OTHERS => (OTHERS => '0'));
		END IF;
		IF falling_edge(clk) AND wr_en = '1' THEN
			reg_file_q(to_integer(unsigned(rf_a3))) <= rf_d3;
		END IF;
		rf_d1 <= reg_file_q(to_integer(unsigned(rf_a1)));
		rf_d2 <= reg_file_q(to_integer(unsigned(rf_a2)));

		IF falling_edge(clk) AND pc_en = '1' THEN
			reg_file_q(7) <= PC_D;
		END IF;
		pc_q <= reg_file_q(7);
	END PROCESS;

	PROC_STATE <= reg_file_q(0) & reg_file_q(1) & reg_file_q(2) & reg_file_q(3) & reg_file_q(4) & reg_file_q(5) & reg_file_q(6) & reg_file_q(7);
END ARCHITECTURE;