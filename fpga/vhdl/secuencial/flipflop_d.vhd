----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: d_flipflop_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: D Flip-Flop. La señal D (btn0) se transfiere a Q en el flanco de subida 
--              de btn2. Se incluye reset asíncrono (btn3).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_flipflop_pynq is
    Port (
        btn0 : in  STD_LOGIC;  -- Entrada D
        btn2 : in  STD_LOGIC;  -- Clock (CLK)
        btn3 : in  STD_LOGIC;  -- Reset asíncrono
        led0 : out STD_LOGIC;  -- Q
        led1 : out STD_LOGIC   -- Q'
    );
end d_flipflop_pynq;

architecture Behavioral of d_flipflop_pynq is
    signal Q : STD_LOGIC := '0';
begin
    process(btn2, btn3)
    begin
        if btn3 = '1' then
            Q <= '0';
        elsif rising_edge(btn2) then
            Q <= btn0;
        end if;
    end process;

    led0 <= Q;
    led1 <= not Q;
end Behavioral;
