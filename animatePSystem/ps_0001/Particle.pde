class Particle {

  PVector position, force;
  
  Particle() {
    
    resetPosition();
    
    force = new PVector();
    
  }
  void update() {
  }
  void resetPosition() {
    position = PVector.random3D();
    position.mult(random(rebirthRadius));
    
    if(particles.size() == 0) position.add(avg);
    else position.add(randomParticle().position);
    
  }
  void display() {
    stroke(255);
    point(position.x, position.y, position.z);
  }
}

