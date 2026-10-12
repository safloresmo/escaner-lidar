----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: bitcomp
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Compara dos señales de 1 bit y produce salidas que indican si la 
--              primera es mayor, menor o igual a la segunda.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bitcomp is
    Port (
        btn0 : in  STD_LOGIC;  -- Entrada A
        btn1 : in  STD_LOGIC;  -- Entrada B
        led0 : out STD_LOGIC;  -- Salida: A > B
        led1 : out STD_LOGIC;  -- Salida: A < B
        led2 : out STD_LOGIC   -- Salida: A = B
    );
end bitcomp;

architecture Behavioral of bitcomp is
begin
    -- A > B: se cumple si A es '1' y B es '0'
    led0 <= '1' when (btn0 = '1' and btn1 = '0') else '0';
    -- A < B: se cumple si A es '0' y B es '1'
    led1 <= '1' when (btn0 = '0' and btn1 = '1') else '0';
    -- A = B: se cumple si ambas señales son iguales
    led2 <= '1' when (btn0 = btn1) else '0';
end Behavioral;
