library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity next_state is
	port (curr_state: in std_logic_vector(4 downto 0);
			IR: in std_logic_vector(15 downto 0);
			C_flag: in std_logic;
			Z_flag: in std_logic;
			TZ_flag: in std_logic;
			TB: in std_logic_vector(15 downto 0);
			RF_a3: in std_logic_vector(2 downto 0);
			NS: out std_logic_vector(4 downto 0)
			);
end entity;

architecture beh of next_state is

begin
	process(curr_state, IR, C_flag, Z_flag, TZ_flag, TB, RF_a3)
	begin
	case curr_state is
		when "00001" =>
			if(IR(15 downto 12) = "1011") then
				NS <= "10111";
			else
				NS <= "00010";
			end if;
		when "00010" =>
			case IR(15 downto 12) is
				when "0000" =>
					NS <= "00110";
				when "0001" =>
					case IR(1 downto 0) is
						when "00"=>
							NS <= "00011";
						when "01"=>
							if (Z_flag = '0') then
								NS <= "11001";
							else 
								NS <= "00011";
							end if;
						when "10"=>
							if (C_flag = '0') then
								NS <= "11001";
							else 
								NS <= "00011";
							end if;
						when others =>
							NS <= "00110";
					end case;
				when "0010" =>
					case(IR(1 downto 0)) is
						when "00"=>
							NS <= "00011";
						when "01"=>
							if (C_flag = '0') then
							NS <= "11001";
							else 
							NS <= "00011";
							end if;
						when "10"=>
							if (Z_flag = '0') then
							NS <= "11001";
							else 
							NS <= "00011";	
							end if;
						when others=>
							NS <= (others => '0');
					end case;
				when "0011" =>
					NS <= "00111";
				when "0111" =>
					NS <= "01000";
				when "0101" =>
					NS <= "01000";
				when "1100" =>
					NS <= "01100";
				when "1101" =>
					NS <= "01101";
				when "1000" =>
					NS <= "10010";
				when "1001" =>
					NS <= "10100";
				when "1010" =>
					NS <= "10100";
				when others =>
					NS <= (others=>'0');
			end case;
		when "00011" =>
			if IR(15 downto 12) = "1011" then
				NS <= "00001";
			else
				NS <= "00100";
			end if;
		when "00100" =>
			-- if RF_a3 = "111" then
			-- 	NS <= "11000";
			-- else
			-- 	NS <= "11001";
			-- end if;
			NS <= "00001";
		when "00101" =>
			NS <= "00100";
		when "00110" =>
			NS <= "00100";
		when "00111" =>
			if RF_a3 = "111" then
				NS <= "11010"; --26
			else
				NS <= "11001"; --25
			end if;
		when "01000" =>
			if IR(15 downto 12) = "0111" then
				NS <= "01001";
			elsif IR(15 downto 12) = "0101" then
				NS <= "01011";
			else
				NS <= "00000";
			end if;
		when "01001" =>
			NS <= "01010";
		when "01010" =>
			-- if RF_a3 = "111" then
			-- 	NS <= "11000";
			-- else
			-- 	NS <= "11001";	
			-- end if;
			NS <= "00001";
		when "01011" =>
			NS <= "00001"; --1
		when "01100" =>
			NS <= "01101"; --13
		when "01101" =>
			if IR(15 downto 12) = "1100" then
				NS <= "01110";
			elsif IR(15 downto 12) = "1101" then
				NS <= "01111";
			else
				NS <= "00000";
			end if;
		when "01110" =>
			if TB = "0000000000000000" then
				-- if RF_a3 = "111" then
				-- 	NS <= "11000";
				-- else
				-- 	NS <= "11001";
				-- end if;
				NS <= "00001";
			else
				NS <= "01101";
			end if;
		when "01111" =>
			NS <= "10000";
		when "10000" =>
			NS <= "10001";
		when "10001" =>
			if TB = "0000000000000000" then
				NS <= "00001";
			else
				NS <= "01101";
			end if;
		when "10010" =>
			if TZ_flag = '1' then 
				NS <= "10011";
			else
				NS <= "00001";
			end if;
		when "10011" =>
			NS <= "00001";
		when "10100" =>
			if IR(15 downto 12) = "1001" then
				NS <= "10101";
			elsif IR(15 downto 12) = "1010" then
				NS <= "10110";
			else
				NS <= "00000";
			end if;
		when "10101" =>
			NS <= "00001";
		when "10110" =>
			NS <= "00001";
		when "10111" =>
			NS <= "00011";
		when "11000" =>
			NS <= "00001";
		when "11001" =>
			NS <= "00001";
		when "11011" =>
			NS <= "00001";
		when others =>
			NS <= "00001";
	end case;
	end process;
end architecture;