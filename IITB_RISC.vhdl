-- IITB-RISC-2022
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY IITB_RISC IS
	PORT (
		CLK, RST : IN STD_LOGIC;
		R0, R1, R2, R3, R4, R5, R6, R7 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF IITB_RISC IS
	COMPONENT FSM IS
		PORT (
			CLK : IN STD_LOGIC;
			RST : IN STD_LOGIC;
			IR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			TB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
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
	END COMPONENT;

	COMPONENT DATAPATH IS
		PORT (
			CLK, RST, BOOT : IN STD_LOGIC;
			ALU_OP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			IR_EN, TA_EN, TB_EN, TC_EN, PC_EN, C_EN, Z_EN, TZ_EN, TD_EN : IN STD_LOGIC;
			REG_WR_EN, mem_wr_en, mem_rw_en : IN STD_LOGIC;
			rf_a1_mux, rf_a3_mux, rf_d3_mux : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			ta_mux, tb_mux : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			tc_mux : IN STD_LOGIC;
			mem_addr_mux : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			mem_di_mux : IN STD_LOGIC;
			alu_x_a_mux : IN STD_LOGIC;
			alu_y_a_mux : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			alu_y_b_mux : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			PC_mux : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			TB_outp : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			IR_outp : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			RF_a3 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			C_flag : OUT STD_LOGIC;
			TZ_flag : OUT STD_LOGIC;
			Z_flag : OUT STD_LOGIC;
			PROC_OUT : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
		);
	END COMPONENT DATAPATH;

	SIGNAL IR_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL TB_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL RF_a3_sig : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL C_flag_sig : STD_LOGIC;
	SIGNAL TZ_flag_sig : STD_LOGIC;
	SIGNAL Z_flag_sig : STD_LOGIC;
	SIGNAL ALU_OP_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL IR_EN_sig : STD_LOGIC;
	SIGNAL TA_EN_sig : STD_LOGIC;
	SIGNAL TB_EN_sig : STD_LOGIC;
	SIGNAL TC_EN_sig : STD_LOGIC;
	SIGNAL PC_EN_sig : STD_LOGIC;
	SIGNAL C_EN_sig : STD_LOGIC;
	SIGNAL Z_EN_sig : STD_LOGIC;
	SIGNAL TZ_EN_sig : STD_LOGIC;
	SIGNAL TD_EN_sig : STD_LOGIC;
	SIGNAL REG_WR_EN_sig : STD_LOGIC;
	SIGNAL mem_wr_en_sig, mem_rw_en_sig : STD_LOGIC;
	SIGNAL rf_a1_mux_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL rf_a3_mux_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL rf_d3_mux_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL ta_mux_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL tb_mux_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL tc_mux_sig : STD_LOGIC;
	SIGNAL mem_addr_mux_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL mem_di_mux_sig : STD_LOGIC;
	SIGNAL alu_x_a_mux_sig : STD_LOGIC;
	SIGNAL alu_y_a_mux_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL alu_y_b_mux_sig : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL PC_mux_sig : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL BOOT : STD_LOGIC := '1';
	SIGNAL PROC_OUT : STD_LOGIC_VECTOR(127 DOWNTO 0);
BEGIN
	fsm1 : FSM PORT MAP(
		CLK => CLK, RST => RST, IR => IR_sig, RF_a3 => RF_a3_sig, C_flag => C_flag_sig, Z_flag => Z_flag_sig, TZ_flag => TZ_flag_sig, TB => TB_sig,
		ALU_op => ALU_op_sig, IR_EN => IR_EN_sig, TA_EN => TA_EN_sig, TB_EN => TB_EN_sig, TC_EN => TC_EN_sig, PC_EN => PC_EN_sig,
		C_EN => C_EN_sig, Z_EN => Z_en_sig, TZ_EN => TZ_EN_sig, TD_EN => TD_EN_sig, reg_wr_en => reg_wr_en_sig,
		mem_wr_en => mem_wr_en_sig, mem_rw_en => mem_rw_en_sig, rf_a1_mux => rf_a1_mux_sig, rf_a3_mux => rf_a3_mux_sig, rf_d3_mux => rf_d3_mux_sig,
		ta_mux => ta_mux_sig, tb_mux => tb_mux_sig, tc_mux => tc_mux_sig, mem_addr_mux => mem_addr_mux_sig,
		mem_di_mux => mem_di_mux_sig, alu_x_a_mux => alu_x_a_mux_sig, alu_y_a_mux => alu_y_a_mux_sig, alu_y_b_mux => alu_y_b_mux_sig,
		PC_mux => PC_mux_sig);
	datapath1 : DATAPATH PORT MAP(
		BOOT => BOOT, CLK => CLK, RST => RST,
		ALU_OP => ALU_op_sig,
		IR_EN => IR_EN_sig, TA_EN => TA_EN_sig, TB_EN => Tb_EN_sig, TC_EN => Tc_EN_sig, PC_EN => pc_EN_sig, C_EN => c_EN_sig, Z_EN => z_EN_sig, TZ_EN => Tz_EN_sig, TD_EN => Td_EN_sig,
		REG_WR_EN => REG_WR_EN_sig, mem_wr_en => mem_WR_EN_sig, mem_rw_en => mem_RW_EN_sig,
		rf_a1_mux => rf_a1_mux_sig, rf_a3_mux => rf_a3_mux_sig, rf_d3_mux => rf_d3_mux_sig,
		ta_mux => ta_mux_sig, tb_mux => tb_mux_sig,
		tc_mux => tc_mux_sig,
		mem_addr_mux => mem_addr_mux_sig,
		mem_di_mux => mem_di_mux_sig,
		alu_x_a_mux => alu_x_a_mux_sig,
		alu_y_a_mux => alu_y_a_mux_sig,
		alu_y_b_mux => alu_y_b_mux_sig,
		PC_mux => PC_mux_sig,
		TB_outp => tb_sig,
		IR_outp => ir_sig,
		RF_a3 => rf_a3_sig,
		C_flag => c_flag_sig,
		TZ_flag => tz_flag_sig,
		Z_flag => z_flag_sig,
		PROC_OUT => PROC_OUT
	);

	R0 <= PROC_OUT(127 DOWNTO 112);
	R1 <= PROC_OUT(111 DOWNTO 96);
	R2 <= PROC_OUT(95 DOWNTO 80);
	R3 <= PROC_OUT(79 DOWNTO 64);
	R4 <= PROC_OUT(63 DOWNTO 48);
	R5 <= PROC_OUT(47 DOWNTO 32);
	R6 <= PROC_OUT(31 DOWNTO 16);
	R7 <= PROC_OUT(15 DOWNTO 0);
END ARCHITECTURE;