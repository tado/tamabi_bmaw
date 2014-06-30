/*
 * Touche for Arduino
 * Touche FM Theremin
 *
 */

import ddf.minim.*;
import ddf.minim.ugens.*;

float recVoltageMax;
float recTimeMax;
float voltageMax; //電圧の最大値
float timeMax; //電圧が最大値だったときの時間
float yMax = 100; //グラフのY座標最大値
float yMin = 0; //グラフのY座標最小値
float graphMargin = 20; //グラフと画面の余白

Minim minim;
AudioOutput out;
Oscil fm;

void setup() {
  //画面サイズ
  size(800, 600); 
  //ポートを設定
  PortSelected=2; 
  //シリアルポートを初期化
  SerialPortSetup();

  // Minimクラスのインスタンス化(初期化)
  minim = new Minim( this );
  // 出力先を生成
  out   = minim.getLineOut();
  // モジュレータ用のオシレーター
  Oscil wave = new Oscil( 200, 0.8, Waves.SINE );
  // キャリア用のオスレータを生成
  fm = new Oscil( 10, 2, Waves.SINE );
  // モジュレータの値の最小値を100Hzに
  fm.offset.setLastValue( 100 );
  // キャリアの周波数にモジュレータを設定( = 周波数変調)
  fm.patch( wave.frequency );
  // and patch wave to the output
  wave.patch( out );
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
    float modulateAmount = map( dist, 0, 1000, 0, 1000 );
    float modulateFrequency = map( timeMax, 0, 159, 0.1, 100 );

    fm.frequency.setLastValue( modulateFrequency );
    fm.amplitude.setLastValue( modulateAmount );
  }

  //波形を表示
  background(0);
  stroke(255);
  noFill();
  //Y座標の原点を画面の中心に移動
  translate(0, height/2);
  //バッファーに格納されたサンプル数だけくりかえし
  for (int i = 0; i < out.bufferSize() - 1; i++) {
    //サンプル数から、画面の幅いっぱいに波形を表示するようにマッピング
    float x = map(i, 0, out.bufferSize(), 0, width);
    //画面の高さいっぱになるように、サンプルの値をマッピング
    float y = map(out.mix.get(i), 0, 1.0, 0, height/4);
    //値をプロット
    point(x, y);
  }
}

//マウスをクリック
void mouseReleased() {
  //現在の最大値を記録
  recVoltageMax = voltageMax;
  recTimeMax = timeMax;
}

