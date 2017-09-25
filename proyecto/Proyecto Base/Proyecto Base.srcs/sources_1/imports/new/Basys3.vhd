-- __author__ = "Diego Iruretagoyena"

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

entity Basys3 is
    Port (
        sw          : in   std_logic_vector (2 downto 0);  -- Señales de entrada de los interruptores -- Arriba   = '1'   -- Los 3 swiches de la derecha: 2, 1 y 0.
        btn         : in   std_logic_vector (4 downto 0);  -- Señales de entrada de los botones       -- Apretado = '1'   -- 0 central, 1 arriba, 2 izquierda, 3 derecha y 4 abajo.
        led         : out  std_logic_vector (3 downto 0);  -- Señales de salida  a  los leds          -- Prendido = '1'   -- Los 4 leds de la derecha: 3, 2, 1 y 0.
        clk         : in   std_logic;                      -- No Tocar - Señal de entrada del clock   -- Frecuencia = 100Mhz.
        seg         : out  std_logic_vector (7 downto 0);  -- No Tocar - Salida de las señales de segmentos.
        an          : out  std_logic_vector (3 downto 0)   -- No Tocar - Salida del selector de diplay.
          );
end Basys3;

architecture Behavioral of Basys3 is
-- Inicio de la declaración de los componentes.
component Status 
    Port ( 
           clock    : in  std_logic;                        -- Se?l del clock (reducido).                    
           C        : in  std_logic;                        
           Z        : in  std_logic;                        
           N        : in  std_logic;
           dataout  : out std_logic_vector (2 downto 0)); -- Seniales de salida. Diagrama: 3 bits
end component;

component ROM
    Port (
        address   : in  std_logic_vector(11 downto 0);
        dataout   : out std_logic_vector(32 downto 0)
          );
end component; 

component PC
    Port ( 
           clock    : in  std_logic;
           load     : in  std_logic;
           datain   : in  std_logic_vector (11 downto 0);
           dataout  : out std_logic_vector (11 downto 0));
end component;

component RAM
    Port (
        clock       : in   std_logic;
        write       : in   std_logic;
        address     : in   std_logic_vector (11 downto 0);
        datain      : in   std_logic_vector (15 downto 0);
        dataout     : out  std_logic_vector (15 downto 0)
          );
end component;

component Mux
    Port ( 
           reg_in   : in  std_logic_vector (15 downto 0);
           entrada_zero  : in  std_logic_vector (15 downto 0);
           entrada_1  : in  std_logic_vector (15 downto 0);
           entrada_2  : in  std_logic_vector (15 downto 0);
           entrada_3  : in  std_logic_vector (15 downto 0);
           entrada_selector   : in  std_logic_vector (2 downto 0);
           data_out : out std_logic_vector (15 downto 0));
end component;

component Clock_Divider -- No Tocar
    Port (
        clk         : in    std_logic;
        speed       : in    std_logic_vector (1 downto 0);
        clock       : out   std_logic
          );
    end component;
    
component Display_Controller  -- No Tocar
    Port (  
        dis_a       : in    std_logic_vector (3 downto 0);
        dis_b       : in    std_logic_vector (3 downto 0);
        dis_c       : in    std_logic_vector (3 downto 0);
        dis_d       : in    std_logic_vector (3 downto 0);
        clk         : in    std_logic;
        seg         : out   std_logic_vector (7 downto 0);
        an          : out   std_logic_vector (3 downto 0)
          );
    end component;

component Debouncer  -- No Tocar
    Port (
        clk         : in    std_logic;
        datain      : in    std_logic_vector (4 downto 0);
        dataout     : out   std_logic_vector (4 downto 0));
    end component;

component C_U is
    Port ( 
           opcode   : in  std_logic_vector (16 downto 0); 
           Status   : in  std_logic_vector (2 downto 0); 
           loadPC   : out std_logic;    
           EnableA  : out std_logic;
           EnableB  : out std_logic;
           SelA     : out std_logic_vector (2 downto 0);
           SelB     : out std_logic_vector (2 downto 0);
           SelALU   : out std_logic_vector (2 downto 0);
           W        : out std_logic
         );
end component;

component ALU 
    Port ( 
           a        : in  std_logic_vector (15 downto 0);   -- Primer operando.
           b        : in  std_logic_vector (15 downto 0);   -- Segundo operando.
           sop      : in  std_logic_vector (2 downto 0);    -- Selector de la operación.
           c        : out std_logic;                        -- Señal de 'carry'.
           z        : out std_logic;                        -- Señal de 'zero'.
           n        : out std_logic;                        -- Señal de 'nagative'.
           result   : out std_logic_vector (15 downto 0));  -- Resultado de la operación.    
end component ALU;

component Reg 
    Port ( 
           clock    : in  std_logic;                        -- Señal del clock (reducido).
           load     : in  std_logic;                        -- Señal de carga.
           up       : in  std_logic;                        -- Señal de subida.
           down     : in  std_logic;                        -- Señal de bajada.
           datain   : in  std_logic_vector (15 downto 0);   -- Señales de entrada de datos.
           dataout  : out std_logic_vector (15 downto 0));  -- Señales de salida de datos.
end component;

-- Fin de la declaración de los componentes.
-- Inicio de la declaración de señales.
-- Entrega 1-----------------------------------------------------
-- Señal del clock reducido.
signal clock            : std_logic := '0';        
-- Estas son las salidas a los display de 7 segmentos
signal dis_a            : std_logic_vector(3 downto 0);  -- Señales de salida al display A.    
signal dis_b            : std_logic_vector(3 downto 0);  -- Señales de salida al display B.     
signal dis_c            : std_logic_vector(3 downto 0);  -- Señales de salida al display C.    
signal dis_d            : std_logic_vector(3 downto 0);  -- Señales de salida al display D. 
-- Señal de los botones 
signal d_btn            : std_logic_vector(4 downto 0);  -- Señales de botones con antirrebote.
-- Fin de la declaración de los señales.
--1 arriba, 2 izquierda, 3 derecha y 4 abajo.
signal resultado          : std_logic_vector(15 downto 0);
signal izq_mas            : std_logic;
signal der_mas            : std_logic;
signal izq_men            : std_logic;
signal der_men            : std_logic;
signal primera_entrada     : std_logic_vector(15 downto 0);
signal segunda_entrada     : std_logic_vector(15 downto 0);
signal num_izq : std_logic_vector(15 downto 0);
signal num_der : std_logic_vector(15 downto 0);
-- Entrega 1-----------------------------------------------------
-- Entrega 2-----------------------------------------------------
-- Si ven el diagrama, hay que hacer una signal por cada senal que entre o salga de los componentes. Aca van:
signal Salida_ROM        : std_logic_vector(32 downto 0);
signal Salida_Registro_A       : std_logic_vector(15 downto 0);
signal Salida_Registro_B       : std_logic_vector(15 downto 0);
signal Salida_Mux_A       : std_logic_vector(15 downto 0);
signal Salida_Mux_B       : std_logic_vector(15 downto 0);


signal loadPC            : std_logic; 
signal EnableA           : std_logic;
signal EnableB           : std_logic;

signal SelA              : std_logic_vector(2 downto 0);
signal SelB              : std_logic_vector(2 downto 0);
signal SelALU            : std_logic_vector(2 downto 0);

signal W                 : std_logic;

signal PCDataOut         : std_logic_vector(11 downto 0);


signal resultado_alu         : std_logic_vector(15 downto 0);


signal Salida_RAM       : std_logic_vector(15 downto 0);

-- flags
signal C                 : std_logic;
signal N                 : std_logic;
signal Z                 : std_logic;
signal StatusDataOut     : std_logic_vector(2 downto 0);
-- Entrega 2-----------------------------------------------------
-- Entrega 2-----------------------------------------------------
begin
-- Inicio de declaración de comportamientos.
led(0) <= clock;
izq_mas <= '1' when (btn(1) = '1' and btn(2) = '1') else '0'; 
der_mas <= '1' when (btn(3) = '1' and btn(1) = '1') else '0'; 
izq_men <= '1' when (btn(2) = '1' and btn(4) = '1') else '0'; 
der_men <= '1' when (btn(3) = '1' and btn(4) = '1') else '0';


-- Inicio de declaración de instancias.

--  Instancias Entrega 1 --------------------------------
instancia_Clock_Divider: Clock_Divider port map( -- No Tocar - Intancia de Clock_Divider.
    clk         => clk,  -- No Tocar - Entrada del clock completo (100Mhz).
    speed       => "10", -- Selector de velocidad: "00" full, "01" fast, "10" normal y "11" slow. 
    clock       => clock -- No Tocar - Salida del clock reducido: 25Mhz, 8hz, 2hz y 0.5hz.
    );

instancia_Display_Controller: Display_Controller port map( -- No Tocar - Intancia de Display_Controller.
    dis_a       => dis_a,-- No Tocar - Entrada de señales para el display A.
    dis_b       => dis_b,-- No Tocar - Entrada de señales para el display B.
    dis_c       => dis_c,-- No Tocar - Entrada de señales para el display C.
    dis_d       => dis_d,-- No Tocar - Entrada de señales para el display D.
    clk         => clk,  -- No Tocar - Entrada del clock completo (100Mhz).
    seg         => seg,  -- No Tocar - Salida de las señales de segmentos.
    an          => an    -- No Tocar - Salida del selector de diplay.
	);

instancia_Debouncer: Debouncer port map( -- No Tocar - Intancia de Debouncer.
    clk         => clk,   -- No Tocar - Entrada del clock completo (100Mhz).
    datain      => btn,   -- No Tocar - Entrada del botones con rebote.
    dataout     => d_btn  -- No Tocar - Salida de botones con antirrebote.
    );
    
instancia_reg_izq: Reg port map (
           clock => clock,    
           load => EnableA,   
           up => izq_mas,      
           down => izq_men,    
           datain => resultado_alu,
           dataout => Salida_Registro_A
);

instancia_reg_der: Reg port map (
           clock => clock,    
           load => EnableB,   
           up => der_mas,      
           down => der_men,    
           datain => resultado_alu,
           dataout => Salida_Registro_B
);
-- Esta la tuvimos que cambiar para poder hablar con los MUX
instancia_ALU: ALU port map(
    a        => Salida_Mux_A,
    b        => Salida_Mux_B,
    sop      => SelALU,
    result   => resultado_alu,
    n        => N,
    c        => C,
    z        => Z
    );

--  Instancias Entrega 1 --------------------------------


--  Instancias Entrega 2 --------------------------------

instancia_Mux_A: Mux port map (
    reg_in   => Salida_Registro_A,
    entrada_zero  => "0000000000000000",
    entrada_1  => "0000000000000001",
    entrada_2  => "0000000000000000",
    entrada_3  => "0000000000000001",
    entrada_selector   => SelA,
    data_out => Salida_Mux_A
    );

instancia_Mux_B: Mux port map (
    reg_in   => Salida_Registro_B,
    entrada_zero  => "0000000000000000",
    entrada_1  => Salida_RAM,
    entrada_2  => Salida_ROM(32 downto 17),
    entrada_3  => "0000000000000001",
    entrada_selector   => SelB,
    data_out => Salida_Mux_B
    );

instancia_ROM: ROM port map(
    address   => PCDataOut,
    dataout   => Salida_ROM
    );

instancia_PC: PC port map( -- No Tocar - Intancia de Clock_Divider.
    clock    => clock,
    load     => loadPC,
    datain   => Salida_ROM(28 downto 17),-- Esta se corta segun los bits que necesitamos - Atte. Diegol
    dataout  => PCDataOut
    );

instancia_RAM: RAM port map( -- No Tocar - Intancia de Clock_Divider.
    clock       => clock,
    write       => W,
    address     => Salida_ROM(28 downto 17),-- Esta se corta segun los bits que necesitamos - Atte. Diegol
    datain      => resultado_alu,
    dataout     => Salida_RAM
    );

instancia_Stat: Status port map(
    clock    => clock, 
    C        => C,
    Z        => Z,
    N        => N,
    dataout  => StatusDataOut
    );

instancia_CU: C_U port map(
    opcode   => Salida_ROM(16 downto 0),
    Status   => StatusDataOut,
    loadPC   => loadPC,
    EnableA  => EnableA,
    EnableB  => EnableB,
    SelA     => SelA,
    SelB     => SelB,
    SelALU   => SelALU,
    W        => W
    );

--  Instancias Entrega 2 --------------------------------
-- Con esto indicamos que mostrar en el display de 7 seg., dependiendo de que pide el usuario
dis_a <= resultado_alu(15 downto 12) when (btn(0) = '1') 
          else Salida_Registro_A(7 downto 4);
dis_b <= resultado_alu(11 downto 8) when (btn(0) = '1') 
          else Salida_Registro_A(3 downto 0);
dis_c <= resultado_alu(7 downto 4) when (btn(0) = '1') 
          else Salida_Registro_B(7 downto 4);
dis_d <= resultado_alu(3 downto 0) when (btn(0) = '1') 
          else Salida_Registro_B(3 downto 0);

-- Fin de declaración de comportamientos.
  
end Behavioral;
