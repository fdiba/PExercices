class Particle {

  PVector pos, force, velocity;
  PVector centeringForce;
  PVector localOffset;
  
  Particle() {
    resetPosition();
    
    centeringForce = new PVector();
    velocity = new PVector();
    force = new PVector();
    
    localOffset = PVector.random3D();
  }
  void update() {
    
    force.mult(0);
    
    applyFlockingForce();
    
    applyViscosityForce();
    
    applyCenteringForce();
    
    velocity.add(force); //mass = 1
    
    pos.add(PVector.mult(velocity, speed));
    
  }
  void applyCenteringForce(){
    centeringForce.set(pos);
    centeringForce.sub(avg);
    float distanceToCenter = centeringForce.mag();
    centeringForce.normalize();
    centeringForce.mult(-distanceToCenter/(spread*spread));
    force.add(centeringForce);
    
  }
  void applyViscosityForce(){
    force.add(PVector.mult(velocity, -viscosity));
  }
  void applyFlockingForce(){
    
    PVector p = PVector.div(pos, neighborhood);
    
    force.add(noise(p.x + globalOffset.x + localOffset.x * independence, p.y, p.z) - .5,
      noise(p.x, p.y + globalOffset.y  + localOffset.y * independence, p.z) - .5,
      noise(p.x, p.y, p.z + globalOffset.z + localOffset.z * independence) - .5);
      
      /*
     force.add(
      noise(
        pos.x / neighborhood + globalOffset.x + localOffset.x * independence,
        pos.y / neighborhood,
        pos.z / neighborhood)
        - .5,
      noise(
        pos.x / neighborhood,
        pos.y / neighborhood + globalOffset.y  + localOffset.y * independence,
        pos.z / neighborhood)
        - .5,
      noise(
        pos.x / neighborhood,
        pos.y / neighborhood,
        pos.z / neighborhood + globalOffset.z + localOffset.z * independence)
        - .5);*/
    
  }
  void resetPosition() {
    
    pos = PVector.random3D();
    
    pos.mult(random(rebirthRadius));
    
    if(particles.size()== 0) pos.add(avg);
    else pos.add(randomParticle().pos);
    
  }
  void display() {
    stroke(255, 0, 0, 255);
    point(pos.x, pos.y, pos.z);
  }
}

