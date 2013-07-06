/*
 * Touche for Arduino
 * Vidualization Example 03
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
    float diffX = x - rx;
    float diffY = y - ry;
    float dist = dist(x, y, rx, ry);
    float rot = map(diffX, 0, width, 0, PI*2);
    float col = map(dist, 0, width, 0, 180);

    pushMatrix();
    translate(width/2, height/2);
    rotate(rot);

    //現在の最大値と、記録した最大値の距離で円を描く
    fill(255, 0, 0, col);
    stroke(127);
    ellipse(0, 0, dist, dist);

    //現在の最大値と、記録した最大値の間に線を描く
    stroke(255);
    line(0, 0, dist/2, 0);

    //記録しておいた最大値の場所に円を描く
    noStroke();
    fill(#3399ff);
    ellipse(0, 0, 10, 10);

    //現在の最大値の場所に円を描く
    ellipse(dist/2, 0, 10, 10);
    popMatrix();

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

