library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;  

entity Corcuera_InsMemory is 
port (
 
    Corcuera_PC : int STD_LOGIC_VECTOR (31 downto 0); 
    Corcuera_Instr : out STD_LOGIC_VECTOR (31 downto 0)

    );
end Corcuera_InsMemory; 

architecture instr_mem of Corcuera_InsMemory is 

signal Corcuera_INSTR_ADDR : STD_LOGIC_VECTOR (4 downto 0); 


type Corcuera_ROM_TYPE is array (0 TO 31) OF  STD_LOGIC_VECTOR (31 downto 0); 

constant Corcuera_ROM_DATA: Corcuera_ROM_TYPE:= 
    (     
        X"02008024", X"22310005", X"00802024", X"01004024", 
        X"01204824", X"12110007", X"3c011001", X"00240821", 
        X"8c280000", X"01284820", X"20840004", X"22100001", 
        X"08100005", X"00000000", X"00000000", X"00000000", 
        X"00000000", X"00000000", X"00000000", X"00000000", 
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000"
    );

begin 

Corcuera_INSTR_ADDR <= Corcuera_PC(6 downto 2);
Corcuera_Instr <= Corcuera_ROM_DATA(TO_INTEGER(UNSIGNED(Corcuera_INSTR_ADDR))); 

end instr_mem; 