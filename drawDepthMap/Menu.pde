class Menu {
  PVector location;
  ArrayList<Slider> sliders;
  int[] colors = {-8410437,-9998215,-1849945,-5517090,-4250587,-14178341,-5804972,-3498634};
  int showTime;
  
  Menu(PVector _location) {
    
    location = _location;
        
    sliders = new ArrayList<Slider>();
    
    //--- first behringer group -------------------//
    
    sliders.add(new Slider(location, "xTrans", -2000, 2000, colors[0]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(0, 0);
    
    //---
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "yTrans", -2000, 2000, colors[1]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(0, 1);
    
    //---
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "zTrans", -2500, 2500, colors[2]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(0, 2);
    
    sliders.get(sliders.size()-1).initValue(-200);
    zTrans = -200;
    
    //--- second behringer group -------------------//
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "rotateX", 0, 360, colors[0]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(1, 0);
    
    sliders.get(sliders.size()-1).initValue(45);
    rotateXangle = 45;
    
    //---
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "rotateY", 0, 360, colors[1]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(1, 1);
    
    sliders.get(sliders.size()-1).initValue(0);
    rotateYangle = 0;
    
    //---
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "rotateZ", 0, 360, colors[2]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(1, 2);
    
    sliders.get(sliders.size()-1).initValue(0);
    rotateZangle = 0;
    
    //---
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "amplitude", 1, 200, colors[4]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(1, 3);
    
    sliders.get(sliders.size()-1).initValue(25);
    amplitude = 25;
    
    //---
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "ySpace", 10, 150, colors[5]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(1, 4);
    
    sliders.get(sliders.size()-1).initValue(10);
    ySpace = 10;
    
    //---
    
    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "depth", -200, 200, colors[6]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(1, 5);
    
    sliders.get(sliders.size()-1).initValue(60);
    depth = 60;
    
    //---

    sliders.add(new Slider(new PVector(location.x, location.y + 15*sliders.size()), "maxDist", 1, 250, colors[7]));
    if(BCF2000) sliders.get(sliders.size()-1).setbehSlider(1, 6);
    
    sliders.get(sliders.size()-1).initValue(45);
    maxDist = 45;
    
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
