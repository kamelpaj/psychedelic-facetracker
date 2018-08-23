import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(255);
    text("OPEN", 500, 500);
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255);
    text("CLOSED", 1000, 500);    
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(255);
    text(handState, 500, 500);    
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255);
    text(handState, 500, 500);    
    fill(255, 255, 255);
    break;
  }
}
