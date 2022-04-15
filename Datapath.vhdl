library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DATA_PATH is
	port(
	CLK, RST :in std_logic;
	
	);
end entity DATA_PATH;


architecture Complicated of DATA_PATH is
	component FF16 is
		port(D: in std_logic_vector(15 downto 0);
			  EN: in std_logic;
			  RST: in std_logic;
			  CLK: in std_logic;
			  Q: out std_logic_vector(15 downto 0));
	end component FF16;
	
	component FF3 is
		port(D: in std_logic_vector(2 downto 0);
			  EN: in std_logic;
			  RST: in std_logic;
			  CLK: in std_logic;
			  Q: out std_logic_vector(2 downto 0));
	end component FF3;	
	
	component FF1 is
		port(D: in std_logic;
			  EN: in std_logic;
			  RST: in std_logic;
			  CLK: in std_logic;
			  Q: out std_logic);
	end component FF1;
	
	component REG_FILE is
		port(CLK, RST : in std_logic;
			  RF_A1 : in std_logic_vector(15 downto 0);
			  RF_A2 : in std_logic_vector(15 downto 0);
			  RF_A3 : in std_logic_vector(15 downto 0);
			  RF_D3 : in std_logic_vector(15 downto 0);
			  RF_D1 : out std_logic_vector(15 downto 0);
			  RF_D2 : out std_logic_vector(15 downto 0));
	end component REG_FILE;
	
	component MEMORY is
		port(CLK: in std_logic;
			  ADDR: in std_logic_vector(15 downto 0);
			  DATA: in std_logic_vector(15 downto 0);
			  OUTP: out std_logic_vector(15 downto 0));
	end component MEMORY;
	
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
		out_enc: out std_logic_vector(2 downto 0);
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
	
	signal one_16_bit: std_logic_vector(15 downto 0) := "0000000000000001";
	signal alu_y_c, alu_y_z: std_logic;
	signal alu_y_a, alu_y_b, alu_y_out: std_logic_vector(15 downto 0);
	signal alu_x_c, alu_x_z: std_logic;
	signal alu_x_a, alu_x_out: std_logic_vector(15 downto 0);
	
	signal mem_addr_in, mem_data_in, mem_outp : std_logic_vector(15 downto 0);
	signal rf_a1_in, rf_a2_in, rf_a3_in, rf_d3_in, rf_d1_out, rf_d2_out: std_logic_vector(15 downto 0);
begin
	
	ALU_Y : ALU port map(alu_op =>, inp_a =>alu_y_a, inp_b =>alu_y_b, out_c => alu_y_c, out_z => alu_y_z, alu_out => alu_y_out);
	ALU_X : ALU port map(alu_op =>, inp_a =>alu_x_a, inp_b =>one_16_bit, out_c => alu_x_c, out_z => alu_x_z, alu_out => alu_x_out);
	
	RAM : MEMORY port map(CLK => CLK, ADDR => mem_addr_in, DATA =>mem_data_in, OUTP => mem_outp);
	
	REGISTER_FILE : REG_FILE port map(CLK => CLK, RST => RST, RF_A1 => rf_a1_in, RF_A2 => rf_a2_in, RF_A3 => rf_a3_in, RF_D3 => rf_d3_in, RF_D1 =>rf_d1_out, RF_D2=> rf_d2_out);
	
	IR : FF16 port map(D => IR_in,EN=> IR_EN, RST=> RST, CLK=>CLK, Q=>IR_out );
	TB : FF16 port map(D => TB_in,EN=> TB_EN, RST=> RST, CLK=>CLK, Q=>TB_out );
	TA : FF16 port map(D => TA_in,EN=> TA_EN, RST=> RST, CLK=>CLK, Q=>TA_out );
	TC : FF16 port map(D => TC_in,EN=> TC_EN, RST=> RST, CLK=>CLK, Q=>TC_out );
	PC : FF16 port map(D => PC_in,EN=> PC_EN, RST=> RST, CLK=>CLK, Q=>PC_out );
	
	TD : FF3 port map(D => TD_in,EN=> TD_EN, RST=> RST, CLK=>CLK, Q=>TD_out );
	
	PE : PRIORITY_ENC port map(inp => pe_in,outp => pe_out,out_enc =>pe_out_enc);
	
	SE6: SignExt6 port map(inp => se6_inp, outp => se6_outp);
	SE9: SignExt9 port map(inp => se9_inp, outp => se9_outp);
	
	LS1: LShifter1 port map(inp =>LS1_inp, outp =>LS1_outp);
	LS7: LShifter7 port map(inp =>LS7_inp, outp =>LS7_outp);
	
end architecture;