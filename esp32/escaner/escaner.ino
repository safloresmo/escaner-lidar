// Escáner de dos ejes con el sensor TFmini-S.
//
// Un servo inclina el sensor (eje Y) y un motor a pasos lo gira (eje X). En
// cada punto se toma una distancia y se manda por el puerto serie a la
// computadora, que arma la imagen con `python/recibir_escaneo.py`.
//
// El barrido empieza al recibir "START". Cada fila va entre los bytes 0xAA y
// 0xFF, con las distancias en hexadecimal separadas por comas; al terminar se
// manda "END".

#include <ESP32Servo.h>
#include "TFMPlus.h"

TFMPlus tfm;
Servo servoY;
HardwareSerial tfSerial(2);

// Constantes del sistema
const int ANCHO = 128, ALTO = 64;
const int pinServoY = 19, pinStepX = 23, pinDirX = 22, rxPin = 16, txPin = 17;
const int delayStep = 1000, delayServo = 10;
const char CMD_START[] = "START", CMD_END[] = "END";
bool escaneo = false;

void moverPaso() {
  digitalWrite(pinStepX, HIGH); delayMicroseconds(delayStep);
  digitalWrite(pinStepX, LOW); delayMicroseconds(delayStep);
}

void setup() {
  Serial.begin(115200); delay(100);
  tfSerial.begin(115200, SERIAL_8N1, rxPin, txPin);
  tfm.begin(&tfSerial); tfm.sendCommand(SET_FRAME_RATE, FRAME_100);

  pinMode(pinStepX, OUTPUT); pinMode(pinDirX, OUTPUT); digitalWrite(pinDirX, HIGH);
  servoY.setPeriodHertz(50); servoY.attach(pinServoY); servoY.write(90); delay(500);
}

// Detecta comando "START" en flujo serial
bool comandoStart() {
  static byte buf[5], i = 0;
  while (Serial.available()) {
    buf[i++] = Serial.read();
    if (i == 5) {
      if (!memcmp(buf, CMD_START, 5)) return true;
      memmove(buf, buf + 1, 4); i = 4;
    }
  }
  return false;
}

void loop() {
  if (!escaneo && comandoStart()) {
    escaneo = true; Serial.println("OK"); delay(200); return;
  }
  if (!escaneo) return;

  // Bucle principal de escaneo
  for (int y = 0; y < ALTO; y++) {
    servoY.write(map(y, 0, ALTO - 1, 90, 0));
    delay(delayServo);
    Serial.write(0xAA); // Inicio de línea

    for (int x = 0; x < ANCHO; x++) {
      int16_t d = 0, s, t;
      d = (tfm.getData(d, s, t) && d < 65500 && d > 0 && s >= 100) ? d : 0;
      char h[5]; snprintf(h, sizeof(h), "%04X", d);
      Serial.print(h); if (x < ANCHO - 1) Serial.print(",");
      moverPaso();
    }

    Serial.println();      // Fin de línea textual
    Serial.write(0xFF);    // Fin de línea especial
    digitalWrite(pinDirX, !digitalRead(pinDirX)); // Zigzag
    delay(5);
  }

  Serial.write((uint8_t*)CMD_END, sizeof(CMD_END) - 1); // Enviar "END"
  Serial.println();
  while (true); // Fin de ejecución
}
