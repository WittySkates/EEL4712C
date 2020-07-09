library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;

entity memory is
    port (
        clk        : in std_logic;
        rst        : in std_logic;
        address    : in  std_logic_vector(31 downto 0);
        data       : out std_logic_vector(31 downto 0);
        RegB       : in  std_logic_vector(31 downto 0);
        MemRead    : in std_logic;
        MemWrite   : in std_logic;
        InPort1_en : in  std_logic;
        InPort0_en : in  std_logic;
        InPort     : in  std_logic_vector(31 downto 0);
        OutPort    : out std_logic_vector(31 downto 0)
    );
end memory;

architecture IO_WRAP of memory is
    signal OutPort_en : std_logic;
    signal Ram_en     : std_logic;
    signal InPort0    : std_logic_vector(31 downto 0);
    signal InPort1    : std_logic_vector(31 downto 0);
    signal RamOut     : std_logic_vector(31 downto 0);
    signal OutSel     : std_logic_vector(1 downto 0);

begin

	process(address, MemWrite)
	begin
		OutPort_en <= '0';
		Ram_en <= '0';
		if (MemWrite = '1') then
			if (address = x"0000FFFC") then 
				OutPort_en <= '1';
			else
				Ram_en <= '1';
			end if; 
	   end if;
	end process;

	process (clk,rst)
	begin
		if (rst = '1') then
			OutSel <= "11";
		elsif (rising_edge(clk)) then 
			if (MemRead = '1') then
				if (address = x"0000FFF8") then
					OutSel <= "00";
				elsif (address = x"0000FFFC") then
					OutSel <= "01";
				else 
					OutSel <= "10";
				end if;
			end if;
		end if;
	end process;

	OUT_MUX: entity work.mux_4x1
		generic map (WIDTH => 32)
		port map (
			sel    => OutSel,
			in0    => InPort0,
			in1    => InPort1,
			in2    => RamOut,
			in3    => (others => '0'),
			output => data
		);

	IN_PORT_0: entity work.reg
		generic map (WIDTH => 32)
		port map (
			clk    => clk,
			rst    => '0',
			en     => InPort0_en,
			input  => InPort,
			output => InPort0
		);

	IN_PORT_1: entity work.reg
		generic map (WIDTH => 32)
		port map (
			clk    => clk,
			rst    => '0',
			en     => InPort1_en,
			input  => InPort,
			output => InPort1
		);

	OUT_PORT: entity work.reg
		generic map (WIDTH => 32)
		port map (
			clk    => clk,
			rst    => rst,
			en     => OutPort_en,
			input  => RegB,
			output => OutPort
		);
		
	RAM: entity work.ram
		port map (
			address	=> address(9 downto 2),
			clock   => clk,
			data	=> RegB,
			wren	=> Ram_en,
			q		=> RamOut
		);



end IO_WRAP;