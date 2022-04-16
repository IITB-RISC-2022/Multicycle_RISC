library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  port(alu_op: in std_logic_vector(1 downto 0);
      inp_a: in std_logic_vector(15 downto 0);
      inp_b: in std_logic_vector(15 downto 0);
      out_c: out std_logic;
      out_z: out std_logic;
      alu_out: out std_logic_vector(15 downto 0));
end entity;

architecture behav of ALU is
begin
	process(alu_op, inp_a, inp_b) 
	-- acc_z is a temp var used to calculate whether all bits of temp_out are 0 or not
	variable acc_z : std_logic := '0';
	-- temp_out is a temp variable that stores the output of the ALU
	variable temp_out : std_logic_vector(15 downto 0);
	begin
		
		
		if (alu_op = "00") then
			temp_out := std_logic_vector(unsigned(inp_a) + unsigned(inp_b))(15 downto 0);
			if (unsigned(inp_a) + unsigned(inp_b)) > 2**16-1 then
				out_c <= '1';
			else
				out_c <= '0';
			end if;
		elsif (alu_op = "01") then
			temp_out := inp_a xor inp_b;
			out_c <= '0';
		elsif (alu_op = "10") then
			temp_out := inp_a nand inp_b;
			out_c <= '0';
		elsif (alu_op = "11") then
			temp_out := std_logic_vector(unsigned(inp_a) - unsigned(inp_b))(15 downto 0);
		end if;
		
		for i in 0 to 15 loop
			acc_z := acc_z or temp_out(i);
		end loop;
		acc_z := not acc_z;
		
		alu_out <= temp_out;
		out_z <= acc_z;
		
	
	end process;

end architecture;