class Menu {
  PVector location;
  ArrayList<Slider> sliders;
  ArrayList<Integer> colors;
  
  Menu(PVector _location) {
    
    location = _location;
    
    setColors();
    
    sliders = new ArrayList<Slider>();
    
    sliders.add(new Slider(location, "rotateY", -180, 180, colors.get(1)));
    sliders.get(sliders.size()-1).initValue(21.6f);
    rotateYangle = 21.6f;
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15), "rotateX", -180, 180, colors.get(0)));
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "zTrans", -5000, 5000, colors.get(2)));
    sliders.get(sliders.size()-1).initValue(300);
    zTrans = 300;
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "xTrans", -2000, 2000, colors.get(4)));
    sliders.get(sliders.size()-1).initValue(-520);
    xTrans = -520;
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "ySpace", 0, 20, colors.get(3)));
    sliders.get(sliders.size()-1).initValue(10);
    ySpace = 10;
  }
  protected void update(){
    
    if(mousePressed){
      PVector mousePosition = new PVector(mouseX, mouseY);
      for (Slider s: sliders) s.update(mousePosition);
    }
    
    for (Slider s: sliders) s.followMouse();
    
  }
  void resetSliders(){
    for (Slider s: sliders) s.reset();
  }
  void display(){
    for (Slider s: sliders) s.display();
  }
  void setColors(){
    colors = new ArrayList<Integer>();
    colors.add(color(240, 65, 50)); //red
    colors.add(color(135, 205, 137)); //green
    colors.add(color(40, 135, 145)); //blue green
    colors.add(color(252, 177, 135)); //orange
    colors.add(color(15, 65, 85)); //dark blue
  }
}
