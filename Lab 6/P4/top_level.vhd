library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity top_level is 
port (
	clk 			: in std_logic;
	switch 		: in std_logic_vector(9 downto 0);
	button		: in std_logic_vector(1 downto 0);		
	red			: out std_logic_vector(3 downto 0);
	blue			: out std_logic_vector(3 downto 0);
	green			: out std_logic_vector(3 downto 0);
	v_sync		: out std_logic;
	h_sync		: out std_logic);
end top_level;

architecture bhv of top_level is

	signal clk25Mhz : std_logic;
	signal Hcount1, Vcount1 : std_logic_vector(COUNT_WIDTH-1 downto 0);
	signal ROM_address : std_logic_vector(11 downto 0);
	signal ROM_address1 : std_logic_vector(13 downto 0);
	signal video_on : std_logic;
	signal row_enable, column_enable : std_logic;
	signal row_enable1, column_enable1 : std_logic;
	signal row_enable2, column_enable2 : std_logic;
	signal q1, q2 : std_logic_vector(11 downto 0);
	signal rst : std_logic;
	signal qDisp : std_logic_vector(11 downto 0);
	signal toLarge : std_logic;

begin
	rst <= not button(0);
	toLarge <= '1';
	
	U_PXL: entity work.pixel_clock port map (
		rst => rst,
		clk => clk,
		pixel_clock => clk25Mhz);
	
	U_VSYNC: entity work.VGA_sync_gen port map (
		clk => clk25Mhz,
		rst => rst,
		Hcount => Hcount1,
		Vcount => Vcount1,
		h_sync => h_sync,
		v_sync => v_sync,
		video_on => video_on);
-----------------------------------------------------------------------------	
	U_BRCOUNT: entity work.block_row port map (
		input => switch(2 downto 0),
		Vcount => Vcount1,
		rom_look_row => ROM_address(11 downto 6),
		enable => row_enable1);
	
	U_BCCOUNT: entity work.block_column port map (
		input => switch(2 downto 0),
		Hcount => Hcount1,
		rom_look_column => ROM_address(5 downto 0),
		enable => column_enable1);
-----------------------------------------------------------------------------
	U_BRCOUNT1: entity work.block_row1 port map (
		input => switch(2 downto 0),
		Vcount => Vcount1,
		rom_look_row => ROM_address1(13 downto 7),
		enable => row_enable2);
	
	U_BCCOUNT1: entity work.block_column1 port map (
		input => switch(2 downto 0),
		Hcount => Hcount1,
		rom_look_column => ROM_address1(6 downto 0),
		enable => column_enable2);
-----------------------------------------------------------------------------	
	U_VGAROM: entity work.vga_rom port map (
		address => ROM_address,
		clock => clk25Mhz,
		q => q1(11 downto 0));
		
	U_VGAROM1: entity work.vga_rom1 port map (
		address => ROM_address1,
		clock => clk25Mhz,
		q => q2(11 downto 0));
		
	process(clk25Mhz)
	begin
		if toLarge = '0' then
			qDisp <= q1;
			column_enable <= column_enable1;
			row_enable <= row_enable1;
		else 
			qDisp <= q2;
			column_enable <= column_enable2;
			row_enable <= row_enable2;
		end if;
		
		if(row_enable = '1' and column_enable = '1' and video_on = '1') then
			red <= qDisp(11 downto 8);
			green <= qDisp(7 downto 4);
			blue <= qDisp(3 downto 0);
		else
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
		end if;
	end process;
end bhv;