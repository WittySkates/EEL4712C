library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;

entity alu_small_tb is
end alu_small_tb;

architecture TB of alu_small_tb is
	constant WIDTH  : positive := 32;
	signal Input1   : std_logic_vector(WIDTH-1 downto 0) := (others=>'0');
	signal Input2   : std_logic_vector(WIDTH-1 downto 0) := (others=>'0');
	signal Sel 	    : std_logic_vector(sel_size-1 downto 0) := (others=>'0');
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


		Sel <= add_u;
		Input1 <= std_logic_vector(to_unsigned(10, WIDTH));
		Input2 <= std_logic_vector(to_unsigned(15, WIDTH));
		wait for 10 ns;
		assert(Result = std_logic_vector(to_unsigned(25, WIDTH))) report "add_u Result incorrect" severity failure;
		assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "add_u ResultHi incorrect" severity failure;
		assert(Branch = '0') report "add_u Branch incorrect" severity failure;

		Sel <= sub_u;
		Input1 <= std_logic_vector(to_unsigned(25, WIDTH));
		Input2 <= std_logic_vector(to_unsigned(10, WIDTH));
		wait for 10 ns;
		assert(Result = std_logic_vector(to_unsigned(15, WIDTH))) report "sub_u Result incorrect" severity failure;
		assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "sub_u ResultHi incorrect" severity failure;
		assert(Branch = '0') report "sub_u Branch incorrect" severity failure;

		Sel <= mul_s;
		Input1 <= std_logic_vector(to_signed(10, WIDTH));
		Input2 <= std_logic_vector(to_signed(-5, WIDTH));
		wait for 10 ns;
		assert(ResultHi&Result = std_logic_vector(to_signed(-50, WIDTH*2))) report "mul_s Result&ResultHi incorrect" severity failure;
		assert(Branch = '0') report "mul_s Branch incorrect" severity failure;

		Sel <= mul_u;
		Input1 <= std_logic_vector(to_unsigned(10, WIDTH));
		Input2 <= std_logic_vector(to_unsigned(5, WIDTH));
		wait for 10 ns;
		assert(ResultHi&Result = std_logic_vector(to_unsigned(50, WIDTH*2))) report "mul_u Result&ResultHi incorrect" severity failure;
		assert(Branch = '0') report "mul_u Branch incorrect" severity failure;

		Sel <= and_op;
		Input1 <= std_logic_vector(to_unsigned(65535, WIDTH));
		Input2 <= "11111111111111110001001000110100";
		wait for 10 ns;
		assert(Result = std_logic_vector(to_unsigned(65535, WIDTH) and "11111111111111110001001000110100")) report "and_op Result incorrect" severity failure;
		assert(ResultHi = std_logic_vector(to_unsigned(0,WIDTH))) report "and_op ResultHi incorrect" severity failure;
		assert(Branch = '0') report "and_op Branch incorrect" severity failure;


		Sel <= shr_l;
		ShiftAmt <= std_logic_vector(to_unsigned(4,5));
		Input2 <= std_logic_vector(to_unsigned(15, WIDTH));
		wait for 10 ns;
		assert(Result = std_logic_vector(SHIFT_RIGHT(to_unsigned(15, WIDTH),4))) report "shr_l Result incorrect" severity failure;
		assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "shr_l ResultHi incorrect" severity failure;
		assert(Branch = '0') report "shr_l Branch incorrect" severity failure;

		Sel <= shr_a;
		ShiftAmt <= std_logic_vector(to_unsigned(1,5));
		Input2 <= "11110000000000000000000000001000";
		wait for 10 ns;
		assert(Result = "11111000000000000000000000000100") report "shr_a Result incorrect" severity failure;
		assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "shr_a ResultHi incorrect" severity failure;
		assert(Branch = '0') report "shr_a Branch incorrect" severity failure;
		
		Sel <= shr_a;
		ShiftAmt <= std_logic_vector(to_unsigned(1,5));
		Input2 <= std_logic_vector(to_unsigned(8, WIDTH));
		wait for 10 ns;
		assert(Result = std_logic_vector(SHIFT_RIGHT(to_signed(8, WIDTH), 1))) report "shr_a Result incorrect" severity failure;
		assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "shr_a ResultHi incorrect" severity failure;
		assert(Branch = '0') report "shr_a Branch incorrect" severity failure;

		Sel <= slt_s;
		Input1 <= std_logic_vector(to_unsigned(15, WIDTH));
		Input2 <= std_logic_vector(to_unsigned(10, WIDTH));
		wait for 10 ns;
		assert(Result = std_logic_vector(to_signed(0, WIDTH))) report "slt_s Result incorrect" severity failure;
		assert(ResultHi = std_logic_vector(to_signed(0, WIDTH))) report "slt_s ResultHi incorrect" severity failure;
		assert(Branch = '0') report "slt_s Branch incorrect" severity failure;
		
		Sel <= slt_s;
		Input1 <= std_logic_vector(to_unsigned(10, WIDTH));
		Input2 <= std_logic_vector(to_unsigned(15, WIDTH));
		wait for 10 ns;
		assert(Result = std_logic_vector(to_signed(1, WIDTH))) report "slt_s Result incorrect" severity failure;
		assert(ResultHi = std_logic_vector(to_signed(0, WIDTH))) report "slt_s ResultHi incorrect" severity failure;
		assert(Branch = '0') report "slt_s Branch incorrect" severity failure;

		Sel <= b_lteq;
		Input1 <= std_logic_vector(to_unsigned(5, WIDTH));
		wait for 10 ns;
		assert(Branch = '0') report "b_lteq Branch incorrect" severity failure;
		assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "b_lteq ResultHi incorrect" severity failure;
		assert(Result = std_logic_vector(to_unsigned(0, WIDTH))) report "b_lteq Result incorrect" severity failure;

		Sel <= b_gt;
		Input1 <= std_logic_vector(to_unsigned(5, WIDTH));
		wait for 10 ns;
		assert(Branch = '1') report "b_gt Branch incorrect" severity failure;
		assert(ResultHi = std_logic_vector(to_unsigned(0, WIDTH))) report "b_gt ResultHi incorrect" severity failure;
		assert(Result = std_logic_vector(to_unsigned(0, WIDTH))) report "b_gt Result incorrect" severity failure;
		
		wait for 10 ns;
		
		report "Finished";
		wait;
	end process;

end TB;