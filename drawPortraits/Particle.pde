class Particle{
  
  PVector location;
  color couleur;
  
  Particle(){
    location = new PVector(random(width), random(height));
    couleur = color(255);
  }
  void update(){
    
  }
  void display(){
    stroke(couleur);
    point(location.x, location.y);
    
  }
}
