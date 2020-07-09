library ieee;
use ieee.std_logic_1164.all;

entity reg is
	generic (WIDTH : positive := 8);
	port (
		 clk	: in  std_logic;
		 rst	: in  std_logic;
		 en	: in	std_logic;
		 d  	: in  std_logic_vector(width-1 downto 0);
		 q 	: out std_logic_vector(width-1 downto 0));
end reg;

architecture bhv of reg is

begin  
	process(clk, rst, en)
	begin   
		if (rst = '1') then
			q <= (others => '0');      
		elsif (rising_edge(clk)) then
			if (en = '1') then
				q <= d;
			else
		end if;     
    end if;    
  end process; 
end bhv;
