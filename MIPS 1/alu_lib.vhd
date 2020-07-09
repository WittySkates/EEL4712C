library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package alu_lib is

    constant sel_size   : integer := 5;
    constant add_u  		: std_logic_vector(4 downto 0) := "00000"; -- add unsigned
    constant sub_u  		: std_logic_vector(4 downto 0) := "00001"; -- sub unsigned
    constant mul_s 		: std_logic_vector(4 downto 0) := "00010"; -- multiply signed
    constant mul_u 		: std_logic_vector(4 downto 0) := "00011"; -- multiply unsigned
    constant and_op    	: std_logic_vector(4 downto 0) := "00100"; -- and
    constant or_op     	: std_logic_vector(4 downto 0) := "00101"; -- or
    constant xor_op    	: std_logic_vector(4 downto 0) := "00110"; -- xor
    constant shr_l  		: std_logic_vector(4 downto 0) := "00111"; -- shift right logical
    constant shl_l  		: std_logic_vector(4 downto 0) := "01000"; -- shift left logical
    constant shr_a  		: std_logic_vector(4 downto 0) := "01001"; -- shift right arithmetic
    constant slt_s  		: std_logic_vector(4 downto 0) := "01010"; -- set on less than signed
    constant slt_u  		: std_logic_vector(4 downto 0) := "01011"; -- set on less than unsigned
    constant b_eq    	: std_logic_vector(4 downto 0) := "01100"; -- branch on equal
    constant b_ne    	: std_logic_vector(4 downto 0) := "01101"; -- branch not equal
    constant b_lteq  	: std_logic_vector(4 downto 0) := "01110"; -- Branch on Less Than or Equal to Zero
    constant b_gt    	: std_logic_vector(4 downto 0) := "01111"; -- Branch on Greater Than Zero
    constant b_lt    	: std_logic_vector(4 downto 0) := "10000"; -- Branch on Less Than Zero
    constant b_gteq   	: std_logic_vector(4 downto 0) := "10001"; -- Branch on Greater Than or Equal to Zero
    
end alu_lib;