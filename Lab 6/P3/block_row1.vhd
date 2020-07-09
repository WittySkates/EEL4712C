library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity block_row1  is
port (  
	input				: in  std_logic_vector(2 downto 0);
	Vcount      	: in 	std_logic_vector(COUNT_WIDTH-1 downto 0);
	rom_look_row  	: out std_logic_vector(6 downto 0);
	enable			: out std_logic);
end block_row1;

architecture behv of block_row1  is
begin
	process(Vcount, input)
	
		variable temp_count  :  unsigned(COUNT_WIDTH-1 downto 0);
		
   begin
		if (input="001") then --top left
			if unsigned(Vcount) <= TOP_LEFT_Y_END and unsigned(Vcount) >= TOP_LEFT_Y_START then
				temp_count := (unsigned(Vcount) - TOP_LEFT_Y_START);
				enable <='1';
			else 
				temp_count := (others => '0');
				enable <='0';
			end if;
		elsif (input="010") then --top right
			if unsigned(Vcount) <= TOP_RIGHT_Y_END and unsigned(Vcount) >= TOP_RIGHT_Y_START then
				temp_count := (unsigned(Vcount) - TOP_RIGHT_Y_START);
				enable <='1';
			else 
				temp_count := (others => '0');
				enable <='0';
			end if;
		elsif (input="011") then --bottom left
			if unsigned(Vcount) <= BOTTOM_LEFT_Y_END and unsigned(Vcount) >= BOTTOM_LEFT_Y_START then
				temp_count := (unsigned(Vcount) - BOTTOM_LEFT_Y_START);
				enable <='1';
			else 
				temp_count := (others => '0');
				enable <='0';
			end if;
		elsif (input="100") then --bottom right
			if unsigned(Vcount) <= BOTTOM_RIGHT_Y_END and unsigned(Vcount) >= BOTTOM_RIGHT_Y_START then
				temp_count := (unsigned(Vcount) - BOTTOM_RIGHT_Y_START);
				enable <='1';
			else 
				temp_count := (others => '0');
				enable <='0';
			end if;
		else	  						--center
			if unsigned(Vcount) <= CENTERED_Y_END and unsigned(Vcount) >= CENTERED_Y_START then
				temp_count := (unsigned(Vcount) - CENTERED_Y_START);
				enable <='1';
			else 
				temp_count := (others => '0');
				enable <='0';
			end if;	
		end if;
		rom_look_row <= std_logic_vector(temp_count(6 downto 0));
   end process; 
end behv;
