library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DATAPATH is
	port(
	CLK, RST :in std_logic;
	ALU_OP : in std_logic_vector(1 downto 0);
	IR_EN, TA_EN, TB_EN, TC_EN, PC_EN, C_EN, Z_EN, TZ_EN, TD_EN : in std_logic;
	R7_sel, REG_WR_EN, mem_wr_en : in std_logic;
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
	TD_outp: out std_logic_vector(2 downto 0);
	IR_outp: out std_logic_vector(15 downto 0);
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
			  WR_EN, r7_sel : in std_logic;
			  RF_A1 : in std_logic_vector(2 downto 0);
			  RF_A2 : in std_logic_vector(2 downto 0);
			  RF_A3 : in std_logic_vector(2 downto 0);
			  RF_D3 : in std_logic_vector(15 downto 0);
			  R7_IN : in std_logic_vector(15 downto 0);
			  RF_D1 : out std_logic_vector(15 downto 0);
			  RF_D2 : out std_logic_vector(15 downto 0));
	end component;
	
	component MEMORY is
		port(CLK, WR_Enable: in std_logic;
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
	IR_outp <= IR_out;
	TB_outp <= TB_out;
	TD_outp <= TD_out;
	ALU_Y : ALU port map(alu_op =>ALU_OP, inp_a =>alu_y_a, inp_b =>alu_y_b, out_c => C_IN, out_z => Z_IN, alu_out => alu_y_out);
	flag_C: FF1 port map(D => C_in, EN=>C_EN, RST=>RST, CLK=>CLK, Q=>C_flag);
	flag_Z: FF1 port map(D => Z_in, EN=>Z_EN, RST=>RST, CLK=>CLK, Q=>Z_flag);
	flag_TZ: FF1 port map(D => Z_in, EN=>TZ_EN, RST=>RST, CLK=>CLK, Q=>TZ_flag);
	
	ALU_X : ALU port map(alu_op =>"01", inp_a =>alu_x_a, --
								inp_b =>one_16_bit, out_c => alu_x_c, out_z => alu_x_z, alu_out => alu_x_out);
	
	RAM : MEMORY port map(CLK => CLK, WR_Enable => mem_wr_en, ADDR => mem_addr_in, DATA =>mem_data_in, OUTP => mem_data_out);
	
	REGISTER_FILE : REG_FILE port map(CLK => CLK, 
												 RST => RST, 
												 WR_EN => reg_wr_en, 
												 r7_sel => r7_sel, 
												 RF_A1 => rf_a1_in, 
												 RF_A2 => IR_out(8 downto 6), --
												 RF_A3 => rf_a3_in, 
												 RF_D3 => rf_d3_in, 
												 R7_IN => R7_IN,
												 RF_D1 =>rf_d1_out, 
												 RF_D2=> rf_d2_out);
	
	IR : FF16 port map(D => mem_data_out, EN=> IR_EN, RST=> RST, CLK=>CLK, Q=>IR_out );
	TB : FF16 port map(D => TB_in,EN=> TB_EN, RST=> RST, CLK=>CLK, Q=>TB_out );
	TA : FF16 port map(D => TA_in,EN=> TA_EN, RST=> RST, CLK=>CLK, Q=>TA_out );
	TC : FF16 port map(D => TC_in,EN=> TC_EN, RST=> RST, CLK=>CLK, Q=>TC_out );
	PC : FF16 port map(D => PC_in,EN=> PC_EN, RST=> RST, CLK=>CLK, Q=>PC_out );
	
	TD : FF3 port map(D => TD_in,EN=> TD_EN, RST=> RST, CLK=>CLK, Q=>TD_out );
	
	PE : PRIORITY_ENC port map(inp => TB_out,outp => PE_out,out_enc =>TD_in);
	
	SE6: SignExt6 port map(inp => IR_out(5 downto 0), outp => se6_outp);
	SE9: SignExt9 port map(inp => IR_out(8 downto 0), outp => se9_outp);
	
	LS1: LShifter1 port map(inp =>TB_out, outp =>LS1_outp);
	LS7: LShifter7 port map(inp =>IR_out(8 downto 0), outp =>LS7_outp);
	
	process(
	CLK, 
	ALU_OP,
	IR_EN, TA_EN, TB_EN, TC_EN, PC_EN, C_EN, Z_EN, TD_EN,
	R7_sel, REG_WR_EN, mem_wr_en,
	rf_a1_mux, rf_a3_mux, rf_d3_mux, 
	ta_mux, tb_mux, tc_mux,
	r7_mux, mem_addr_mux, mem_di_mux,
	alu_y_a_mux, alu_y_b_mux, alu_x_a_mux,
	PC_mux
	-- CONTROL BITS !
	)
	
	begin
		case(rf_a1_mux) is 
			when "00" =>
				rf_a1_in <= IR_out(11 downto 9); --
			when "01" =>
				rf_a1_in <= TD_out; --
			when "10" =>
				rf_a1_in <= "111";
			when others =>
				rf_a1_in <= "000";
		end case;
				
				
		case(rf_a3_mux) is 
			when "00" =>
				rf_a3_in <= IR_out(8 downto 6); --
			when "01" =>
				rf_a3_in <= TD_out; --
			when "10" =>
				rf_a3_in <= IR_out(11 downto 9); --
			when others =>
				rf_a3_in <= IR_out(5 downto 3); --
		end case;
		
		case(rf_d3_mux) is 
			when "00" =>
				rf_d3_in <= LS7_outp; --
			when "01" =>
				rf_d3_in <= TA_out; --
			when "10" =>
				rf_d3_in <= TC_out; --
			when others =>
				rf_d3_in <= (others => '0');
		end case;

		case(tb_mux) is 
			when "00" =>
				TB_in <= PE_out; --
			when "01" =>
				TB_in <= se9_outp; --
			when "10" =>
				TB_in <= rf_d2_out; --
			when others =>
				TB_in <= (others => '0');
		end case;		
			
		case(ta_mux) is 
			when "00" =>
				TA_in <= mem_data_out; --
			when "01" =>
				TA_in <= alu_y_out; --
			when "10" =>
				TA_in <= rf_d1_out; --
			when others =>
				TA_in <= alu_x_out;
		end case;	
		
		case(tc_mux) is 
			when '0' =>
				TC_in <= mem_data_out; --
			when '1' =>
				TC_in <= rf_d1_out; --
		end case;	
		
		case(R7_mux) is 
			when "00" =>
				R7_in <= alu_y_out; --
			when "01" =>
				R7_in <= PC_out;  --
			when "10" =>
				R7_in <= TB_out; --
			when others =>
				R7_in <= (others => '0');
		end case;	
		
		case(mem_addr_mux) is 
			when "00" =>
				mem_addr_in <= TA_out; --
			when "01" =>
				mem_addr_in <= PC_out; --
			when "10" =>
				mem_addr_in <= TB_out; --
			when others =>
				mem_addr_in <= (others =>'0');
		end case;
				
		case(mem_di_mux) is 
			when '0' =>
				mem_data_in <= TA_out; -- 
			when '1' =>
				mem_data_in <= TC_out; --
		end case;	
		
		case(alu_y_b_mux) is
			when "000" =>
				alu_y_b <= LS1_outp; --
			when "001" =>
				alu_y_b <= se6_outp; --
			when "010" =>
				alu_y_b <= se9_outp; --
			when "011" =>
				alu_y_b <= TB_out; --
			when "100" =>
				alu_y_b <= TC_out; --
			when others =>
				alu_y_b <= (others=>'0');
		end case;
		
		case(alu_y_a_mux) is
		when "00" =>
				alu_y_a <= PC_out;
			when "01" =>
				alu_y_a <= TA_out; --
			when "10" =>
				alu_y_a <= TB_out; --
			when "11" =>
				alu_y_a <= se9_outp; --
			when others =>
				alu_y_a <= (others=>'0');
		end case; 

		case(alu_x_a_mux) is
			when '0' =>
				alu_x_a <= PC_out;
			when '1' =>
				alu_x_a <= TA_out;
			when others =>
				alu_x_a <= (others => '0');
		end case; 
		
		case(PC_mux) is
			when "000" =>
				PC_in <= alu_y_out; --
			when "001" =>
				PC_in <= alu_x_out; --
			when "010" =>
				PC_in <= TA_out; --
			when "011" =>
				PC_in <= TB_out; --
			when "100" =>
				PC_in <= TC_out; --
			when "101" =>
				PC_in <= LS7_outp; --
			when others =>
				PC_in <= (others=>'0');
		end case;
	end process;
	
	
	
end architecture;