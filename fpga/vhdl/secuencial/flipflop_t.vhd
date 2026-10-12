----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: t_flipflop_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: T Flip-Flop. Cambia el estado de Q (toggle) en cada flanco de subida de 
--              btn2 si T (btn0) es '1'. Se resetea asíncronamente con btn3.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity t_flipflop_pynq is
    Port (
        btn0 : in  STD_LOGIC;  -- Entrada T
        btn2 : in  STD_LOGIC;  -- Clock (CLK)
        btn3 : in  STD_LOGIC;  -- Reset asíncrono
        led0 : out STD_LOGIC;  -- Q
        led1 : out STD_LOGIC   -- Q'
    );
end t_flipflop_pynq;

architecture Behavioral of t_flipflop_pynq is
    signal Q : STD_LOGIC := '0';
begin
    process(btn2, btn3)
    begin
        if btn3 = '1' then
            Q <= '0';
        elsif rising_edge(btn2) then
            if btn0 = '1' then
                Q <= not Q;  -- Toggle cuando T es '1'
            end if;
        end if;
    end process;

    led0 <= Q;
    led1 <= not Q;
end Behavioral;
