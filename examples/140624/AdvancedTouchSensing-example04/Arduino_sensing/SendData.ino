byte yMSB=0, yLSB=0, xMSB=0, xLSB=0, zeroByte=128, Checksum=0;

void SendData(int Command, unsigned int yValue,unsigned int xValue){
    yLSB=lowByte(yValue);   //yの値(16bit)の後半8bit
    yMSB=highByte(yValue);  //yの値(16bit)の前半8bit
    xLSB=lowByte(xValue);   //xの値(16bit)の後半8bit
    xMSB=highByte(xValue);  //xの値(16bit)の前半8bit

    //空白(0Byte)の値がある場所を記録
    zeroByte = 128;                            // 10000000
    if(yLSB==0){ yLSB=1; zeroByte=zeroByte+1;} // 1bit目を1に(10000001)
    if(yMSB==0){ yMSB=1; zeroByte=zeroByte+2;} // 2bit目を1に(10000010)
    if(xLSB==0){ xLSB=1; zeroByte=zeroByte+4;} // 3bit目を1に(10000100)
    if(xMSB==0){ xMSB=1; zeroByte=zeroByte+8;} // 4bit目を1に(10001000)
    
    Checksum = (Command + yMSB + yLSB + xMSB + xLSB + zeroByte)%255;
    
    if( Checksum !=0 ){
        Serial.write(byte(0));            // 先頭のビット
        Serial.write(byte(Command));      // どのグラフを描画するのかを指定するコマンド
        
        Serial.write(byte(yMSB));         // Yの値の前半8bit(1Byte)を送信
        Serial.write(byte(yLSB));         // Yの値の後半8bit(1Byte)を送信
        Serial.write(byte(xMSB));         // Xの値の前半8bit(1Byte)を送信
        Serial.write(byte(xLSB));         // Xの値の後半8bit(1Byte)を送信
        
        Serial.write(byte(zeroByte));     // どの値に0があるのかを送信
        Serial.write(byte(Checksum));     // チェック用バイト
    }
}

void PlottArray(unsigned int Cmd,float Array1[],float Array2[]){
    
    SendData(Cmd+1, 1,1);
    delay(1);
    for(int x=0;  x < sizeOfArray;  x++){
        SendData(Cmd, round(Array1[x]),round(Array2[x]));
    }
    SendData(Cmd+2, 1,1);
}

