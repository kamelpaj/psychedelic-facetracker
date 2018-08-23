final int numberOfParticles = 400;

final float initRange = 2.0;
final float massMin = 1.0;
final float massMax = 10.0;

final float mouseForce = 0.1;

final float masterDampening = 0.9;
final float noiseMulti = 0.1;

/*
 
 Spastic Bubbles
 
 2D simulation of particles with very strange properties.
 
 */

ArrayList particles;
boolean bDoMouseForce;

void setup() {
  size(1920, 1080, P3D);

  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.init();

  background(0);
  frameRate(60);

  particles = new ArrayList();

  for (int i = 0; i < numberOfParticles; i++) {   
    particles.add((new c_Particle()));
  }
}

void draw() {
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  KJoint[] joints = null;
  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);

    if (skeleton.isTracked()) {

      joints = skeleton.getJoints();

      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);

  particleSolver(joints);

  //background(0,0,0,1);
  fill(0, 0, 0, 5);
  rect(0, 0, width, height);

  for (int i = 0; i < particles.size(); i++)
  {
    c_Particle thisParticle = (c_Particle) particles.get(i);
    thisParticle.drw();
  }
}

void particleSolver(KJoint[] joints) {

  for (int i = 0; i < particles.size(); i++) {   
    c_Particle thisParticle = (c_Particle) particles.get(i);  
    for (int j = 0; j < particles.size(); j++) {              
      if (i!=j)
      {
        c_Particle thatParticle = (c_Particle) particles.get(j);

        float collisionD = thisParticle.mass + thatParticle.mass;
        float springConst = 0.05;

        float d = thatParticle.position.dist(thisParticle.position);      
        if (d < (collisionD)) {
          if (d < collisionD * 0.5) {
            thisParticle.velocity.x += ( -1 * springConst * (thatParticle.position.x - thisParticle.position.x));
            thisParticle.velocity.y += ( -1 * springConst * (thatParticle.position.y - thisParticle.position.y));
            thisParticle.velocity.mult(0.99);
          } else
          {
            thisParticle.velocity.x += ( springConst * (thatParticle.position.x - thisParticle.position.x));
            thisParticle.velocity.y += ( springConst * (thatParticle.position.y - thisParticle.position.y));
          }

          // inherit a little of their neighbors velocity
          thisParticle.velocity.x += thatParticle.velocity.x * 0.001;
          thisParticle.velocity.y += thatParticle.velocity.y * 0.001;
        }  // end of collision check
      }  // if (i != j)
    } // j
  }  // i

  for (int i = 0; i < particles.size(); i++) {
    c_Particle thisParticle = (c_Particle) particles.get(i);

    if (thisParticle.position.x > width) {
      thisParticle.position.x = width - (thisParticle.position.x - width);
      thisParticle.velocity.x *= -1;
    }
    if (thisParticle.position.y > height) {
      thisParticle.position.y = height - (thisParticle.position.y - height);
      thisParticle.velocity.y *= -1;
    }
    if (thisParticle.position.x < 0) {
      thisParticle.position.x = -1 * thisParticle.position.x;
      thisParticle.velocity.x *= -1;
    }
    if (thisParticle.position.y < 0) {
      thisParticle.position.y = -1 * thisParticle.position.y;
      thisParticle.velocity.y *= -1;
    }

    // add noise
    thisParticle.velocity.x += noiseMulti * (noise(thisParticle.position.x, thisParticle.position.y, frameCount) - 0.5);
    thisParticle.velocity.y += noiseMulti * (noise(thisParticle.position.y, thisParticle.position.x, frameCount) - 0.5) ;

    // attract to the mouse pointer
    if (bDoMouseForce) {
      thisParticle.velocity.x += mouseForce * (joints[KinectPV2.JointType_HandRight].getX() - thisParticle.position.x);
      thisParticle.velocity.y += mouseForce * (joints[KinectPV2.JointType_HandRight].getY() - thisParticle.position.y);
    } else {
      thisParticle.velocity.x += mouseForce * (joints[KinectPV2.JointType_HandRight].getX() - thisParticle.position.x) * 0.01;
      thisParticle.velocity.y += mouseForce * (joints[KinectPV2.JointType_HandRight].getY() - thisParticle.position.y) * 0.01;
    }

    thisParticle.velocity.mult(masterDampening);

    thisParticle.position.add(thisParticle.velocity);

    if (thisParticle.bIsClickedOn) {
      thisParticle.position.set(mouseX+0.0, mouseY+0.0, 0.0);
    }
  }
}

//draw hand state
PVector getHandPosition(KJoint joint) {
  //noStroke();
  //pushMatrix();
  //translate(joint.getX(), joint.getY(), joint.getZ());
  return new PVector(joint.getX(), joint.getY());
  //ellipse(0, 0, 70, 70);
  //popMatrix();
}

void mouseDragged() {
  bDoMouseForce = true;
}

void mousePressed() {
  bDoMouseForce = true;
} 

void mouseReleased() {  
  bDoMouseForce = false;
}

void mouseMoved() {
}
