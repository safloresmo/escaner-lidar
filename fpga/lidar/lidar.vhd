library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
   port(
      clk        : in  std_logic;                         -- Reloj del sistema (50 MHz)
      reset      : in  std_logic;                         -- Reset asíncrono
      pd         : in  std_logic_vector(7 downto 0);        -- pd(0) se usará para UART RX
      distance   : out std_logic_vector(15 downto 0);       -- Salida de distancia (16 bits)
      data_valid : out std_logic                          -- Indica paquete válido
   );
end top;

architecture Behavioral of top is

   -- Instancia del módulo tfmini_interface
   component tfmini_interface is
      port(
         clk        : in  std_logic;
         reset      : in  std_logic;
         pd         : in  std_logic_vector(7 downto 0);
         distance   : out std_logic_vector(15 downto 0);
         data_valid : out std_logic
      );
   end component;

   -- Instancia del ILA
   component ila_0 is
      port (
         clk    : in std_logic;
         probe0 : in std_logic_vector(15 downto 0);  -- Conectamos "distance"
         probe1 : in std_logic_vector(0 downto 0)    -- Conectamos "data_valid" (1 bit)
      );
   end component;

   -- Señal para convertir data_valid (std_logic) a vector de 1 bit
   signal data_valid_vec : std_logic_vector(0 downto 0);

begin

   U1: tfmini_interface
      port map(
         clk        => clk,
         reset      => reset,
         pd         => pd,
         distance   => distance,
         data_valid => data_valid
      );

   -- Convertimos data_valid a un vector de 1 bit para el ILA
   data_valid_vec(0) <= data_valid;

   U2: ila_0
      port map(
         clk    => clk,
         probe0 => distance,
         probe1 => data_valid_vec
      );

end Behavioral;
