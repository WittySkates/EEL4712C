library ieee;
use ieee.std_logic_1164.all;

entity gray1 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        output : out std_logic_vector(3 downto 0));
end gray1;

architecture bhv of gray1 is
type state_outs is (	state_0, state_1, state_2, state_3, 
								state_4, state_5, state_6, state_7, 
								state_8, state_9, state_A, state_B,
								state_C, state_D, state_E, state_F
								);
signal state_current : state_outs;

begin
	process(clk, rst)
	begin
		if rst = '1' then
			state_current <= state_0;
		elsif rising_edge(clk) then
			case state_current is
			
				when state_0 =>
					output <= "0000";
					state_current <= state_1;
					
				when state_1 =>
					output <= "0001";
					state_current <= state_3;
					
				when state_2 =>
					output <= "0010";
					state_current <= state_6;
					
				when state_3 =>
					output <= "0011";
					state_current <= state_2;
					
				when state_4 =>
					output <= "0100";
					state_current <= state_C;
					
				when state_5 =>
					output <= "0101";
					state_current <= state_4;
					
				when state_6 =>
					output <= "0110";
					state_current <= state_7;
					
				when state_7 =>
					output <= "0111";
					state_current <= state_5;
					
				when state_8 =>
					output <= "1000";
					state_current <= state_0;
					
				when state_9 =>
					output <= "1001";
					state_current <= state_8;
					
				when state_A =>
					output <= "1010";
					state_current <= state_B;
					
				when state_B =>
					output <= "1011";
					state_current <= state_9;
					
				when state_C =>
					output <= "1100";
					state_current <= state_D;
					
				when state_D =>
					output <= "1101";
					state_current <= state_F;
					
				when state_E =>
					output <= "1110";
					state_current <= state_A;
					
				when state_F =>
					output <= "1111";
					state_current <= state_E;
					
				when others => null;
				
			end case;
		end if;
	end process;
end bhv;