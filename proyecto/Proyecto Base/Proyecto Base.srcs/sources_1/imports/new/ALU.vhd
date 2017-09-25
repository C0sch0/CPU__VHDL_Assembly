-- __author__ = "Diego Iruretagoyena"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    Port ( 
           a        : in  std_logic_vector (15 downto 0);   -- Primer operando.
           b        : in  std_logic_vector (15 downto 0);   -- Segundo operando.
           sop      : in  std_logic_vector (2 downto 0);    -- Selector de la operación.
           c        : out std_logic;                        -- Señal de 'carry'.
           z        : out std_logic;                        -- Señal de 'zero'.
           n        : out std_logic;                        -- Señal de 'nagative'.
           result   : out std_logic_vector (15 downto 0));  -- Resultado de la operación.
end ALU;

architecture Behavioral of ALU is
component SUM is
  port (
        a          : in   std_logic_vector (15 downto 0) ;  
        b          : in   std_logic_vector (15 downto 0) ; 
        c_in       : in   std_logic ;  
        c_out      : out  std_logic ;
        n          : out std_logic;  
        s          : out  std_logic_vector (15 downto 0));
end component SUM;

component RESTA is
  port (
        a          : in   std_logic_vector (15 downto 0) ;  
        b          : in   std_logic_vector (15 downto 0) ; 
        c_in       : in   std_logic ;  
        c_out      : out  std_logic ;
        n          : out std_logic;  
        s          : out  std_logic_vector (15 downto 0)   
    
  );
end component RESTA;

signal result_sum : std_logic_vector (15 downto 0) ; 
signal result_rest : std_logic_vector (15 downto 0) ; 

-- Este es para eliminar error al intentar comparar usando senal de out
signal buffer_resultado      : std_logic_vector (15 downto 0) ; 
signal buffer_c              : std_logic; 
signal buffer_c_salida_sum   : std_logic;
signal buffer_c_salida_rest  : std_logic;
signal buffer_salida_n_sum       : std_logic;
signal buffer_salida_n_rest       : std_logic;
begin


sumador: SUM port map (
          a => a,
          b => b,
          c_in => buffer_c,
          c_out => buffer_c_salida_sum,
          n => buffer_salida_n_sum,
          s => result_sum); 

rest: Resta port map (
          a => a,
          b => b,
          c_in => buffer_c,
          c_out => buffer_c_salida_rest,
          n => buffer_salida_n_rest,
          s => result_rest);

-- Aca el manejo del resultado, segun el valor de sop. Itera sobre sop y revisa con que sop calza
with sop select
      buffer_resultado <= (result_rest) when "001",
                (result_sum) when "000",
                (a and b) when "010",
                (a or b) when "011",
                (not a) when "100",
                (a xor b) when "101",
                (a(14 downto 0) & '0') when "110",
                ('0' & a(15 downto 1)) when "111",
                (a or b) when others;

z <= '1' when (buffer_resultado = "0000000000000000") else '0';

c <= buffer_c_salida_sum when (sop="000") else 
    '1' when (sop= "001" and a >= b) else 
    a(15) when (sop="110") else 
    a(0) when (sop="111") else 
    '0';

--c <= buffer_c_salida_sum when (sop = "000" or sop = "001") else 
--     a(0) when (sop="010") else
--     a(15) when (sop="100") else
--     a(0) when (sop="111") else 
--     a(15) when (sop="110") else 
--    '0';
--  Sugerencia flag C - Diego

result <= buffer_resultado;
n <= '1' when (sop = "001" and a < b) else '0';


end Behavioral;
---------------- 



