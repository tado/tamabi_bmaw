import ddf.minim.*;

// Minim関連
Minim minim;
AudioPlayer[] player = new AudioPlayer[4];

Graph MyArduinoGraph = new Graph(150, 80, 500, 300, color(31,127,255));
float[] gestureOne=null;
float[] gestureTwo = null;
float[] gestureThree = null;
float[][] gesturePoints = new float[4][2];
float[] gestureDist = new float[4];
String[] names = {
  "Nothing", "Touch", "Grab", "In water"
};

void setup() {
  //!!!!!!!!!!!!!!!!!!!!!!!!!!
  // ポート番号を必ず指定すること
  //!!!!!!!!!!!!!!!!!!!!!!!!!!
  PortSelected=4;

  size(1000, 500);

  //グラフ初期化
  MyArduinoGraph.xLabel="Readnumber";
  MyArduinoGraph.yLabel="Amp";
  MyArduinoGraph.Title=" Graph";
  noLoop();
  SerialPortSetup();

  //Minim初期化
  minim = new Minim(this);

  //サウンドファイル読込み
  player[0] = minim.loadFile("anton.aif");
  player[1] = minim.loadFile("cello-f2.aif");
  player[2] = minim.loadFile("cherokee.aif");
  player[3] = minim.loadFile("drumLoop.aif");
  //それぞれのプレーヤーをループ再生しミュートしておく
  for(int i = 0; i < player.length; i++){
    player[i].loop();
    player[i].mute();
  }
}

void draw() {
  background(255);

   //グラフ描画
   if ( DataRecieved3 ) {
    pushMatrix();
    pushStyle();
    MyArduinoGraph.yMax=1000;      
    MyArduinoGraph.yMin=-200;      
    MyArduinoGraph.xMax=int (max(Time3));
    MyArduinoGraph.DrawAxis();    
    MyArduinoGraph.smoothLine(Time3, Voltage3);
    popStyle();
    popMatrix();

    float gestureOneDiff =0;
    float gestureTwoDiff =0;
    float gestureThreeDiff =0;

    //ジェスチャーの比較
    float totalDist = 0;
    int currentMax = 0;
    float currentMaxValue = -1;
    for (int i = 0; i < 4;i++) {
      //  gesturePoints[i][0] = 
      if (mousePressed && mouseX > 750 && mouseX<800 && mouseY > 100*(i+1) && mouseY < 100*(i+1) + 50) {
        fill(255, 0, 0);
        gesturePoints[i][0] = Time3[MyArduinoGraph.maxI];
        gesturePoints[i][1] = Voltage3[MyArduinoGraph.maxI];
      }
      else {
        fill(255, 255, 255);
      }

      //それぞれのジェスチャーからの距離を算出
      gestureDist[i] = dist(Time3[MyArduinoGraph.maxI], Voltage3[MyArduinoGraph.maxI], gesturePoints[i][0], gesturePoints[i][1]);
      totalDist = totalDist + gestureDist[i];
      if (gestureDist[i] < currentMaxValue || i == 0) {
        currentMax = i;
        currentMaxValue =  gestureDist[i];
      }
    }
    totalDist=totalDist /3;

    for (int i = 0; i < 4;i++) {
      float currentAmmount = 0;
      currentAmmount = 1-gestureDist[i]/totalDist;
      if (currentMax == i) {
        fill(0, 0, 0);
        fill(currentAmmount*255.0f, 0, 0);

        //いったん全てのプレーヤーをミュート
        for(int j = 0; j < player.length; j++){
          player[j].mute();
        }

        //該当するプレーヤーのみミュートを解除
        player[i].unmute();

      }
      else {
        fill(255, 255, 255);
      }

      stroke(0, 0, 0);
      rect(750, 100 * (i+1), 50, 50);
      fill(0, 0, 0);
      textSize(30);
      text(names[i], 810, 100 * (i+1)+25);

      fill(255, 0, 0);
    }
  }
}

void stop() {
  myPort.stop();
  super.stop();
}
