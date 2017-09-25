-- __author__ = "Diego Iruretagoyena"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RESTA is
    Port(
        a          : in   std_logic_vector(15 downto 0) ;  
        b          : in   std_logic_vector (15 downto 0) ; 
        c_in       : in   std_logic ;  
        c_out      : out  std_logic ;  
        s          : out  std_logic_vector (15 downto 0) ;
        n      : out  std_logic                    
        );

end entity RESTA;

architecture bhd of RESTA is

  component FA is
    port (a          : in   std_logic ;  
        b          : in   std_logic ;  
        c_in       : in   std_logic ;  
        c_out      : out  std_logic ;  
        s          : out  std_logic);
  end component FA;

signal carry_interno : std_logic_vector(16 downto 0);
signal b_alt : std_logic_vector(15 downto 0);
  
begin

b_alt <= not (b);
carry_interno(0) <= '1';

  REST: for n in 0 to 15 generate
        sumador: FA port map (
          a => a(n),
          b => b_alt(n),
          s => s(n),
          c_in => carry_interno(n),
          c_out => carry_interno(n+1)
        );
    end generate;

c_out <= carry_interno(16);
n <= '1' when a < b else '0';  
end bhd;

