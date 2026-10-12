// Lee el sensor TFmini-S por UART y escribe cada trama de 9 bytes tal cual llega.

#include <HardwareSerial.h>

HardwareSerial tfmini(2); // UART2

void setup() {
  Serial.begin(115200);
  tfmini.begin(115200, SERIAL_8N1, 6, 7); // RX = GPIO6, TX = GPIO7
  while (!Serial);
  Serial.println("Esperando datos crudos del TFmini...");
}

void loop() {
  if (tfmini.available()) {
    uint8_t byte1 = tfmini.read();

    if (byte1 == 0x59 && tfmini.peek() == 0x59) {
      tfmini.read(); // consumir segundo header

      uint8_t frame[9];
      frame[0] = 0x59;
      frame[1] = 0x59;

      for (int i = 2; i < 9; i++) {
        while (!tfmini.available());
        frame[i] = tfmini.read();
      }

      // Imprimir los bytes
      Serial.print("Frame: ");
      for (int i = 0; i < 9; i++) {
        if (frame[i] < 0x10) Serial.print("0");
        Serial.print(frame[i], HEX);
        Serial.print(" ");
      }
      Serial.println();
    }
  }
}
