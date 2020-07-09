library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package alu_lib is

	constant ALU_SEL_SIZE  : integer := 5;
	constant OP_ADD_U  : std_logic_vector(4 downto 0) := "00000"; -- add unsigned
	constant OP_SUB_U  : std_logic_vector(4 downto 0) := "00001"; -- sub unsigned
	constant OP_MULT_S : std_logic_vector(4 downto 0) := "00010"; -- mult signed
	constant OP_MULT_U : std_logic_vector(4 downto 0) := "00011"; -- mult unsigned
	constant OP_AND    : std_logic_vector(4 downto 0) := "00100"; -- and
	constant OP_OR     : std_logic_vector(4 downto 0) := "00101"; -- or
	constant OP_XOR    : std_logic_vector(4 downto 0) := "00110"; -- or
	constant OP_SHR_L  : std_logic_vector(4 downto 0) := "00111"; -- shift right logical
	constant OP_SHL_L  : std_logic_vector(4 downto 0) := "01000"; -- shift left logical
	constant OP_SHR_A  : std_logic_vector(4 downto 0) := "01001"; -- shift right arithmetic
	constant OP_SLT_S  : std_logic_vector(4 downto 0) := "01010"; -- slt - set on less than signed
	constant OP_SLT_U  : std_logic_vector(4 downto 0) := "01011"; -- sltu - set on less than unsigned
	constant OP_BEQ    : std_logic_vector(4 downto 0) := "01100"; -- branch on equal
	constant OP_BNE    : std_logic_vector(4 downto 0) := "01101"; -- branch not equal
	constant OP_BLTE   : std_logic_vector(4 downto 0) := "01110"; -- Branch on Less Than or Equal to Zero
	constant OP_BGT    : std_logic_vector(4 downto 0) := "01111"; -- Branch on Greater Than Zero
	constant OP_BLT    : std_logic_vector(4 downto 0) := "10000"; -- Branch on Less Than Zero
	constant OP_BGTE   : std_logic_vector(4 downto 0) := "10001"; -- Branch on Greater Than or Equal to Zero

end alu_lib;