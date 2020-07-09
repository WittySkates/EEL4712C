library ieee;
use ieee.std_logic_1164.all;

entity pixel_clock is
port( 
	clk, rst		:	in 	std_logic;
	pixel_clock	:	out	std_logic);
end pixel_clock; 

architecture bhv of pixel_clock is

	signal toggle	:	std_logic := '0';

begin
	process(clk)
	begin
		if rst = '1' then
			toggle <= '0';
		elsif(rising_edge(clk)) then
			toggle <= not toggle;
		end if;
		pixel_clock <= toggle;
	end process;
end bhv;