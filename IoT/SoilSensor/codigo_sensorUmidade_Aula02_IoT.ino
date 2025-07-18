#include <ESP8266WiFi.h>

float umidade = 0.0; //Inicializando uma variável para receber a umidade (float)
char umidadestr[6]; //Inicializando uma variável char para converter em String o valor lido analogicamente

void setup() {
  Serial.begin(115200); //bps (bits per second)
  Serial.println();
  Serial.println("Iniciando...");

  pinMode(LED_BUILTIN, OUTPUT);
}

//Função: faz a leitura do nível de umidade
//Parâmetros: nenhum
//Retorno: umidade percentual (0-100)
//Observação: o ADC do NodeMCU permite até, no máximo, 3.3V. Dessa forma, para 3.3V, obtem-se 1023 como leitura de ADC

float FazLeituraUmidade(void)
{
    int ValorADC; //Valor lido analogicamente pelo sensor de umidade
    float UmidadePercentual; //valor interpretado de acordo com a escala abaixo
 
     ValorADC = analogRead(0);   //1024 -> 3,3V
     Serial.print("[Leitura ADC] ");
     Serial.println(ValorADC);
 
     //Quanto maior o número lido do ADC, menor a umidade.
     //Sendo assim, calcula-se a porcentagem de umidade por:
     //      
     //   Valor lido                 Umidade percentual
     //      _    0                           _ 100
     //      |                                |   
     //      |                                |   
     //      -   ValorADC                     - UmidadePercentual 
     //      |                                |   
     //      |                                |   
     //     _|_  1024                         _|_ 0
     //
     //   (UmidadePercentual-0) / (100-0)  =  (ValorADC - 1024) / (-1024)
     //      Logo:
     //      UmidadePercentual = 100 * ((1024-ValorADC) / 1024)  
     
    UmidadePercentual = 100 * ((1024-(float)ValorADC) / 1024);
    //  UmidadePercentual = map(ValorADC, 0, 1024, 100, 0);
     Serial.print("[Umidade Percentual] ");
     Serial.print(UmidadePercentual);
     Serial.println("%");
 
     return UmidadePercentual;
}

void loop() {

  float umidade = FazLeituraUmidade();
  
  // Conversão Floats para Strings:
  char TempString[32];  //  array de character temporário

  // dtostrf( [Float variable] , [Minimum SizeBeforePoint] , [sizeAfterPoint] , [WhereToStoreIt] )
  dtostrf(umidade, 2, 1, TempString);
  String umidadestr = String(TempString);

    Serial.println(umidadestr);
    delay(2000);

}
