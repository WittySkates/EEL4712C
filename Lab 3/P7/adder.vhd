library ieee;
use ieee.std_logic_1164.all;

entity adder is
    generic (
        WIDTH : positive := 8); 
    port (
        x, y : in  std_logic_vector(WIDTH-1 downto 0);
        cin  : in  std_logic;
        s    : out std_logic_vector(WIDTH-1 downto 0);
        cout : out std_logic);
end adder;

architecture RIPPLE_CARRY of adder is

signal rippleC : std_logic_vector(WIDTH downto 0);

begin  -- RIPPLE_CARRY
	
	rippleC(0) <= Cin;
	
	setWidth: for i in 0 to WIDTH-1 generate
		fullAdder : entity work.fa
		port map(
		input1 => X(i),
		input2 => Y(i),
		carry_in => rippleC(i),
		sum => S(i),
		carry_out => rippleC(i+1));
	end generate setWidth;
	
	cout <= rippleC(WIDTH);

end RIPPLE_CARRY;


architecture CARRY_LOOKAHEAD of adder is

begin  -- CARRY_LOOKAHEAD

    process(x, y, cin)

        -- generate and propagate bits
        variable g, p : std_logic_vector(WIDTH-1 downto 0);

        -- internal carry bits
        variable carry : std_logic_vector(WIDTH downto 0);

        -- and'd p sequences
        variable p_ands : std_logic_vector(WIDTH-1 downto 0);

    begin

        -- calculate generate (g) and propogate (p) values

        for i in 0 to WIDTH-1 loop
        -- fill in code that defines each g and p bit
				g(i) := x(i) and y(i);
				p(i) := x(i) or y(i);
        end loop;  -- i

        carry(0) := cin;

        -- calculate each carry bit

        for i in 1 to WIDTH loop

            -- calculate and'd p terms for ith carry logic      
            -- the index j corresponds to the lowest Pj value in the sequence
            -- e.g., PiPi-1...Pj

            for j in 0 to i-1 loop
                p_ands(j) := '1';

                -- and everything from Pj to Pi-1
                for k in j to i-1 loop
                -- fill code
					 p_ands(j) := p_ands(j) and p(k);
                end loop;
            end loop;

            carry(i) := g(i-1);

            -- handle all of the pg minterms
            for j in 1 to i-1 loop
            -- fill in code
				carry(i) := carry(i) or (p_ands(j) and g(j-1));
            end loop;

            -- handle the final propagate of the carry in
            carry(i) := carry(i) or (p_ands(0) and cin);
        end loop;  -- i

        -- set the outputs
        for i in 0 to WIDTH-1 loop
        -- fill in code
		  s(i) <= (x(i) xor y(i) xor carry(i));
        end loop;  -- i

        cout <= carry(WIDTH);

    end process;

end CARRY_LOOKAHEAD;


-- You don't have to change any of the code for the following
-- architecture. However, read the lab instructions to create
-- an RTL schematic of this entity so you can see how the
-- synthesized circuit differs from the previous carry
-- lookahead circuit.

architecture CARRY_LOOKAHEAD_BAD_SYNTHESIS of adder is
begin  -- CARRY_LOOKAHEAD_BAD_SYNTHESIS

    process(x, y, cin)

        -- generate and propagate bits
        variable g, p : std_logic_vector(WIDTH-1 downto 0);

        -- internal carry bits
        variable carry : std_logic_vector(WIDTH downto 0);

    begin

        -- calculate generate (g) and propogate (p) values

        for i in 0 to WIDTH-1 loop
            g(i) := x(i) and y(i);
            p(i) := x(i) or y(i);
        end loop;  -- i

        -- calculate carry bits (the order here is very important)
        -- Problem: defining the carries this way causes the synthesis
        -- tool to chain everything together like a ripple carry.
        -- See RTL view in synthesis tool.

        carry(0) := cin;
        for i in 0 to WIDTH-1 loop
            carry(i+1) := g(i) or (p(i) and carry(i));
        end loop;  -- i

        -- set the outputs

        for i in 0 to WIDTH-1 loop
            s(i) <= x(i) xor y(i) xor carry(i);
        end loop;  -- i

        cout <= carry(WIDTH);

    end process;

end CARRY_LOOKAHEAD_BAD_SYNTHESIS;



architecture HIERARCHICAL of adder is

signal C : std_logic;
signal P : std_logic_vector(1 downto 0);
signal G : std_logic_vector(1 downto 0);

begin  -- HIERARCHICAL
	cla4One : entity work.cla4
	port map(
	X => X(7 downto 4),
	Y => Y(7 downto 4),
	Cin => C,
	S => S(7 downto 4),
	Cout => open,
	BP => P(1),
	BG => G(1));
	
	cla4Two : entity work.cla4
	port map(
	X => X(3 downto 0),
	Y => Y(3 downto 0),
	Cin => Cin,
	S => S(3 downto 0),
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
	BP => open,
	BG => open);

end HIERARCHICAL;