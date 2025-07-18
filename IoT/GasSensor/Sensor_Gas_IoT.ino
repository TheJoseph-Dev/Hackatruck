const int sensorPin = A0; // Pino analógico conectado ao sensor MQ3
int sensorValue; // Variável para armazenar o valor lido do sensor

void setup() {
  Serial.begin(115200); // Inicializa a comunicação serial com a velocidade de 115200 bps
}

void loop() {
  sensorValue = analogRead(sensorPin); // Lê o valor do sensor
 // Serial.println(sensorValue); // Envia o valor lido pela porta serial
  Serial.println(map(sensorValue,0,1023,0,100)); // Envia o valor lido pela porta serial em %
  delay(1000); // Aguarda 1 segundo antes de ler o sensor novamente
}