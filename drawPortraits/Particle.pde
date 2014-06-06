class Particle {

  PVector location;
  PVector plocation;
  color couleur;
  PVector translation;
  PVector jump;
  boolean init;

  Particle() {

    translation = new PVector(random(10000), random(10000));
    location = plocation = new PVector();

    jump = new PVector(0.005, 0.005);
    //location = new PVector(random(640), random(480));
    
    
    couleur = color(255,0,0);
  }
  void update() {
    location.x = map(noise(translation.x), 0, 1, 0, width);
    location.y = map(noise(translation.y), 0, 1, 0, height);
    
    getColorAndActUponIt();
    
    translation.add(jump);
  }
  void getColorAndActUponIt() {

    int loc = (int)location.x + (int)location.y * host.img.width;
    
    float r = red(host.img.pixels[loc]);
    //float g = green(host.img.pixels[(int)loc]);
    //float b = blue(host.img.pixels[(int)loc]); 
    couleur = color(r);
  }
  void display() {
    stroke(couleur);
    
    
    if(init){
      line(plocation.x, plocation.y, location.x, location.y);
    } else {
      point(location.x, location.y);
      init = true;
    }
    plocation = location.get();
  }
}

