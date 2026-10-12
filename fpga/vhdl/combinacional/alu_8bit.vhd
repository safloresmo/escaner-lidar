----------------------------------------------------------------------------------
-- Ingeniero: SAMUEL FLORES MONTES
-- Nombre del Módulo: alu_8bit_pynq
-- Nombre del Proyecto: Compuertas
-- Dispositivos Objetivo: PYNQ-Z1
-- Versiones de Herramientas: 2024.2
-- Descripción: ALU de 8 bits que realiza diversas operaciones (suma, resta, AND, OR, 
--              XOR, NAND, NOR, XNOR, NOT, etc.) según el OPCODE y MODE. La operación 
--              se ejecuta solo si EN es '1'.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_8bit_pynq is
    Port (
        EN     : in  STD_LOGIC;                      -- Habilitación de la ALU
        MODE   : in  STD_LOGIC;                      -- Modo: 0 = Aritmético, 1 = Lógico
        OPCODE : in  STD_LOGIC_VECTOR(3 downto 0);     -- Código de operación
        A      : in  STD_LOGIC_VECTOR(7 downto 0);     -- Operando A
        B      : in  STD_LOGIC_VECTOR(7 downto 0);     -- Operando B
        Y      : out STD_LOGIC_VECTOR(7 downto 0)      -- Salida de la ALU
    );
end alu_8bit_pynq;

architecture Behavioral of alu_8bit_pynq is
    signal result : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(EN, MODE, OPCODE, A, B)
    begin
        if EN = '0' then
            result <= (others => 'Z');  -- Tri-state: ALU deshabilitada
        else
            if MODE = '0' then  -- Operaciones aritméticas
                case OPCODE is
                    when "0000" => result <= std_logic_vector(unsigned(A) + unsigned(B));  -- Suma
                    when "0001" => result <= std_logic_vector(unsigned(A) - unsigned(B));  -- Resta
                    when "0010" => result <= std_logic_vector(unsigned(A(3 downto 0)) * unsigned(B(3 downto 0))); -- Multiplicación (4 bits)
                    when others => result <= (others => '0');
                end case;
            else  -- Operaciones lógicas
                case OPCODE is
                    when "0011" => result <= not A;                 -- NOT A
                    when "0100" => result <= A and B;               -- AND
                    when "0101" => result <= A or B;                -- OR
                    when "0110" => result <= A nand B;              -- NAND
                    when "0111" => result <= A xor B;               -- XOR
                    when "1000" => result <= A xnor B;              -- XNOR
                    when others => result <= (others => '0');
                end case;
            end if;
        end if;
    end process;
    
    Y <= result;
end Behavioral;
