// 複数のサウンドファイルを鳴らす

import ddf.minim.*;

Minim minim;
AudioSample kick;
AudioSample snare;

void setup(){
  size(512, 200, P3D);
  minim = new Minim(this);

  // バスドラムの音を読込み
  kick = minim.loadSample( "BD.mp3", // ファイル名
                            512      // バッファサイズ
                            );

  // ファイルが存在しない場合、エラーメッセージを返す
  if ( kick == null ){
   println("Didn't get kick!");
 }
  // スネアの音を読込み
  snare = minim.loadSample("SD.wav", 512);
  // ファイルが存在しない場合、エラーメッセージを返す
  if ( snare == null ){
    println("Didn't get snare!");

  }
}
void draw(){
  background(0);
  stroke(255);

  // それぞれのサウンドの波形の描画
  for (int i = 0; i < kick.bufferSize() - 1; i++) {
    float x1 = map(i, 0, kick.bufferSize(), 0, width);
    float x2 = map(i+1, 0, kick.bufferSize(), 0, width);
    line(x1, 50 - kick.mix.get(i)*50, x2, 50 - kick.mix.get(i+1)*50);
    line(x1, 150 - snare.mix.get(i)*50, x2, 150 - snare.mix.get(i+1)*50);
  }
}

// キー入力でサウンド再生
void keyPressed(){
  if ( key == 's' ){
    snare.trigger();
  }
  if ( key == 'k' ){
    kick.trigger();
  }
}

