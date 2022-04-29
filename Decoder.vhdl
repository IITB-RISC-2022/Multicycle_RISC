library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemoryDecoder is
    port(
    x: in std_logic_vector(4 downto 0);
    mem_di_mux: out std_logic;
    mem_addr_mux: out std_logic_vector(1 downto 0);
    WR_Enable, RW_Enable: out std_logic
    );
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RFDecoder is
    port(
    x: in std_logic_vector(5 downto 0);
    rf_a1_mux, rf_a3_mux, rf_d3_mux: out std_logic_vector(1 downto 0);
	 reg_wr_en: out std_logic
    );
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AluyDecoder is
    port(
    x: in std_logic_vector(8 downto 0);
    
    alu_y_a_mux: out std_logic_vector(1 downto 0);
    alu_y_b_mux: out std_logic_vector(2 downto 0);
    ALU_OP: out std_logic_vector(1 downto 0);
    C_EN, Z_EN, TZ_EN: out std_logic
	 );
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AluxDecoder is
    port(
    x: in std_logic;
    alu_x_a_mux: out std_logic
	);
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCDecoder is
    port(
    x: in std_logic_vector(2 downto 0);
    PC_mux: out std_logic_vector(2 downto 0);
    PC_EN: out std_logic
	);
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity R7Decoder is
    port(
    x: in std_logic_vector(1 downto 0);
    R7_mux: out std_logic_vector(1 downto 0);
    R7_EN: out std_logic
	);
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TADecoder is
    port(
    x: in std_logic_vector(2 downto 0);
    TA_mux: out std_logic_vector(1 downto 0);
    TA_EN: out std_logic
	);
end entity;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TBDecoder is
    port(
    x: in std_logic_vector(1 downto 0);
	en: in std_logic;
    TB_mux: out std_logic_vector(1 downto 0);
    TB_EN: out std_logic
	);
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TCDecoder is
    port(
    x: in std_logic_vector(1 downto 0);
    TC_mux: out std_logic;
    TC_EN: out std_logic
	);
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TDDecoder is
    port(
    x: in std_logic;
    TD_EN: out std_logic
	);
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IRDecoder is
    port(
    x: in std_logic;
    IR_EN: out std_logic
	);
end entity;

architecture behav of IRDecoder is
begin
    process(x)
    begin
        IR_EN <= x;
    end process;
end architecture;

architecture behav of TDDecoder is
begin
    process(x)
    begin
        TD_EN <= x;
    end process;
end architecture;

architecture behav of TCDecoder is
begin
    process(x)
    begin
        TC_mux <= not x(0);
        TC_EN <= x(0) or x(1);
    end process;
end architecture;

architecture behav of TBDecoder is
begin
    process(x, en)
    begin
        TB_mux <= x;
        TB_EN <= en;
    end process;
end architecture;

architecture behav of TADecoder is
begin
    process(x)
    begin
        case(x) is 
			when "000" =>
				TA_mux <= "00";
                TA_EN <= '0';
			when "001" =>
                TA_mux <= "00";
                TA_EN <= '1';
			when "010" =>
                TA_mux <= "01";
                TA_EN <= '1';
            when "011" =>
                TA_mux <= "10";
                TA_EN <= '1';
            when "100" =>
                TA_mux <= "11";
                TA_EN <= '1';
			when others =>
                TA_mux <= "00";
                TA_EN <= '0';
		end case;	
    end process;
end architecture;

architecture behav of R7Decoder is
begin
    process(x)
    begin
        R7_mux <= x(1 downto 0);
        R7_EN <= (x(0) or x(1) );
    end process;
end architecture;

architecture behav of PCDecoder is
begin
    process(x)
    begin
        PC_mux <= x(2 downto 0);
        PC_EN <= (x(0) or x(1) ) or x(2);
    end process;
end architecture;

architecture behav of AluxDecoder is
begin
    alu_x_a_mux <= x;
end architecture;

architecture behav of AluyDecoder is
    begin
        process(x)
        begin
            alu_y_a_mux <= x(8 downto 7);
            alu_y_b_mux <= x(6 downto 4);
            ALU_OP <= x(3 downto 2);
            C_EN <= ( (not x(1) )and x(0) );
            Z_EN <= x(0);
            TZ_EN <= x(1) and (not x(0));
        end process;
end architecture;

architecture behav of RFDecoder is
    begin
        process(x)
        begin
            rf_a1_mux <= x(5 downto 4);
            rf_a3_mux <= x(3 downto 2);
            rf_d3_mux <= x(1 downto 0);
            reg_wr_en <= x(1) or x(0);
        end process;
end architecture;

architecture behav of MemoryDecoder is
begin
    process(x)
    begin
        mem_di_mux <= x(4);
        mem_addr_mux <= x(3 downto 2);
        WR_Enable <= (x(1) and (not x(0)));
		RW_Enable <= (not x(1)) and x(0);
    end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decoder is
    port(
		cw: in std_logic_vector(35 downto 0);
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
end entity;

architecture behav of Decoder is
	component MemoryDecoder is
		 port(
			x: in std_logic_vector(4 downto 0);
			mem_di_mux: out std_logic;
			mem_addr_mux: out std_logic_vector(1 downto 0);
			WR_Enable: out std_logic;
			RW_Enable: out std_logic
		);
	end component;

	component RFDecoder is
		 port(
		 x: in std_logic_vector(5 downto 0);
		 rf_a1_mux, rf_a3_mux, rf_d3_mux: out std_logic_vector(1 downto 0);
		 reg_wr_en: out std_logic
		 );
	end component;
	
	component AluyDecoder is
		 port(
		 x: in std_logic_vector(8 downto 0);
		 
		 alu_y_a_mux: out std_logic_vector(1 downto 0);
		 alu_y_b_mux: out std_logic_vector(2 downto 0);
		 ALU_OP: out std_logic_vector(1 downto 0);
		 C_EN, Z_EN, TZ_EN: out std_logic
		 );
	end component;
	
	component AluxDecoder is
		 port(
		 x: in std_logic;
		 alu_x_a_mux: out std_logic
		);
	end component;

	component PCDecoder is
		 port(
		 x: in std_logic_vector(2 downto 0);
		 PC_mux: out std_logic_vector(2 downto 0);
		 PC_EN: out std_logic
		);
	end component;
	
	component R7Decoder is
		 port(
		 x: in std_logic_vector(1 downto 0);
		 R7_mux: out std_logic_vector(1 downto 0);
		 R7_EN: out std_logic
		 );
	end component;

	component TADecoder is
		 port(
		 x: in std_logic_vector(2 downto 0);
		 TA_mux: out std_logic_vector(1 downto 0);
		 TA_EN: out std_logic
		);
	end component;
	
	component TBDecoder is
		 port(
		 x: in std_logic_vector(1 downto 0);
		 en: in std_logic;
		 TB_mux: out std_logic_vector(1 downto 0);
		 TB_EN: out std_logic
		);
	end component;
	
	component TCDecoder is
		 port(
		 x: in std_logic_vector(1 downto 0);
		 TC_mux: out std_logic;
		 TC_EN: out std_logic
		);
	end component;

	component TDDecoder is
		 port(
		 x: in std_logic;
		 TD_EN: out std_logic
		);
	end component;

	component IRDecoder is
		 port(
		 x: in std_logic;
		 IR_EN: out std_logic
		);
	end component;
begin
    MD: MemoryDecoder port map(x => cw(34 downto 30), mem_di_mux => mem_di_mux, mem_addr_mux => mem_addr_mux, WR_Enable => WR_Enable, RW_Enable => RW_Enable );
	 RF: RFDecoder port map(x => cw(29 downto 24), rf_a1_mux => rf_a1_mux, rf_a3_mux => rf_a3_mux, rf_d3_mux => rf_d3_mux, reg_wr_en => reg_wr_en);
	 AYD: AluyDecoder port map(x => cw(23 downto 15), alu_y_a_mux => alu_y_a_mux, alu_y_b_mux => alu_y_b_mux, ALU_OP => ALU_OP, C_EN => C_EN, Z_EN => Z_EN, TZ_EN => TZ_EN);
	 AXD: AluxDecoder port map(x => cw(14), alu_x_a_mux => alu_x_a_mux);
	 PCD: PCDecoder port map(x => cw(13 downto 11), PC_EN => PC_EN, PC_mux => PC_mux);
	 R7D: R7Decoder port map(x => cw(10 downto 9), R7_mux => R7_mux, R7_EN => R7_EN);
	 TAD: TADecoder port map(x => cw(8 downto 6),TA_mux => TA_mux, TA_EN => TA_EN);
	 TBD: TBDecoder port map(x => cw(5 downto 4), en => cw(35), TB_mux => TB_mux, TB_EN => TB_EN);
	 TCD: TCDecoder port map(x => cw(3 downto 2),TC_mux => TC_mux, TC_EN => TC_EN);
	 TDD: TDDecoder port map(x => cw(1), TD_EN => TD_EN);
	 IRD: IRDecoder port map(x => cw(0), IR_EN => IR_EN);

end architecture;