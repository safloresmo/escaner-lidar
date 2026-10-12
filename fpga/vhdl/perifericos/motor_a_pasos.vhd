-- Controlador de un motor a pasos en modo de paso completo.
library IEEE;
use IEEE.std_logic_1164.all;

-- Controlador para motor a pasos en modo full-step.
-- Se asume:
--   - Reset (btn[0]) es activo en '1'
--   - Enable (E, btn[1]) mantiene el paso actual cuando es '1'
--   - Dirección (Dir, btn[2]) determina si la secuencia avanza ('1') o retrocede ('0')
--   - La salida Sec (4 bits) se conecta a las bobinas del motor (ej. pd[0] a pd[3])
entity SMControl is
    Port (
        Clk   : in  std_logic;                        -- Reloj del sistema (conectado a "clock")
        Reset : in  std_logic;                        -- Reset, activo '1' (btn[0])
        E     : in  std_logic;                        -- Enable: si '1' mantiene la secuencia (btn[1])
        Dir   : in  std_logic;                        -- Dirección: '1' para avance, '0' para retroceso (btn[2])
        Sec   : out std_logic_vector(3 downto 0)         -- Salida de la secuencia de activación (para pd[0..3])
    );
end SMControl;

architecture Behavioral of SMControl is
    -- Definición de estados que representan cada paso en la secuencia
    type States is (Step_0, Step_1, Step_2, Step_3);
    signal Current_State, Next_State : States;
begin
    -- Proceso de transición de estados: según el estado actual, enable y dirección se determina el siguiente paso.
    process(Clk, Reset, Current_State)
    begin
        if Reset = '1' then
            Next_State <= Step_0;
        elsif rising_edge(Clk) then
            case Current_State is
                when Step_0 =>
                    Sec <= x"A";  -- Patrón "A" (1010)
                    if E = '1' then
                        Next_State <= Step_0;  -- Mantiene el paso actual
                    else
                        if Dir = '1' then
                            Next_State <= Step_1;  -- Avanza al siguiente paso
                        else
                            Next_State <= Step_3;  -- Retrocede
                        end if;
                    end if;
                when Step_1 =>
                    Sec <= x"9";  -- Patrón "9" (1001)
                    if E = '1' then
                        Next_State <= Step_1;
                    else
                        if Dir = '1' then
                            Next_State <= Step_2;
                        else
                            Next_State <= Step_0;
                        end if;
                    end if;
                when Step_2 =>
                    Sec <= x"5";  -- Patrón "5" (0101)
                    if E = '1' then
                        Next_State <= Step_2;
                    else
                        if Dir = '1' then
                            Next_State <= Step_3;
                        else
                            Next_State <= Step_1;
                        end if;
                    end if;
                when Step_3 =>
                    Sec <= x"6";  -- Patrón "6" (0110)
                    if E = '1' then
                        Next_State <= Step_3;
                    else
                        if Dir = '1' then
                            Next_State <= Step_0;
                        else
                            Next_State <= Step_2;
                        end if;
                    end if;
                when others =>
                    Next_State <= Step_0;
            end case;
        end if;
    end process;
    
    -- Proceso de actualización de estado: en cada flanco de subida del reloj se actualiza el estado actual.
    process(Clk)
    begin
        if rising_edge(Clk) then
            Current_State <= Next_State;
        end if;
    end process;
    
end Behavioral;

