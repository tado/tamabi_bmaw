/*
 * Arduino - Processingシリアル通信
 * センサーの値をグラフにプロット
 * Processing側サンプル
 */
import processing.serial.*;

int NUM = 2; //センサーの数
Serial myPort; // シリアルポート

int[] sensors = new int[NUM]; //センサーの値を格納する配列
int cnt; //カウンター

// グラフの線の色を格納
color[] col = new color[6];

void setup() {
  //画面設定
  size(800, 400);
  frameRate(60);

  // シリアルポートのリスト取得
  println(Serial.list());
  // ポート番号とスピードを指定してシリアルポートをオープン
  myPort = new Serial(this, Serial.list()[0], 9600);
  // 改行コード(\n)が受信されるまで、シリアルメッセージを受けつづける
  myPort.bufferUntil('\n');

  //グラフ初期化
  initGraph();
}

void draw() {
  // センサーの数だけ、グラフをプロット  
  for (int i = 0; i < NUM; i++) {
    fill(col[i]);
    float tx = map(cnt, 0, width, 0, width);
    float ty = map(sensors[i], 0, 1023, height, 0);
    ellipse(tx, ty, 4, 4);
  }
  // 画面の右端まで描画したら再初期化
  if (cnt > width) {
    initGraph();
  }
  //カウンタアップ
  cnt++;
}

//グラフの初期化
void initGraph() {
  background(47);
  noStroke();
  cnt = 0;
  // グラフ描画の線の色を定義
  col[0] = color(255, 127, 31);
  col[1] = color(31, 255, 127);
  col[2] = color(127, 31, 255);
  col[3] = color(31, 127, 255);
  col[4] = color(127, 255, 31);
  col[5] = color(127);
}

void serialEvent(Serial myPort) { 
  // シリアルバッファーを読込み
  String myString = myPort.readStringUntil('\n');
  // 空白文字など余計な情報を消去
  myString = trim(myString);
  // コンマ区切りで複数の情報を読み込む
  sensors = int(split(myString, ','));
  // 読込みが完了したら、次の情報を要求
  myPort.write("A");
}

