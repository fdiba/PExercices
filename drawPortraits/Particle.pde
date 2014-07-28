class Particle {
  
  PVector location;
  PVector plocation;
  PVector destination;
  PVector velocity;
  
  //color c;
  int blueValue;
  int delay;
  
  //----- param ----//
  int lifespan = 70;
  int maxValue = 60;
  int minValue = -60;
  int maxSpeed = 1;
  float distMin = 10f;
  int step = 5;
  int threshold = 127;
  int maxDelay = 25;
  
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
    velocity = new PVector();
    setDestination();
    setDelay();
  }
  void setDelay(){
    delay = (int) random(maxDelay);
  }
  void setDestination(){
    destination = location.get();
    destination.add(new PVector(random(minValue, maxValue), random(minValue, maxValue)));
  }
  void update(){
    
    PVector acceleration = PVector.sub(destination, location);
    acceleration.normalize();
    acceleration.mult(.1);
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    
    editDelay();
    
    setBoundaries();
    
    setParticleColorBasedOnHostImage();
    
    checkDistanceFromDestination();
    
  }
  void editDelay(){
    
    delay--;
    if(delay<0)delay=0;
    
  }
  void setParticleColorBasedOnHostImage(){
    
    int loc = (int)location.x + (int)location.y * width;
    
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
  void checkDistanceFromDestination(){
    
    float distance = dist(location.x, location.y, destination.x, destination.y);
    
    if(distance <= distMin) {
      PVector rd = new PVector(random(minValue, maxValue), random(minValue, maxValue));
      destination.add(rd);
    }
    
  }
  void setBoundaries(){
      
    if(location.x > width) {
      location.x = width;
    } else if (location.x < 0){
      location.x = 0;
    }
    
    if(location.y > height) {
      location.y = height;
    } else if (location.y < 0){
      location.y = 0;
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
