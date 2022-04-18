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
			next_state: out std_logic_vector(4 downto 0)
			);
end entity;

architecture beh of next_state is

begin
	process(curr_state, IR, C_flag, Z_flag, TZ_flag, TB, RF_a3)
	begin
	case curr_state is
		when "00001" =>
			if(IR(15 downto 12) = "1011") then
				next_state <= "10111";
			else
				next_state <= "00010";
			end if;
		when "00010" =>
			case IR(15 downto 12) is
				when "0000" =>
					next_state <= "00110";
				when "0001" =>
					case(IR(1 downto 0)) is
						when "00"=>
							next_state <= "00011";
						when "01"=>
							if (C_flag = '0') then
							next_state <= "11001";
							else 
							next_state <= "00011";
							end if;
						when "10"=>
							if (Z_flag = '0') then
							next_state <= "11001";
							else 
							next_state <= "00011";
							end if;
						when "11"=>
							next_state <= "00101";
					end case;
				when "0010" =>
					case(IR(1 downto 0)) is
						when "00"=>
							next_state <= "00011";
						when "01"=>
							if (C_flag = '0') then
							next_state <= "11001";
							else 
							next_state <= "00011";
							end if;
						when "10"=>
							if (Z_flag = '0') then
							next_state <= "11001";
							else 
							next_state <= "00011";	
							end if;
						when others=>
							next_state <= (others => '0');
					end case;
				when "0011" =>
					next_state <= "00111";
				when "0111" =>
					next_state <= "01000";
				when "0101" =>
					next_state <= "01000";
				when "1100" =>
					next_state <= "01100";
				when "1101" =>
					next_state <= "01101";
				when "1000" =>
					next_state <= "10010";
				when "1001" =>
					next_state <= "10100";
				when "1010" =>
					next_state <= "10100";
				when others =>
					next_state <= (others=>'0');
			end case;
		when "00011" =>
			if IR(15 downto 12) = "1011" then
				next_state <= "00001";
			else
				next_state <= "00100";
			end if;
		when "00100" =>
			if RF_a3 = "111" then
				next_state <= "11000";
			else
				next_state <= "11001";
			end if;
		when "00101" =>
			next_state <= "00100";
		when "00110" =>
			next_state <= "00100";
		when "00111" =>
			if RF_a3 = "111" then
				next_state <= "11010"; --26
			else
				next_state <= "11001"; --25
			end if;
		when "01000" =>
			if IR(15 downto 12) = "0111" then
				next_state <= "01001";
			elsif IR(15 downto 12) = "0101" then
				next_state <= "01011";
			else
				next_state <= "00000";
			end if;
		when "01001" =>
			next_state <= "01011";
		when "01010" =>
			if RF_a3 = "111" then
				next_state <= "11000";
			else
				next_state <= "11001";	
			end if;
		when "01011" =>
			next_state <= "00001"; --1
		when "01100" =>
			next_state <= "01101"; --13
		when "01101" =>
			if IR(15 downto 12) = "1100" then
				next_state <= "01110";
			elsif IR(15 downto 12) = "1101" then
				next_state <= "01111";
			else
				next_state <= "00000";
			end if;
		when "01110" =>
			if TB = "0000000000000000" then
				if RF_a3 = "111" then
					next_state <= "11000";
				else
					next_state <= "11001";
				end if;
			else
				next_state <= "01101";
			end if;
		when "01111" =>
			next_state <= "10000";
		when "10000" =>
			next_state <= "10001";
		when "10001" =>
			if TB = "0000000000000000" then
				next_state <= "00001";
			else
				next_state <= "01101";
			end if;
		when "10010" =>
			if TZ_flag = '1' then 
				next_state <= "10011";
			else
				next_state <= "00001";
			end if;
		when "10011" =>
			next_state <= "00001";
		when "10100" =>
			if IR(15 downto 12) = "1001" then
				next_state <= "10101";
			elsif IR(15 downto 12) = "1010" then
				next_state <= "10110";
			else
				next_state <= "00000";
			end if;
		when "10101" =>
			next_state <= "00001";
		when "10110" =>
			next_state <= "00001";
		when "10111" =>
			next_state <= "00011";
		when "11000" =>
			next_state <= "00001";
		when "11001" =>
			next_state <= "00001";
		when "11011" =>
			next_state <= "00001";
		when others =>
			next_state <= "00000";
	end case;
	end process;
end architecture;