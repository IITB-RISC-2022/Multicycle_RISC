-- IITB-RISC-2022
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY next_state IS
	PORT (
		curr_state : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		IR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		C_flag : IN STD_LOGIC;
		Z_flag : IN STD_LOGIC;
		TZ_flag : IN STD_LOGIC;
		TB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		RF_a3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		NS : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE beh OF next_state IS

BEGIN
	PROCESS (curr_state, IR, C_flag, Z_flag, TZ_flag, TB, RF_a3)
	BEGIN
		CASE curr_state IS
			WHEN "00001" =>
				IF (IR(15 DOWNTO 12) = "1011") THEN
					NS <= "10111";
				ELSE
					NS <= "00010";
				END IF;
			WHEN "00010" =>
				CASE IR(15 DOWNTO 12) IS
					WHEN "0000" =>
						NS <= "00101";
					WHEN "1110" =>
						NS <= "00101";
					WHEN "0001" =>
						CASE IR(1 DOWNTO 0) IS
							WHEN "00" =>
								NS <= "00011";
							WHEN "01" =>
								IF (Z_flag = '0') THEN
									NS <= "00001";
								ELSE
									NS <= "00011";
								END IF;
							WHEN "10" =>
								IF (C_flag = '0') THEN
									NS <= "00001";
								ELSE
									NS <= "00011";
								END IF;
							WHEN OTHERS =>
								NS <= "00110";
						END CASE;
					WHEN "0010" =>
						CASE(IR(1 DOWNTO 0)) IS
						WHEN "00" =>
							NS <= "00011";
						WHEN "01" =>
							IF (z_flag = '0') THEN
								NS <= "00001";
							ELSE
								NS <= "00011";
							END IF;
						WHEN "10" =>
							IF (c_flag = '0') THEN
								NS <= "00001";
							ELSE
								NS <= "00011";
							END IF;
						WHEN OTHERS =>
							NS <= (OTHERS => '0');
						END CASE;
					WHEN "0011" =>
						NS <= "00111";
					WHEN "0111" =>
						NS <= "01000";
					WHEN "0101" =>
						NS <= "11011";
					WHEN "1100" =>
						NS <= "01100";
					WHEN "1101" =>
						NS <= "01100";
					WHEN "1000" =>
						NS <= "10010";
					WHEN "1001" =>
						NS <= "10100";
					WHEN "1010" =>
						NS <= "10100";
					WHEN OTHERS =>
						NS <= (OTHERS => '0');
				END CASE;
			WHEN "00011" =>
				IF IR(15 DOWNTO 12) = "1011" THEN
					NS <= "11000";
				ELSE
					NS <= "00100";
				END IF;
			WHEN "00100" =>
				NS <= "00001";
			WHEN "00101" =>
				NS <= "11100";
			WHEN "00110" =>
				NS <= "00100";
			WHEN "00111" =>
				NS <= "00001";
			WHEN "01000" =>
				IF IR(15 DOWNTO 12) = "0111" THEN
					NS <= "01001";
				ELSE
					NS <= "00000";
				END IF;
			WHEN "01001" =>
				NS <= "01010";
			WHEN "01010" =>
				NS <= "00001";
			WHEN "01011" =>
				NS <= "00001"; --1
			WHEN "01100" => -- 12
				IF IR(15 DOWNTO 12) = "1100" THEN
					NS <= "01101"; --13
				ELSIF IR(15 DOWNTO 12) = "1101" THEN
					NS <= "01111"; -- 15
				END IF;
			WHEN "01101" => -- 13
				IF IR(15 DOWNTO 12) = "1100" THEN
					NS <= "01110";
				ELSE
					NS <= "00000";
				END IF;
			WHEN "01110" => -- 14
				IF TB = "0000000000000000" THEN
					NS <= "00001";
				ELSE
					NS <= "01101";
				END IF;
			WHEN "01111" => -- 15
				NS <= "10000";
			WHEN "10000" => -- 16
				NS <= "10001";
			WHEN "10001" => -- 16
				IF TB = "0000000000000000" THEN
					NS <= "00001";
				ELSE
					NS <= "01111";
				END IF;
			WHEN "10010" =>
				IF TZ_flag = '1' THEN
					NS <= "10011";
				ELSE
					NS <= "00001";
				END IF;
			WHEN "10011" =>
				NS <= "00001";
			WHEN "10100" =>
				IF IR(15 DOWNTO 12) = "1001" THEN
					NS <= "10101";
				ELSIF IR(15 DOWNTO 12) = "1010" THEN
					NS <= "10110";
				ELSE
					NS <= "00000";
				END IF;
			WHEN "10101" =>
				NS <= "00001";
			WHEN "10110" =>
				NS <= "00001";
			WHEN "10111" =>
				NS <= "00011";
			WHEN "11000" =>
				NS <= "00001";
			WHEN "11011" =>
				NS <= "01011";
			WHEN "11100" =>
				NS <= "00001";
			WHEN OTHERS =>
				NS <= "00001";
		END CASE;
	END PROCESS;
END ARCHITECTURE;