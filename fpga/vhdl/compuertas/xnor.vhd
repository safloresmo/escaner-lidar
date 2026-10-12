----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: xnor_gate_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Implementa una compuerta XNOR de 1 bit. La salida es '1' si ambas 
--              entradas son iguales; de lo contrario, es '0'.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xnor_gate_pynq is
    Port ( 
        btn0 : in  STD_LOGIC;  -- Entrada A
        btn1 : in  STD_LOGIC;  -- Entrada B
        led0 : out STD_LOGIC   -- Salida: A XNOR B
    );
end xnor_gate_pynq;

architecture Behavioral of xnor_gate_pynq is
begin
    -- Realiza la operación lógica XNOR
    led0 <= btn0 xnor btn1;
end Behavioral;
