/*
 * Touche for Arduino
 * Vidualization Example 02
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
  noLoop();
  //ポートを設定
  PortSelected=5; 
  //シリアルポートを初期化
  SerialPortSetup();

  recVoltageMax = recTimeMax = 0;
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
    float x = map(timeMax, 0, 159, graphMargin, width-graphMargin);
    float y = map(voltageMax, yMin, yMax, height-graphMargin, graphMargin); 
    float rx = map(recTimeMax, 0, 159, graphMargin, width-graphMargin);
    float ry = map(recVoltageMax, yMin, yMax, height-graphMargin, graphMargin);

    //枠線を描く
    noFill();
    stroke(127);
    rect(graphMargin, graphMargin, width - graphMargin * 2, height - graphMargin * 2);

    //現在の最大値の座標を交差する線で描く
    stroke(80);
    line(x, graphMargin, x, height-graphMargin);
    line(graphMargin, y, width-graphMargin, y);

    stroke(255);
    line(x, y, rx, ry);

    //現在のそれぞれの最大値を文字で表示
    fill(#3399ff);
    noStroke();
    text(timeMax, x+2, height-graphMargin-2);
    text(voltageMax, graphMargin, y-10);

    //現在の最大値を円で描く
    ellipse(x, y, 20, 20);
    ellipse(rx, ry, 20, 20);

    float dist = dist(x, y, rx, ry);
    text("dist = "+dist, rx + 12, ry);
  }
}

void mouseReleased() {
  recVoltageMax = voltageMax;
  recTimeMax = timeMax;
}

void stop() {
  myPort.stop();
  super.stop();
}

