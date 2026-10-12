----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: FA_arch
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Implementa un sumador completo (Full Adder) que suma dos bits y un 
--              acarreo de entrada. La suma se muestra en led0 y el acarreo en led1.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA_arch is
    Port ( 
        btn0 : in  STD_LOGIC;  -- Entrada A
        btn1 : in  STD_LOGIC;  -- Entrada B
        btn2 : in  STD_LOGIC;  -- Acarreo de entrada (Cin)
        led0 : out STD_LOGIC;  -- Suma: A XOR B XOR Cin
        led1 : out STD_LOGIC   -- Acarreo de salida: (A AND B) OR (Cin AND (A XOR B))
    );
end FA_arch;

architecture Behavioral of FA_arch is
begin
    -- Calcula la suma y el acarreo
    led0 <= btn0 xor btn1 xor btn2;
    led1 <= (btn0 and btn1) or (btn2 and (btn0 xor btn1));
end Behavioral;
