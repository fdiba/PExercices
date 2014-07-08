class SliderController {

  PVector location;
  int width;
  
  SliderController(PVector _location) {
    width = 10;
    location = _location.get();
    location.y += width/2;
    
  }
  protected void update(){
    
  }
  protected void display(){
    
    rectMode(PApplet.CENTER);
    noStroke();
    fill(255);
    rect(location.x, location.y, width, width);
  }

}

