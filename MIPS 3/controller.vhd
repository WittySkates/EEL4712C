library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;

entity controller is
    port (
        clk          : in std_logic;
        rst          : in std_logic;
        PCWriteCond  : out std_logic;
        PCWrite      : out std_logic;
        IorD         : out std_logic;
        MemRead      : out std_logic;
        MemWrite     : out std_logic;
        MemToReg     : out std_logic_vector(1 downto 0);
        IRWrite      : out std_logic;
        JumpAndLink  : out std_logic;
        IsSigned     : out std_logic;
        PCSource     : out std_logic_vector(1 downto 0);
        OpSelect     : out std_logic_vector(ALU_SEL_SIZE-1 downto 0);
        ALUSrcA      : out std_logic;
        ALUSrcB      : out std_logic_vector(1 downto 0);
        RegWrite     : out std_logic;
        RegDst       : out std_logic;
        ALU_LO_HI    : out std_logic_vector(1 downto 0);
        LO_en        : out std_logic;
        HI_en        : out std_logic;
        IR31downto26 : in  std_logic_vector(5 downto 0);
        IR5downto0   : in  std_logic_vector(5 downto 0);
        IR20downto16 : in  std_logic_vector(4 downto 0)
    );
end controller;

architecture FSM of controller is

    type STATE_TYPE is (INSTRUCTION_FETCH, LOAD_IR, INSTRUCTION_DECODE,
                        R_TYPE_EXECUTION, I_TYPE_EXECUTION,
                        R_TYPE_COMPLETION, I_TYPE_COMPLETION,
                        MEMORY_ADDRESS_COMPUTATION,
                        MEMORY_ACCESS_READ, LOAD_MEMORY_DATA_REG, MEMORY_READ_COMPLETION,
                        MEMORY_ACCESS_WRITE,
                        BRANCH_COMPLETION,
                        WRITE_RETURN_ADDR,
                        JUMP, JUMP_REGISTER,
                        HALT); 
    signal state, next_state : STATE_TYPE;

    signal IR5downto0_ext : unsigned(7 downto 0);
    signal IR31downto26_ext : unsigned(7 downto 0);

begin

    process(clk,rst)
    begin
        if (rst = '1') then
            state <= INSTRUCTION_FETCH;
        elsif (rising_edge(clk)) then
            state <= next_state;
        end if;
    end process;

    IR5downto0_ext <= resize(unsigned(IR5downto0),8);
    IR31downto26_ext <= resize(unsigned(IR31downto26),8);

    process(IR31downto26_ext, IR5downto0_ext, state)
    begin
        PCWriteCond <= '0';
        PCWrite     <= '0';
        IorD        <= '0';
        MemRead     <= '0';
        MemWrite    <= '0';
        MemToReg    <= "00";
        IRWrite     <= '0';
        JumpAndLink <= '0';
        IsSigned    <= '0';
        PCSource    <= "00";
        OpSelect    <= (others => '0');
        ALUSrcA     <= '0';
        ALUSrcB     <= "00";
        RegWrite    <= '0';
        RegDst      <= '0';
        ALU_LO_HI   <= "00";
        LO_en       <= '0';
        HI_en       <= '0'; 
        next_state  <= state;

        case state is
            when INSTRUCTION_FETCH =>
                IorD <= '0';
                MemRead <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= "01";
                OpSelect <= OP_ADD_U; 
                PCSource <= "00";
                PCWrite <= '1';
                next_state <= LOAD_IR;
            when LOAD_IR => 
                IRWrite <= '1';
                next_state <= INSTRUCTION_DECODE;
            when INSTRUCTION_DECODE =>
                ALUSrcA <= '0';
                IsSigned <= '1';
                ALUSrcB <= "11";
                OPSelect <= OP_ADD_U;
                if (IR31downto26_ext = x"00")
                    then next_state <= R_TYPE_EXECUTION;
                elsif (IR31downto26_ext = x"09" or IR31downto26_ext = x"10" or
                        IR31downto26_ext = x"0C" or IR31downto26_ext = x"0D" or
                        IR31downto26_ext = x"0E" or IR31downto26_ext = x"0A" or
                        IR31downto26_ext = x"0B")
                    then next_state <= I_TYPE_EXECUTION;
                elsif (IR31downto26_ext = x"23" or IR31downto26_ext = x"2B")
                    then next_state <= MEMORY_ADDRESS_COMPUTATION;
                elsif (IR31downto26_ext = x"04" or IR31downto26_ext = x"05" or
                        IR31downto26_ext = x"06" or IR31downto26_ext = x"07" or
                        IR31downto26_ext = x"01")
                    then next_state <= BRANCH_COMPLETION;
                elsif (IR31downto26_ext = x"02")
                    then next_state <= JUMP;
                elsif (IR31downto26_ext = x"03") -- JAL
                    then next_state <= WRITE_RETURN_ADDR;
                elsif (IR31downto26_ext = x"3F")
                    then next_state <= HALT;
                end if;
            when R_TYPE_EXECUTION =>
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                next_state <= R_TYPE_COMPLETION;
                case IR5downto0_ext is
                    when x"21" => 
                        OpSelect <= OP_ADD_U;
                    when x"23" => 
                        OpSelect <= OP_SUB_U;
                    when x"18" =>
                        OpSelect <= OP_MULT_S;
                        LO_en <= '1';
                        HI_en <= '1'; 
                    when x"19" => 
                        OpSelect <= OP_MULT_U;
                        LO_en <= '1';
                        HI_en <= '1';
                    when x"24" => 
                        OpSelect <= OP_AND;
                    when x"25" => 
                        OpSelect <= OP_OR;
                    when x"26" => 
                        OpSelect <= OP_XOR; 
                    when x"02" =>
                        OpSelect <= OP_SHR_L; 
                    when x"00" =>
                        OpSelect <= OP_SHL_L;
                    when x"03" => 
                        OpSelect <= OP_SHR_A;
                    when x"2A" => 
                        OpSelect <= OP_SLT_S;
                    when x"2B" => 
                        OpSelect <= OP_SLT_U;
                    when x"10" =>
                        ALU_LO_HI <= "10"; 
                        MemToReg <= "00";
                        RegDst <= '1';
                        RegWrite <= '1';
                        next_state <= INSTRUCTION_FETCH;
                    when x"12" =>
                        ALU_LO_HI <= "01";
                        MemToReg <= "00";
                        RegDst <= '1';
                        RegWrite <= '1';
                        next_state <= INSTRUCTION_FETCH;
                    when x"08" =>
                        next_state <= JUMP_REGISTER;
                    when others => report "Invalid R Type instruction." severity note;
                end case;
            when R_TYPE_COMPLETION =>

                ALU_LO_HI <= "00";
                MemToReg <= "00";
                RegDst <= '1';
                RegWrite <= '1';
                next_state <= INSTRUCTION_FETCH;
            when I_TYPE_EXECUTION =>
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                next_state <= I_TYPE_COMPLETION;
                case IR31downto26_ext is
                    when x"09" => 
                        IsSigned <= '1';
                        OpSelect <= OP_ADD_U;
                    when x"10" => 
                        IsSigned <= '1';
                        OpSelect <= OP_SUB_U;
                    when x"0C" =>
                        IsSigned <= '0';
                        OpSelect <= OP_AND;
                    when x"0D" =>
                        IsSigned <= '0';
                        OpSelect <= OP_OR;
                    when x"0E" =>
                        IsSigned <= '0';
                        OpSelect <= OP_XOR;
                    when x"0A" =>
                        IsSigned <= '1';
                        OpSelect <= OP_SLT_S;
                    when x"0B" =>
                        IsSigned <= '1';
                        OpSelect <= OP_SLT_U;
                    when others =>
                        report "Invalid I Type instruction while decoding." severity note;
                        next_state <= INSTRUCTION_FETCH;
                end case;
            when I_TYPE_COMPLETION =>

                ALU_LO_HI <= "00";
                MemToReg <= "00";
                RegDst <= '0';
                RegWrite <= '1';
                next_state <= INSTRUCTION_FETCH;
            when MEMORY_ADDRESS_COMPUTATION => 

                ALUSrcA <= '1';
                IsSigned <= '0';
                ALUSrcB <= "10";
                OpSelect <= OP_ADD_U;
                if (IR31downto26_ext = x"23") then next_state <= MEMORY_ACCESS_READ;
                elsif (IR31downto26_ext = x"2B") then next_state <= MEMORY_ACCESS_WRITE;
                else 
                    report "Invalid memory access instruction." severity note;
                    next_state <= INSTRUCTION_FETCH;
                end if;
            when MEMORY_ACCESS_READ =>

                IorD <= '1';
                MemRead <= '1';
                next_state <= LOAD_MEMORY_DATA_REG;
            when LOAD_MEMORY_DATA_REG =>
                next_state <= MEMORY_READ_COMPLETION;
            when MEMORY_READ_COMPLETION =>
            
                RegDst <= '0';
                MemToReg <= "01";
                RegWrite <= '1';
                next_state <= INSTRUCTION_FETCH;
            when MEMORY_ACCESS_WRITE =>
                IorD <= '1';
                MemWrite <= '1';
                next_state <= INSTRUCTION_FETCH;
            when BRANCH_COMPLETION => 
                PCWriteCond <= '1';
                next_state <= INSTRUCTION_FETCH;
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                PCSource <= "01";

                case IR31downto26_ext is
                    when x"04" => 
                        OpSelect <= OP_BEQ;
                    when x"05" =>
                        OpSelect <= OP_BNE;
                    when x"06" => 
                        OpSelect <= OP_BLTE;
                    when x"07" =>
                        OpSelect <= OP_BGT;
                    when x"01" =>
                        if (IR20downto16 = "00001") then
                            OpSelect <= OP_BGTE;
                        elsif(IR20downto16 = "00000") then
                            OpSelect <= OP_BLT;
                        else report "Unable to determine." severity note;
                        end if;
                    when others => report "Invalid branch instruction." severity note;
                end case;

            when WRITE_RETURN_ADDR =>
                MemToReg <= "10";
                JumpAndLink <= '1';
                RegWrite <= '1';
                next_state <= JUMP;
            when JUMP =>
                PCSource <= "10"; 
                PCWrite <= '1';
                next_state <= INSTRUCTION_FETCH;
            when JUMP_REGISTER =>
                PCSource <= "11";
                PCWrite <= '1';
                next_state <= INSTRUCTION_FETCH;
            when HALT =>
                next_state <= state;
        end case;
    end process;
end FSM;