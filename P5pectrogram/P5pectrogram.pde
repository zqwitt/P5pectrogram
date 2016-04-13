import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer in;
//AudioInput in;
FFT fft;
int colmax = 720;
int rowmax = 160;
int[][] sgram = new int[rowmax][colmax];
int col;
int leftedge;


void setup()
{

  size(160, 720, P3D);
  colmax = height;
  colorMode(HSB, 360, 100, 100, 100);
  minim = new Minim(this);

  //in = minim.getLineIn();
  in = minim.loadFile("jingle.mp3", 1024);

  fft = new FFT(in.bufferSize(), in.sampleRate());
  in.loop();

  strokeWeight(2);
}

void draw()
{
  camera(-(width*(2*atan(PI/4))), height/2, (height/2) / tan(PI/4), width, height/2, 0, 0, 1, 0);
  background(0);
  stroke(255);

  fft.forward(in.mix);

  for (int i = 0; i <  rowmax; i++)
  {
    sgram[i][col] = (int)fft.getBand(i)*10;
  }
  col = col + 1; 
  if (col == colmax) { 
    col = 0;
  }

  for (int i = 0; i < colmax-leftedge; i++) {
    for (int j = 0; j < rowmax; j+=5) {
      float h = norm(sgram[j][i+leftedge], 240, 0)*240;
      float b = norm(sgram[j][i+leftedge], 0, 100)*100;
      float s = norm(sgram[j][i+leftedge], 0, 60)*100;
      stroke(h, s, b,50);
      line(j*(width/rowmax)+(width/rowmax), i, 100, j*(width/rowmax)+(width/rowmax), i, 100+b/20);
    }
  }
  for (int i = 0; i < leftedge; i++) {
    for (int j = 0; j < rowmax; j+=5) {
      float h = norm(sgram[j][i], 240, 0)*240;
      float b = norm(sgram[j][i], 0, 100)*100;
      float s = norm(sgram[j][i], 0, 60)*100;
      stroke(h, s, b,50);
      line(j*(width/rowmax)+(width/rowmax), i+colmax-leftedge, 100, j*(width/rowmax)+(width/rowmax), i+colmax-leftedge, 100+b/20);
    }
  }
  leftedge = leftedge + 1; 
  if (leftedge == colmax) { 
    leftedge = 0;
  }
}