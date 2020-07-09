library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity decoder7seg_tb is
end decoder7seg_tb;
 
architecture TB of decoder7seg_tb is 

    component decoder7seg
    port(
         input : in  std_logic_vector(3 downto 0);
         output : out  std_logic_vector(6 downto 0)
        );
    end component;
   
   signal input : std_logic_vector(3 downto 0) := (others => '0');
   signal output : std_logic_vector(6 downto 0);
 
begin
 
   UUT: decoder7seg 
		port map (
          input => input,
          output => output
        );

   process
   begin        
        for i in 0 to 15 loop
            input <= conv_std_logic_vector(i,4);
            wait for 50 ns;
        end loop;
      wait;
   end process;

end TB;