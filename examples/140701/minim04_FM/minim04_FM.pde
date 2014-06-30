// FM合成

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

// オシレーター
Oscil fm;

void setup(){
  size( 512, 200, P3D );

  // Minimクラスのインスタンス化(初期化)
  minim = new Minim( this );
  // 出力先を生成
  out   = minim.getLineOut();
  // モジュレータ用のオシレーター
  Oscil wave = new Oscil( 200, 0.8, Waves.SINE );
  // キャリア用のオスレータを生成
  fm = new Oscil( 10, 2, Waves.SINE );
  // モジュレータの値の最小値を200Hzに
  fm.offset.setLastValue( 200 );
  // キャリアの周波数にモジュレータを設定( = 周波数変調)
  fm.patch( wave.frequency );
  // and patch wave to the output
  wave.patch( out );
}

// 波形を描画
void draw(){
  background( 0 );
  stroke( 255 );
  for( int i = 0; i < out.bufferSize() - 1; i++ ) {
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
  }  
}

// マウスの位置によってFMのパラメータを変化させる
void mouseMoved(){
  float modulateAmount = map( mouseY, 0, height, 500, 1 );
  float modulateFrequency = map( mouseX, 0, width, 0.1, 100 );
  
  fm.frequency.setLastValue( modulateFrequency );
  fm.amplitude.setLastValue( modulateAmount );
}
