class c_Particle {

  PVector position;
  PVector velocity;
  PVector clr;
  float mass;
  boolean bIsClickedOn;

  c_Particle() {
    position = new PVector((width / 2.0) + random(-initRange, initRange), (height / 2.0) + random(-initRange, initRange));
    velocity = new PVector(0.0, 0.0);
    clr = new PVector(33.0, 64.0, 255.0);

    mass = random(massMin, massMax);
    bIsClickedOn = false;
  }

  void drw() {

    pushMatrix();
    translate(position.x, position.y);
    fill(clr.x, clr.y, clr.z, velocity.mag()*128);
    //sphere(mass);
    ellipse(0, 0, mass, mass); 
    popMatrix();
  }
}
