-- IITB-RISC-2022
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FSM IS
	PORT (
		CLK : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		TB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		IR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		RF_a3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		C_flag : IN STD_LOGIC;
		TZ_flag : IN STD_LOGIC;
		Z_flag : IN STD_LOGIC;
		ALU_OP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		IR_EN : OUT STD_LOGIC;
		TA_EN : OUT STD_LOGIC;
		TB_EN : OUT STD_LOGIC;
		TC_EN : OUT STD_LOGIC;
		PC_EN : OUT STD_LOGIC;
		C_EN : OUT STD_LOGIC;
		Z_EN : OUT STD_LOGIC;
		TZ_EN : OUT STD_LOGIC;
		TD_EN : OUT STD_LOGIC;
		REG_WR_EN : OUT STD_LOGIC;
		mem_wr_en, mem_rw_en : OUT STD_LOGIC;
		rf_a1_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rf_a3_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rf_d3_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		ta_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		tb_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		tc_mux : OUT STD_LOGIC;
		mem_addr_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		mem_di_mux : OUT STD_LOGIC;
		alu_x_a_mux : OUT STD_LOGIC;
		alu_y_a_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		alu_y_b_mux : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		PC_mux : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END ENTITY;

ARCHITECTURE beh OF FSM IS
	COMPONENT next_state IS
		PORT (
			curr_state : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			IR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			C_flag : IN STD_LOGIC;
			Z_flag : IN STD_LOGIC;
			TZ_flag : IN STD_LOGIC;
			TB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			RF_a3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			NS : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT control_word IS
		PORT (
			s : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			ir : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			X : OUT STD_LOGIC_VECTOR(33 DOWNTO 0));
	END COMPONENT;

	COMPONENT Decoder IS
		PORT (
			cw : IN STD_LOGIC_VECTOR(33 DOWNTO 0);
			mem_di_mux : OUT STD_LOGIC;
			mem_addr_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			WR_Enable, RW_Enable : OUT STD_LOGIC;
			rf_a1_mux, rf_a3_mux, rf_d3_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			reg_wr_en : OUT STD_LOGIC;
			alu_y_a_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			alu_y_b_mux : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			ALU_OP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			C_EN, Z_EN, TZ_EN : OUT STD_LOGIC;
			alu_x_a_mux : OUT STD_LOGIC;
			PC_mux : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			PC_EN : OUT STD_LOGIC;
			TA_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			TA_EN : OUT STD_LOGIC;
			TB_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			TB_EN : OUT STD_LOGIC;
			TC_mux : OUT STD_LOGIC;
			TC_EN : OUT STD_LOGIC;
			TD_EN : OUT STD_LOGIC;
			IR_EN : OUT STD_LOGIC
		);
	END COMPONENT;
	SIGNAL curr_st8, next_st8 : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL cont_word : STD_LOGIC_VECTOR(33 DOWNTO 0);
BEGIN
	next_state1 : next_state PORT MAP(curr_state => curr_st8, IR => IR, C_flag => C_flag, Z_flag => Z_flag, TZ_flag => TZ_flag, TB => TB, RF_a3 => RF_a3, NS => next_st8);
	control_word1 : control_word PORT MAP(s => curr_st8, ir => IR, X => cont_word);
	decoder1 : Decoder PORT MAP(
		cw => cont_word, ALU_op => ALU_op, IR_EN => IR_EN, TA_EN => TA_EN, TB_EN => TB_EN, TC_EN => TC_EN, PC_EN => PC_EN,
		C_EN => C_EN, Z_EN => Z_en, TZ_EN => TZ_EN, TD_EN => TD_EN, reg_wr_en => reg_wr_en,
		wr_enable => mem_wr_en, rw_enable => mem_rw_en, rf_a1_mux => rf_a1_mux, rf_a3_mux => rf_a3_mux, rf_d3_mux => rf_d3_mux,
		ta_mux => ta_mux, tb_mux => tb_mux, tc_mux => tc_mux, mem_addr_mux => mem_addr_mux,
		mem_di_mux => mem_di_mux, alu_x_a_mux => alu_x_a_mux, alu_y_a_mux => alu_y_a_mux, alu_y_b_mux => alu_y_b_mux,
		PC_mux => PC_mux);

	PROCESS (RST, CLK, curr_st8, next_st8)
	BEGIN
		IF CLK'event AND CLK = '1' THEN

			IF RST = '1' THEN
				curr_st8 <= "00001";
			ELSE
				curr_st8 <= next_st8;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;