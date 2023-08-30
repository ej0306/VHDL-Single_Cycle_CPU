library iEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity Corcuera_DataMemory IS 
port (
        Corcuera_MAR: in STD_LOGIC_VECTOR (3 downto 0); 
        Corcuera_MDR: in STD_LOGIC_VECTOR (31 downto 0); 
        Corcuera_WREN : in STD_LOGIC ; 
        Corcuera_CLOCK: in STD_LOGIC; 
        Corcuera_DataOut: out STD_LOGIC_VECTOR(31 downto 0)
    );

end Corcuera_DataMemory;

architecture data_memory of Corcuera_DataMemory is 
type Corcuera_RAM_ARRAY is array (0 to 15) OF STD_LOGIC_VECTOR (31 downto 0); 

signal Corcuera_RAM: Corcuera_RAM_ARRAY := 
                    (
                        X"0000000a", X"00000014", X"0000001e", X"00000028",   
                        X"00000032", X"00000000", X"00000000", X"00000000",   
                        X"00000000", X"00000000", X"00000000", X"00000000",   
                        X"00000000", X"00000000", X"00000000", X"00000000"    
                   
                    );

begin 

process (Corcuera_CLOCK)
    begin
        if (RISING_EDGE (Corcuera_CLOCK)) then 
            if (Corcuera_WREN = '1') then
                Corcuera_RAM(TO_INTEGER(UNSIGNED(Corcuera_MAR))) <= Corcuera_MDR; 
            end if; 
        end if; 
    end process; 

Corcuera_DataOut <=  Corcuera_RAM(TO_INTEGER(UNSIGNED(Corcuera_MAR))); 

end data_memory; 