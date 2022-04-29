library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IITB_RISC is 
	port (CLK, RST: in std_logic);
end entity;

architecture ViruS of IITB_RISC is
	component FSM is 
		port (CLK: in std_logic;
				RST: in std_logic;
				IR: in std_logic_vector(15 downto 0);
				TB: in std_logic_vector(15 downto 0);
				RF_a3: in std_logic_vector(2 downto 0);
				C_flag: in std_logic;
				TZ_flag: in std_logic;
				Z_flag: in std_logic;
				ALU_OP : out std_logic_vector(1 downto 0);
				IR_EN: out std_logic;
				TA_EN: out std_logic;
				TB_EN: out std_logic;
				TC_EN: out std_logic;
				PC_EN: out std_logic;
				C_EN: out std_logic;
				Z_EN: out std_logic;
				TZ_EN: out std_logic;
				TD_EN : out std_logic;
				R7_en: out std_logic;
				REG_WR_EN: out std_logic;
				mem_wr_en, mem_rw_en : out std_logic;
				rf_a1_mux: out std_logic_vector(1 downto 0);
				rf_a3_mux: out std_logic_vector(1 downto 0);
				rf_d3_mux: out std_logic_vector(1 downto 0);
				ta_mux: out std_logic_vector(1 downto 0);
				tb_mux: out std_logic_vector(1 downto 0);
				r7_mux: out std_logic_vector(1 downto 0);
				tc_mux: out std_logic;
				mem_addr_mux: out std_logic_vector(1 downto 0);
				mem_di_mux: out std_logic;
				alu_x_a_mux: out std_logic;
				alu_y_a_mux: out std_logic_vector(1 downto 0);
				alu_y_b_mux: out std_logic_vector(2 downto 0);
				PC_mux: out std_logic_vector(2 downto 0));
	end component;
	
	component DATAPATH is
		port(
		CLK, RST :in std_logic;
		ALU_OP : in std_logic_vector(1 downto 0);
		IR_EN, TA_EN, TB_EN, TC_EN, PC_EN, C_EN, Z_EN, TZ_EN, TD_EN : in std_logic;
		R7_en, REG_WR_EN, mem_wr_en, mem_rw_en : in std_logic;
		rf_a1_mux, rf_a3_mux, rf_d3_mux: in std_logic_vector(1 downto 0);
		ta_mux, tb_mux, r7_mux: in std_logic_vector(1 downto 0);
		tc_mux: in std_logic;
		mem_addr_mux: in std_logic_vector(1 downto 0);
		mem_di_mux: in std_logic;
		alu_x_a_mux: in std_logic;
		alu_y_a_mux: in std_logic_vector(1 downto 0);
		alu_y_b_mux: in std_logic_vector(2 downto 0);
		PC_mux: in std_logic_vector(2 downto 0);
		TB_outp: out std_logic_vector(15 downto 0);
		IR_outp: out std_logic_vector(15 downto 0);
		RF_a3: out std_logic_vector(2 downto 0);
		C_flag: out std_logic;
		TZ_flag: out std_logic;
		Z_flag: out std_logic
		);
	end component DATAPATH;
	
	-- component Decoder is
	-- 	 port(
	-- 		cw: in std_logic_vector(35 downto 0);
	-- 		mem_di_mux: out std_logic;
	-- 		mem_addr_mux: out std_logic_vector(1 downto 0);
	-- 		WR_Enable: out std_logic;
	-- 		rf_a1_mux, rf_a3_mux, rf_d3_mux: out std_logic_vector(1 downto 0);
	-- 		reg_wr_en: out std_logic;
	-- 		alu_y_a_mux: out std_logic_vector(1 downto 0);
	-- 		alu_y_b_mux: out std_logic_vector(2 downto 0);
	-- 		ALU_OP: out std_logic_vector(1 downto 0);
	-- 		C_EN, Z_EN, TZ_EN: out std_logic;
	-- 		alu_x_a_mux: out std_logic;
	-- 		PC_mux: out std_logic_vector(2 downto 0);
	-- 		PC_EN: out std_logic;
	-- 		R7_mux: out std_logic_vector(1 downto 0);
	-- 		R7_EN: out std_logic;
	-- 		TA_mux: out std_logic_vector(1 downto 0);
	-- 		TA_EN: out std_logic;
	-- 		TB_mux: out std_logic_vector(1 downto 0);
	-- 		TB_EN: out std_logic;
	-- 		TC_mux: out std_logic;
	-- 		TC_EN: out std_logic;
	-- 		TD_EN: out std_logic;
	-- 		IR_EN: out std_logic
	-- 	);
	-- end component;
	
			signal IR_sig: std_logic_vector(15 downto 0);
			signal	TB_sig: std_logic_vector(15 downto 0);
			signal	RF_a3_sig: std_logic_vector(2 downto 0);
			signal	C_flag_sig: std_logic;
			signal	TZ_flag_sig: std_logic;
			signal	Z_flag_sig: std_logic;
			signal	ALU_OP_sig : std_logic_vector(1 downto 0);
			signal	IR_EN_sig: std_logic;
			signal	TA_EN_sig: std_logic;
			signal	TB_EN_sig: std_logic;
			signal	TC_EN_sig: std_logic;
			signal	PC_EN_sig: std_logic;
			signal	C_EN_sig:  std_logic;
			signal	Z_EN_sig:  std_logic;
			signal	TZ_EN_sig: std_logic;
			signal	TD_EN_sig : std_logic;
			signal	R7_en_sig:  std_logic;
			signal	REG_WR_EN_sig: std_logic;
			signal	mem_wr_en_sig, mem_rw_en_sig : std_logic;
			signal	rf_a1_mux_sig: std_logic_vector(1 downto 0);
			signal	rf_a3_mux_sig: std_logic_vector(1 downto 0);
			signal	rf_d3_mux_sig: std_logic_vector(1 downto 0);
			signal	ta_mux_sig: std_logic_vector(1 downto 0);
			signal	tb_mux_sig: std_logic_vector(1 downto 0);
			signal	r7_mux_sig: std_logic_vector(1 downto 0);
			signal	tc_mux_sig: std_logic;
			signal	mem_addr_mux_sig: std_logic_vector(1 downto 0);
			signal	mem_di_mux_sig: std_logic;
			signal	alu_x_a_mux_sig: std_logic;
			signal	alu_y_a_mux_sig: std_logic_vector(1 downto 0);
			signal	alu_y_b_mux_sig: std_logic_vector(2 downto 0);
			signal	PC_mux_sig: std_logic_vector(2 downto 0);
begin
	fsm1: FSM port map(CLK => CLK, RST => RST, IR=> IR_sig, RF_a3 => RF_a3_sig, C_flag=> C_flag_sig, Z_flag =>  Z_flag_sig, TZ_flag => TZ_flag_sig, TB => TB_sig,
						 ALU_op => ALU_op_sig, IR_EN => IR_EN_sig, TA_EN => TA_EN_sig, TB_EN=> TB_EN_sig, TC_EN=> TC_EN_sig, PC_EN=> PC_EN_sig, 
						 C_EN=> C_EN_sig, Z_EN=> Z_en_sig, TZ_EN => TZ_EN_sig, TD_EN=> TD_EN_sig, r7_EN=> r7_en_sig, reg_wr_en=> reg_wr_en_sig,
						 mem_wr_en => mem_wr_en_sig, mem_rw_en => mem_rw_en_sig, rf_a1_mux=> rf_a1_mux_sig, rf_a3_mux => rf_a3_mux_sig, rf_d3_mux=> rf_d3_mux_sig,
						 ta_mux => ta_mux_sig, tb_mux => tb_mux_sig, tc_mux => tc_mux_sig, r7_mux => r7_mux_sig, mem_addr_mux => mem_addr_mux_sig,
						 mem_di_mux => mem_di_mux_sig, alu_x_a_mux => alu_x_a_mux_sig, alu_y_a_mux => alu_y_a_mux_sig, alu_y_b_mux => alu_y_b_mux_sig,
						 PC_mux => PC_mux_sig);
	datapath1: DATAPATH port map( 		CLK=> CLK, RST=> RST,
		ALU_OP => ALU_op_sig,
		IR_EN =>IR_EN_sig , TA_EN =>TA_EN_sig , TB_EN =>Tb_EN_sig, TC_EN=>Tc_EN_sig, PC_EN=>pc_EN_sig, C_EN=>c_EN_sig, Z_EN=>z_EN_sig, TZ_EN=>Tz_EN_sig, TD_EN =>Td_EN_sig,
		R7_en => R7_en_sig, REG_WR_EN => REG_WR_EN_sig, mem_wr_en => mem_WR_EN_sig, mem_rw_en => mem_RW_EN_sig,
		rf_a1_mux => rf_a1_mux_sig, rf_a3_mux => rf_a3_mux_sig, rf_d3_mux => rf_d3_mux_sig,
		ta_mux =>ta_mux_sig, tb_mux => tb_mux_sig, r7_mux => r7_mux_sig,
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
		Z_flag => z_flag_sig);
end architecture;