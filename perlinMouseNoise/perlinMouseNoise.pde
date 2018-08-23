int nrOfParticles = 300;
Particle particles[]= new Particle[nrOfParticles];

void setup() {
  size(1000, 800);
  background(100);

  // Nr of particles to display.
  for (int i = 0; i < nrOfParticles; i++) {
    particles[i] = new Particle(i*3+50, height);
    particles[i].alpha = map(abs(i-nrOfParticles/2), 0, nrOfParticles/2, 150, 0);
  }
}

void draw() {
  noStroke();
  smooth();

  for (int i = 0; i < nrOfParticles; i++) {
    fill(particles[i].c, particles[i].alpha);
    particles[i].move();
    particles[i].display();
  }
}

class Particle {
  PVector location;
  PVector velocity;
  // size of each particle;
  float size = 1;

  float alpha;
  color c = (#ccdefc);

  Particle(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
  }

  final float noiseScale = 200; 
  void move() {
    PVector mouseAttractor = new PVector();
    float direction = noise((this.location.x)/noiseScale, this.location.y/noiseScale)*TWO_PI;
    
    this.velocity.x = sin(direction)*0.5;
    this.velocity.y = cos(direction)*0.5;
    
    this.location.add(this.velocity);
    
    if (mouseX < location.x) {
      mouseAttractor.add(0, 0.2);
    } else if (mouseX > location.x) {
      mouseAttractor.add(0, -0.2);
    }
    if (mouseY < location.y) {
      mouseAttractor.add(0.2, 0);
    } else if (mouseY > location.y) {
      mouseAttractor.add(-0.2, 0);
    }
    this.location.add(mouseAttractor);
  }

  void display() {
    ellipse(this.location.x, this.location.y, size, size);
  }
}
