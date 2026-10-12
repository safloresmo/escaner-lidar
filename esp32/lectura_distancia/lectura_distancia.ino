// Lee el sensor TFmini-S por UART, comprueba la suma de cada trama y escribe
// la distancia y la intensidad de la señal.

#include <HardwareSerial.h>

HardwareSerial tfmini(2); // UART2

void setup() {
  Serial.begin(115200);
  tfmini.begin(115200, SERIAL_8N1, 6, 7); // RX = GPIO6, TX = GPIO7
  while (!Serial);
  Serial.println("Interpretando datos del TFmini...");
}

void loop() {
  if (tfmini.available()) {
    uint8_t byte1 = tfmini.read();

    if (byte1 == 0x59 && tfmini.peek() == 0x59) {
      tfmini.read(); // segundo header

      uint8_t frame[9];
      frame[0] = 0x59;
      frame[1] = 0x59;

      for (int i = 2; i < 9; i++) {
        while (!tfmini.available());
        frame[i] = tfmini.read();
      }

      // Verificar checksum
      uint8_t checksum = 0;
      for (int i = 0; i < 8; i++) {
        checksum += frame[i];
      }

      if (checksum == frame[8]) {
        uint16_t distance = frame[2] + (frame[3] << 8);
        uint16_t strength = frame[4] + (frame[5] << 8);

        Serial.print("Distancia: ");
        Serial.print(distance);
        Serial.print(" cm\tFuerza: ");
        Serial.println(strength);
      } else {
        Serial.println("Checksum inválido");
      }
    }
  }
}
