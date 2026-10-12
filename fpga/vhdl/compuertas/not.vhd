----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: not_gate_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Implementa una compuerta NOT de 1 bit. La salida es la negación de la 
--              entrada.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity not_gate_pynq is
    Port ( 
        btn0 : in  STD_LOGIC;  -- Entrada
        led0 : out STD_LOGIC   -- Salida: NOT A
    );
end not_gate_pynq;

architecture Behavioral of not_gate_pynq is
begin
    -- Realiza la operación lógica NOT
    led0 <= not btn0;
end Behavioral;
