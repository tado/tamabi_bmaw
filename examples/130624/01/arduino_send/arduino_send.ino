/*
 * Arduino - Processingシリアル通信
 * Arduino側サンプル
 */

int sensors[2]; // センサーの値を格納する配列
int inByte; // 受信するシリアル通信の文字列

void setup(){
  // 9600bpsでシリアルポートを開始
  Serial.begin(9600);
  // センサーの値と受信する文字列を初期化
  sensors[0] = 0;
  sensors[1] = 0;
  inByte = 0;
  // 通信を開始
  establishContact();
}

void loop(){
  // もしProcessingから何か文字を受けとったら
  if (Serial.available() > 0) {
    // 受信した文字列を読み込み
    inByte = Serial.read();
    // アナログセンサーの値を計測
    sensors[0] = analogRead(A0);
    sensors[1] = analogRead(A1);
    // コンマ区切りでセンサーの値を送出
    Serial.print(sensors[0]);
    Serial.print(",");
    Serial.println(sensors[1]);          
  }
}

void establishContact() {
  // Processingから何か文字が送られてくるのを待つ
  while (Serial.available() <= 0) {
    // 初期化用の文字列
    Serial.println("0,0"); 
    delay(300);
  }
}

