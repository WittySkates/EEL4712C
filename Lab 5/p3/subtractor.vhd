library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor is
	generic(WIDTH	:	integer :=8);
	port(
		a		:	in	 std_logic_vector(WIDTH-1 downto 0);
		b 		:	in   std_logic_vector(WIDTH-1 downto 0);
		sub	: 	out	 std_logic_vector(WIDTH-1 downto 0));
end entity;	

architecture bhv of subtractor is
begin
	sub <= std_logic_vector(unsigned(a) - unsigned(b));
end bhv;