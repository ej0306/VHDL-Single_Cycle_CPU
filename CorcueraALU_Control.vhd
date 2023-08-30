library ieee; 
use ieee.std_logic_1164.all;

entity CorcueraALU_Control is 
  port (
    Corcuera_ALU_op : in std_logic_vector (1 downto 0);
    Corcuera_fnct : in std_logic_vector (5 downto 0);
    Corcuera_ALUctr : out std_logic_vector (3 downto 0)
  ); 
end CorcueraALU_Control; 

architecture AluControl of CorcueraALU_Control is
begin 
    Corcuera_ALUctr <= "0010" when Corcuera_ALU_op = "00" or (Corcuera_ALU_op = "10" and Corcuera_fnct = "100000") else
                    "0110" when Corcuera_ALU_op = "01" or (Corcuera_ALU_op = "10" and Corcuera_fnct = "100010") else 
                    "0011" when (Corcuera_ALU_op = "10" and Corcuera_fnct = "100001") else 
                    "0111" when (Corcuera_ALU_op = "10" and Corcuera_fnct = "100011") else 
                    "0000" when (Corcuera_ALU_op = "10" and Corcuera_fnct = "100100") else 
                    "0001" when (Corcuera_ALU_op = "10" and Corcuera_fnct = "100101") else 
                    "1100" when (Corcuera_ALU_op = "10" and Corcuera_fnct = "100111") else 
                    "1000" when (Corcuera_ALU_op = "10" and Corcuera_fnct = "000000") else 
                    "1001" when (Corcuera_ALU_op = "10" and Corcuera_fnct = "000010") else 
                    "1011" when (Corcuera_ALU_op = "10" and Corcuera_fnct = "000011") else 
                    "0000" when (Corcuera_ALU_op = "10" ) else 
                    "0001" when (Corcuera_ALU_op = "11" ) else 
                    "0010";

end AluControl;