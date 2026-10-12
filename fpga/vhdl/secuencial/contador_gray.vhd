----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: gray_code_counter_async_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Contador de 4 bits que genera la secuencia en código Gray. Se utiliza
--              un contador binario interno que se convierte a Gray. El reset asíncrono
--              reinicia el contador a "0000".
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity gray_code_counter_async_pynq is
    Port (
        btn2 : in  STD_LOGIC;  -- Clock
        btn3 : in  STD_LOGIC;  -- Reset asíncrono
        led0 : out STD_LOGIC;
        led1 : out STD_LOGIC;
        led2 : out STD_LOGIC;
        led3 : out STD_LOGIC
    );
end gray_code_counter_async_pynq;

architecture Behavioral of gray_code_counter_async_pynq is
    signal binary_count : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal gray_count : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(btn2, btn3)
    begin
        if btn3 = '1' then
            binary_count <= "0000";  -- Reset inmediato
        elsif rising_edge(btn2) then
            binary_count <= binary_count + 1;
        end if;
    end process;

    -- Conversión de binario a código Gray:
    -- El bit más significativo se copia y los demás se generan XOR del bit actual con el inmediato superior.
    gray_count(3) <= binary_count(3);
    gray_count(2) <= binary_count(3) xor binary_count(2);
    gray_count(1) <= binary_count(2) xor binary_count(1);
    gray_count(0) <= binary_count(1) xor binary_count(0);

    led0 <= gray_count(0);
    led1 <= gray_count(1);
    led2 <= gray_count(2);
    led3 <= gray_count(3);
end Behavioral;
