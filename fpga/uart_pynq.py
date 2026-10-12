"""Lee el periférico AXI Uartlite desde Python en la PYNQ-Z1.

Se ejecuta en un cuaderno de Jupyter de la propia placa, después de copiar a
ella el bitstream (`UART.bit`) y su descripción (`UART.hwh`) generados en
Vivado a partir del diseño de bloques.
"""

from pynq import Overlay
from pynq import MMIO
from time import sleep, time

# Cargamos el bitstream generado (archivo con diseño en hardware)
ol = Overlay("/home/xilinx/jupyter_notebooks/UART.bit")

# Dirección base del periférico UART en el espacio de memoria AXI
address = 0x42C00000

# === CONSTANTES DE HARDWARE ===

# Direcciones de los registros FIFO (First In First Out)
RX_FIFO = 0x00  # Registro de lectura (recepción)
TX_FIFO = 0x04  # Registro de escritura (transmisión)

# Dirección del registro de estado (STAT_REG)
STAT_REG = 0x08
RX_VALID = 0     # Indica si hay datos válidos en la FIFO de recepción
RX_FULL = 1      # Indica si la FIFO de recepción está llena
TX_EMPTY = 2     # Indica si la FIFO de transmisión está vacía
TX_FULL = 3      # Indica si la FIFO de transmisión está llena
IS_INTR = 4      # Bandera de interrupción activa
OVERRUN_ERR = 5  # Error de sobrecarga (no se leyó a tiempo)
FRAME_ERR = 6    # Error de trama (datos corruptos)
PARITY_ERR = 7   # Error de paridad (si se usa)

# Dirección del registro de control (CTRL_REG)
CTRL_REG = 0x0C
RST_TX = 0   # Bit para resetear la FIFO de transmisión
RST_RX = 1   # Bit para resetear la FIFO de recepción
INTR_EN = 4  # Habilita interrupciones (no se usa aquí)


# === CLASE PARA CONTROLAR EL MÓDULO UART MEDIANTE MMIO ===
class UartAXI:
    def __init__(self, address):
        # Inicializa el acceso MMIO al periférico UART en la dirección dada
        self.uart = MMIO(address, 0x10000, debug=False)
        self.address = address

    def setupCtrlReg(self):
        # Reinicia las FIFOs de transmisión y recepción
        # y luego limpia el registro de control
        self.uart.write(CTRL_REG, 1 << RST_TX | 1 << RST_RX)
        sleep(1)
        self.uart.write(CTRL_REG, 0)
        sleep(1)

    def read(self, count, timeout=10):
        # Intenta leer "count" caracteres del UART
        # Espera hasta que haya datos válidos o se cumpla el tiempo de espera
        buf = ""
        stop_time = time() + timeout
        for i in range(count):
            while (not (self.uart.read(STAT_REG) & 1 << RX_VALID)) and (time() < stop_time):
                pass
            if time() >= stop_time:
                break
            buf += chr(self.uart.read(RX_FIFO))
        return buf

    def write(self, buf, timeout=10):
        # Escribe datos (cadena buf) al UART
        stop_time = time() + timeout
        wr_count = 0
        for i in buf:
            # Espera si la FIFO de transmisión está llena
            while (self.uart.read(STAT_REG) & 1 << TX_FULL) and (time() < stop_time):
                pass
            if time() > stop_time:
                break
            self.uart.write(TX_FIFO, ord(i))
            wr_count += 1
        return wr_count


# Instancia del objeto UART con la dirección asignada
uart = UartAXI(address)

# Configura los registros de control del módulo UART
uart.setupCtrlReg()

# Lectura de 64 caracteres desde UART (en espera)
uart.read(64)
