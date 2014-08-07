class Menu {
  PVector location;
  ArrayList<Slider> sliders;
  int[] colors = {-8410437,-9998215,-1849945,-5517090,-4250587,-14178341,-5804972,-3498634};
  int showTime;
  
  Menu(PVector _location) {
    
    location = _location;
        
    sliders = new ArrayList<Slider>();
    
    sliders.add(new Slider(location, "blobThreshold", 0, 255, colors[0]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(0, 0);
    
    sliders.get(sliders.size()-1).initValue(72);
    blobThreshold = 72;
    
    //---
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "blurRadius", 1, 200, colors[1]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(0, 1);
    
    sliders.get(sliders.size()-1).initValue(9);
    blurRadius = 9;
    
    //---
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "edgeMinNumber", 0, 500, colors[2]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(0, 2);
    
    sliders.get(sliders.size()-1).initValue(375);
    edgeMinNumber = 375;
    
    //---
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "distMin", 0, 100, colors[3]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(0, 3);
    
    sliders.get(sliders.size()-1).initValue(10);
    distMin = 10;
    
  }
  protected void update(){
    
    if(showTime>0)showTime--;
    
    if(mousePressed){
      PVector mousePosition = new PVector(mouseX, mouseY);
      for (Slider s: sliders) s.update(mousePosition);
    }
    
    for (Slider s: sliders) s.followMouse();
    
  }
  void resetBSliders(){
    for (Slider s: sliders) s.editBehSliderPos();
  }
  void resetSliders(){
    for (Slider s: sliders) s.reset();
  }
  void drawBorders(float mx, float my, float mwidth, float mheight){
    
    noFill();
    rectMode(CORNER);
    strokeWeight(1);
    stroke(colors[4], 127);
    rect(mx, my, mwidth, mheight);
    
  }
  void reveal(){
    
    showTime = 24*2;
    
  }
  void display(){

    float mx, my, mwidth, mheight;
    mx = location.x-10;
    my = location.y-10;
    mwidth = 120;
    mheight = location.y + 15*sliders.size() - 35;

    if(mouseX > mx && mouseX < mx+mwidth && mouseY > my && mouseY < my + mheight || showTime>0) {
      drawBorders(mx, my, mwidth, mheight);
      for (Slider s: sliders) s.display();
    }
  }
}
