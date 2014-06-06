class Menu{
  
  float brightness = 1;
  
  Menu(){   
  }
  void addSaturation(){
    brightness += .1;
  }
  void reduceSaturation(){
    brightness -= .1;
  }
  
}
