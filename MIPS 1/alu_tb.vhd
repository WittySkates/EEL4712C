library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;

entity alu_tb is
end alu_tb;

architecture TB of alu_tb is
	constant WIDTH  : positive := 8;
	signal Input1   : std_logic_vector(WIDTH-1 downto 0) := (others=>'0');
	signal Input2   : std_logic_vector(WIDTH-1 downto 0) := (others=>'0');
	signal Sel      : std_logic_vector(sel_size-1 downto 0) := (others=>'0');
	signal ShiftAmt : std_logic_vector(4 downto 0) := (others=>'0');
	signal Result   : std_logic_vector(WIDTH-1 downto 0);
	signal ResultHi : std_logic_vector(WIDTH-1 downto 0);
	signal Branch   : std_logic := '0';
	
begin
	UUT: entity work.alu
		generic map ( WIDTH => WIDTH )
		port map (
			Input2   => Input2,
			Input1   => Input1,
			ShiftAmt => ShiftAmt,
			Sel 		=> Sel,
			Result   => Result,
			ResultHi => ResultHi,
			Branch   => Branch
			);
	
	process
	begin
		for i in 0 to 2**(WIDTH)-1 loop
			for j in 0 to 2**(WIDTH)-1 loop

				Input1 <= std_logic_vector(to_unsigned(i, WIDTH));
				Input2 <= std_logic_vector(to_unsigned(j, WIDTH));

				Sel <= add_u;
				wait for 10 ns;
				assert(Result = std_logic_vector(to_unsigned(i, WIDTH)+to_unsigned(j, WIDTH))) report "add_u Result incorrect" severity failure;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "add_u ResultHi incorrect" severity failure;
				assert(Branch = '0') report "add_u Branch incorrect" severity failure;

				Sel <= sub_u;
				wait for 10 ns;
				assert(Result = std_logic_vector(to_unsigned(i, WIDTH)-to_unsigned(j, WIDTH))) report "sub_u Result incorrect" severity failure;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "sub_u ResultHi incorrect" severity failure;
				assert(Branch = '0') report "sub_u Branch incorrect" severity failure;

				Sel <= mul_s;
				wait for 10 ns;
				assert(ResultHi&Result = std_logic_vector(to_signed(i, WIDTH)*to_signed(j, WIDTH))) report "mul_s Result&ResultHi incorrect" severity failure;
				assert(Branch = '0') report "mul_s Branch incorrect" severity failure;

				Sel <= mul_u;
				wait for 10 ns;
				assert(ResultHi&Result = std_logic_vector(to_unsigned(i, WIDTH)*to_unsigned(j, WIDTH))) report "mul_u Result&ResultHi incorrect" severity failure;
				assert(Branch = '0') report "mul_u Branch incorrect" severity failure;

				Sel <= and_op;
				wait for 10 ns;
				assert(Result = std_logic_vector(to_unsigned(i, WIDTH) and to_unsigned(j, WIDTH))) report "and_op Result incorrect" severity failure;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "and_op ResultHi incorrect" severity failure;
				assert(Branch = '0') report "and_op Branch incorrect" severity failure;

				Sel <= or_op;
				wait for 10 ns;
				assert(Result = std_logic_vector(to_unsigned(i, WIDTH) or to_unsigned(j, WIDTH))) report "or_op Result incorrect" severity failure;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "or_op ResultHi incorrect" severity failure;
				assert(Branch = '0') report "or_op Branch incorrect" severity failure;

				Sel <= xor_op;
				wait for 10 ns;
				assert(Result = std_logic_vector(to_unsigned(i, WIDTH) xor to_unsigned(j, WIDTH))) report "xor_op Result incorrect" severity failure;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "xor_op ResultHi incorrect" severity failure;
				assert(Branch = '0') report "xor_op Branch incorrect" severity failure;

				for k in 0 to 8 loop

					ShiftAmt <= std_logic_vector(to_unsigned(k,5));
					wait for 10 ns;

					Sel <= shr_l;
					wait for 10 ns;
					assert(Result = std_logic_vector(SHIFT_RIGHT(to_unsigned(j, WIDTH), k))) report "shr_l Result incorrect" severity failure;
					assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "shr_l ResultHi incorrect" severity failure;
					assert(Branch = '0') report "shr_l Branch incorrect" severity failure;

					Sel <= shl_l;
					wait for 10 ns;
					assert(Result = std_logic_vector(SHIFT_LEFT(to_unsigned(j, WIDTH), k))) report "shl_l Result incorrect" severity failure;
					assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "shl_l ResultHi incorrect" severity failure;
					assert(Branch = '0') report "shl_l Branch incorrect" severity failure;

					Sel <= shr_a;
					wait for 10 ns;
					assert(Result = std_logic_vector(SHIFT_RIGHT(to_signed(j, WIDTH), k))) report "shr_a Result incorrect" severity failure;
					assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "shr_a ResultHi incorrect" severity failure;
					assert(Branch = '0') report "shr_a Branch incorrect" severity failure;

				end loop; 

				Sel <= slt_s;
				wait for 10 ns;
				if (to_signed(i, WIDTH) < to_signed(j, WIDTH)) then
				  assert(Result = std_logic_vector(to_unsigned(1,WIDTH))) report "slt_s Result incorrect" severity failure;
				else
				  assert(Result = std_logic_vector(to_unsigned(0, WIDTH))) report "slt_s Result incorrect" severity failure;
				end if;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "slt_s ResultHi incorrect" severity failure;
				assert(Branch = '0') report "slt_s Branch incorrect" severity failure;

				Sel <= slt_u;
				wait for 10 ns;
				if (to_unsigned(i, WIDTH) < to_unsigned(j, WIDTH)) then
				  assert(Result = std_logic_vector(to_unsigned(1,WIDTH))) report "slt_u Result incorrect" severity failure;
				else
				  assert(Result = std_logic_vector(to_unsigned(0, WIDTH))) report "slt_u Result incorrect" severity failure;
				end if;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "slt_u ResultHi incorrect" severity failure;
				assert(Branch = '0') report "slt_u Branch incorrect" severity failure;

				Sel <= b_eq;
				wait for 10 ns;
				if (to_signed(i, WIDTH) = to_signed(j, WIDTH)) then
				  assert(Branch = '1') report "b_eq Branch incorrect" severity failure;
				else
				  assert(Branch = '0') report "b_eq Branch incorrect" severity failure;
				end if;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "b_eq ResultHi incorrect" severity failure;
				assert(Result = std_logic_vector(to_unsigned(0, WIDTH))) report "b_eq Result incorrect" severity failure;

				Sel <= b_ne;
				wait for 10 ns;
				if (to_signed(i, WIDTH) = to_signed(j, WIDTH)) then
				  assert(Branch = '0') report "b_ne Branch incorrect" severity failure;
				else
				  assert(Branch = '1') report "b_ne Branch incorrect" severity failure;
				end if;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "b_ne ResultHi incorrect" severity failure;
				assert(Result = std_logic_vector(to_unsigned(0, WIDTH))) report "b_ne Result incorrect" severity failure;

				Sel <= b_lteq;
				wait for 10 ns;
				if (to_signed(i, WIDTH) <= to_signed(0, WIDTH)) then
				  assert(Branch = '1') report "b_lteq Branch incorrect" severity failure;
				else
				  assert(Branch = '0') report "b_lteq Branch incorrect" severity failure;
				end if;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "b_lteq ResultHi incorrect" severity failure;
				assert(Result = std_logic_vector(to_unsigned(0, WIDTH))) report "b_lteq Result incorrect" severity failure;

				Sel <= b_gt;
				wait for 10 ns;
				if (to_signed(i, WIDTH) > to_signed(0, WIDTH)) then
				  assert(Branch = '1') report "b_gt Branch incorrect" severity failure;
				else
				  assert(Branch = '0') report "b_gt Branch incorrect" severity failure;
				end if;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "b_gt ResultHi incorrect" severity failure;
				assert(Result = std_logic_vector(to_unsigned(0, WIDTH))) report "b_gt Result incorrect" severity failure;

				Sel <= b_lt;
				wait for 10 ns;
				if (to_signed(i, WIDTH) < to_signed(0, WIDTH)) then
				  assert(Branch = '1') report "b_lt Branch incorrect" severity failure;
				else
				  assert(Branch = '0') report "b_lt Branch incorrect" severity failure;
				end if;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "b_lt ResultHi incorrect" severity failure;
				assert(Result = std_logic_vector(to_unsigned(0, WIDTH))) report "b_lt Result incorrect" severity failure;

				Sel <= b_gteq;
				wait for 10 ns;
				if (to_signed(i, WIDTH) >= to_signed(0, WIDTH)) then
				  assert(Branch = '1') report "b_gteq Branch incorrect" severity failure;
				else
				  assert(Branch = '0') report "b_gteq Branch incorrect" severity failure;
				end if;
				assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "b_gteq ResultHi incorrect" severity failure;
				assert(Result = std_logic_vector(to_unsigned(0, WIDTH))) report "b_gteq Result incorrect" severity failure;

			end loop;
		end loop;
		report "Finished";
		wait;
end process;

end TB;