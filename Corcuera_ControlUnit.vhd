library ieee; 
use ieee.std_logic_1164.all;

entity Corcuera_ControlUnit is 
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
end Corcuera_ControlUnit; 

architecture ControlUnit of Corcuera_ControlUnit is 

begin 
    Corcuera_regDst <= '1' when Corcuera_opCode ="000000" else  
                    '0' ;

    Corcuera_ALUsrc <= '0' when Corcuera_opCode = "000000" or Corcuera_opCode = "000100" or 
                             Corcuera_opCode = "000101" else 
                    '1'; 

    Corcuera_PCsrc  <= '1' when Corcuera_opCode = "000100" or Corcuera_opCode = "000101" or 
                             Corcuera_opCode = "000010" else 
                    '0'; 

    Corcuera_RegWr  <= '0' when Corcuera_opCode = "101011" or Corcuera_opCode = "000100" or
                             Corcuera_opCode = "000101" or Corcuera_opCode = "000010" else 
                    '1'; 
                        
    Corcuera_MemWr  <= '1' when Corcuera_opCode = "101011" else 
                    '0';
        
    Corcuera_MemToReg <= '1' when Corcuera_opCode = "100011" else 
                      '0';

    Corcuera_ExtOp    <= '0' when Corcuera_opCode = "001101" or Corcuera_opCode = "001100" else 
                      '1'; 
    
    Corcuera_Jmp      <= '1' when Corcuera_opCode = "000010" else 
                      '0'; 

    Corcuera_ALUop  <= "00" when Corcuera_opCode = "101011" or Corcuera_opCode = "100011" or
                              Corcuera_opCode = "001000" or Corcuera_opCode = "001001" else 
                    "01" when Corcuera_opCode = "000100" or Corcuera_opCode = "000101" else 
                    "11" when Corcuera_opCode = "001101" else 
                    "10"; 



end ControlUnit; 