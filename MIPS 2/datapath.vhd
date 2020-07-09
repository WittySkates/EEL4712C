library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;

entity datapath is
    port(
        clk          : in  std_logic;
        rst          : in  std_logic;
        InPort1_en   : in  std_logic;
        InPort0_en   : in  std_logic;
        InPort       : in  std_logic_vector(31 downto 0); 
        PCWriteCond  : in  std_logic;
        PCWrite      : in  std_logic; 
        IorD         : in  std_logic; 
        MemRead      : in  std_logic; 
        MemWrite     : in  std_logic;
        MemToReg     : in  std_logic_vector(1 downto 0); 
        IRWrite      : in  std_logic; 
        JumpAndLink  : in  std_logic;
        IsSigned     : in  std_logic; 
        PCSource     : in  std_logic_vector(1 downto 0); 
        OpSelect     : in  std_logic_vector(ALU_SEL_SIZE-1 downto 0);
        ALUSrcA      : in  std_logic; 
        ALUSrcB      : in  std_logic_vector(1 downto 0);
        RegWrite     : in  std_logic; 
        RegDst       : in  std_logic; 
        ALU_LO_HI    : in  std_logic_vector(1 downto 0); 
        LO_en        : in  std_logic; 
        HI_en        : in  std_logic; 
        IR31downto26 : out std_logic_vector(5 downto 0); 
        IR5downto0   : out std_logic_vector(5 downto 0); 
        IR20downto16 : out  std_logic_vector(4 downto 0); 
        OutPort      : out std_logic_vector(31 downto 0)
    );
end datapath;

architecture STR of datapath is
    signal PC             : std_logic_vector(31 downto 0); 
    signal ALUOut         : std_logic_vector(31 downto 0); 
    signal ALUOutReg      : std_logic_vector(31 downto 0);
    signal MemAddr        : std_logic_vector(31 downto 0); 
    signal IR             : std_logic_vector(31 downto 0);
    signal WriteRegister  : std_logic_vector( 4 downto 0); 
    signal WriteData      : std_logic_vector(31 downto 0); 
    signal MemData        : std_logic_vector(31 downto 0);
    signal MemDataReg     : std_logic_vector(31 downto 0);
    signal ALUOutSeletion : std_logic_vector(31 downto 0);
    signal RegAIn         : std_logic_vector(31 downto 0); 
    signal RegBIn         : std_logic_vector(31 downto 0);
    signal RegAOut        : std_logic_vector(31 downto 0); 
    signal RegBOut        : std_logic_vector(31 downto 0);
    signal ALUInputA      : std_logic_vector(31 downto 0);
    signal ALUInputB      : std_logic_vector(31 downto 0);
    signal PCInput        : std_logic_vector(31 downto 0); 
    signal HI             : std_logic_vector(31 downto 0); 
    signal HIReg          : std_logic_vector(31 downto 0);
    signal LO             : std_logic_vector(31 downto 0); 
    signal LOReg          : std_logic_vector(31 downto 0);
    signal Branch         : std_logic; 
    signal Mux4ASrc2      : std_logic_vector(31 downto 0); 
    signal Mux4ASrc3      : std_logic_vector(31 downto 0); 
    signal Mux4BSrc2      : std_logic_vector(31 downto 0); 
    signal PC_en          : std_logic;
	 
begin
    U_PROGRAM_COUNTER: entity work.reg
        generic map (
            WIDTH => 32
        )
        port map (
            clk    => clk,
            rst    => rst,
            en     => PC_en,
            input  => PCInput,
            output => PC
        );

    PC_en <= ((Branch and PCWriteCond) or PCWrite);

    U_MEMORY: entity work.memory
        port map (
            clk        => clk,
            rst        => rst,
            address    => MemAddr,
            data       => MemData,
            MemRead    => MemRead,
            MemWrite   => MemWrite,
            InPort1_en => InPort1_en,
            InPort0_en => InPort0_en,
            InPort     => InPort,
            OutPort    => OutPort,
            RegB       => RegBOut
        );

    U_INSTRUCTION_REGISTER: entity work.reg
        generic map (
            WIDTH => 32
        )
        port map (
            clk    => clk,
            rst    => rst,
            en     => IRWrite,
            input  => MemData,
            output => IR
        );

    U_MEMORY_DATA_REGISTER: entity work.reg
        generic map (
            WIDTH => 32
        )
        port map (
            clk    => clk,
            rst    => rst,
            en     => '1',
            input  => MemData,
            output => MemDataReg
        );

    U_MUX_2x1_A: entity work.mux_2x1
        generic map (
            WIDTH => 32
        )
        port map(
            sel    => IorD,
            in0    => PC,
            in1    => ALUOutReg,
            output => MemAddr
        );

    U_MUX_2x1_B: entity work.mux_2x1
        generic map (
            WIDTH => 5
        )
        port map(
            sel    => RegDst,
            in0    => IR(20 downto 16),
            in1    => IR(15 downto 11),
            output => WriteRegister
        );

    U_MUX_4x1_D: entity work.mux_4x1
        generic map (
            WIDTH => 32
        )
        port map(
            sel    => MemToReg,
            in0    => ALUOutSeletion,
            in1    => MemDataReg,
            in2    => PC,
            in3    => std_logic_vector(to_unsigned(0,32)),
            output => WriteData
        );

    U_REGISTERS_FILE: entity work.registers_file
        port map (
            clk           => clk,
            rst           => rst,
            ReadReg1      => IR(25 downto 21),
            ReadReg2      => IR(20 downto 16),
            ReadData1     => RegAIn,
            ReadData2     => RegBIn,
            WriteRegister => WriteRegister,
            WriteData     => WriteData,
            RegWrite      => RegWrite,
            JumpAndLink   => JumpAndLink
        );

    U_REGISTER_A: entity work.reg
        generic map (
            WIDTH => 32
        )
        port map (
            clk    => clk,
            rst    => rst,
            en     => '1',
            input  => RegAIn,
            output => RegAOut
        );

    U_REGISTER_B: entity work.reg
        generic map (
            WIDTH => 32
        )
        port map (
            clk    => clk,
            rst    => rst,
            en     => '1',
            input  => RegBIn,
            output => RegBOut
        );

    U_MUX_2x1_D: entity work.mux_2x1
        generic map (
            WIDTH => 32
        )
        port map(
            sel    => ALUSrcA,
            in0    => PC,
            in1    => RegAOut,
            output => ALUInputA
        );

    U_SIGN_EXTEND_MUX_4A: entity work.extender
        generic map (
            IN_WIDTH => 16,
            OUT_WIDTH => 32
        )
        port map (
            IsSigned => IsSigned,
            input    => IR(15 downto 0),
            output   => Mux4ASrc2
        );

    Mux4ASrc3 <= std_logic_vector(SHIFT_LEFT(unsigned(Mux4ASrc2), 2));

    U_MUX_4x1_A: entity work.mux_4x1
        generic map (
            WIDTH => 32
        )
        port map(
            sel    => ALUSrcB,
            in0    => RegBOut,
            in1    => std_logic_vector(to_unsigned(4, 32)),
            in2    => Mux4ASrc2,
            in3    => Mux4ASrc3,
            output => ALUInputB
        );

    U_ALU: entity work.alu
        generic map (
            WIDTH => 32
        )
        port map(
            Input1   => ALUInputA,
            Input2   => ALUInputB,
            ShiftAmt => IR(10 downto 6),
            OpSelect => OpSelect,
            Result   => ALUOut,
            ResultHi => HI,
            Branch   => Branch
        );

    Mux4BSrc2 <= PC(31 downto 28) & IR(25 downto 0) & "00";

    U_MUX_4x1_B: entity work.mux_4x1
        generic map (
            WIDTH => 32
        )
        port map(
            sel    => PCSource,
            in0    => ALUOut,
            in1    => ALUOutReg,
            in2    => Mux4BSrc2,
            in3    => RegAOut,
            output => PCInput
        );

    U_MUX_4x1_C: entity work.mux_4x1
        generic map (
            WIDTH => 32
        )
        port map(
            sel    => ALU_LO_HI,
            in0    => ALUOutReg,
            in1    => LOReg,
            in2    => HIReg,
            in3    => std_logic_vector(to_unsigned(0, 32)),
            output => ALUOutSeletion
        );

    U_ALU_OUT_REGISTER: entity work.reg
        generic map (
            WIDTH => 32
        )
        port map (
            clk    => clk,
            rst    => rst,
            en     => '1',
            input  => ALUOut,
            output => ALUOutReg
        );

    U_LO_REGISTER: entity work.reg
        generic map (
            WIDTH => 32
        )
        port map (
            clk    => clk,
            rst    => rst,
            en     => LO_en,
            input  => ALUOut,
            output => LOReg
        );

    U_HI_REGISTER: entity work.reg
        generic map (
            WIDTH => 32
        )
        port map (
            clk    => clk,
            rst    => rst,
            en     => HI_en,
            input  => HI,
            output => HIReg
        );

    IR31downto26 <= IR(31 downto 26);
    IR5downto0 <= IR(5 downto 0);
    IR20downto16 <= IR(20 downto 16);

end STR;