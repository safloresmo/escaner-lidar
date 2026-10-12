----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: half_adder_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Implementa un sumador de medio bit (Half Adder) que suma dos bits.
--              La suma se muestra en led0 (A XOR B) y el acarreo en led1 (A AND B).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HA_arch is
    Port ( 
        btn0 : in  STD_LOGIC;  -- Entrada A
        btn1 : in  STD_LOGIC;  -- Entrada B
        led0 : out STD_LOGIC;  -- Suma: A XOR B
        led1 : out STD_LOGIC   -- Acarreo: A AND B
    );
end HA_arch;

architecture Behavioral of HA_arch is
begin
    -- Calcula la suma (XOR) y el acarreo (AND)
    led0 <= btn0 xor btn1;
    led1 <= btn0 and btn1;
end Behavioral;