library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd is
    generic (WIDTH : positive := 16);
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        go     : in  std_logic;
        done   : out std_logic;
        x      : in  std_logic_vector(WIDTH-1 downto 0);
        y      : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0));
end gcd;

architecture FSMD of gcd is

type state_type is (state0, state1, state2, state3, state4);
signal state	: state_type;
	
begin  -- FSMD
	process(rst, clk, go)
		variable tempX, tempY : unsigned(WIDTH-1 downto 0);
	begin
		state <= state;
		if rst = '1' then 
			state <= state0;
			output <= (others => '0');
			tempX := (others => '0');
			tempY := (others => '0');
			done <= '0';
		elsif rising_edge(clk) then
			case state is
				when state0 =>
					if go = '1' then
						state <= state1;
						done <= '0';	
					end if;
				when state1 =>
					tempX := unsigned(x);
					tempY := unsigned(y);
					state <= state2;
				when state2 =>
					if tempX < tempY then
						tempY := tempY - tempX;
					elsif tempY < tempX then
						tempX := tempX - tempY;
					else
						state <= state3;
					end if;
				when state3 =>
					output <= std_logic_vector(tempX);
					done <= '1';
					state <= state4;
				when state4 =>
					if go = '0' then
						state <= state0;
					end if;
				when others =>
				null;
			end case;
		end if;
	end process;
end FSMD;

architecture FSM_D1 of gcd is
	
signal x_lt_y,x_ne_y,x_sel,y_sel,x_en,y_en,output_en : std_logic;

begin  -- FSM_D1
	
	U_CT: entity work.ctrl1
	port map(
		clk => clk,
		go => go,
		x_lt_y => x_lt_y,
		x_ne_y => x_ne_y,
		x_sel => x_sel,
		y_sel => y_sel,
		x_en => x_en,
		y_en => y_en,
		output_en => output_en,
		done => done);
	
	U_DP: entity work.datapath1 
	generic map (WIDTH)
	port map(
		clk => clk,
		rst => rst,
		x => x,
		y => y,
		x_sel => x_sel,
		y_sel => y_sel,
		x_en => x_en,
		y_en => y_en,
		output_en => output_en,
		x_lt_y => x_lt_y,
		x_ne_y => x_ne_y,
		output => output);

end FSM_D1;

architecture FSM_D2 of gcd is

signal x_lt_y,x_ne_y,x_sel,y_sel,x_en,y_en,output_en,sub0_sel,sub1_sel : std_logic;

begin  -- FSM_D2

	U_DP: entity work.datapath2 
	generic map (WIDTH)
	port map(
		clk => clk,
		rst => rst,
		x => x,
		y => y,
		x_sel => x_sel,
		y_sel => y_sel,
		x_en => x_en,
		y_en => y_en,
		output_en => output_en,
		sub0_sel => sub0_sel,
		sub1_sel => sub1_sel,
 		x_lt_y => x_lt_y,
		x_ne_y => x_ne_y,
		output => output);
		
	U_CT: entity work.ctrl2
	port map(
		clk => clk,
		go => go,
		x_lt_y => x_lt_y,
		x_ne_y => x_ne_y,
		sub0_sel => sub0_sel,
		sub1_sel => sub1_sel,
		x_sel => x_sel,
		y_sel => y_sel,
		x_en => x_en,
		y_en => y_en,
		output_en => output_en,
		done => done);


end FSM_D2;
