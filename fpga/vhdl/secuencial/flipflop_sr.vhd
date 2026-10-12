----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: sr_flipflop_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: SR Flip-Flop. Se actualiza en el flanco de subida de btn2 (CLK). Se 
--              resetea asíncronamente con btn3. Las entradas btn0 y btn1 corresponden a S y R.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sr_flipflop_pynq is
    Port (
        btn0 : in  STD_LOGIC;  -- Set (S)
        btn1 : in  STD_LOGIC;  -- Reset (R)
        btn2 : in  STD_LOGIC;  -- Clock (CLK)
        btn3 : in  STD_LOGIC;  -- Reset asíncrono
        led0 : out STD_LOGIC;  -- Q
        led1 : out STD_LOGIC   -- Q'
    );
end sr_flipflop_pynq;

architecture Behavioral of sr_flipflop_pynq is
    signal Q : STD_LOGIC := '0';
begin
    process(btn2, btn3)
    begin
        if btn3 = '1' then
            Q <= '0';  -- Reset asíncrono
        elsif rising_edge(btn2) then
            if (btn0 = '1' and btn1 = '0') then
                Q <= '1';
            elsif (btn0 = '0' and btn1 = '1') then
                Q <= '0';
            end if;
            -- Si btn0 y btn1 son ambos '1' o ambos '0', se mantiene el valor actual.
        end if;
    end process;
    
    led0 <= Q;
    led1 <= not Q;
end Behavioral;
