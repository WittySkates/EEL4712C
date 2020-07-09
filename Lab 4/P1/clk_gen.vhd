library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_gen is
    generic (
        ms_period : positive);          -- amount of ms for button to be
                                        -- pressed before creating clock pulse
    port (
        clk50MHz : in  std_logic;
        rst      : in  std_logic;
        button_n : in  std_logic;
        clk_out  : out std_logic);
end clk_gen;

architecture bhv of clk_gen is

signal in1  : std_logic;
signal out1 : std_logic;
signal cnt  : integer range 0 to ms_period := 0;

begin
	U_CD: entity work.clk_div
		generic map(
		clk_in_freq => 50000000,
		clk_out_freq => 1000)
		port map(
		clk_in => clk50MHz,
		rst => rst,
		clk_out => in1
		);	
	process(rst, in1)
	begin
		if rst = '1' then
			cnt <= 0;
			out1 <= '0';
		elsif rising_edge(in1) then
			if button_n = '0' then
				if cnt = ms_period then
					out1 <= '1';
					cnt <= 1;
				else 
					cnt <= cnt + 1;
					out1 <= '0';
				end if;
			else
				cnt <= 0;
				out1 <= '0';
			end if;
		end if;
	end process;
	clk_out <= out1;
end bhv;
	