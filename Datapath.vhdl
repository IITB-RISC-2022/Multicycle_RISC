-- IITB-RISC-2022
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DATAPATH IS
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
END ENTITY DATAPATH;
ARCHITECTURE Complicated OF DATAPATH IS
	COMPONENT FF16 IS
		PORT (
			D : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			EN : IN STD_LOGIC;
			RST : IN STD_LOGIC;
			CLK : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;

	COMPONENT FF3 IS
		PORT (
			D : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			EN : IN STD_LOGIC;
			RST : IN STD_LOGIC;
			CLK : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;

	COMPONENT FF1 IS
		PORT (
			D : IN STD_LOGIC;
			EN : IN STD_LOGIC;
			RST : IN STD_LOGIC;
			CLK : IN STD_LOGIC;
			Q : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT REG_FILE IS
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
	END COMPONENT;

	COMPONENT MEMORY_SYNTH IS
		PORT (
			CLK, WR_Enable, RW_Enable : IN STD_LOGIC;
			ADDR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			OUTP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;

	COMPONENT ALU IS
		PORT (
			alu_op : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			inp_a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			inp_b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			out_c : OUT STD_LOGIC;
			out_z : OUT STD_LOGIC;
			alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;

	COMPONENT SignExt6 IS
		PORT (
			inp : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
	END COMPONENT;

	COMPONENT SignExt9 IS
		PORT (
			inp : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
			outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
	END COMPONENT;

	COMPONENT PRIORITY_ENC IS
		PORT (
			inp : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			outp : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			out_enc : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT LShifter1 IS
		PORT (
			inp : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT LShifter7 IS
		PORT (
			inp : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
			outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT mux_2x1_16bit IS
		PORT (
			inp_1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			sel : IN STD_LOGIC
		);
	END COMPONENT;
	COMPONENT mux_4x1_3bit IS
		PORT (
			inp_1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			inp_2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			inp_3 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			inp_4 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			outp : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT mux_4x1_16bit IS
		PORT (
			inp_1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_3 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_4 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT mux_8x1_16bit IS
		PORT (
			inp_1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_3 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_4 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_5 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_6 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_7 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			inp_8 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;
	SIGNAL one_16_bit : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000001";
	SIGNAL alu_y_a, alu_y_b, alu_y_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL alu_x_c, alu_x_z : STD_LOGIC;
	SIGNAL C_in, Z_in : STD_LOGIC;
	SIGNAL alu_x_out, alu_x_A : STD_LOGIC_VECTOR(15 DOWNTO 0);

	SIGNAL mem_addr_in, mem_data_in, mem_data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL rf_d3_in, rf_d1_out, rf_d2_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL rf_a1_in, rf_a3_in : STD_LOGIC_VECTOR(2 DOWNTO 0);

	SIGNAL IR_in, IR_out, TA_in, TA_out, TB_in, TB_out, TC_in, TC_out, PC_in, PC_out, PE_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL se6_outp, se9_outp, LS7_outp, LS1_outp : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL TD_in, TD_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	IR_in <= mem_data_out;
	IR_outp <= IR_out;
	TB_outp <= TB_out;
	RF_a3 <= rf_a3_in;
	ALU_Y : ALU PORT MAP(alu_op => ALU_OP, inp_a => alu_y_a, inp_b => alu_y_b, out_c => C_IN, out_z => Z_IN, alu_out => alu_y_out);
	flag_C : FF1 PORT MAP(D => C_in, EN => C_EN, RST => RST, CLK => CLK, Q => C_flag);
	flag_Z : FF1 PORT MAP(D => Z_in, EN => Z_EN, RST => RST, CLK => CLK, Q => Z_flag);
	flag_TZ : FF1 PORT MAP(D => Z_in, EN => TZ_EN, RST => RST, CLK => CLK, Q => TZ_flag);

	ALU_X : ALU PORT MAP(
		alu_op => "00", inp_a => alu_x_a, --
		inp_b => one_16_bit, out_c => alu_x_c, out_z => alu_x_z, alu_out => alu_x_out);

	RAM : MEMORY_SYNTH PORT MAP(CLK => CLK, WR_Enable => mem_wr_en, RW_Enable => mem_rw_en, ADDR => mem_addr_in, DATA => mem_data_in, OUTP => mem_data_out);

	REGISTER_FILE : REG_FILE PORT MAP(
		CLK => CLK,
		RST => RST,
		WR_EN => reg_wr_en,
		RF_A1 => rf_a1_in,
		RF_A2 => IR_out(8 DOWNTO 6),
		RF_A3 => rf_a3_in,
		RF_D3 => rf_d3_in,
		RF_D1 => rf_d1_out,
		RF_D2 => rf_d2_out,
		PC_D => PC_in,
		PC_EN => PC_EN,
		PROC_STATE => PROC_OUT,
		PC_Q => PC_out
	);

	IR : FF16 PORT MAP(D => mem_data_out, EN => IR_EN, RST => RST, CLK => CLK, Q => IR_out);
	TB : FF16 PORT MAP(D => TB_in, EN => TB_EN, RST => RST, CLK => CLK, Q => TB_out);
	TA : FF16 PORT MAP(D => TA_in, EN => TA_EN, RST => RST, CLK => CLK, Q => TA_out);
	TC : FF16 PORT MAP(D => TC_in, EN => TC_EN, RST => RST, CLK => CLK, Q => TC_out);

	TD : FF3 PORT MAP(D => TD_in, EN => TD_EN, RST => RST, CLK => CLK, Q => TD_out);

	PE : PRIORITY_ENC PORT MAP(inp => TB_out, outp => PE_out, out_enc => TD_in);

	SE6 : SignExt6 PORT MAP(inp => IR_out(5 DOWNTO 0), outp => se6_outp);
	SE9 : SignExt9 PORT MAP(inp => IR_out(8 DOWNTO 0), outp => se9_outp);

	LS1 : LShifter1 PORT MAP(inp => TB_out, outp => LS1_outp);
	LS7 : LShifter7 PORT MAP(inp => IR_out(8 DOWNTO 0), outp => LS7_outp);

	mux1 : mux_4x1_3bit PORT MAP(inp_1 => "000", inp_2 => IR_out(11 DOWNTO 9), inp_3 => TD_out, inp_4 => "111", sel => rf_a1_mux, outp => rf_a1_in);
	mux2 : mux_4x1_3bit PORT MAP(inp_1 => IR_out(8 DOWNTO 6), inp_2 => TD_out, inp_3 => IR_out(5 DOWNTO 3), inp_4 => IR_out(11 DOWNTO 9), sel => rf_a3_mux, outp => rf_a3_in);
	mux3 : mux_4x1_16bit PORT MAP(inp_1 => (OTHERS => '0'), inp_2 => TA_out, inp_3 => TC_out, inp_4 => LS7_outp, sel => rf_d3_mux, outp => rf_d3_in);
	mux4 : mux_4x1_16bit PORT MAP(inp_1 => alu_y_out, inp_2 => rf_d2_out, inp_3 => PE_out, inp_4 => se9_outp, sel => tb_mux, outp => TB_in);
	mux5 : mux_4x1_16bit PORT MAP(inp_1 => mem_data_out, inp_2 => rf_d1_out, inp_3 => alu_y_out, inp_4 => alu_x_out, sel => ta_mux, outp => TA_in);
	mux6 : mux_2x1_16bit PORT MAP(inp_1 => rf_d1_out, inp_2 => mem_data_out, outp => TC_in, sel => tc_mux);

	mux8 : mux_4x1_16bit PORT MAP(inp_1 => TA_out, inp_2 => PC_out, inp_3 => TB_out, inp_4 => (OTHERS => '0'), outp => mem_addr_in, sel => mem_addr_mux);
	mux9 : mux_2x1_16bit PORT MAP(inp_1 => TA_out, inp_2 => TC_out, outp => mem_data_in, sel => mem_di_mux);
	mux10 : mux_8x1_16bit PORT MAP(
		inp_1 => se6_outp, inp_2 => LS1_outp, inp_3 => se9_outp, inp_4 => TC_out,
		inp_5 => TB_out, inp_6 => (0 => '1', OTHERS => '0'), inp_7 => (OTHERS => '0'), inp_8 => (OTHERS => '0'), outp => alu_y_b, sel => alu_y_b_mux);
	mux11 : mux_4x1_16bit PORT MAP(
		inp_1 => (OTHERS => '0'), inp_2 => TA_out, inp_3 => TB_out, inp_4 => se9_outp,
		outp => alu_y_a, sel => alu_y_a_mux);
	mux12 : mux_2x1_16bit PORT MAP(inp_1 => TA_out, inp_2 => PC_out, outp => alu_x_a, sel => alu_x_a_mux);
	mux13 : mux_8x1_16bit PORT MAP(
		inp_1 => (OTHERS => '0'), inp_2 => TA_out, inp_3 => LS7_outp, inp_4 => TC_out, inp_5 => alu_x_out,
		inp_6 => TB_out, inp_7 => alu_y_out, inp_8 => (OTHERS => '0'), outp => PC_in, sel => PC_mux);
END ARCHITECTURE;