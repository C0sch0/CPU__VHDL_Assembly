-- __author__ = "Diego Iruretagoyena"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Status is
    Port ( clock    : in  std_logic;                        -- Se?l del clock (reducido).                    
           C        : in  std_logic;                        
           Z        : in  std_logic;                        
           N        : in  std_logic;
           dataout  : out std_logic_vector (2 downto 0));  -- Se?les de salida de datos.
end Status;

architecture Behavioral of Status is

signal reg : std_logic_vector(2 downto 0) := (others => '0'); -- Se?les del registro. Parten en 0.

begin

reg_prosses : process (clock)           -- Proceso sensible a clock.
        begin
          if (rising_edge(clock)) then  -- Condici? de flanco de subida de clock.
              reg(2) <= C;
              reg(1) <= Z;
              reg(0) <= N;
          end if;
        end process;
        
dataout <= reg;                         -- Los datos del registro salen sin importar el estado de clock.
            
end Behavioral;