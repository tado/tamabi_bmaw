import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;
SineWave sine;

void setup() {
  size(512, 200, P3D);
  frameRate(60);
  smooth();
  strokeWeight(2);

  minim = new Minim(this);
  out = minim.getLineOut();
  sine = new SineWave(440, 1.0, out.sampleRate());
  sine.portamento(200);
  out.addSignal(sine);
}

void draw() {
  //波形を表示
  background(0);
  stroke(255);
  //バッファーに格納されたサンプル数だけくりかえし
  for (int i = 0; i < out.bufferSize() - 1; i++) {
    // それぞれのバッファーでのX座標を探す
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    // 次の値へ向けて線を描く
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
  }
}

void mouseMoved() {
  // 周波数をマウスのX座標で変化させる
  float freq = map(mouseX, 0, width, 20, 1000);
  sine.setFreq(freq);
  // 音量をマウスのY座標で変化させる
  float amp = map(mouseY, 0, height, 1, 0);
  sine.setAmp(amp);
}

