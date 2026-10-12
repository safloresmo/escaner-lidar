-- Banco de pruebas de tfmini_interface: le manda tramas por la línea serie,
-- como lo haría el sensor, y comprueba qué distancias entrega.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_tfmini_interface is
end tb_tfmini_interface;

architecture sim of tb_tfmini_interface is
   constant PERIODO : time := 20 ns;       -- Reloj de 50 MHz
   constant BIT     : time := 8680.56 ns;  -- 115200 baudios

   type trama_t is array (0 to 8) of std_logic_vector(7 downto 0);

   constant TRAMA_30  : trama_t := (x"59", x"59", x"1E", x"00", x"94", x"00", x"1F", x"00", x"83");
   constant TRAMA_32  : trama_t := (x"59", x"59", x"20", x"00", x"8A", x"00", x"20", x"00", x"7C");
   constant TRAMA_600 : trama_t := (x"59", x"59", x"58", x"02", x"10", x"01", x"00", x"09", x"26");
   constant SUMA_MALA : trama_t := (x"59", x"59", x"40", x"00", x"94", x"00", x"1F", x"00", x"D9");

   signal clk        : std_logic := '0';
   signal reset      : std_logic := '1';
   signal linea      : std_logic := '1';
   signal pd         : std_logic_vector(7 downto 0);
   signal distance   : std_logic_vector(15 downto 0);
   signal data_valid : std_logic;

   signal validas : natural := 0;
   signal fin     : boolean := false;
begin
   clk <= not clk after PERIODO / 2 when not fin else '0';
   pd  <= "0000000" & linea;

   dut : entity work.tfmini_interface
      port map(clk => clk, reset => reset, pd => pd, distance => distance, data_valid => data_valid);

   contar : process(clk)
   begin
      if rising_edge(clk) and data_valid = '1' then
         validas <= validas + 1;
      end if;
   end process;

   estimulos : process
      procedure mandar_byte(dato : std_logic_vector(7 downto 0)) is
      begin
         linea <= '0';
         wait for BIT;
         for i in 0 to 7 loop
            linea <= dato(i);
            wait for BIT;
         end loop;
         linea <= '1';
         wait for BIT;
      end procedure;

      procedure mandar_trama(trama : trama_t) is
      begin
         for i in trama'range loop
            mandar_byte(trama(i));
         end loop;
      end procedure;

      procedure esperar(distancia : natural; total : natural; caso : string) is
      begin
         wait for 4 * BIT;
         assert validas = total
            report caso & ": tramas válidas = " & natural'image(validas) severity failure;
         assert to_integer(unsigned(distance)) = distancia
            report caso & ": distancia = " & natural'image(to_integer(unsigned(distance))) severity failure;
         report caso & ": correcto";
      end procedure;
   begin
      wait for 10 * PERIODO;
      reset <= '0';
      wait for 2 * BIT;

      mandar_trama(TRAMA_30);
      esperar(30, 1, "trama de 30 cm");

      mandar_trama(TRAMA_32);
      esperar(32, 2, "trama de 32 cm seguida");

      -- Una suma que no cuadra no cambia la salida.
      mandar_trama(SUMA_MALA);
      esperar(32, 2, "suma incorrecta");

      -- Bytes sueltos antes de la cabecera, incluido un 0x59 aislado.
      mandar_byte(x"00");
      mandar_byte(x"59");
      mandar_byte(x"A7");
      mandar_trama(TRAMA_600);
      esperar(600, 3, "basura antes de la trama");

      -- Empezar a escuchar a media trama: se pierde esa y se engancha a la siguiente.
      for i in 4 to 8 loop
         mandar_byte(TRAMA_30(i));
      end loop;
      esperar(600, 3, "trama cortada");
      mandar_trama(TRAMA_30);
      esperar(30, 4, "trama tras una cortada");

      report "Todas las pruebas pasaron";
      fin <= true;
      wait;
   end process;
end sim;
