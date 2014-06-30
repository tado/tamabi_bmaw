/*
 * Arduino - Processingシリアル通信
 * Processing側サンプル
 */

import processing.serial.*;
Serial myPort; // シリアルポート

float fillColor;
float diameter;

void setup() {
  size(640, 480);
  // ポート番号とスピードを指定してシリアルポートをオープン
  myPort = new Serial(this, Serial.list()[0], 9600);
  // 改行コード(\n)が受信されるまで、シリアルメッセージを受けつづける
  myPort.bufferUntil('\n');
}

void draw() {
  // 受信したセンサーの値で円を描画
  background(0);
  fill(fillColor);
  ellipse(width/2, height/2, diameter, diameter);
}

void serialEvent(Serial myPort) { 
  // シリアルバッファーを読込み
  String myString = myPort.readStringUntil('\n');
  // 空白文字など余計な情報を消去
  myString = trim(myString);
  // コンマ区切りで複数の情報を読み込む
  int sensors[] = int(split(myString, ','));
  // 読み込んだ情報の数だけ、配列に格納
  if (sensors.length > 1) {
    fillColor = map(sensors[0], 0, 1023, 0, 255);
    diameter = map(sensors[1], 0, 1023, 0, height);
  }
  // 読込みが完了したら、次の情報を要求
  myPort.write("A");
}

