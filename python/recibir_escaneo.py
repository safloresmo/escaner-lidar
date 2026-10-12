"""Recibe un escaneo del ESP32 y lo convierte en una imagen.

Manda "START" por el puerto serie, lee las filas que envía el escáner y, al
tener la matriz completa, la guarda en un CSV y en una imagen en escala de
grises (más claro = más cerca).

Necesita `pyserial`, `numpy` y `matplotlib`.
"""

import serial
import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime

PUERTO = 'COM10'
BAUDRATE = 115200
ANCHO, ALTO = 128, 64
COMANDO_START = b'\x53\x54\x41\x52\x54'  # "START"
SYNC = b'\xAA'
FIN = b'\xFF'

ser = serial.Serial(PUERTO, BAUDRATE, timeout=1)
print("Enviando comando START...")
ser.write(COMANDO_START)

print("Esperando sincronización...")
while True:
    byte = ser.read()
    if byte == SYNC:
        print("Sincronización recibida (0xAA)")
        break

matriz = []
fila_str = ""
capturando = False

while True:
    byte = ser.read()
    if byte == b'':
        continue

    if byte == SYNC:
        fila_str = ""
        capturando = True
    elif byte == FIN and capturando:
        try:
            fila = [int(v, 16) for v in fila_str.strip().split(',') if v]
            if len(fila) == ANCHO:
                matriz.append(fila)
                print(f" Línea {len(matriz)} de {ALTO}")
            else:
                print("Línea inválida, ignorada")
        except Exception as e:
            print(f"Error al procesar línea: {e}")
        capturando = False
    elif capturando:
        try:
            fila_str += byte.decode()
        except:
            pass

    if len(matriz) == ALTO:
        print("Matriz completa recibida.")
        break

if len(matriz) == ALTO:
    matriz_np = np.array(matriz)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    np.savetxt(f"lidar_{timestamp}.csv", matriz_np, fmt='%d', delimiter=',')
    plt.imshow(matriz_np, cmap='Greys_r', interpolation='nearest')
    plt.title("Escaneo LiDAR")
    plt.axis('off')
    plt.colorbar(label='Distancia (cm)')
    plt.tight_layout()
    plt.savefig(f"lidar_{timestamp}.png", dpi=300)
    plt.show()
    print("Imagen y CSV guardados.")
else:
    print(f"Solo se recibieron {len(matriz)} líneas.")
