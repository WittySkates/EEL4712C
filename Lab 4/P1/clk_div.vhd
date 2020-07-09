library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_div is
    generic(clk_in_freq  : natural := 50;
            clk_out_freq : natural := 10);
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic;
        rst     : in  std_logic);
end clk_div;

architecture bhv of clk_div is

signal hertz : std_logic;
signal max   : natural := (clk_in_freq/clk_out_freq)/2-1;
signal cnt   : integer range 0 to max := 0;

begin
	process(rst, clk_in)
	begin
		if rst = '1' then
			hertz <= '0';
			cnt <= 0;
		elsif rising_edge(clk_in) then
			if cnt = max then
				cnt <= 0;
				hertz <= not hertz;
			else
				cnt <= cnt + 1;
			end if;
		end if;
	end process;
	
	clk_out <= hertz;
	
end bhv;
