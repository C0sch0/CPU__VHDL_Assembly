-- __author__ = "Diego Iruretagoyena"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity C_U is
    Port (   
           -- Entran -- 
           opcode   : in  std_logic_vector (16 downto 0); 
           Status   : in  std_logic_vector (2 downto 0);
           -- Salen -- 
           EnableA  : out std_logic;
           EnableB  : out std_logic;
           loadPC   : out std_logic;
           SelA     : out std_logic_vector (2 downto 0);
           SelB     : out std_logic_vector (2 downto 0);
           SelALU   : out std_logic_vector (2 downto 0);
           W        : out std_logic
         );
end C_U;

architecture Behavioral of C_U is
    type memory_array is array (0 to 70) of std_logic_vector (12 downto 0);
signal Z : std_logic;
signal N : std_logic;
signal C : std_logic;
signal dataout : std_logic_vector(12 downto 0) := (others => '0');
signal memory : memory_array:= (


"0100100000000", 
"0010000100000", 
"0100101100000", 
"0010101100000", 
"0100101000000", 
"0010101000000", 
"0000000100001", 
"0000100000001", 
"0100000000000",
"0010000000000", 
"0100001100000", 
"0010001100000", 
"0100001000000", 
"0010001000000", 
"0000000000001", 
"0100000000010", 
"0010000000010", 
"0100001100010", 
"0010001100010", 
"0100001000010", 
"0010001000010", 
"0000000000011", 
"0100000000100", 
"0010000000100", 
"0100001100100", 
"0010001100100", 
"0100001000100", 
"0010001000100", 
"0000000000101", 
"0100000000110", 
"0010000000110", 
"0100001100110", 
"0010001100110", 
"0100001000110", 
"0010001000110", 
"0000000000111", 
"0100000001000", 
"0010000001000", 
"0100001101000", 
"0010001101000",
"0100001001000", 
"0010001001000", 
"0000000001001", 
"0100000101010", 
"0010000101010", 
"0000000101011", 
"0100000101100", 
"0010000101100", 
"0000000101101", 
"0100000101110",
"0010000101110", 
"0000000101111", 
"0100000010000", 
"0011000000000", 
"0001001000001", 
"0011000000010", 
"1000000000000", 
"1000000000000", 
"1000000000000", 
"1000000000000", 
"1000000000000", 
"1000000000000", 
"1000000000000", 
"1000000000000", 
"0000000000000", 
"0000101000000", 
"0000000000010", 
"0000001100010", 
"0000001000010", 
"0010100100000", 
"0100000010010"  
  );


begin

--dataout <= memory(to_integer(unsigned(opcode))); 
C <= Status(2);
Z <= Status(1);
N <= Status(0);
process(opcode)
begin
case opcode(6 downto 0) is

  -- JLT when N = 1
  when "0111101" =>
    if N = '0' then
      dataout  <= "0000000000000";
    else dataout <= memory(to_integer(unsigned(opcode))); 
    end if;

  -- JLE when N = 1 o Z = 1
  when "0111110" =>
    if N = '0' and Z = '0' then -- Ignacio: se cambio N = '1' por N = '0'
      dataout  <= "0000000000000";
    else dataout <= memory(to_integer(unsigned(opcode))); 
    end if;

  -- JCR when C = 1
  when "0111111" =>
    if C = '0' then
      dataout  <= "0000000000000";
    else dataout <= memory(to_integer(unsigned(opcode))); 
    end if;

  -- JEQ when Z = 1
  when "0111001" =>
    if Z = '0' then
      dataout  <= "0000000000000";
    else dataout <= memory(to_integer(unsigned(opcode))); 
    end if;

  -- JNE when Z = 0
  when "0111010" =>
    if Z = '1' then
      dataout  <= "0000000000000";
    else dataout <= memory(to_integer(unsigned(opcode))); 
    end if;

  -- JGT when N = 0 y Z = 0
  when "0111011" =>
    if Z = '1' or N = '1' then 
      dataout  <= "0000000000000";
    else dataout <= memory(to_integer(unsigned(opcode))); 
    end if;

  -- JGE when N = 0
  when "0111100" =>
    if N = '1' then
      dataout  <= "0000000000000";
    else dataout <= memory(to_integer(unsigned(opcode))); 
    end if;

  when others  =>  dataout <= memory(to_integer(unsigned(opcode))); 
end case;
end process;

SelA    <= dataout(9 downto 7); 
SelB    <= dataout(6 downto 4); 
SelALU  <= dataout(3 downto 1); 
W       <= dataout(0); 
loadPC  <= dataout(12); 
EnableA <= dataout(11); 
EnableB <= dataout(10); 

end Behavioral;