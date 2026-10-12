----------------------------------------------------------------------------------
-- Nombre del Módulo: tfmini_interface
-- Dispositivos Objetivo: PYNQ-Z1
-- Descripción: Lee el sensor TFmini-S por UART. Recibe los bytes de la línea serie,
--              busca la cabecera 0x59 0x59 de cada trama de 9 bytes, comprueba la
--              suma y entrega la distancia en centímetros.
--
--              Reconstruido después de la residencia: el archivo original quedó
--              solo con la plantilla. Está simulado, no probado en la placa.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tfmini_interface is
   generic(
      CLK_HZ : positive := 50_000_000;  -- Frecuencia de clk
      BAUD   : positive := 115_200      -- Velocidad del sensor
   );
   port(
      clk        : in  std_logic;                      -- Reloj del sistema
      reset      : in  std_logic;                      -- Reset asíncrono, activo en '1'
      pd         : in  std_logic_vector(7 downto 0);   -- pd(0) es la línea TX del sensor
      distance   : out std_logic_vector(15 downto 0);  -- Última distancia válida, en cm
      data_valid : out std_logic                       -- Un pulso de un ciclo por trama válida
   );
end tfmini_interface;

architecture Behavioral of tfmini_interface is
   constant CICLOS_POR_BIT : positive := CLK_HZ / BAUD;
   constant CABECERA       : std_logic_vector(7 downto 0) := x"59";

   -- La línea serie no está sincronizada con clk: pasa por dos registros.
   signal rx_meta, rx : std_logic;

   -- Receptor UART: 8 bits de datos, sin paridad, 1 bit de parada.
   type estado_rx_t is (reposo, inicio, datos, parada);
   signal estado_rx  : estado_rx_t;
   signal cuenta     : integer range 0 to CICLOS_POR_BIT - 1;
   signal bit_actual : integer range 0 to 7;
   signal desplaza   : std_logic_vector(7 downto 0);
   signal byte_rx    : std_logic_vector(7 downto 0);
   signal byte_listo : std_logic;

   -- Posición dentro de la trama: 0 y 1 cabecera, 2 a 7 datos, 8 suma.
   signal posicion : integer range 0 to 8;
   signal suma     : unsigned(7 downto 0);
   signal dist_l   : std_logic_vector(7 downto 0);
   signal dist_h   : std_logic_vector(7 downto 0);
begin

   sincronizar : process(clk, reset)
   begin
      if reset = '1' then
         rx_meta <= '1';
         rx      <= '1';
      elsif rising_edge(clk) then
         rx_meta <= pd(0);
         rx      <= rx_meta;
      end if;
   end process;

   -- Cada bit se muestrea en su centro: tras el flanco de inicio se espera medio
   -- bit y después un bit completo por cada muestra.
   recibir : process(clk, reset)
   begin
      if reset = '1' then
         estado_rx  <= reposo;
         cuenta     <= 0;
         bit_actual <= 0;
         desplaza   <= (others => '0');
         byte_rx    <= (others => '0');
         byte_listo <= '0';
      elsif rising_edge(clk) then
         byte_listo <= '0';

         case estado_rx is
            when reposo =>
               cuenta     <= 0;
               bit_actual <= 0;
               if rx = '0' then
                  estado_rx <= inicio;
               end if;

            when inicio =>
               if cuenta = CICLOS_POR_BIT / 2 - 1 then
                  cuenta <= 0;
                  if rx = '0' then
                     estado_rx <= datos;
                  else
                     estado_rx <= reposo;  -- Era ruido, no un bit de inicio
                  end if;
               else
                  cuenta <= cuenta + 1;
               end if;

            when datos =>
               if cuenta = CICLOS_POR_BIT - 1 then
                  cuenta   <= 0;
                  desplaza <= rx & desplaza(7 downto 1);  -- Llega primero el bit bajo
                  if bit_actual = 7 then
                     estado_rx <= parada;
                  else
                     bit_actual <= bit_actual + 1;
                  end if;
               else
                  cuenta <= cuenta + 1;
               end if;

            when parada =>
               if cuenta = CICLOS_POR_BIT - 1 then
                  cuenta    <= 0;
                  estado_rx <= reposo;
                  if rx = '1' then
                     byte_rx    <= desplaza;
                     byte_listo <= '1';
                  end if;
               else
                  cuenta <= cuenta + 1;
               end if;
         end case;
      end if;
   end process;

   -- Trama: 59 59 Dist_L Dist_H Fuerza_L Fuerza_H Temp_L Temp_H Suma
   interpretar : process(clk, reset)
   begin
      if reset = '1' then
         posicion   <= 0;
         suma       <= (others => '0');
         dist_l     <= (others => '0');
         dist_h     <= (others => '0');
         distance   <= (others => '0');
         data_valid <= '0';
      elsif rising_edge(clk) then
         data_valid <= '0';

         if byte_listo = '1' then
            case posicion is
               when 0 =>
                  if byte_rx = CABECERA then
                     suma     <= unsigned(CABECERA);
                     posicion <= 1;
                  end if;

               when 1 =>
                  if byte_rx = CABECERA then
                     suma     <= suma + unsigned(byte_rx);
                     posicion <= 2;
                  else
                     posicion <= 0;
                  end if;

               when 8 =>
                  if unsigned(byte_rx) = suma then
                     distance   <= dist_h & dist_l;
                     data_valid <= '1';
                  end if;
                  posicion <= 0;

               when others =>
                  if posicion = 2 then
                     dist_l <= byte_rx;
                  elsif posicion = 3 then
                     dist_h <= byte_rx;
                  end if;
                  suma     <= suma + unsigned(byte_rx);
                  posicion <= posicion + 1;
            end case;
         end if;
      end if;
   end process;

end Behavioral;
