----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: xor_gate_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Implementa una compuerta XOR de 1 bit. La salida es '1' si las entradas 
--              son diferentes y '0' si son iguales.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_gate_pynq is
    Port ( 
        btn0 : in  STD_LOGIC;  -- Entrada A
        btn1 : in  STD_LOGIC;  -- Entrada B
        led0 : out STD_LOGIC   -- Salida: A XOR B
    );
end xor_gate_pynq;

architecture Behavioral of xor_gate_pynq is
begin
    -- Realiza la operación lógica XOR
    led0 <= btn0 xor btn1;
end Behavioral;
