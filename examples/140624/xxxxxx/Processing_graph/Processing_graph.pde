/*
 * Touche for Arduino
 * Vidualization Example 03
 *
 */
import processing.pdf.*;
import java.util.Calendar;

boolean savePDF = false;

float tileCount = 20;
color circleColor = color(0);
int circleAlpha = 180;
int actRandomSeed = 0;

float recVoltageMax;
float recTimeMax;
float voltageMax; //電圧の最大値
float timeMax; //電圧が最大値だったときの時間
float yMax = 200; //グラフのY座標最大値
float yMin = 0; //グラフのY座標最小値
float graphMargin = 20; //グラフと画面の余白
float angle = 0;

void setup() {
  //画面サイズ
  size(600, 600); 
  //ポートを設定
  PortSelected=5; 
  //シリアルポートを初期化
  SerialPortSetup();

  //記録した最大値の値を初期化
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

    //現在の最大値と記録した最大値との距離を算出してテキストで表示
    float dist = dist(x, y, rx, ry);
    text("dist = "+dist, rx + 12, ry);

    translate(width/tileCount/2, height/tileCount/2);

    background(255);
    smooth();
    noFill();

    randomSeed(actRandomSeed);

    stroke(circleColor, circleAlpha);
    strokeWeight(5);

    for (int gridY=0; gridY<tileCount; gridY++) {
      for (int gridX=0; gridX<tileCount; gridX++) {

        float posX = width/tileCount * gridX;
        float posY = height/tileCount * gridY;

        float shiftX = random(-dist, dist)/20;
        float shiftY = random(-dist, dist)/20;

        ellipse(posX+shiftX, posY+shiftY, 20, 20);
      }
    }
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

