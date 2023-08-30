library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_signed.all; 

entity Corcuera_Mux2x1 IS
    generic (n : integer := 32);
    port ( 
        Corcuera_V, Corcuera_W : in STD_LOGIC_VECTOR (n-1 downto 0) ;
        Corcuera_Sel : in STD_LOGIC ;
        Corcuera_MuxOut : OUT STD_LOGIC_VECTOR (n-1 downto 0) ) ;

end Corcuera_Mux2x1 ;

architecture Mux2x1 OF Corcuera_Mux2x1 IS
begin
    process ( Corcuera_V, Corcuera_W, Corcuera_Sel )
        begin
        if Corcuera_Sel = '0' then
            Corcuera_MuxOut <= Corcuera_V ;
        else
            Corcuera_MuxOut <=Corcuera_W ;
        end if ;
    end process ;
end Mux2x1 ;