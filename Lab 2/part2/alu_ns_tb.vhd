library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu_ns_tb is
end alu_ns_tb;

architecture TB of alu_ns_tb is

    component alu_ns

        generic (
            WIDTH : positive := 16
            );
        port (
            input1   : in  std_logic_vector(WIDTH-1 downto 0);
            input2   : in  std_logic_vector(WIDTH-1 downto 0);
            sel      : in  std_logic_vector(3 downto 0);
            output   : out std_logic_vector(WIDTH-1 downto 0);
            overflow : out std_logic
            );

    end component;

    constant WIDTH  : positive                           := 8;
    signal input1   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal input2   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal sel      : std_logic_vector(3 downto 0)       := (others => '0');
    signal output   : std_logic_vector(WIDTH-1 downto 0);
    signal overflow : std_logic;

begin  -- TB

    UUT : alu_ns
        generic map (WIDTH => WIDTH)
        port map (
            input1   => input1,
            input2   => input2,
            sel      => sel,
            output   => output,
            overflow => overflow);

    process
    begin

        -- test 2+6 (no overflow)
        sel    <= "0000";
        input1 <= conv_std_logic_vector(2, input1'length);
        input2 <= conv_std_logic_vector(6, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(8, output'length)) report "Error : 2+6 = " & integer'image(conv_integer(output)) & " instead of 8" severity warning;
        assert(overflow = '0') report "Error                                   : overflow incorrect for 2+8" severity warning;

        -- test 250+50 (with overflow)
        sel    <= "0000";
        input1 <= conv_std_logic_vector(250, input1'length);
        input2 <= conv_std_logic_vector(50, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(300, output'length)) report "Error : 250+50 = " & integer'image(conv_integer(output)) & " instead of 44" severity warning;
        assert(overflow = '1') report "Error                                     : overflow incorrect for 250+50" severity warning;

        -- test 5*6
        sel    <= "0010";
        input1 <= conv_std_logic_vector(5, input1'length);
        input2 <= conv_std_logic_vector(6, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(30, output'length)) report "Error : 5*6 = " & integer'image(conv_integer(output)) & " instead of 30" severity warning;
        assert(overflow = '0') report "Error                                    : overflow incorrect for 5*6" severity warning;

        -- test 64*64
        sel    <= "0010";
        input1 <= conv_std_logic_vector(64, input1'length);
        input2 <= conv_std_logic_vector(64, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(4096, output'length)) report "Error : 64*64 = " & integer'image(conv_integer(output)) & " instead of 0" severity warning;
        assert(overflow = '1') report "Error                                      : overflow incorrect for 64*64" severity warning;

        -- add many more tests
		  
		  sel <= "1000";
		  input1 <= conv_std_logic_vector(4, input1'length);
		  input2 <= conv_std_logic_vector(4, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(8, output'length)) report "Error : 4 shift left = " & integer'image(conv_integer(output)) & " instead of 8" severity warning;
        assert(overflow = '0') report "Error                                   : overflow incorrect for 4 shift left" severity warning;

		  sel <= "1000";
		  input1 <= conv_std_logic_vector(128, input1'length);
		  input2 <= conv_std_logic_vector(128, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(0, output'length)) report "Error : 128 shift left = " & integer'image(conv_integer(output)) & " instead of 0" severity warning;
        assert(overflow = '1') report "Error                                   : overflow incorrect for 8 shift left" severity warning;
        
		  sel <= "1001";
		  input1 <= conv_std_logic_vector(8, input1'length);
		  input2 <= conv_std_logic_vector(8, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(4, output'length)) report "Error : 8 shift right = " & integer'image(conv_integer(output)) & " instead of 4" severity warning;
        assert(overflow = '0') report "Error                                   : overflow incorrect for 8 shift right" severity warning;		  
		  
		  sel <= "1011";
		  input1 <= conv_std_logic_vector(52, input1'length);
		  input2 <= conv_std_logic_vector(52, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(44, output'length)) report "Error : 52 reversed = " & integer'image(conv_integer(output)) & " instead of 44" severity warning;
        assert(overflow = '0') report "Error                                   : overflow incorrect for 8 shift right" severity warning;		  
		  
		  sel <= "1010";
		  input1 <= conv_std_logic_vector(53, input1'length);
		  input2 <= conv_std_logic_vector(53, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(83, output'length)) report "Error : 53 reversed = " & integer'image(conv_integer(output)) & " instead of 83" severity warning;
        assert(overflow = '0') report "Error                                   : overflow incorrect for 8 shift right" severity warning;		  
		  
		  wait;

    end process;



end TB;