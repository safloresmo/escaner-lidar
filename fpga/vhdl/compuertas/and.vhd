----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: and_gate_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Implementa una compuerta AND de 1 bit. La salida es '1' solo si ambas 
--              entradas son '1'.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_gate_pynq is
    Port ( 
        btn0 : in  STD_LOGIC;  -- Entrada A
        btn1 : in  STD_LOGIC;  -- Entrada B
        led0 : out STD_LOGIC   -- Salida: A AND B
    );
end and_gate_pynq;

architecture Behavioral of and_gate_pynq is
begin
    -- Realiza la operación lógica AND
    led0 <= btn0 and btn1;
end Behavioral;
