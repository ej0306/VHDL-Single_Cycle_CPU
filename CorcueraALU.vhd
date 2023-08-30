library ieee; 
use ieee.numeric_std.all; 
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;


entity CorcueraALU is 
  port (
      Corcuera_Asrc, Corcuera_Bsrc: in std_logic_vector (31 downto 0);
      Corcuera_ALUctr: in std_logic_vector (3 downto 0);
      Corcuera_shamt: in std_logic_vector (4 downto 0);
      Corcuera_ALUOut: out std_logic_vector (31 downto 0);
      Corcuera_Ovf, Corcuera_Neg, Corcuera_Zero: out std_logic 
 ); 
end CorcueraALU; 

architecture ALU_Unit of CorcueraALU is
    signal offset: integer;
    signal Corcuera_Result : std_logic_vector (32 downto 0);
    signal Corcuera_ZeroTemp: std_logic_vector (31 downto 0);
    signal Corcuera_SignTemp: std_logic_vector (31 downto 0);

    begin
        Corcuera_ZeroTemp <= X"00000000";  
        Corcuera_SignTemp <= (others => Corcuera_Bsrc(31));
        offset <= to_integer(unsigned(Corcuera_shamt));

        process (Corcuera_ALUctr, Corcuera_Asrc, Corcuera_Bsrc, Corcuera_shamt )
        begin 
            case Corcuera_ALUctr is 
            when "0000" => 
                Corcuera_Result <= ('0' & Corcuera_Asrc) and ('0' & Corcuera_Bsrc) ;
            when "0001" =>
                Corcuera_Result <= ('0' & Corcuera_Asrc) or ('0' & Corcuera_Bsrc) ;
            when "0010" => 
                Corcuera_Result <= ('0' & Corcuera_Asrc) + ('0' & Corcuera_Bsrc) ;
            when "0110" => 
                Corcuera_Result <= ('0' & Corcuera_Asrc) - ('0' & Corcuera_Bsrc) ;
            when "0011" => 
                Corcuera_Result <= ('0' & Corcuera_Asrc) + ('0' & Corcuera_Bsrc) ;
            when "0111" => 
                Corcuera_Result <= ('0' & Corcuera_Asrc) - ('0' & Corcuera_Bsrc) ;

            when "1000" => 
                Corcuera_Result <=  '0' & (Corcuera_Bsrc((31 - offset) downto 0) & 
                                    Corcuera_ZeroTemp((offset - 1) downto 0) );
            when "1001" => 
                Corcuera_Result <=  '0' & (Corcuera_ZeroTemp((offset - 1) downto 0) & 
                                    Corcuera_Bsrc(31 downto offset) );
            when "1011" => 
                Corcuera_Result <=  '0' & (Corcuera_SignTemp((offset - 1) downto 0) & 
                                    Corcuera_Bsrc(31 downto offset) );

            when others => Corcuera_Result <= '0' & X"00000000";
            end case; 
        end process; 

        Corcuera_ALUOut <= Corcuera_Result(31 downto 0);
        Corcuera_Zero <= '1' when Corcuera_Result = X"00000000" else '0'; 
        Corcuera_Ovf  <= '0' when Corcuera_ALUctr = "0011" or  Corcuera_ALUctr = "0111" else 
                    Corcuera_Result(32) xor Corcuera_Result (31);
        Corcuera_Neg <= Corcuera_Result(31);
            

end ALU_Unit;