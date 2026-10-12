----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: nand_gate_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Implementa una compuerta NAND de 1 bit. La salida es '0' solo si ambas 
--              entradas son '1'; de lo contrario, la salida es '1'.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nand_gate_pynq is
    Port ( 
        btn0 : in  STD_LOGIC;  -- Entrada A
        btn1 : in  STD_LOGIC;  -- Entrada B
        led0 : out STD_LOGIC   -- Salida: A NAND B
    );
end nand_gate_pynq;

architecture Behavioral of nand_gate_pynq is
begin
    -- Realiza la operación lógica NAND
    led0 <= btn0 nand btn1;
end Behavioral;
