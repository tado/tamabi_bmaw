/*
 * Touche for Arduino
 * Vidualization Example 05
 *
 */

float recVoltageMax;
float recTimeMax;
float voltageMax; //電圧の最大値
float timeMax; //電圧が最大値だったときの時間
float yMax = 100; //グラフのY座標最大値
float yMin = 0; //グラフのY座標最小値
float graphMargin = 20; //グラフと画面の余白

float angle = 0;   
int NUM = 100;     
float offset = 360.0/float(NUM);          
color[] colors = new color[NUM];

void setup() {
  //画面サイズ
  size(800, 600, OPENGL); 
  noStroke();
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(60);
  for (int i=0; i<NUM; i++) {
    colors[i] = color(offset*i, 70, 100, 31);
  }
  //noLoop();
  //ポートを設定
  PortSelected=5; 
  //シリアルポートを初期化
  SerialPortSetup();
}

void draw() {
  background(0);

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
    //記録した座標を変換
    float rx = map(recTimeMax, 0, 159, 0, width);
    float ry = map(recVoltageMax, yMin, yMax, height, 0);
    //それぞれの差分
    float diffX = x - rx;
    float diffY = y - ry;
    //距離を算出
    float dist = dist(x, y, rx, ry);

    //回転する立方体を角度をずらしながら大量に描く
    //立方体の大きさを差分に対応させている
    ambientLight(0, 0, 50);
    directionalLight(0, 0, 100, -1, 0, 0);
    pushMatrix();
    translate(width/2, height/2, -20); 
    for (int i=0; i<NUM; i++) {
      pushMatrix();
      fill(colors[i]);
      rotateY(radians(angle / diffY * 3.0 + offset*i));
      rotateX(radians(angle / diffY * 2.0 + offset*i));
      rotateZ(radians(angle / 10.0 + offset*i));
      box(dist);
      popMatrix();
    }
    angle += 1.0;
    popMatrix();
    //現在の最大値と記録した最大値との距離を算出してテキストで表示
    fill(0, 0, 100);
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

