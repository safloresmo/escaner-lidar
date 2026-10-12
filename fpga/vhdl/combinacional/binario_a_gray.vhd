----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: bin_to_gray_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Convierte un número binario de 4 bits a código Gray. Se copia el bit
--              más significativo y se genera cada bit siguiente haciendo XOR del bit 
--              actual con el inmediatamente superior.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin_to_gray_pynq is
    Port (
        B3, B2, B1, B0 : in STD_LOGIC;    -- Entrada binaria de 4 bits (B3 es MSB)
        G3, G2, G1, G0 : out STD_LOGIC     -- Salida en código Gray de 4 bits (G3 es MSB)
    );
end bin_to_gray_pynq;

architecture Behavioral of bin_to_gray_pynq is
begin
    -- Conversión a código Gray:
    -- El bit más significativo se copia; cada bit siguiente es el XOR del bit actual 
    -- con el bit anterior.
    G3 <= B3;
    G2 <= B3 xor B2;
    G1 <= B2 xor B1;
    G0 <= B1 xor B0;
end Behavioral;
