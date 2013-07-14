/*
 * Touche for Arduino
 * Touche Theremin
 *
 */

import ddf.minim.*;
import ddf.minim.signals.*;

float recVoltageMax;
float recTimeMax;
float voltageMax; //電圧の最大値
float timeMax; //電圧が最大値だったときの時間
float yMax = 100; //グラフのY座標最大値
float yMin = 0; //グラフのY座標最小値
float graphMargin = 20; //グラフと画面の余白

Minim minim;
AudioOutput out;
SineWave sine;

void setup() {
  //画面サイズ
  size(800, 600); 
  //ポートを設定
  PortSelected=0; 
  //シリアルポートを初期化
  SerialPortSetup();

  minim = new Minim(this);
  out = minim.getLineOut();
  sine = new SineWave(440, 1.0, out.sampleRate());
  sine.portamento(200);
  out.addSignal(sine);
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

    // Sin波の周波数をセンサーの値の距離に対応させる
    float freq = map(dist, 0, 1000, 20, 1000);
    sine.setFreq(freq);
  }

  //波形を表示
  background(0);
  stroke(255);
  //バッファーに格納されたサンプル数だけくりかえし
  for (int i = 0; i < out.bufferSize() - 1; i++) {
    // それぞれのバッファーでのX座標を探す
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    // 次の値へ向けて線を描く
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
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

