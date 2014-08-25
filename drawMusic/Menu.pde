class Menu {
  PVector location;
  Slider[] sliders;
  int showTime;
  
  Menu(PApplet pApplet, PVector _location, Object[][] objects) {
    
    location = _location;
        
    sliders = new Slider[objects.length];
    
    for(int i=0; i<objects.length; i++){
  
      String param = (String) objects[i][0];
      float lowValue = (Integer) objects[i][1];
      float maxValue = (Integer) objects[i][2];
      int c = (Integer) objects[i][3];
      
      sliders[i] = new Slider(pApplet, new PVector(location.x, location.y + 15*i), param, lowValue, maxValue, c);
      
      int row = (Integer) objects[i][4];
      int sliderId = (Integer) objects[i][5];
      int value = (Integer) objects[i][6];  
      
      if(BCF2000) sliders[i].setbehSlider(row, sliderId);
      sliders[i].initValue(value);
      
      params.put(param, value);
      
    }
    
  }
  void reveal(){
    showTime = 24*2;
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
  void display(){
    
    float mx, my, mwidth, mheight;
    mx = location.x-10;
    my = location.y-10;
    mwidth = 120;
    mheight = location.y + 15*sliders.length - 35;

    if(mouseX > mx && mouseX < mx+mwidth && mouseY > my && mouseY < my + mheight || showTime>0) {
      drawBorders(mx, my, mwidth, mheight);
      for (Slider s: sliders) s.display();
    }
    
  }
  void drawBorders(float mx, float my, float mwidth, float mheight){
    
    noFill();
    rectMode(CORNER);
    strokeWeight(1);
    stroke(colors[4], 127);
    rect(mx, my, mwidth, mheight);
    
  }
}
