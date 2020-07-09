library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity block_column1 is
port ( 
	input			 	: in  std_logic_vector(2 downto 0);
	Hcount       	: in  std_logic_vector(COUNT_WIDTH-1 downto 0);
	rom_look_column: out std_logic_vector(6 downto 0);
	enable		 	: out std_logic);
end block_column1;

architecture behv of block_column1  is
begin
	process(Hcount, input)
	
		variable temp_count	:	unsigned(COUNT_WIDTH-1 downto 0);
		
   begin
		if (input="001") then --top left
			if unsigned(Hcount) <= TOP_LEFT_X_END and unsigned(Hcount) >= TOP_LEFT_X_START then
				temp_count := (unsigned(Hcount) - TOP_LEFT_X_START);
				enable <='1';
			else 
				temp_count := (others => '0');
				enable <='0';
			end if;
		elsif (input="010") then --top right
			if unsigned(Hcount) <= TOP_RIGHT_X_END and unsigned(Hcount) >= TOP_RIGHT_X_START then
				temp_count := (unsigned(Hcount) - TOP_RIGHT_X_START);
				enable <='1';
			else 
				temp_count := (others => '0');
				enable <='0';
			end if;
		elsif (input="011") then --bottom left
			if unsigned(Hcount) <= BOTTOM_LEFT_X_END and unsigned(Hcount) >= BOTTOM_LEFT_X_START then
				temp_count := (unsigned(Hcount) - BOTTOM_LEFT_X_START);
				enable <='1';
			else 
				temp_count := (others => '0');
				enable <='0';
			end if;
		elsif (input="100") then --bottom right
			if unsigned(Hcount) <= BOTTOM_RIGHT_X_END and unsigned(Hcount) >= BOTTOM_RIGHT_X_START then
				temp_count := (unsigned(Hcount) - BOTTOM_RIGHT_X_START);
				enable <='1';
			else 
				temp_count := (others => '0');
				enable <='0';
			end if;
		else							--center
			if unsigned(Hcount) <= CENTERED_X_END and unsigned(Hcount) >= CENTERED_X_START then
				temp_count := (unsigned(Hcount) - CENTERED_X_START);
				enable <='1';
			else 
				temp_count := (others => '0');
				enable <='0';
			end if;	
		end if;
		rom_look_column <= std_logic_vector(temp_count(6 downto 0));
   end process; 
end behv;