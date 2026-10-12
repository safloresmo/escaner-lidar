----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: jk_flipflop_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: JK Flip-Flop. Actualiza Q en cada flanco de subida de btn2 según las 
--              entradas J (btn0) y K (btn1). Se resetea asíncronamente con btn3.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jk_flipflop_pynq is
    Port (
        btn0 : in  STD_LOGIC;  -- Entrada J
        btn1 : in  STD_LOGIC;  -- Entrada K
        btn2 : in  STD_LOGIC;  -- Clock (CLK)
        btn3 : in  STD_LOGIC;  -- Reset asíncrono
        led0 : out STD_LOGIC;  -- Q
        led1 : out STD_LOGIC   -- Q'
    );
end jk_flipflop_pynq;

architecture Behavioral of jk_flipflop_pynq is
    signal Q : STD_LOGIC := '0';
begin
    process(btn2, btn3)
    begin
        if btn3 = '1' then
            Q <= '0';
        elsif rising_edge(btn2) then
            case (btn0 & btn1) is
                when "10" => Q <= '1';      -- Set
                when "01" => Q <= '0';      -- Reset
                when "11" => Q <= not Q;    -- Toggle
                when others => Q <= Q;      -- No cambio
            end case;
        end if;
    end process;

    led0 <= Q;
    led1 <= not Q;
end Behavioral;
