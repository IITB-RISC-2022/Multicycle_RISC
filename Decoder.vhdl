-- IITB-RISC-2022
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MemoryDecoder IS
	PORT (
		x : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		mem_di_mux : OUT STD_LOGIC;
		mem_addr_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		WR_Enable, RW_Enable : OUT STD_LOGIC
	);
END ENTITY;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RFDecoder IS
	PORT (
		x : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		rf_a1_mux, rf_a3_mux, rf_d3_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		reg_wr_en : OUT STD_LOGIC
	);
END ENTITY;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY AluyDecoder IS
	PORT (
		x : IN STD_LOGIC_VECTOR(8 DOWNTO 0);

		alu_y_a_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		alu_y_b_mux : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		ALU_OP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		C_EN, Z_EN, TZ_EN : OUT STD_LOGIC
	);
END ENTITY;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY AluxDecoder IS
	PORT (
		x : IN STD_LOGIC;
		alu_x_a_mux : OUT STD_LOGIC
	);
END ENTITY;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PCDecoder IS
	PORT (
		x : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		PC_mux : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		PC_EN : OUT STD_LOGIC
	);
END ENTITY;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TADecoder IS
	PORT (
		x : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		TA_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		TA_EN : OUT STD_LOGIC
	);
END ENTITY;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TBDecoder IS
	PORT (
		x : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		en : IN STD_LOGIC;
		TB_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		TB_EN : OUT STD_LOGIC
	);
END ENTITY;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TCDecoder IS
	PORT (
		x : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		TC_mux : OUT STD_LOGIC;
		TC_EN : OUT STD_LOGIC
	);
END ENTITY;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TDDecoder IS
	PORT (
		x : IN STD_LOGIC;
		TD_EN : OUT STD_LOGIC
	);
END ENTITY;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY IRDecoder IS
	PORT (
		x : IN STD_LOGIC;
		IR_EN : OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE behav OF IRDecoder IS
BEGIN
	PROCESS (x)
	BEGIN
		IR_EN <= x;
	END PROCESS;
END ARCHITECTURE;

ARCHITECTURE behav OF TDDecoder IS
BEGIN
	PROCESS (x)
	BEGIN
		TD_EN <= x;
	END PROCESS;
END ARCHITECTURE;

ARCHITECTURE behav OF TCDecoder IS
BEGIN
	PROCESS (x)
	BEGIN
		TC_mux <= NOT x(0);
		TC_EN <= x(0) OR x(1);
	END PROCESS;
END ARCHITECTURE;

ARCHITECTURE behav OF TBDecoder IS
BEGIN
	PROCESS (x, en)
	BEGIN
		TB_mux <= x;
		TB_EN <= en;
	END PROCESS;
END ARCHITECTURE;

ARCHITECTURE behav OF TADecoder IS
BEGIN
	PROCESS (x)
	BEGIN
		CASE(x) IS
			WHEN "000" =>
			TA_mux <= "00";
			TA_EN <= '0';
			WHEN "001" =>
			TA_mux <= "00";
			TA_EN <= '1';
			WHEN "010" =>
			TA_mux <= "01";
			TA_EN <= '1';
			WHEN "011" =>
			TA_mux <= "10";
			TA_EN <= '1';
			WHEN "100" =>
			TA_mux <= "11";
			TA_EN <= '1';
			WHEN OTHERS =>
			TA_mux <= "00";
			TA_EN <= '0';
		END CASE;
	END PROCESS;
END ARCHITECTURE;

ARCHITECTURE behav OF PCDecoder IS
BEGIN
	PROCESS (x)
	BEGIN
		PC_mux <= x(2 DOWNTO 0);
		PC_EN <= (x(0) OR x(1)) OR x(2);
	END PROCESS;
END ARCHITECTURE;

ARCHITECTURE behav OF AluxDecoder IS
BEGIN
	alu_x_a_mux <= x;
END ARCHITECTURE;

ARCHITECTURE behav OF AluyDecoder IS
BEGIN
	PROCESS (x)
	BEGIN
		alu_y_a_mux <= x(8 DOWNTO 7);
		alu_y_b_mux <= x(6 DOWNTO 4);
		ALU_OP <= x(3 DOWNTO 2);
		C_EN <= ((NOT x(1))AND x(0));
		Z_EN <= x(0);
		TZ_EN <= x(1) AND (NOT x(0));
	END PROCESS;
END ARCHITECTURE;

ARCHITECTURE behav OF RFDecoder IS
BEGIN
	PROCESS (x)
	BEGIN
		rf_a1_mux <= x(5 DOWNTO 4);
		rf_a3_mux <= x(3 DOWNTO 2);
		rf_d3_mux <= x(1 DOWNTO 0);
		reg_wr_en <= x(1) OR x(0);
	END PROCESS;
END ARCHITECTURE;

ARCHITECTURE behav OF MemoryDecoder IS
BEGIN
	PROCESS (x)
	BEGIN
		mem_di_mux <= x(4);
		mem_addr_mux <= x(3 DOWNTO 2);
		WR_Enable <= (x(1) AND (NOT x(0)));
		RW_Enable <= (NOT x(1)) AND x(0);
	END PROCESS;
END ARCHITECTURE;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Decoder IS
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
END ENTITY;

ARCHITECTURE behav OF Decoder IS
	COMPONENT MemoryDecoder IS
		PORT (
			x : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			mem_di_mux : OUT STD_LOGIC;
			mem_addr_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			WR_Enable : OUT STD_LOGIC;
			RW_Enable : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT RFDecoder IS
		PORT (
			x : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			rf_a1_mux, rf_a3_mux, rf_d3_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			reg_wr_en : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT AluyDecoder IS
		PORT (
			x : IN STD_LOGIC_VECTOR(8 DOWNTO 0);

			alu_y_a_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			alu_y_b_mux : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			ALU_OP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			C_EN, Z_EN, TZ_EN : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT AluxDecoder IS
		PORT (
			x : IN STD_LOGIC;
			alu_x_a_mux : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT PCDecoder IS
		PORT (
			x : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			PC_mux : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			PC_EN : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT TADecoder IS
		PORT (
			x : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			TA_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			TA_EN : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT TBDecoder IS
		PORT (
			x : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			en : IN STD_LOGIC;
			TB_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			TB_EN : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT TCDecoder IS
		PORT (
			x : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			TC_mux : OUT STD_LOGIC;
			TC_EN : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT TDDecoder IS
		PORT (
			x : IN STD_LOGIC;
			TD_EN : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT IRDecoder IS
		PORT (
			x : IN STD_LOGIC;
			IR_EN : OUT STD_LOGIC
		);
	END COMPONENT;
BEGIN
	MD : MemoryDecoder PORT MAP(x => cw(32 DOWNTO 28), mem_di_mux => mem_di_mux, mem_addr_mux => mem_addr_mux, WR_Enable => WR_Enable, RW_Enable => RW_Enable);
	RF : RFDecoder PORT MAP(x => cw(27 DOWNTO 22), rf_a1_mux => rf_a1_mux, rf_a3_mux => rf_a3_mux, rf_d3_mux => rf_d3_mux, reg_wr_en => reg_wr_en);
	AYD : AluyDecoder PORT MAP(x => cw(21 DOWNTO 13), alu_y_a_mux => alu_y_a_mux, alu_y_b_mux => alu_y_b_mux, ALU_OP => ALU_OP, C_EN => C_EN, Z_EN => Z_EN, TZ_EN => TZ_EN);
	AXD : AluxDecoder PORT MAP(x => cw(12), alu_x_a_mux => alu_x_a_mux);
	PCD : PCDecoder PORT MAP(x => cw(11 DOWNTO 9), PC_EN => PC_EN, PC_mux => PC_mux);
	TAD : TADecoder PORT MAP(x => cw(8 DOWNTO 6), TA_mux => TA_mux, TA_EN => TA_EN);
	TBD : TBDecoder PORT MAP(x => cw(5 DOWNTO 4), en => cw(33), TB_mux => TB_mux, TB_EN => TB_EN);
	TCD : TCDecoder PORT MAP(x => cw(3 DOWNTO 2), TC_mux => TC_mux, TC_EN => TC_EN);
	TDD : TDDecoder PORT MAP(x => cw(1), TD_EN => TD_EN);
	IRD : IRDecoder PORT MAP(x => cw(0), IR_EN => IR_EN);

END ARCHITECTURE;