library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath1 is
	generic(WIDTH : integer := 8);
	port(
		clk			: in std_logic;
		x				: in std_logic_vector(WIDTH-1 downto 0);
		y				: in std_logic_vector(WIDTH-1 downto 0);
		output		: out std_logic_vector(WIDTH-1 downto 0);
		rst        	: in 	std_logic;
		x_sel,y_sel	: in	std_logic;
		x_en,y_en   : in	std_logic;
		output_en  	: in	std_logic;
		x_lt_y	   : out	std_logic;
		x_ne_y	   : out std_logic);
end datapath1;

architecture path of datapath1 is

signal xmux_xreg, ymux_yreg : std_logic_vector(width-1 downto 0);
signal subx_xmux, suby_ymux : std_logic_vector(width-1 downto 0);
signal xreg_out, yreg_out : std_logic_vector(width-1 downto 0);
	
begin

	U_MUX_X: entity work.mux_2x1 
	generic map(WIDTH)
	port map(
		in1 => x,
		in2 => subx_xmux,
		sel => x_sel,
		output => xmux_xreg);
		
	U_MUX_Y: entity work.mux_2x1 
	generic map(WIDTH)
	port map(
		in1 => y,
		in2 => suby_ymux,
		sel => y_sel,
		output => ymux_yreg);
		
	U_REG_X: entity work.reg 
	generic map(WIDTH)
	port map(	
		clk => clk,
		rst => rst,
		en => x_en,
		d => xmux_xreg,
		q => xreg_out);
		
	U_REG_Y: entity work.reg 
	generic map(WIDTH)
	port map(	
		clk => clk,
		rst => rst,
		en => y_en,
		d => ymux_yreg,
		q => yreg_out);
	
	U_SUB_X: entity work.subtractor 
	generic map(WIDTH)
	port map(
		a => xreg_out,
		b => yreg_out,
		sub => subx_xmux);
	
	U_SUB_Y: entity work.subtractor 
	generic map(WIDTH)
	port map(
		a => yreg_out,
		b => xreg_out,
		sub => suby_ymux);
		
	U_COMP: entity work.comparator 
	generic map(WIDTH)
	port map(
		x => xreg_out,
		y => yreg_out,
		x_lt_y => x_lt_y,
		x_ne_y => x_ne_y);
		
	U_REG_O: entity work.reg 
	generic map(WIDTH)
	port map(	
		clk => clk,
		rst => rst,
		en => output_en,
		d => xreg_out,
		q => output);
	
end path;