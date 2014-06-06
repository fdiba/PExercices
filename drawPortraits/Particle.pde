class Particle{
  
  PVector location;
  color couleur;
  PVector translation;
  PVector jump;
  
  Particle(){
    
    translation = new PVector(random(10000), random(10000));
    location = new PVector();
    jump = new PVector(0.001, 0.001);
    couleur = color(255);
  }
  void update(){
    location.x = map(noise(translation.x), 0, 1, 0, width);
    location.y = map(noise(translation.y), 0, 1, 0, height);
    translation.add(jump);
  }
  void display(){
    stroke(couleur);
    point(location.x, location.y);
    
  }
}
