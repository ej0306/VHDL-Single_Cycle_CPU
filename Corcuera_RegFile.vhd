library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 

entity Corcuera_RegFile IS 

    port (
        Corcuera_Clock : in STD_LOGIC; 
        Corcuera_Wren  : in STD_LOGIC; 
        -- REG_RD
        Corcuera_RegA : in STD_LOGIC_VECTOR (4 downto 0);
        Corcuera_DataIn : in STD_LOGIC_VECTOR (31 downto 0);
        -- REG_RT
        Corcuera_RegB : in STD_LOGIC_VECTOR (4 downto 0);
        Corcuera_Read1 : OUT STD_LOGIC_VECTOR (31 downto 0);
        -- REG_RS
        Corcuera_RegC : in STD_LOGIC_VECTOR (4 downto 0);
        Corcuera_Read2 : out STD_LOGIC_VECTOR (31 downto 0)

    );
end Corcuera_RegFile;

architecture RegisterFile of Corcuera_RegFile is 

type Corcuera_REG_TYPE is array (0 to 31 ) of STD_LOGIC_VECTOR (31 downto 0);
SIGNAL Corcuera_REG_ARRAY : Corcuera_REG_TYPE := 
            (
            X"00000000", X"00000000", X"00000000", X"00000000",   
            X"00000000", X"00000000", X"00000000", X"00000000",    
            X"00000000", X"00000000", X"00000000", X"00000000",   
            X"00000000", X"00000000", X"00000000", X"00000000",  
            X"00000000", X"00000000", X"00000000", X"00000000",    
            X"00000000", X"00000000", X"00000000", X"00000000",    
            X"00000000", X"00000000", X"00000000", X"00000000",    
            X"00000000", X"00000000", X"00000000", X"00000000"   
            );

begin
    process (Corcuera_Clock)
    begin 

    if (RISING_EDGE (Corcuera_Clock)) then 
        if (Corcuera_Wren = '1') then 
            Corcuera_REG_ARRAY(TO_INTEGER(UNSIGNED(Corcuera_RegA))) <= Corcuera_DataIn; 
        end if;
    end if;
    end process; 

    Corcuera_Read1 <= X"00000000" when Corcuera_RegB = "00000" else 
                                            Corcuera_REG_ARRAY(TO_INTEGER(UNSIGNED(Corcuera_RegB)));

    Corcuera_Read2 <= X"00000000" when Corcuera_RegC = "00000" else 
                                            Corcuera_REG_ARRAY(TO_INTEGER(UNSIGNED(Corcuera_RegC)));

end RegisterFile; 