class Particle {

  PVector location;
  color couleur;
  PVector translation;
  PVector jump;

  Particle() {

    translation = new PVector(random(10000), random(10000));
    location = new PVector();

    jump = new PVector(0.005, 0.005);
    //location = new PVector(random(640), random(480));
    
    
    couleur = color(255,0,0);
  }
  void update() {
    location.x = (int) map(noise(translation.x), 0, 1, 0, width);
    location.y = (int) map(noise(translation.y), 0, 1, 0, height);
    
 
    getColorAndActUponIt();
    
    translation.add(jump);
    
  }
  void getColorAndActUponIt() {

    int loc = (int)location.x + (int)location.y * host.img.width;
    
    float r = red(host.img.pixels[loc]);
    //float g = green(host.img.pixels[(int)loc]);
    //float b = blue(host.img.pixels[(int)loc]);
    
    this.couleur = color(r);
    //this.couleur = color(255, 0, 0);
    //pixels[(int)loc] = color(r);
  

  }
  void display() {
    stroke(this.couleur);
    point(location.x, location.y);
    
  }
}

