----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: bcd_up_counter_sync_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Contador en BCD de 4 bits con reset síncrono. Cuenta de "0000" a "1001"
--              (0 a 9) y se reinicia a "0000" si se activa el reset o al llegar a 9.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd_up_counter_sync_pynq is
    Port (
        btn2 : in  STD_LOGIC;  -- Clock
        btn3 : in  STD_LOGIC;  -- Reset síncrono
        led0 : out STD_LOGIC;
        led1 : out STD_LOGIC;
        led2 : out STD_LOGIC;
        led3 : out STD_LOGIC
    );
end bcd_up_counter_sync_pynq;

architecture Behavioral of bcd_up_counter_sync_pynq is
    signal count : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process(btn2)
    begin
        if rising_edge(btn2) then
            if btn3 = '1' or count = "1001" then
                count <= "0000";  -- Reset o reinicio al llegar a 9 (1001)
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    led0 <= count(0);
    led1 <= count(1);
    led2 <= count(2);
    led3 <= count(3);
end Behavioral;
