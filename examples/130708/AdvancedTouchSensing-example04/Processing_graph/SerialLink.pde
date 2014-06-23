import processing.serial.*;
int SerialPortNumber=2;
int PortSelected=2;

//グローバル変数
int xValue, yValue, Command;
boolean Error=true;
boolean UpdateGraph=true;
int lineGraph;
int ErrorCounter=0;
int TotalRecieved=0;

//ローカル変数
boolean DataRecieved1=false, DataRecieved2=false, DataRecieved3=false;

float[] DynamicArrayTime1, DynamicArrayTime2, DynamicArrayTime3;
float[] Time1, Time2, Time3;
float[] Voltage1, Voltage2, Voltage3;
float[] current;
float[] DynamicArray1, DynamicArray2, DynamicArray3;

float[] PowerArray= new float[0]; // Dynamic arrays that will use the append()
float[] DynamicArrayPower = new float[0]; // function to add values
float[] DynamicArrayTime= new float[0];

String portName;
String[] ArrayOfPorts=new String[SerialPortNumber];

boolean DataRecieved=false, Data1Recieved=false, Data2Recieved=false;
int incrament=0;

int NumOfSerialBytes=8; // The size of the buffer array
int[] serialInArray = new int[NumOfSerialBytes]; // Buffer array
int serialCount = 0; // A count of how many bytes received
int xMSB, xLSB, yMSB, yLSB; // Bytes of data

Serial myPort; // The serial port object

//========================================================================
// シリアル通信の初期化関数
// スピードを115200bpsで接続し、シリアルポートのバッファをクリアした後、
// シリアルのバッファ値を20Byteに設定
//========================================================================
void SerialPortSetup() {
  //text(Serial.list().length,200,200);
  portName= Serial.list()[PortSelected];
  //println( Serial.list());
  ArrayOfPorts=Serial.list();
  printArray(ArrayOfPorts);
  myPort = new Serial(this, portName, 115200);
  delay(50);
  myPort.clear();
  myPort.buffer(20);
}

//========================================================================
// シリアルイベント:
// シリアルポートから何か情報を受けとると呼びだされる
//========================================================================
void serialEvent(Serial myPort) {
  while (myPort.available ()>0) {
    // シリアルのバッファーから次のバイト列を読込み
    int inByte = myPort.read();
    if (inByte==0) {
      serialCount=0;
    }
    if (inByte>255) {
      println(" inByte = "+inByte);
      exit();
    }
    // シリアルポートから取得された最新のバイトを、配列に追加
    serialInArray[serialCount] = inByte;
    serialCount++;

    Error=true;
    if (serialCount >= NumOfSerialBytes ) {
      serialCount = 0;
      TotalRecieved++;
      int Checksum=0;

      for (int x=0; x<serialInArray.length-1; x++) {
        Checksum=Checksum+serialInArray[x];
      }

      Checksum=Checksum%255;

      if (Checksum==serialInArray[serialInArray.length-1]) {
        Error = false;
        DataRecieved=true;
      } 
      else {
        Error = true;
        DataRecieved=false;
        ErrorCounter++;
        println("Error:  "+ ErrorCounter +" / "+ TotalRecieved+" : "+float(ErrorCounter/TotalRecieved)*100+"%");
      }
    }

    if (!Error) {
      int zeroByte = serialInArray[6];
      // println (zeroByte & 2);
      xLSB = serialInArray[3];
      if ( (zeroByte & 1) == 1) xLSB=0;
      xMSB = serialInArray[2];
      if ( (zeroByte & 2) == 2) xMSB=0;
      yLSB = serialInArray[5];
      if ( (zeroByte & 4) == 4) yLSB=0;
      yMSB = serialInArray[4];
      if ( (zeroByte & 8) == 8) yMSB=0;

      //データ内容確認用
      //println( "0\tCommand\tyMSB\tyLSB\txMSB\txLSB\tzeroByte\tsChecksum");
      //println(serialInArray[0]+"\t"+Command +"\t"+ yMSB +"\t"+ yLSB +"\t"+ xMSB +"\t"+ xLSB+"\t" +zeroByte+"\t"+ serialInArray[7]);

      //========================================================================
      // バイト(8bit)単位に分割されたデータを合成して、16bit(0〜1024)の値を復元する
      //========================================================================
      Command  = serialInArray[1];
      xValue   = xMSB << 8 | xLSB; // xMSBとxLSBの値から、xValueを合成
      yValue   = yMSB << 8 | yLSB; // yMSBとyLSBの値から、yValueを合成

      //データ内容確認用
      //println(Command+ "  "+xValue+"  "+ yValue+" " );

      //========================================================================
      // Command, xValue, yValueの3つの値がArduinoから取得完了
      // 様々なケースごとに、グラフ描画用の配列に格納していく
      //========================================================================

      switch(Command) { //Commandの値によって、動作をふりわけ

        //配列1と配列2がArduinoから受信された状態、グラフを更新する

      case 1: // 配列にデータを追加
        DynamicArrayTime3=append( DynamicArrayTime3, (xValue) ); //xValueを時間の配列に1つ追加
        DynamicArray3=append( DynamicArray3, (yValue) ); //yValueをの電圧の配列に1つ追加
        break;

      case 2: // 想定外のサイズの配列を受けとった場合、配列を空に初期化
        DynamicArrayTime3= new float[0];
        DynamicArray3= new float[0];
        break;

      case 3:  // 配列の受信完了、値を追加した配列をグラフ描画用の配列にコピーして、グラフを描画する
        Time3=DynamicArrayTime3;
        Voltage3=DynamicArray3;
        //   println(Voltage3.length);
        DataRecieved3=true;
        break;
      }
    }
  }
  redraw();
}

