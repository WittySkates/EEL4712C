library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;

entity registers_file is 
    port (
        clk           : in std_logic;
        rst           : in std_logic;

        ReadReg1      : in std_logic_vector(4 downto 0);
        ReadReg2      : in std_logic_vector(4 downto 0);
        ReadData1     : out std_logic_vector(31 downto 0);
        ReadData2     : out std_logic_vector(31 downto 0);

        WriteRegister : in std_logic_vector(4 downto 0);
        WriteData     : in std_logic_vector(31 downto 0);
        RegWrite      : in std_logic; 

        JumpAndLink   : in std_logic 
    );
end registers_file;

architecture async_read of registers_file is
    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal regs : reg_array; 
begin 
    process (clk, rst) is
    begin 
        if (rst = '1') then
            for i in regs'range loop
                regs(i) <= (others => '0');
            end loop;
        elsif (rising_edge(clk)) then
            if (RegWrite = '1') then
                if (JumpAndLink = '1') then
                    regs(31) <= WriteData;
                else
                    regs(to_integer(unsigned(WriteRegister))) <= WriteData;
                end if;
            end if;
        end if;
    end process;
    ReadData1 <= regs(to_integer(unsigned(ReadReg1)));
    ReadData2 <= regs(to_integer(unsigned(ReadReg2)));
end async_read;