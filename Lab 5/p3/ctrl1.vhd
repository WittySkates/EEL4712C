library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrl1 is
	generic (WIDTH : integer := 8);
	port (
		x_sel,y_sel	: out	std_logic;
		x_en,y_en   : out	std_logic;
		output_en  	: out	std_logic;
		done   		: out std_logic;
		clk			: in  std_logic;
		x_lt_y	   : in	std_logic;
		x_ne_y	   : in  std_logic;
		go    		: in  std_logic);
end ctrl1; 



architecture STR of ctrl1 is  

type state_type is (state1,state2,state3,state4,state5,state6,state7);
signal state : state_type;

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if go = '0' then
				state <= state1; 
			else
				case state is
					when state1 => 
						state <= state5; 
					when state5|state2|state3 =>
						state <= state7; 
					when state4 =>	
						state <= state6;
					when state7 =>	
						if (x_ne_y = '1' and x_lt_y = '1') then 
							state <= state2;
						elsif (x_ne_y = '1' and x_lt_y = '0') then 
							state <= state3;
						elsif (x_ne_y = '0') then 
							state <= state4;
						end if;
					 when others => 
						state <= state6;
				end case;
			end if;
		end if;
	end process;
	
	process(state)
	begin
		case state is 
			when state5 => 
				output_en <= '0';
				done <= '0';
				x_en <= '1';
				y_en <= '1';
				x_sel <= '0';
				y_sel <= '0';
			when state2 => 
				output_en <= '0';
				done <= '0';
				x_en <= '0';
				y_en <= '1';
				y_sel <= '1';
			when state3 => 
				output_en <= '0';
				done <= '0';
				y_en <= '0';
				x_en <= '1';
				x_sel <= '1';
			when state4 =>
				output_en <= '1';
				done <= '0';
				x_en <= '0';
				y_en <= '0';
			when state6 => 
				done <= '1';
			when others =>
				done <= '0';
				x_en <= '0';
				y_en <= '0';
				output_en <= '0';
		end case;
	end process;
end STR;

