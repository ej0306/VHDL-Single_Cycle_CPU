library ieee; 
use ieee.numeric_std.all; 
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;

entity Corcuera_CPU is 
    port (
            Corcuera_Clock, Corcuera_Reset: in std_logic; 
            Corcuera_PC_OUT, Corcuera_ALU_Result: out std_logic_vector(31 downto 0)
    );
end Corcuera_CPU; 



architecture CPU of Corcuera_CPU is 

component Corcuera_Instruction_Memory
    port (
            Corcuera_PC : in std_logic_vector(31 downto 0);
            Corcuera_Instr: out std_logic_vector(31 downto 0)
    );
end component;

component Corcuera_Data_Memory 
    port (
        Corcuera_MAR: in std_logic_vector (3 DOWNTO 0); 
        Corcuera_MDR: in std_logic_vector (31 DOWNTO 0); 
        Corcuera_WREN : in std_logic ; 
        Corcuera_Clock: in std_logic; 
        Corcuera_DataOut: out std_logic_vector(31 DOWNTO 0)
    );
end component;

component Corcuera_Register_File 
    port (
        Corcuera_Clock : in std_logic; 
        Corcuera_Wren  : in std_logic; 
      
        Corcuera_RegA : in std_logic_vector (4 DOWNTO 0);
        Corcuera_DataIn : in std_logic_vector (31 DOWNTO 0);
       
        Corcuera_RegB : in std_logic_vector (4 DOWNTO 0);
        Corcuera_Read1 : out std_logic_vector (31 DOWNTO 0);
        
        Corcuera_RegC : in std_logic_vector (4 DOWNTO 0);
        Corcuera_Read2 : out std_logic_vector (31 DOWNTO 0)
    );
end component;

component Corcuera_ALU
    port (
        Corcuera_srcA, Corcuera_srcB: in std_logic_vector (31 downto 0);
        Corcuera_ALUctr: in std_logic_vector (3 downto 0);
        Corcuera_Shamt: in std_logic_vector (4 downto 0);
        Corcuera_ALUOut: out std_logic_vector (31 downto 0);
        Corcuera_Ovf, Corcuera_Neg, Corcuera_Zero: out std_logic 
    );
end component;

component Corcuera_Mux_2_1
    generic (n : integer := 32);
    PORT ( 
    Corcuera_V, Corcuera_W : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0) ;
    Corcuera_Sel : IN STD_LOGIC ;
    Corcuera_MuxOut : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0) 
    ) ;
end component;

component Corcuera_Control_Unit
    port (
        Corcuera_opCode : in std_logic_vector(5 downto 0);
        Corcuera_ALUop : out std_logic_vector(1 downto 0);
        Corcuera_PCsrc : out std_logic;
        Corcuera_ALUsrc : out std_logic;
        Corcuera_regDst: out std_logic;
        Corcuera_RegWr : out std_logic;
        Corcuera_MemWr : out std_logic;
        Corcuera_ExtOp : out std_logic;
        Corcuera_Jmp : out std_logic;
        Corcuera_MemToReg : out std_logic 
    );
end component;

component Corcuera_Alu_Control
    port (
        Corcuera_ALUop : in std_logic_vector (1 downto 0);
        Corcuera_Funct : in std_logic_vector (5 downto 0);
        Corcuera_ALUctr : out std_logic_vector (3 downto 0)
    );
end component;




signal Corcuera_currentPC: std_logic_vector(31 downto 0);
signal Corcuera_nextPC, PC4: std_logic_vector(31 downto 0);
signal Corcuera_BranchAddr : std_logic_vector(31 downto 0);
signal Corcuera_JumpAddr : std_logic_vector(31 downto 0);

signal Corcuera_PC_Branch : std_logic_vector(31 downto 0);

signal Corcuera_Instr : std_logic_vector(31 downto 0);

signal Corcuera_ALUop :  std_logic_vector(1 downto 0);
signal Corcuera_PCsrc :  std_logic;
signal Corcuera_ALUsrc :  std_logic;
signal Corcuera_regDst:  std_logic;
signal Corcuera_RegWr :  std_logic;
signal Corcuera_MemWr :  std_logic;
signal Corcuera_ExtOp :  std_logic;
signal Corcuera_Jmp :  std_logic;
signal Corcuera_MemToReg :  std_logic; 

signal RtOrRd : std_logic_vector(4 downto 0);
signal Corcuera_DataIn : std_logic_vector(31 downto 0);
signal Corcuera_RegB, Corcuera_RegC: std_logic_vector (4 DOWNTO 0);

signal Corcuera_Read1 : std_logic_vector(31 downto 0);
signal Corcuera_Read2 : std_logic_vector(31 downto 0);

signal Corcuera_ALUctr : std_logic_vector(3 downto 0); 
signal Corcuera_ALUOut : std_logic_vector(31 downto 0);
signal Corcuera_Ovf, Corcuera_Neg, Corcuera_Zero: std_logic;
signal Corcuera_DataOut : std_logic_vector(31 downto 0);

signal Corcuera_AluBus_B : std_logic_vector(31 downto 0);

signal Sign_Temp : std_logic_vector (15 downto 0);
signal Imm_Ext, Sign_Ext, Zero_Ext: std_logic_vector (31 downto 0);

signal EXT_IMM_SHIFT_2 : std_logic_vector (31 downto 0);

signal branch: std_logic; 

begin

process(Corcuera_Clock, Corcuera_Reset)
begin
    if(Corcuera_Reset = '1') then
        Corcuera_currentPC <= X"00400000";
    elsif (rising_edge(Corcuera_Clock)) then 
        Corcuera_currentPC <= Corcuera_nextPC;
    end if; 
end process; 

PC4 <= Corcuera_currentPC + x"4";


Instr_Mem: Corcuera_Instruction_Memory 
        port map (Corcuera_currentPC, Corcuera_Instr);


Cont_Unit: Corcuera_Control_Unit 
        port map (Corcuera_Instr(31 downto 26), Corcuera_ALUop, Corcuera_PCsrc,
                    Corcuera_ALUsrc, Corcuera_regDst, Corcuera_RegWr, Corcuera_MemWr,
                                    Corcuera_ExtOp, Corcuera_Jmp, Corcuera_MemToReg);

Mux_RegDst: Corcuera_Mux_2_1 
        generic map (n => 5 ) 
        port map (Corcuera_Instr(20 downto 16), 
            Corcuera_Instr(15 downto 11), Corcuera_regDst, RtOrRd);

    Corcuera_RegB <= Corcuera_Instr(25 downto 21);
    Corcuera_RegC <= Corcuera_Instr(20 downto 16);

Reg_File: Corcuera_Register_File
        port map (Corcuera_Clock, Corcuera_RegWr, RtOrRd, Corcuera_DataIn, Corcuera_RegB, 
                    Corcuera_Read1, Corcuera_RegC, Corcuera_Read2 );

    Sign_Temp <= (others => Corcuera_Instr(15));
    Sign_Ext <= Sign_Temp & Corcuera_Instr(15 downto 0);
    Zero_Ext <= X"0000" &  Corcuera_Instr(15 downto 0);
    Imm_Ext <= sign_Ext when Corcuera_ExtOp  = '1' else Zero_Ext; 

Alu_Contr: Corcuera_Alu_Control
        port map (Corcuera_ALUop, Corcuera_Instr(5 downto 0), Corcuera_ALUctr);

    Corcuera_AluBus_B <= Imm_Ext when Corcuera_ALUsrc = '1' else Corcuera_Read2;


ALU: Corcuera_ALU
        port map (Corcuera_Read1, Corcuera_AluBus_B, Corcuera_ALUctr, Corcuera_Instr(10 downto 6),
                Corcuera_ALUOut, Corcuera_Ovf, Corcuera_Neg, Corcuera_Zero );


    EXT_IMM_SHIFT_2 <= Imm_Ext(29 downto 0) & "00"; 
    Corcuera_BranchAddr <= PC4 + EXT_IMM_SHIFT_2; 
    Corcuera_JumpAddr <= "000000" & (Corcuera_Instr(23 downto 0) & "00");
    
    branch <= Corcuera_PCsrc and Corcuera_Zero ; 

    Corcuera_PC_Branch <= Corcuera_JumpAddr when Corcuera_Jmp = '1' else
                        Corcuera_BranchAddr when branch = '1';
                         

    Corcuera_nextPC <= Corcuera_PC_Branch when branch = '1' else PC4; 


Data_Mem: Corcuera_Data_Memory
         port map (Corcuera_ALUOut(5 downto 2), Corcuera_Read2, Corcuera_MemWr, 
                                Corcuera_Clock, Corcuera_DataOut );


    Corcuera_DataIn <= Corcuera_DataOut when Corcuera_MemToReg = '1' else Corcuera_ALUOut; 
    
    Corcuera_PC_Out <= Corcuera_currentPC;
    Corcuera_ALU_Result <= Corcuera_ALUOut;


end CPU;