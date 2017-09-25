-- __author__ = "Diego Iruretagoyena"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux is
    Port ( reg_in   : in  std_logic_vector (15 downto 0); -- Lo que nos llega del Registro
           entrada_zero  : in  std_logic_vector (15 downto 0); -- Input Cero
           entrada_1  : in  std_logic_vector (15 downto 0); -- Registro A = 1 // RegB = literal
           entrada_2  : in  std_logic_vector (15 downto 0); -- Registro A = 0 // RegB = RAMDataIn
           entrada_3  : in  std_logic_vector (15 downto 0); -- 
           entrada_selector   : in  std_logic_vector (2 downto 0); -- Selector de que operacion hacer
           data_out : out std_logic_vector (15 downto 0));-- Salida del mux 
end Mux;


architecture Behavioral of Mux is
begin

with entrada_selector select
    data_out <= reg_in when "000", entrada_zero when "010", entrada_1 when "100", entrada_3 when "001", entrada_2 when others; 

end Behavioral;



