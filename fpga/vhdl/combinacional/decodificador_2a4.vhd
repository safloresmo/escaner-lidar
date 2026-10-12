----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: decoder_2to4_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: Decodificador 2 a 4. Toma una entrada de 2 bits (SEL) y una señal de 
--              habilitación (EN). Cuando EN es '1', activa una de las 4 salidas según 
--              el valor de SEL; en caso contrario, las salidas son '0'.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_2to4_pynq is
    Port (
        EN  : in  STD_LOGIC;                   -- Señal de habilitación
        SEL : in  STD_LOGIC_VECTOR(1 downto 0);  -- Entrada de 2 bits
        D   : out STD_LOGIC_VECTOR(3 downto 0)   -- Salidas decodificadas
    );
end decoder_2to4_pynq;

architecture Behavioral of decoder_2to4_pynq is
begin
    process(EN, SEL)
    begin
        if EN = '1' then
            case SEL is
                when "00" => D <= "0001";  -- Activa D(0)
                when "01" => D <= "0010";  -- Activa D(1)
                when "10" => D <= "0100";  -- Activa D(2)
                when "11" => D <= "1000";  -- Activa D(3)
                when others => D <= "0000";
            end case;
        else
            D <= "0000";  -- Deshabilitado
        end if;
    end process;
end Behavioral;
