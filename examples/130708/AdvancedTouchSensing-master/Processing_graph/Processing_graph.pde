/*
 * Processing_graph.pde
 *
 */

// グラフ描画のクラスのインスタンス化(初期化)
Graph MyArduinoGraph = new Graph(150, 80, 500, 300, color (200, 20, 20));
// 4つのジェスチャーを記録する配列
float[][] gesturePoints = new float[4][2];
// 現在のジェスチャーと登録したジェスチャーとの距離
float[] gestureDist = new float[4];
// それぞれのジェスチャーの名前の文字列
String[] names = {
  "Nothing", "Touch", "Grab", "In water"
};

void setup() {
  //画面サイズ
  size(1000, 500); 
  // グラフのラベル設定
  MyArduinoGraph.xLabel="Readnumber";
  MyArduinoGraph.yLabel="Amp";
  MyArduinoGraph.Title=" Graph";  
  noLoop();

  //ポートを設定
  PortSelected=4; 

  //シリアルポートを初期化
  SerialPortSetup();
}

void draw() {
  background(255);

  /* ====================================================================
   グラフを描画
   ====================================================================  */

   if ( DataRecieved3 ) {
    pushMatrix();
    pushStyle();
    MyArduinoGraph.yMax=100;      
    MyArduinoGraph.yMin=-10;      
    MyArduinoGraph.xMax=int (max(Time3));
    MyArduinoGraph.DrawAxis();    
    MyArduinoGraph.smoothLine(Time3, Voltage3);
    popStyle();
    popMatrix();

    float gestureOneDiff =0;
    float gestureTwoDiff =0;
    float gestureThreeDiff =0;

    /* ====================================================================
     ジェスチャーを比較
     ====================================================================  */
     float totalDist = 0;
     int currentMax = 0;
     float currentMaxValue = -1;
    for (int i = 0; i < 4;i++) { //4つの登録したジェスチャーを比較
      //ボタンをマウスでクリックしたときには、現在のジェスチャーを配列に記録
      if (mousePressed && mouseX > 750 && mouseX<800 && mouseY > 100*(i+1) && mouseY < 100*(i+1) + 50) {
        fill(255, 0, 0);
        gesturePoints[i][0] = Time3[MyArduinoGraph.maxI];
        gesturePoints[i][1] = Voltage3[MyArduinoGraph.maxI];
      } 
      else {
        fill(255, 255, 255);
      }
      //それぞれの点と現在の状態の距離を算出
      gestureDist[i] = dist(Time3[MyArduinoGraph.maxI], Voltage3[MyArduinoGraph.maxI], gesturePoints[i][0], gesturePoints[i][1]);
      //距離の合計を算出
      totalDist = totalDist + gestureDist[i];
      //最大値を算出
      if (gestureDist[i] < currentMaxValue || i == 0) {
        currentMax = i;
        currentMaxValue =  gestureDist[i];
      }
    }
    totalDist=totalDist /3;
    // 現在のジェスチャーと登録したジェスチャーの距離から、ボタンの色を描画
    for (int i = 0; i < 4;i++) {
      float currentAmmount = 0;
      currentAmmount = 1-gestureDist[i]/totalDist;
      if (currentMax == i) {
        fill(currentAmmount*255.0f, 0, 0);
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
