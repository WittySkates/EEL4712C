library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
	generic(WIDTH : integer := 8);
	port(
		x			:	in std_logic_vector(WIDTH-1 downto 0);
		y			: 	in std_logic_vector(WIDTH-1 downto 0);
		x_lt_y	:	out std_logic;
		x_ne_y	:	out std_logic);
end entity;

architecture bhv of comparator is
begin
	process(x,y)
	begin
		if(unsigned(x) < unsigned(y)) then
			x_lt_y <='1';
		else
			x_lt_y <='0';
		end if;
		x_ne_y<='1';
		if (unsigned(x) /= unsigned(y)) then
			x_ne_y <='1';
		else
			x_ne_y <='0';
		end if;
	end process;
end bhv;