library ieee;
use ieee.std_logic_1164.all;

entity cla2 is
    port(
		X 	  : in   std_logic_vector(1 downto 0);
		Y 	  : in   std_logic_vector(1 downto 0);
		Cin  : in   std_logic;
		S 	  : out  std_logic_vector(1 downto 0);
		Cout : out  std_logic;
		BP   : out	std_logic;
		BG   : out	std_logic);
end cla2;

architecture bhv of cla2 is

signal C  : std_logic_vector(1 downto 0);
signal p	 : std_logic_vector(1 downto 0);
signal g  : std_logic_vector(1 downto 0);

begin

	g <= X and Y;
	p <= X xor Y;
	
	C(0) <= Cin;
	C(1) <= g(0) or (p(0) and C(0));
	
	S <= p xor C(1 downto 0);
	Cout <= g(1) or (p(1) and c(1));
	BP <= p(1) and p(0);
	BG <= g(1) or (p(1) and g(0));

end bhv;