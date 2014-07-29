class Particle {
  
  PVector location;
  PVector plocation;
  PVector velocity;
  PVector acceleration;
  
  int blueValue;
  int delay;
  int lifespan;
  
  //----- param ----//
  int startLifespan = 50;
  int maxValue = 60;
  int minValue = -60;
  int maxSpeed = 1;
  float distMin = 10f;
  int step = 5;
  int threshold = 0; //high importance
  float maxforce = 0.05;    //maximum steering force
  //int maxDelay = 25*2;
  
  Particle() {
    location = plocation = new PVector(random(width), random(height)); 
    init();
  }
  Particle(PVector loc, int _lifespan) {
    location = plocation = loc.get();
    lifespan = _lifespan;
    init();
  }
  void init(){
    blueValue = 127;
    //velocity = new PVector(0,0);
    velocity = new PVector(random(minValue, maxValue), random(minValue, maxValue));
    acceleration = new PVector(0,0);
    //setDelay();
  }
  /*void setDelay(){
    delay = int(random(maxDelay))+25;
  }*/
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  void flock(ArrayList<Particle> particles){
    
    PVector sep = separate(particles);
    //PVector ali = align(particles);
    //PVector coh = cohesion(particles);
    
    //-------- TODO PARAM -----------//
    sep.mult(1.5);
    //ali.mult(1.0);
    //coh.mult(1.0);
    
    applyForce(sep);
    //applyForce(ali);
    //applyForce(coh);
    
  }
  PVector separate (ArrayList<Particle> particles) {
    
    float desiredseparation = 25.0f; //--------- PARAM --------------//
    PVector steer = new PVector(0,0);
    int count = 0;
    
    for (Particle other : particles) {
      
      float distance = PVector.dist(location, other.location);
      
      if ((distance > 0) && (distance < desiredseparation)) {
        
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(distance);
        steer.add(diff);
        count++;
            
      }
    }
    
    if (count > 0) steer.div((float)count);
    
    if (steer.mag() > 0) {
      
      //implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxforce);
      
    }
    
    return steer;
    
  }
  PVector align (ArrayList<Particle> particles) {
      
    float neighbordist = 50;
    PVector sum = new PVector(0,0);
    int count = 0;
    
    for (Particle other : particles) {
      
      float distance = PVector.dist(location, other.location);
      
      if ((distance > 0) && (distance < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
      
    }
    
    if (count > 0) {
      
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxSpeed);
      
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxforce);
      return steer;
      
    } else {
      
      return new PVector(0,0);
    
    }
    
  }
  PVector cohesion (ArrayList<Particle> particles) {
    
    float neighbordist = 50;
    PVector sum = new PVector(0,0);
    int count = 0;
    
    for (Particle other : particles) {
      
      float distance = PVector.dist(location, other.location);
      
      if ((distance > 0) && (distance < neighbordist)) {
        sum.add(other.location);
        count++;
      }
    }
    
    if (count > 0) {
      
      sum.div(count);
      return seek(sum);
    
    } else {
      return new PVector(0,0);
    }
    
  }
  PVector seek(PVector target) {
    
    PVector desired = PVector.sub(target, location);
    
    desired.normalize();
    desired.mult(maxSpeed);
    
    /* a method that calculates and applies a steering force towards a target
     * steering = Desired minus Velocity
     */
     
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    return steer;
    
  }
    
  void run(ArrayList<Particle> particles){
    flock(particles);
    update();
  }
  void editDelay(){
    delay--;
    if(delay<0)delay=0;
  }
  void update(){
    
    //PVector acceleration = PVector.sub(destination, location);
    //acceleration.normalize();
    //acceleration.mult(.1);
    
    velocity.add(acceleration);
    
    velocity.limit(maxSpeed);
    
    location.add(velocity);
    
    acceleration.mult(0);
    
    //------------------
        
    setBoundaries();
    
    setParticleColorBasedOnHostImage();
    
    editDelay();
    
  }
  void setParticleColorBasedOnHostImage(){
    
    int y = (int)location.y;
    int x = (int)location.x;
    
    if (y >= height) y = height-1;
    if (x >= width) x = width-1;
    
    int loc = x + y * width;
    
    if(loc < width*height){
      
      color hostColor = host.img.pixels[loc];
      color pixColor = pixels[loc];
    
      //faster than float blue = blue(couleur);
      int hostBlue = hostColor & 0xFF;
      int actualBlueValue = pixColor & 0xFF;
        
      if(blueValue < hostBlue){
        
        blueValue += 5;
        
      } else {
        blueValue -= 5;
      }
      
      blueValue = constrain(blueValue, 0, 255);
      
      int num1 = abs(hostBlue-blueValue);
      int num2 = abs(hostBlue-actualBlueValue);
      
      if(num1<num2) pixels[loc] =  (blueValue << 16) | (blueValue << 8) | blueValue; //if new color is closer than the actual one frome the model
      
      if(num1 < 5 || num2 < 5) editPixArray(loc);

      editLifespan(hostBlue, loc);
      
      
    } else {

      println("bug - loc doesn't exist " + 640*480 + " " + loc); 
      
    }
      
  }
  void editPixArray(int loc){
    
    if(!host.pix[loc]) host.pix[loc] = true;
    
  }
  void editLifespan(int hostBlue, int loc){

    if(hostBlue > threshold && !host.pix[loc]){
        
      lifespan += step*5;
      
    } else {
      
      lifespan -= step;
      
    }
    

    lifespan = constrain(lifespan, 0, 100);
 
  }
  void setBoundaries(){
      
    if(location.x > width) {
      location.x = 0;
    } else if (location.x < 0){
      location.x = width;
    }
    
    if(location.y > height) {
      location.y = 0;
    } else if (location.y < 0){
      location.y = height;
    }
    
  }
  void display(){
    stroke(blueValue);    
    point(location.x, location.y);
  }
  boolean isDead() {
    if(lifespan <= 0) {
      return true;
    } else {
      return false;
    }
  }
}
