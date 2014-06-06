class Menu{
  
  float brightness = 1;
  
  Menu(){   
  }
  void addSaturation(){
    brightness += .1;
    brightness = constrain(brightness, 0, 5);
  }
  void reduceSaturation(){
    brightness -= .1;
    brightness = constrain(brightness, 0, 5);
  }
}
