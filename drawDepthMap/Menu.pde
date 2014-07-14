class Menu {
  PVector location;
  ArrayList<Slider> sliders;
  int[] colors = {-8410437,-9998215,-1849945,-5517090,-4250587,-14178341,-5804972,-3498634};
  
  Menu(PVector _location) {
    
    location = _location;
    
    //setColors();
    
    sliders = new ArrayList<Slider>();
    
    sliders.add(new Slider(location, "xTrans", -2000, 2000, colors[0]));
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "yTrans", -2000, 2000, colors[1]));
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "zTrans", -2500, 2500, colors[2]));
    sliders.get(sliders.size()-1).initValue(-550);
    zTrans = -550;
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "rotateX", 0, 360, colors[0]));
    sliders.get(sliders.size()-1).initValue(45);
    rotateXangle = 45;
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "rotateZ", 0, 360, colors[2]));
    sliders.get(sliders.size()-1).initValue(0);
    rotateZangle = 0;
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "depth", 1, 200, colors[4]));
    sliders.get(sliders.size()-1).initValue(30);
    depth = 30;

 
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
    /*colors = new ArrayList<Integer>();
    colors.add(color(240, 65, 50)); //red
    colors.add(color(135, 205, 137)); //green
    colors.add(color(40, 135, 145)); //blue green
    colors.add(color(252, 177, 135)); //orange
    colors.add(color(15, 65, 85)); //dark blue*/
  }
}
