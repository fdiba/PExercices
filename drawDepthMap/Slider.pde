class Slider {
  
  PVector location;
  SliderController sliderCtrl;
  int width;
  boolean dragging;
  float maxValue;
  float lowValue;
  float value;
  float lowXPos;
  float maxYPos;
  String param;
  int couleur;
  
  Slider(PVector _location, String _param, float _lowValue, float _maxValue, int _color) {
    location = _location;
    width = 100; 
    sliderCtrl = new SliderController(new PVector(location.x+width/2, location.y));
    param = _param;
    
    lowValue = _lowValue;
    maxValue = _maxValue;
    
    lowXPos = location.x;
    maxYPos = location.x + width;
    
    couleur = _color;
  }
  protected void update(PVector mousePosition){
    
    if(mousePosition.x > sliderCtrl.location.x - sliderCtrl.width/2 && mousePosition.x < sliderCtrl.location.x + sliderCtrl.width/2 &&
       mousePosition.y > sliderCtrl.location.y - sliderCtrl.width/2 && mousePosition.y <sliderCtrl. location.y + sliderCtrl.width/2){
      
      //PApplet.println("hit");
      dragging = true;
      //sliderCtrl.location.x = mousePosition.x;
    } 
    
  }
  protected void initValue(float f){
    
    float value = PApplet.map(f, lowValue, maxValue, location.x, location.x+width);
    sliderCtrl.location.x = value;
    
    //sliderCtrl.location.x = location.x + _x;
    
    
  }
  protected void followMouse(){
    if(dragging) {
      sliderCtrl.location.x = mouseX;
      if(sliderCtrl.location.x <= lowXPos) {
        sliderCtrl.location.x = lowXPos;
      } else if (sliderCtrl.location.x >= maxYPos) {
        sliderCtrl.location.x = maxYPos;
      }
      editValue();
    }
  }
  private void editValue(){
    
    value = PApplet.map(sliderCtrl.location.x, lowXPos, maxYPos, lowValue, maxValue);
   
    if (param.equals("depth")) {
      depth = (int) value;
    } else if (param.equals("amplitude")){
      amplitude = (int) value;
    } else if (param.equals("xTrans")){
      xTrans = value;
    } else if (param.equals("zTrans")){
      zTrans = value;
    } else if (param.equals("yTrans")){
      yTrans = value;
    } else if (param.equals("rotateX")){
      rotateXangle = value;
    } else if (param.equals("rotateY")){
      rotateYangle = value;
    } else if (param.equals("rotateZ")){
      rotateZangle = value;
    } else if (param.equals("ySpace")){
      ySpace = (int) value;
    }
   
    println(param + ": " + value);
    
  }
  protected void reset(){
    dragging = false;
  }
  protected void display(){
    rectMode(PApplet.CORNER);
    noStroke();
    fill(couleur);
    rect(location.x, location.y, width, 10);
    sliderCtrl.display();
  }
}

