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

    jump = new PVector(random(0.001, 0.01), random(0.001, 0.01));
     
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
    couleur = host.img.pixels[loc];
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

