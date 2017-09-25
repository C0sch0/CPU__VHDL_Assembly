-- __author__ = "Diego Iruretagoyena"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
    Port (
        a          : in   std_logic ;  
        b          : in   std_logic ;  
        c_in       : in   std_logic ;  
      	c_out      : out  std_logic ;  
        s          : out  std_logic                       
          );
end FA;

architecture bhd of FA is

begin

s <= (a xor b) xor c_in;
c_out <= ((a xor b) and c_in) when c_in ='1' else (a and b); 
	
end architecture bhd;