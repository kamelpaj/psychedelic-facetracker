import KinectPV2.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

KinectPV2 kinect;
Minim minim;
AudioPlayer player;
AudioInput input;
FFT fft;

// Particle stuff
ArrayList<Particle> p = new ArrayList<Particle>();

void setup() {
  size(1920, 1080);
  smooth(2);

  // Particle stuff
  colorMode(HSB);
  noStroke();
  // particleBurst(75, width/2, height/2);

  kinect = new KinectPV2(this);

  //enable HD Face detection
  kinect.enableHDFaceDetection(true);
  kinect.enableColorImg(true); //to draw the color image
  kinect.init();

  // sound
  minim = new Minim(this);
  player = minim.loadFile("reality_code.mp3", 512);
  input = minim.getLineIn();
  player.play();
  fft = new FFT(player.bufferSize(), player.sampleRate());
}

float rot = 0;
float rotneg = 0;

void draw() {
  background(0);
  // image(kinect.getColorImage(), 0, 0);

  //Obtain the Vertex Face Points
  // 1347 Vertex Points for each user.
  ArrayList<HDFaceData> hdFaceData = kinect.getHDFaceVertex();

  fft.forward(player.mix);

  for (int j = 0; j < hdFaceData.size(); j++) {
    //obtain a the HDFace object with all the vertex data
    HDFaceData HDfaceData = (HDFaceData)hdFaceData.get(j);

    if (HDfaceData.isTracked()) {
      //draw the vertex points
      pushStyle();
      stroke(random(255), random(255), random(255));
      strokeWeight(2);
      beginShape(POINTS);
      float cx = 0;
      float cy = 0;
      for (int i = 0; i < KinectPV2.HDFaceVertexCount; i++) {
        float x = HDfaceData.getX(i);
        float y = HDfaceData.getY(i);
        cx += x;
        cy += y;
        vertex(x, y);
      }
      endShape();
      popStyle();

      cx = cx / KinectPV2.HDFaceVertexCount;
      cy = cy / KinectPV2.HDFaceVertexCount;

      rot+=1;
      rotneg-=1;
      boolean sploaded = false;

      // 
      for (int k = 0; k < fft.specSize(); k+=10) {
        pushStyle();
        noFill();
        strokeWeight(5);
        stroke(random(255), random(255), random(255), 200);
        arc(cx+4, cy+4, k+300, k+300, radians(rot), radians(rot) + fft.getBand(k)*2);
        popStyle();
        
        println(fft.getFreq(k));
        if (fft.getFreq(k) > 120 ) {
          particleBurst(5, cx, cy, int(random(255)));

        }
      }
    }

    // Particle burst stuff 
    for (int i = p.size() - 1; i >= 0; i --) {
      p.get(i).update();
      if (p.get(i).dead) {
        p.remove(i);
        continue;
      }
      p.get(i).show();
    }
  }
}

//ArrayList<float> getFrequency() {
//  ArrayList<float> frequency = new ArrayList<float>;
//  int index = 0;
//  for (int i = 0; i < fft.specSize(); i+=10) {
//    frequency[index] = fft.getFreq(i);
//    index++;
//  }
//  return frequency;
//}


void keyPressed() {
  if (key == ' ') {
    particleBurst(75, width/2, height/2, int(random(255)));
  }
}

void particleBurst(int num, float startX, float startY, color c) {
  // int c = int(random(255));
  for (int i = 0; i < num; i ++) {
    float a = int(random(8)) * PI/4;
    p.add(new Particle(startX, startY, a, c));
  }
}
