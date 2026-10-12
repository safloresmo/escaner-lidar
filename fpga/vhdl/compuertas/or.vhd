----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: or_gate_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Implementa una compuerta OR de 1 bit. La salida es '1' si al menos una 
--              entrada es '1'.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or_gate_pynq is
    Port ( 
        btn0 : in  STD_LOGIC;  -- Entrada A
        btn1 : in  STD_LOGIC;  -- Entrada B
        led0 : out STD_LOGIC   -- Salida: A OR B
    );
end or_gate_pynq;

architecture Behavioral of or_gate_pynq is
begin
    -- Realiza la operación lógica OR
    led0 <= btn0 or btn1;
end Behavioral;
