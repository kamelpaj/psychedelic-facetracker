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

void setup() {
  size(1920, 1080);
  smooth(2);

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
void draw() {
  background(0);
  
 
  //Obtain the Vertex Face Points
  // 1347 Vertex Points for each user.
  ArrayList<HDFaceData> hdFaceData = kinect.getHDFaceVertex();
  
  fft.forward(player.mix);

  for (int j = 0; j < hdFaceData.size(); j++) {
    //obtain a the HDFace object with all the vertex data
    HDFaceData HDfaceData = (HDFaceData)hdFaceData.get(j);
  
    if (HDfaceData.isTracked()) {
      //draw the vertex points
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
      
      cx = cx / KinectPV2.HDFaceVertexCount;
      cy = cy / KinectPV2.HDFaceVertexCount;
      
      if (rot > 360) {
         rot = 0;
        } else {
          rot += 0.025; 
      }
      float neg = -rot;
      for (int k = 0; k < fft.specSize(); k+=10) {
        noFill();
        strokeWeight(5);
        stroke(random(255), random(255), random(255), 200);
        
        //println("rot = " + rot + "neg = " + neg);
        arc(cx+4, cy+4, k+300, k+300, rot, rot + fft.getBand(k)*2);
        arc(cx+4, cy+4, k+300, k+300, rot, rot + fft.getBand(k)*2);
      }
    }
  }
}
