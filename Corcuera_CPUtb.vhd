library ieee ;
USE ieee.std_logic_1164.all ;
use ieee.std_logic_signed.all; 

entity Corcuera_CPUtb is 

end Corcuera_CPUtb;

architecture CPUtb of Corcuera_CPUtb is 

component Corcuera_CPU is 
port (
        Corcuera_Clock, Corcuera_Reset: in std_logic; 
        Corcuera_PC_OUT, Corcuera_ALU_Result: out std_logic_vector(31 downto 0)
);
end component;


signal Corcuera_Clock, Corcuera_Reset:  std_logic; 
signal Corcuera_PC_OUT, Corcuera_ALU_Result:  std_logic_vector(31 downto 0);


constant Clock_Period : time := 10 ns; 

begin 
Inst_CPU: Corcuera_CPU 
            port map ( Corcuera_Clock, Corcuera_Reset,
                    Corcuera_PC_OUT, Corcuera_ALU_Result);

Clock_Process: process
begin

    Corcuera_Clock <= '0'; 
    wait for Clock_Period/2;
    Corcuera_Clock <= '1'; 
    wait for Clock_Period/2;

end process; 

Sim_Process: process
begin 

    Corcuera_Reset <= '1'; 
    wait for Clock_Period*10; 
    Corcuera_Reset <= '0'; 

    wait;
end process; 




end CPUtb; 