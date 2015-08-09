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

    applyFlockingForce(PVector.mult(localOffset, independence));

    applyViscosityForce();

    applyCenteringForce();

    velocity.add(force); //mass = 1

    pos.add(PVector.mult(velocity, speed));
  }
  void applyCenteringForce() {
    centeringForce.set(pos);
    centeringForce.sub(avg);
    float distanceToCenter = centeringForce.mag();
    centeringForce.normalize();
    centeringForce.mult(-distanceToCenter/(spread*spread));
    force.add(centeringForce);
  }
  void applyViscosityForce() {
    force.add(PVector.mult(velocity, -viscosity));
  }
  void applyFlockingForce(PVector lOffset) {

    PVector p = PVector.div(pos, neighborhood);

    force.add(noise(p.x + globalOffset.x + lOffset.x, p.y, p.z) - .5, 
    noise(p.x, p.y + globalOffset.y  + lOffset.y, p.z) - .5, 
    noise(p.x, p.y, p.z + globalOffset.z + lOffset.z) - .5);
    
    /*force.add(noise(p.x, p.y, p.z)-.5, 
      noise(p.x, p.y, p.z)-.5, 
      noise(p.x, p.y, p.z)-.5);*/
    
  }
  void resetPosition() {

    pos = PVector.random3D();

    pos.mult(random(rebirthRadius));

    if (particles.size()== 0) pos.add(avg);
    else pos.add(randomParticle().pos);
  }
  //very slow compare to prev version with toxiclibs
  float getDistToPoint(PVector origin, PVector normal, PVector pos) {
    PVector hypotenuse = PVector.sub(pos, origin);
    float c = hypotenuse.mag();
    
    hypotenuse.normalize();
    normal.normalize();
    
    float cos = PVector.dot(normal, hypotenuse);
    
    
    return cos*c;
    
    //float alpha = PVector.angleBetween(normal, hypotenuse);
    //return cos(alpha) * c;
  }
  void display() {
    
   //focalPlane = avg.get();
   //normal = cam.getPosition();

    float distanceToFocalPlane = getDistToPoint(focalPlane, new PVector(normal[0], normal[1], normal[2]), pos);

    distanceToFocalPlane *= 1/dofRatio;
    distanceToFocalPlane = constrain(distanceToFocalPlane, 1, 15);
    strokeWeight(distanceToFocalPlane);
    stroke(255, constrain(255 / (distanceToFocalPlane * distanceToFocalPlane), 1, 255));
    //stroke(255, 0, 0, 255);
    point(pos.x, pos.y, pos.z);
  }
}

