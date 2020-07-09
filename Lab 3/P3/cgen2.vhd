library ieee;
use ieee.std_logic_1164.all;

entity cgen2 is
    port(
		Cin  : in   std_logic;
		P	  : in 	std_logic_vector(1 downto 0);
		G	  : in 	std_logic_vector(1 downto 0);
		Cout : out  std_logic_vector(1 downto 0);
		BP   : out	std_logic;
		BG   : out	std_logic);
end cgen2;

architecture bhv of cgen2 is

signal C : std_logic_vector(2 downto 0);

begin

	C(0) <= Cin;
	C(1) <= G(0) or (P(0) and C(0));
	C(2) <= G(1) or (P(1) and C(1));
	Cout(0) <= C(1);
	Cout(1) <= C(2);
	BP <= P(1) and P(0);
	BG <= G(1) or (P(1) and G(0));

end bhv;
