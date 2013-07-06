/*
 * Touche for Arduino
 * Vidualization Example 00
 *
 */

float voltageMax; //電圧の最大値
float timeMax; //電圧が最大値だったときの時間

void setup() {
  //画面サイズ
  size(800, 600);
  //ポートを設定
  PortSelected=5; 
  //シリアルポートを初期化
  SerialPortSetup();
}

void draw() {
  background(63);
  fill(255);

  //最大値を0に初期化
  voltageMax = timeMax = 0;

  if ( DataRecieved3 ) {
    //電圧の最大値と、そのときの時間を取得
    for (int i = 0; i < Voltage3.length; i++) {
      if (voltageMax < Voltage3[i]) {
        voltageMax = Voltage3[i];
        timeMax = Time3[i];
      }
    }

    //時間と電圧の範囲(最小値と最大値)を表示
    text("Time range: " +  min(Time3) + " - " + max(Time3), 20, 20);
    text("Voltage range: " +  min(Voltage3) + " - " + max(Voltage3), 20, 40);

    //電圧の最大値と、その時の時間を表示
    text("Time: " + timeMax, 20, 80);
    text("Voltage: " + voltageMax, 20, 100);
  }
}

void stop() {
  myPort.stop();
  super.stop();
}
