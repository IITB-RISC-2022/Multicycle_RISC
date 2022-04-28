library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DATAPATH is
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
end entity DATAPATH;


architecture Complicated of DATAPATH is
	component FF16 is
		port(D: in std_logic_vector(15 downto 0);
			  EN: in std_logic;
			  RST: in std_logic;
			  CLK: in std_logic;
			  Q: out std_logic_vector(15 downto 0));
	end component;
	
	component FF3 is
		port(D: in std_logic_vector(2 downto 0);
			  EN: in std_logic;
			  RST: in std_logic;
			  CLK: in std_logic;
			  Q: out std_logic_vector(2 downto 0));
	end component;	
	
	component FF1 is
		port(D: in std_logic;
			  EN: in std_logic;
			  RST: in std_logic;
			  CLK: in std_logic;
			  Q: out std_logic);
	end component;
	
	component REG_FILE is
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
	end component;
	
	component MEMORY is
		port(CLK, WR_Enable, RW_Enable: in std_logic;
			  ADDR: in std_logic_vector(15 downto 0);
			  DATA: in std_logic_vector(15 downto 0);
			  OUTP: out std_logic_vector(15 downto 0));
	end component;
	
	component ALU is
		port(alu_op: in std_logic_vector(1 downto 0);
			  inp_a: in std_logic_vector(15 downto 0);
			  inp_b: in std_logic_vector(15 downto 0);
			  out_c: out std_logic;
			  out_z: out std_logic;
			  alu_out: out std_logic_vector(15 downto 0));
	end component;
	
	component SignExt6 is
		port (
		inp : in std_logic_vector (5 downto 0);
		outp : out std_logic_vector (15 downto 0));
	end component;
	
	component SignExt9 is
		port (
		inp : in std_logic_vector (8 downto 0);
		outp : out std_logic_vector (15 downto 0));
	end component;
	
	component PRIORITY_ENC is
		port(
		inp: in std_logic_vector(15 downto 0);
		outp: out std_logic_vector(15 downto 0);
		out_enc: out std_logic_vector(2 downto 0)
		);
	end component;
	
	component LShifter1 is
		port (
			inp : in std_logic_vector (15 downto 0);
			outp : out std_logic_vector (15 downto 0)
		);
	end component;
	
	component LShifter7 is
		port (
			inp : in std_logic_vector (8 downto 0);
			outp : out std_logic_vector (15 downto 0)
		);
	end component;
	
	component mux_2x1_16bit is
	port (
		 inp_1 : in std_logic_vector (15 downto 0);
		 inp_2 : in std_logic_vector (15 downto 0);
		 outp : out std_logic_vector (15 downto 0);
		 sel : in std_logic
	  );
	end component;
	
	
	component mux_4x1_3bit is
	port (
		 inp_1 : in std_logic_vector (2 downto 0);
		 inp_2 : in std_logic_vector (2 downto 0);
		 inp_3 : in std_logic_vector (2 downto 0);
		 inp_4 : in std_logic_vector (2 downto 0);
		 outp : out std_logic_vector (2 downto 0);
		 sel : in std_logic_vector(1 downto 0)
	  );
	end component;
	
	component mux_4x1_16bit is
	port (
		 inp_1 : in std_logic_vector (15 downto 0);
		 inp_2 : in std_logic_vector (15 downto 0);
		 inp_3 : in std_logic_vector (15 downto 0);
		 inp_4 : in std_logic_vector (15 downto 0);
		 outp : out std_logic_vector (15 downto 0);
		 sel : in std_logic_vector(1 downto 0)
	  );
	end component;
	
	component mux_8x1_16bit is
	port (
		 inp_1 : in std_logic_vector (15 downto 0);
		 inp_2 : in std_logic_vector (15 downto 0);
		 inp_3 : in std_logic_vector (15 downto 0);
		 inp_4 : in std_logic_vector (15 downto 0);
		 inp_5 : in std_logic_vector (15 downto 0);
		 inp_6 : in std_logic_vector (15 downto 0);
		 inp_7 : in std_logic_vector (15 downto 0);
		 inp_8 : in std_logic_vector (15 downto 0);
		 outp : out std_logic_vector (15 downto 0);
		 sel : in std_logic_vector(2 downto 0)
	  );
	end component;

		
	signal one_16_bit: std_logic_vector(15 downto 0) := "0000000000000001";
	signal alu_y_a, alu_y_b, alu_y_out: std_logic_vector(15 downto 0);
	signal alu_x_c, alu_x_z: std_logic;
	signal C_in, Z_in: std_logic;
	signal alu_x_out, alu_x_A: std_logic_vector(15 downto 0);
	
	signal mem_addr_in, mem_data_in, mem_data_out : std_logic_vector(15 downto 0);
	signal rf_d3_in, rf_d1_out, rf_d2_out: std_logic_vector(15 downto 0);
	signal rf_a1_in, rf_a3_in: std_logic_vector(2 downto 0);
	
	signal IR_in, IR_out, TA_in, TA_out, TB_in, TB_out, TC_in, TC_out, PC_in, PC_out, PE_out, R7_in: std_logic_vector(15 downto 0);
	signal se6_outp, se9_outp, LS7_outp, LS1_outp : std_logic_vector(15 downto 0);
	signal TD_in, TD_out: std_logic_vector(2 downto 0);
begin
	IR_in <= mem_data_out;
	IR_outp <= IR_out;
	TB_outp <= TB_out;
	RF_a3 <= rf_a3_in;
	ALU_Y : ALU port map(alu_op =>ALU_OP, inp_a =>alu_y_a, inp_b =>alu_y_b, out_c => C_IN, out_z => Z_IN, alu_out => alu_y_out);
	flag_C: FF1 port map(D => C_in, EN=>C_EN, RST=>RST, CLK=>CLK, Q=>C_flag);
	flag_Z: FF1 port map(D => Z_in, EN=>Z_EN, RST=>RST, CLK=>CLK, Q=>Z_flag);
	flag_TZ: FF1 port map(D => Z_in, EN=>TZ_EN, RST=>RST, CLK=>CLK, Q=>TZ_flag);
	
	ALU_X : ALU port map(alu_op =>"00", inp_a =>alu_x_a, --
								inp_b =>one_16_bit, out_c => alu_x_c, out_z => alu_x_z, alu_out => alu_x_out);
	
	RAM : MEMORY port map(CLK => CLK, WR_Enable => mem_wr_en, RW_Enable => mem_rw_en, ADDR => mem_addr_in, DATA =>mem_data_in, OUTP => mem_data_out);
	
	REGISTER_FILE : REG_FILE port map(CLK => CLK, 
												 RST => RST, 
												 WR_EN => reg_wr_en, 
												 RF_A1 => rf_a1_in, 
												 RF_A2 => IR_out(8 downto 6),
												 RF_A3 => rf_a3_in, 
												 RF_D3 => rf_d3_in, 
												 RF_D1 =>rf_d1_out, 
												 RF_D2=> rf_d2_out,
												 PC_D => PC_in,
												 PC_EN=> PC_EN, 
												 PC_Q=>PC_out 
												 );
	
	IR : FF16 port map(D => mem_data_out, EN=> IR_EN, RST=> RST, CLK=>CLK, Q=>IR_out );
	TB : FF16 port map(D => TB_in,EN=> TB_EN, RST=> RST, CLK=>CLK, Q=>TB_out );
	TA : FF16 port map(D => TA_in,EN=> TA_EN, RST=> RST, CLK=>CLK, Q=>TA_out );
	TC : FF16 port map(D => TC_in,EN=> TC_EN, RST=> RST, CLK=>CLK, Q=>TC_out );
	
	TD : FF3 port map(D => TD_in,EN=> TD_EN, RST=> RST, CLK=>CLK, Q=>TD_out );
	
	PE : PRIORITY_ENC port map(inp => TB_out,outp => PE_out,out_enc =>TD_in);
	
	SE6: SignExt6 port map(inp => IR_out(5 downto 0), outp => se6_outp);
	SE9: SignExt9 port map(inp => IR_out(8 downto 0), outp => se9_outp);
	
	LS1: LShifter1 port map(inp =>TB_out, outp =>LS1_outp);
	LS7: LShifter7 port map(inp =>IR_out(8 downto 0), outp =>LS7_outp);
	
	mux1: mux_4x1_3bit port map(inp_1 => IR_out(11 downto 9),inp_2 =>TD_out, inp_3 =>"111",inp_4=>"000", sel=> rf_a1_mux, outp=>rf_a1_in);
	mux2: mux_4x1_3bit port map(inp_1 => IR_out(8 downto 6),inp_2 =>TD_out, inp_3 =>IR_out(5 downto 3), inp_4=>IR_out(11 downto 9), sel=> rf_a3_mux, outp=>rf_a3_in);
	mux3: mux_4x1_16bit port map(inp_1 =>(others => '0'), inp_2 =>TA_out, inp_3 =>TC_out, inp_4 => LS7_outp, sel=> rf_d3_mux, outp=>rf_d3_in);
	mux4: mux_4x1_16bit port map(inp_1 => (others => '0'), inp_2 => rf_d2_out, inp_3 =>PE_out, inp_4 =>se9_outp, sel=> tb_mux, outp=>TB_in);
	mux5: mux_4x1_16bit port map(inp_1 => mem_data_out,inp_2 =>rf_d1_out, inp_3 =>alu_y_out,inp_4=>alu_x_out, sel=> ta_mux, outp=>TA_in);
	mux6: mux_2x1_16bit port map(inp_1 => rf_d1_out, inp_2 => mem_data_out, outp => TC_in, sel =>tc_mux);
	mux7: mux_4x1_16bit port map(inp_1 => alu_y_out, inp_2 => PC_out, inp_3 => TB_out,inp_4 => (others => '0'),outp => R7_in, sel => R7_mux);
	mux8: mux_4x1_16bit port map(inp_1 => TA_out, inp_2 => PC_out, inp_3 => TB_out, inp_4 => (others =>'0'), outp => mem_addr_in, sel => mem_addr_mux);
	mux9: mux_2x1_16bit port map(inp_1 => TA_out, inp_2 => TC_out, outp => mem_data_in, sel => mem_di_mux);
	mux10: mux_8x1_16bit port map(inp_1 => se6_outp, inp_2 => LS1_outp, inp_3 => se9_outp, inp_4 => TC_out,
	inp_5 => TB_out, inp_6 => (0=>'1', others=>'0'),inp_7 => (others =>'0'),inp_8 => (others =>'0'),outp => alu_y_b, sel => alu_y_b_mux);
	mux11: mux_4x1_16bit port map(inp_1 => (others =>'0') ,inp_2 => TA_out, inp_3 => TB_out, inp_4 => se9_outp,
	outp => alu_y_a, sel => alu_y_a_mux);
	mux12: mux_2x1_16bit port map(inp_1 => TA_out, inp_2 => PC_out, outp => alu_x_a, sel => alu_x_a_mux);
	mux13: mux_8x1_16bit port map(inp_1 => (others =>'0'), inp_2 => TA_out, inp_3 => LS7_outp, inp_4 => TC_out, inp_5 => alu_x_out,
	inp_6 => TB_out, inp_7 => alu_y_out, inp_8 => (others =>'0'), outp => PC_in, sel => PC_mux);
end architecture;