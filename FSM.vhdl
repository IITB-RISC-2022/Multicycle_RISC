library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM is 
	port (CLK: in std_logic;
			RST: in std_logic;
			TB: in std_logic_vector(15 downto 0);
			IR: in std_logic_vector(15 downto 0);
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
end entity;

architecture beh of FSM is
	component next_state is
		port (curr_state: in std_logic_vector(4 downto 0);
				IR: in std_logic_vector(15 downto 0);
				C_flag: in std_logic;
				Z_flag: in std_logic;
				TZ_flag: in std_logic;
				TB: in std_logic_vector(15 downto 0);
				RF_a3: in std_logic_vector(2 downto 0);
				NS: out std_logic_vector(4 downto 0)
				);
	end component;
	
	component control_word is 
		port (s: in std_logic_vector(4 downto 0);
				ir: in std_logic_vector(15 downto 0);
				X: out std_logic_vector(34 downto 0));
	end component;

	component Decoder is
		 port(
			cw: in std_logic_vector(34 downto 0);
			mem_di_mux: out std_logic;
			mem_addr_mux: out std_logic_vector(1 downto 0);
			WR_Enable, RW_Enable: out std_logic;
			rf_a1_mux, rf_a3_mux, rf_d3_mux: out std_logic_vector(1 downto 0);
			reg_wr_en: out std_logic;
			alu_y_a_mux: out std_logic_vector(1 downto 0);
			alu_y_b_mux: out std_logic_vector(2 downto 0);
			ALU_OP: out std_logic_vector(1 downto 0);
			C_EN, Z_EN, TZ_EN: out std_logic;
			alu_x_a_mux: out std_logic;
			PC_mux: out std_logic_vector(2 downto 0);
			PC_EN: out std_logic;
			R7_mux: out std_logic_vector(1 downto 0);
			R7_EN: out std_logic;
			TA_mux: out std_logic_vector(1 downto 0);
			TA_EN: out std_logic;
			TB_mux: out std_logic_vector(1 downto 0);
			TB_EN: out std_logic;
			TC_mux: out std_logic;
			TC_EN: out std_logic;
			TD_EN: out std_logic;
			IR_EN: out std_logic
		);
	end component;
	signal curr_st8, next_st8 : std_logic_vector(4 downto 0);
	signal cont_word : std_logic_vector(34 downto 0);
begin
	next_state1: next_state port map(curr_state => curr_st8, IR => IR, C_flag =>C_flag, Z_flag => Z_flag, TZ_flag=> TZ_flag, TB => TB, RF_a3 =>RF_a3, NS=>next_st8);
	control_word1: control_word port map(s => curr_st8, ir => IR, X => cont_word);
	decoder1: Decoder port map(cw => cont_word, ALU_op => ALU_op, IR_EN => IR_EN, TA_EN => TA_EN, TB_EN=> TB_EN, TC_EN=> TC_EN, PC_EN=> PC_EN, 
					C_EN=> C_EN, Z_EN=> Z_en, TZ_EN => TZ_EN, TD_EN=> TD_EN, r7_EN=> r7_en, reg_wr_en=> reg_wr_en,
					wr_enable => mem_wr_en, rw_enable => mem_rw_en, rf_a1_mux=> rf_a1_mux, rf_a3_mux => rf_a3_mux, rf_d3_mux=> rf_d3_mux,
					ta_mux => ta_mux, tb_mux => tb_mux, tc_mux => tc_mux, r7_mux => r7_mux, mem_addr_mux => mem_addr_mux,
					mem_di_mux => mem_di_mux, alu_x_a_mux => alu_x_a_mux, alu_y_a_mux => alu_y_a_mux, alu_y_b_mux => alu_y_b_mux,
					PC_mux => PC_mux);
	
	process(RST, CLK, curr_st8, next_st8)
	begin
	if CLK'event and CLK = '1' then
		
		if RST = '1' then
			curr_st8 <= "00001";
		else
			curr_st8 <= next_st8;
		end if;
	end if;
	end process;
end architecture;