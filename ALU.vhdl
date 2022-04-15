library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  port(alu_op: in std_logic_vector(1 downto 0);
      alu_a: in std_logic_vector(15 downto 0);
      alu_b: in std_logic_vector(15 downto 0);
      alu_c: out std_logic;
      alu_z: out std_logic;
      alu_out: out std_logic_vector(15 downto 0));
end entity;

architecture behav of ALU is
begin
	process(alu_op, alu_a, alu_b) 
	variable acc_z : std_logic := '0';
	variable temp_out : std_logic_vector(15 downto 0);
	begin
		
		
		if (alu_op = "00") then
			temp_out := std_logic_vector(unsigned(alu_a) + unsigned(alu_b))(15 downto 0);
			alu_c <= std_logic(std_logic_vector(unsigned(alu_a) + unsigned(alu_b))(16));
		elsif (alu_op = "01") then
			temp_out := alu_a xor alu_b;
			alu_c <= '0';
		elsif (alu_op = "10") then
			temp_out := alu_a nand alu_b;
			alu_c <= '0';
		elsif (alu_op = "11") then
			temp_out := std_logic_vector(unsigned(alu_a) - unsigned(alu_b));
		end if;
		
		for i in 0 to 15 loop
			acc_z := acc_z or temp_out(i);
		end loop;
		acc_z := not acc_z;
		
		alu_out <= temp_out;
		alu_z <= acc_z;
		
	
	end process;

end architecture;