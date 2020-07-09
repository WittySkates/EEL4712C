library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;

entity alu is
    generic (
        WIDTH : positive := 16
    );
    port (
        Input1     : in std_logic_vector(WIDTH-1 downto 0);
        Input2     : in std_logic_vector(WIDTH-1 downto 0);
        ShiftAmt   : in std_logic_vector(4 downto 0);
        Sel   		 : in std_logic_vector(sel_size-1 downto 0);
        Result     : out std_logic_vector(WIDTH-1 downto 0);
        ResultHi   : out std_logic_vector(WIDTH-1 downto 0);
        Branch     : out std_logic
    );
end alu;

architecture BHV of alu is 
begin
    process(Input1, Input2, ShiftAmt, Sel)
        variable temp_mult : std_logic_vector(width*2-1 downto 0);
    begin
        case Sel is
            when add_u  => --add, unsigned
                Result <= std_logic_vector(unsigned(Input1) + unsigned(Input2));
                ResultHi <= (others => '0');
                Branch <= '0';
            when sub_u  => --subtract, unsigned
                Result <= std_logic_vector(unsigned(Input1) - unsigned(Input2));
                ResultHi <= (others => '0');
                Branch <= '0';
            when mul_s => --multiply, signed
                temp_mult := std_logic_vector(signed(Input1) * signed(Input2));
                Result <= temp_mult(width-1 downto 0);
                ResultHi <= temp_mult(width*2-1 downto width);
                Branch <= '0';
            when mul_u => --multiply, unsigned
                temp_mult := std_logic_vector(unsigned(Input1) * unsigned(Input2));
                Result <= temp_mult(width-1 downto 0);
                ResultHi <= temp_mult(width*2-1 downto width);
                Branch <= '0';
            when and_op    => --and
                Result <= Input1 and Input2;
                ResultHi <= (others => '0');
                Branch <= '0';
            when or_op     => --or
                Result <= Input1 or Input2;
                ResultHi <= (others => '0');
                Branch <= '0';
            when xor_op    => --xor
                Result <= Input1 xor Input2;
                ResultHi <= (others => '0');
                Branch <= '0';
            when shr_l  => --shift right logical
                Result <= std_logic_vector(SHIFT_RIGHT(unsigned(Input2), to_integer(unsigned(ShiftAmt))));
                ResultHi <= (others => '0');
                Branch <= '0';
            when shl_l  => --shift left logical
                Result <= std_logic_vector(SHIFT_LEFT(unsigned(Input2), to_integer(unsigned(ShiftAmt))));
                ResultHi <= (others => '0');
                Branch <= '0';
            when shr_a  => --shift right arithmetic
                Result <= std_logic_vector(SHIFT_RIGHT(signed(Input2), to_integer(unsigned(ShiftAmt))));
                ResultHi <= (others => '0');
                Branch <= '0';
            when slt_s  => --set less than, signed
                if (signed(Input1) < signed(Input2)) then
                    Result <= std_logic_vector(to_unsigned(1, width));
                else
                    Result <= (others => '0');
                end if;
                ResultHi <= (others => '0');
                Branch <= '0';
            when slt_u  => --set less than, unsigned
                if (unsigned(Input1) < unsigned(Input2)) then
                    Result <= std_logic_vector(to_unsigned(1, width));
                else
                    Result <= (others => '0');
                end if;
                ResultHi <= (others => '0');
                Branch <= '0';
            when b_eq    => --branch if equal to
                if (signed(Input1) = signed(Input2)) then
                    Branch <= '1';
                else
                    Branch <= '0';
                end if;
                Result <= (others => '0');
                ResultHi <= (others => '0');
            when b_ne    => --branch if not equal to
                if (signed(Input1) = signed(Input2)) then
                    Branch <= '0';
                else
                    Branch <= '1';
                end if;
                Result <= (others => '0');
                ResultHi <= (others => '0');
            when b_lteq   => --branch if less than or equal to 0
                if (signed(Input1) <= 0) then
                    Branch <= '1';
                else
                    Branch <= '0';
                end if;
                Result <= (others => '0');
                ResultHi <= (others => '0');
            when b_gt    => --branch if greater than 0
                if (signed(Input1) > 0) then
                    Branch <= '1';
                else
                    Branch <= '0';
                end if;
                Result <= (others => '0');
                ResultHi <= (others => '0');
            when b_lt    => --branch if less than 0
                if (signed(Input1) < 0) then
                    Branch <= '1';
                else
                    Branch <= '0';
                end if;
                Result <= (others => '0');
                ResultHi <= (others => '0');
            when b_gteq   => --branch if greater than or equal to 0
                if (signed(Input1) >= 0) then
                    Branch <= '1';
                else
                    Branch <= '0';
                end if;
                Result <= (others => '0');
                ResultHi <= (others => '0');
            when others => --invalid operations
                Result <= (others => '0');
                ResultHi <= (others => '0');
                Branch <= '0';
        end case;
    end process;
end BHV;