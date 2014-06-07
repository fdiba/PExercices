class Particle {

  PVector location;
  PVector plocation;
  PVector destination;
  PVector velocity;
  color couleur;
  //PVector translation;
  //PVector jump;
  boolean init;
  float lifespan;
  int maxSpeed;
  int maxValue;
  int minValue;

  Particle() {
    location = plocation = new PVector(random(width), random(height));
    init();
  }
  Particle(PVector _location, int _lifespan) {
    location = plocation = _location.get();
    lifespan = _lifespan;
    init();
  }
  void init(){
    minValue = -200;
    maxValue = 200;
    destination = location.get();
    PVector rd = new PVector(random(minValue, maxValue), random(minValue, maxValue));
    destination.add(rd);
    couleur = color(0, 255, 0);
    lifespan = 20;  
    maxSpeed = 2;
    velocity = new PVector();
  }
  void update() {
    
    PVector acceleration = PVector.sub(destination, location);
    acceleration.normalize();
    acceleration.mult(.1);
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    
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
    
    getColorAndActUponIt();

    float distance = dist(location.x, location.y, destination.x, destination.y);
    
    if(distance <= 30) {
      
      PVector rd = new PVector(random(minValue, maxValue), random(minValue, maxValue));
      destination.add(rd);
      
    }

  }
  void getColorAndActUponIt() {
    int loc = (int)location.x + (int)location.y * host.img.width;
 
    if(loc < host.img.pixels.length-1){
 
      couleur = host.img.pixels[loc];
      
      if(couleur != 0xff000000) {
        host.img.pixels[loc] = 0xff000000;
        lifespan += 6;
      } else {
        lifespan -= 6;
      }
    } else {
      lifespan = 0; 
    }
  }
  boolean isDead() {
    if(lifespan <= 0.0) {
        return true;
      } else {
        return false;
      }
  }
  void display() {
    stroke(couleur);
    if(init){
      if(couleur > 0xff000000) line(plocation.x, plocation.y, location.x, location.y);
    } else {
      if(couleur > 0xff00ff00) point(location.x, location.y);
      init = true;
    }
    plocation = location.get();
    //displayDestination();
  }
  void displayDestination(){
    stroke(255,0,0);
    point(destination.x, destination.y);
  }
}

