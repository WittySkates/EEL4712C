library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity VGA_sync_gen is
port (
	rst				: in 	std_logic;
	clk 				: in 	std_logic;
	Hcount      	: out std_logic_vector(COUNT_WIDTH-1 downto 0);
	Vcount	 		: out std_logic_vector(COUNT_WIDTH-1 downto 0);
	h_sync  			: out std_logic; 
	v_sync   		: out std_logic;
	video_on    	: out std_logic);
end VGA_sync_gen;

architecture behv of VGA_sync_gen  is

	signal HTemp  :  unsigned(COUNT_WIDTH-1 downto 0);
	signal VTemp  :  unsigned(COUNT_WIDTH-1 downto 0);
	
begin
	process(clk)
   begin
		if rst = '1' then
			HTemp <= (others => '0');
			VTemp <= (others => '0');
			h_sync <= '1';
			v_sync <= '1';
      elsif(rising_edge(clk)) then
			if(HTemp < H_MAX) then
				HTemp <= HTemp + 1;
				if(HTemp <= H_DISPLAY_END) and (VTemp <= V_DISPLAY_END) then
					video_on <= '1';
				else 
					video_on <= '0';
				end if;
				if(HTemp >= HSYNC_BEGIN) and (HTemp <= HSYNC_END)  then
					h_sync <= '0';
				else
					h_sync <= '1';
				end if;
				if(HTemp = H_VERT_INC) then
					VTemp <= VTemp + 1;
				elsif(VTemp < V_MAX) then
					if(HTemp <= H_DISPLAY_END) and (VTemp <= V_DISPLAY_END) then
						video_on <= '1';
					else
						video_on <= '0';
					end if;
					if(VTemp >= VSYNC_BEGIN) and (VTemp <= VSYNC_END) then
						v_sync <= '0';
					else
						v_sync <= '1';
					end if;
				else
					VTemp <= (others => '0');
				end if;
			else
				HTemp <= (others => '0');
			end if;
			Hcount <= std_logic_vector(HTemp);
			Vcount <= std_logic_vector(VTemp);
		end if;
	end process;
end behv;
