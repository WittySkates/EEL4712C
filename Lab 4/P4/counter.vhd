library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        up_n   : in  std_logic;         -- active low
        load_n : in  std_logic;         -- active low
        input  : in  std_logic_vector(3 downto 0);
        output : out std_logic_vector(3 downto 0));
end counter;

architecture bhv of counter is
begin
	process(clk, rst)
	variable cnt : std_logic_vector(3 downto 0);
	begin
		if rst = '1' then
			cnt := "0000";
		elsif rising_edge(clk) then
			if load_n = '0' then
				cnt := input;
			elsif up_n = '0' then
				cnt := std_logic_vector(unsigned(cnt) + 1);
			else
				cnt := std_logic_vector(unsigned(cnt) - 1);
			end if;
		end if;
		output <= cnt;
	end process;
end bhv;