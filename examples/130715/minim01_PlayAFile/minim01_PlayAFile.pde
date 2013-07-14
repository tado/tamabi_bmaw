// Minimサンプル1:
// サウンドファイルの再生と、波形の描画

import ddf.minim.*;

Minim minim;
AudioPlayer player;

void setup(){
  size(512, 200, P3D);

  // minimクラスをインスタンス化(初期化)、ファイルのデータを直接指定する必要があるので「this」を引数に指定
  minim = new Minim(this);

  // loadImageで画像ファイルを読み込む際の要領でサウンドファイルを読み込む
  // サウンドファイルは、スケッチ内の「data」フォルダ内に入れるのが普通だが
  // フルパスやURLで記述することも可能
  player = minim.loadFile("marcus_kellis_theme.mp3");

  // サウンドの再生
  player.play();
}

void draw(){
  background(0);
  stroke(255);

  // 波形を描画
  for(int i = 0; i < player.bufferSize() - 1; i++){
    float x1 = map( i, 0, player.bufferSize(), 0, width );
    float x2 = map( i+1, 0, player.bufferSize(), 0, width );
    line( x1, 50 + player.left.get(i)*50, x2, 50 + player.left.get(i+1)*50 );
    line( x1, 150 + player.right.get(i)*50, x2, 150 + player.right.get(i+1)*50 );
  }
}
