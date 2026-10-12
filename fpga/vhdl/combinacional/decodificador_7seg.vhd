library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Entity: seg7btn
-- Descripción: Decodificador de 7 segmentos que toma 4 bits en forma binaria
-- (por ejemplo, de botones) y genera la señal para el display en formato hexadecimal.
entity seg7btn is
    Port(
         btn : in  std_logic_vector(3 downto 0);  -- Entradas de los botones (se asume que representan el número en binario)
         pd  : out std_logic_vector(6 downto 0)     -- Salida para el display de 7 segmentos (hexadecimal)
    );
end seg7btn;

architecture seg7btn_arch of seg7btn is
begin
    process(btn)
    begin
        case btn is
            when "0000" => pd <= "0000001"; -- Muestra 0
            when "0001" => pd <= "1001111"; -- Muestra 1
            when "0010" => pd <= "0010010"; -- Muestra 2
            when "0011" => pd <= "0000110"; -- Muestra 3
            when "0100" => pd <= "1001100"; -- Muestra 4
            when "0101" => pd <= "0100100"; -- Muestra 5
            when "0110" => pd <= "0100000"; -- Muestra 6
            when "0111" => pd <= "0001101"; -- Muestra 7
            when "1000" => pd <= "0000000"; -- Muestra 8
            when "1001" => pd <= "0000100"; -- Muestra 9
            when "1010" => pd <= "0001000"; -- Muestra A
            when "1011" => pd <= "1100000"; -- Muestra B
            when "1100" => pd <= "0110001"; -- Muestra C
            when "1101" => pd <= "1000010"; -- Muestra D
            when "1110" => pd <= "0110000"; -- Muestra E
            when others => pd <= "0111000"; -- Muestra F
        end case;
    end process;
end seg7btn_arch;
