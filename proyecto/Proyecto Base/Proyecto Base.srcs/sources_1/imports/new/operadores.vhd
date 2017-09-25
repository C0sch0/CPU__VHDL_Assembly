-- __author__ = "Diego Iruretagoyena"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM is
    Port (
        a          : in   std_logic_vector (15 downto 0) ;  
        b          : in   std_logic_vector (15 downto 0) ; 
        c_in       : in   std_logic ;  
      	c_out      : out  std_logic ;
        n          : out  std_logic ;   
        s          : out  std_logic_vector (15 downto 0)                      
          );
end SUM;

architecture bhd of SUM is

  component FA is
    port (a          : in   std_logic ;  
        b          : in   std_logic ;  
        c_in       : in   std_logic ;  
        c_out      : out  std_logic ;  
        s          : out  std_logic);
  end component FA;

signal carry_interno :  std_logic_vector (16 downto 0);

begin

  suma: for n in 0 to 15 generate
        sumador: FA port map (
          a => a(n),
          b => b(n),
          s => s(n),
          c_in => carry_interno(n),
          c_out => carry_interno(n+1)
        );
    end generate;

-- carry_interno(0) <= c_in
c_out <= carry_interno(16);
n <= '1' when (c_in = '1' and a < b) else '0';

end bhd;



