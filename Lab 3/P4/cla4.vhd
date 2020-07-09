library ieee;
use ieee.std_logic_1164.all;

entity cla4 is
    port(
		X 	  : in   std_logic_vector(3 downto 0);
		Y 	  : in   std_logic_vector(3 downto 0);
		Cin  : in   std_logic;
		S 	  : out  std_logic_vector(3 downto 0);
		Cout : out  std_logic;
		BP   : out	std_logic;
		BG   : out	std_logic);
end cla4;

architecture bhv of cla4 is

signal C : std_logic;
signal P : std_logic_vector(1 downto 0);
signal G : std_logic_vector(1 downto 0);

begin
	cla2One : entity work.cla2
	port map(
	X => X(3 downto 2),
	Y => Y(3 downto 2),
	Cin => C,
	S => S(3 downto 2),
	Cout => open,
	BP => P(1),
	BG => G(1));
	
	cla2Two : entity work.cla2
	port map(
	X => X(1 downto 0),
	Y => Y(1 downto 0),
	Cin => Cin,
	S => S(1 downto 0),
	Cout => open,
	BP => P(0),
	BG => G(0));
	
	cgen2One : entity work.cgen2
	port map(
	Cin => Cin,
	P => P(1 downto 0),
	G => G(1 downto 0),
	Cout(0) => C,
	Cout(1) => Cout,
	BP => BP,
	BG => BG);
	
end bhv;