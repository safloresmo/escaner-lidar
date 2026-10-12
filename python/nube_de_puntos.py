"""Dibuja un escaneo guardado como nube de puntos en 3D.

Lee el CSV que deja `recibir_escaneo.py` y abre una gráfica interactiva: X y Y
son la posición del sensor y Z la distancia medida. Necesita `plotly`.
"""

import csv
import plotly.graph_objects as go

# Leer el archivo CSV
matriz = []
with open("lidar_output.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        if row:  # Ignorar filas vacías
            matriz.append([int(val) for val in row if val.strip() != ""])

# Tamaño real de la matriz
ALTO = len(matriz)
ANCHO = max(len(row) for row in matriz)

# Preparar datos
x_vals = []
y_vals = []
z_vals = []

for y in range(ALTO):
    for x in range(len(matriz[y])):
        z = matriz[y][x]
        if z > 0:
            x_vals.append(x)
            y_vals.append(y)
            z_vals.append(z)

# Crear gráfica interactiva con Plotly
fig = go.Figure(data=[go.Scatter3d(
    x=x_vals, y=y_vals, z=z_vals,
    mode='markers',
    marker=dict(
        size=2,
        color=z_vals,
        colorscale='Viridis',
        opacity=0.8
    )
)])

fig.update_layout(
    scene=dict(
        xaxis_title='X',
        yaxis_title='Y',
        zaxis_title='Distancia (cm)'
    ),
    title="Nube de puntos",
    margin=dict(l=0, r=0, b=0, t=40)
)

fig.show()
