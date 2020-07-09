library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_ns is
generic (
WIDTH : positive := 16
);
port (
	input1 : in std_logic_vector(WIDTH-1 downto 0);
	input2 : in std_logic_vector(WIDTH-1 downto 0);
	sel : in std_logic_vector(3 downto 0);
	output : out std_logic_vector(WIDTH-1 downto 0);
	overflow : out std_logic
);
end alu_ns; 

architecture Behavioral of alu_ns is

begin

process(input1, input2, sel)
variable temp_mul : std_logic_vector(2*width-1 downto 0);
variable temp_add : std_logic_vector(width downto 0);
variable temp_rev : std_logic_vector(width-1 downto 0);
variable temp_swa : std_logic_vector((width/2) - 1 downto 0);

begin
	overflow <= '0';
	
	case sel is
	
		when "0000" =>
			temp_add := std_logic_vector(unsigned("0" & input1) + unsigned("0" & input2));
			overflow <= temp_add(width);
			output <= temp_add(width-1 downto 0);
			
		when "0001" => output <= std_logic_vector(unsigned(input1) - unsigned(input2));
		
		when "0010" =>
			temp_mul := std_logic_vector(unsigned(input1) * unsigned(input2));
			for i in temp_mul'high downto input1'high loop
				if(temp_mul(i) = '1') then
					overflow <= '1';
				end if;
			end loop;
			output <= std_logic_vector(temp_mul(width-1 downto 0));
			
		when "0011" => output <= input1 and input2;
		
		when "0100" => output <= input1 or input2;
		
		when "0101" => output <= input1 xor input2;
		
		when "0110" => output <= input1 nor input2;
		
		when "0111" => output <= not(input1);
		
		when "1000" =>
			overflow <= input1(input1'high);
			output <= input1(input1'high - 1 downto input1'low) & "0";
		
		when "1001" => 
			output <= "0" & input1(input1'high downto input1'low + 1);
			
		when "1010" =>
			temp_swa := input1(width/2 - 1 downto input1'low);
			output <= temp_swa & input1(input1'high downto width/2);
			
		when "1011" => 
			for i in input1'high downto input1'low loop
				temp_rev(temp_rev'left - i) := input1(i);
			end loop;
			output <= temp_rev;
		
		when "1100" => output <= (others => '0');
		when "1101" => output <= (others => '0');
		when "1110" => output <= (others => '0');
		when "1111" => output <= (others => '0');
		when others => NULL;

	end case;
end process;
end Behavioral;
		
		
	

