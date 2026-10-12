----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: nor_gate_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Implementa una compuerta NOR de 1 bit. La salida es '1' únicamente si 
--              ambas entradas son '0'; en otro caso, la salida es '0'.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nor_gate_pynq is
    Port ( 
        btn0 : in  STD_LOGIC;  -- Entrada A
        btn1 : in  STD_LOGIC;  -- Entrada B
        led0 : out STD_LOGIC   -- Salida: A NOR B
    );
end nor_gate_pynq;

architecture Behavioral of nor_gate_pynq is
begin
    -- Realiza la operación lógica NOR
    led0 <= btn0 nor btn1;
end Behavioral;
