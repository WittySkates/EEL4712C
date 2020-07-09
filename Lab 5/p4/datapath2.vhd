library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath2 is
	generic(WIDTH	: integer := 8);
	port(
		clk			: in std_logic;
		x				: in std_logic_vector(WIDTH-1 downto 0);
		y				: in std_logic_vector(WIDTH-1 downto 0);
		output		: out std_logic_vector(WIDTH-1 downto 0);
		rst        	: in 	std_logic;
		x_sel,y_sel	: in	std_logic;
		x_en,y_en   : in	std_logic;
		output_en  	: in	std_logic;
		sub0_sel		: in	std_logic;
		sub1_sel		: in	std_logic;
		x_lt_y	   : out	std_logic;
		x_ne_y	   : out std_logic);
end datapath2;

architecture path of datapath2 is

signal xmux_xreg, ymux_yreg 	: std_logic_vector(width-1 downto 0);
signal xreg_out, yreg_out 	 	: std_logic_vector(width-1 downto 0);
signal sub_sig, mux_0, mux_1 	: std_logic_vector(width-1 downto 0);

begin
	
	U_MUX_X: entity work.mux_2x1 
	generic map(WIDTH)
	port map(
		in1 => x,
		in2 => sub_sig,
		sel => x_sel,
		output => xmux_xreg);
		
	U_MUX_Y: entity work.mux_2x1 
	generic map(WIDTH)
	port map(
		in1 => y,
		in2 => sub_sig,
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
	
	U_M0: entity work.mux_2x1
	generic map(WIDTH)
	port map(
		in1 => xreg_out,
		in2 => yreg_out,
		sel => sub0_sel,
		output => mux_0);
	
	U_M1: entity work.mux_2x1
	generic map(WIDTH)
	port map(
		in1 => xreg_out,
		in2 => yreg_out,
		sel => sub1_sel,
		output => mux_1);
	
	U_SUB: entity work.subtractor 
	generic map(WIDTH)
	port map(
		a => mux_0,
		b => mux_1,
		sub => sub_sig);
		
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