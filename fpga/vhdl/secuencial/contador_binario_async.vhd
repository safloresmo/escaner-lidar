----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: binary_up_counter_async_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Contador ascendente binario de 4 bits con reset asíncrono.
--              Se incrementa en cada flanco de subida del reloj (btn2) y se reinicia
--              inmediatamente a "0000" cuando btn3 es '1'.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity binary_up_counter_async_pynq is
    Port (
        btn2 : in  STD_LOGIC;  -- Clock
        btn3 : in  STD_LOGIC;  -- Reset asíncrono
        led0 : out STD_LOGIC;
        led1 : out STD_LOGIC;
        led2 : out STD_LOGIC;
        led3 : out STD_LOGIC
    );
end binary_up_counter_async_pynq;

architecture Behavioral of binary_up_counter_async_pynq is
    signal count : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process(btn2, btn3)
    begin
        if btn3 = '1' then
            count <= "0000";  -- Reset inmediato
        elsif rising_edge(btn2) then
            count <= count + 1;
        end if;
    end process;

    led0 <= count(0);
    led1 <= count(1);
    led2 <= count(2);
    led3 <= count(3);
end Behavioral;
