/*
 * Touche for Arduino
 * Project Template
 *
 */

float recVoltageMax;
float recTimeMax;
float voltageMax; //電圧の最大値
float timeMax; //電圧が最大値だったときの時間
float yMax = 100; //グラフのY座標最大値
float yMin = 0; //グラフのY座標最小値
float graphMargin = 20; //グラフと画面の余白

void setup() {
  //画面サイズ
  size(800, 600); 
  //ポートを設定
  PortSelected=0; 
  //シリアルポートを初期化
  SerialPortSetup();
}

void draw() {
  background(63);

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
    //画面に描画するために、(x, y)座標の値を画面の大きさにあわせて変換
    float x = map(timeMax, 0, 159, 0, width);
    float y = map(voltageMax, yMin, yMax, height, 0); 
    float rx = map(recTimeMax, 0, 159, 0, width);
    float ry = map(recVoltageMax, yMin, yMax, height, 0);
    float dist = dist(x, y, rx, ry);

    //現在の最大値と記録した最大値との距離を算出してテキストで表示
    fill(255);
    text("dist = "+dist, 20, 20);
  }
}

//マウスをクリック
void mouseReleased() {
  //現在の最大値を記録
  recVoltageMax = voltageMax;
  recTimeMax = timeMax;
}

void stop() {
  myPort.stop();
  super.stop();
}

