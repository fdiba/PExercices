/* --------------------------------------------------------------------------
 * PExercices / drawStrokes
 * --------------------------------------------------------------------------
 * prog:  Florent Di Bartolo / Interaction Design / http://webodrome.fr/
 * date:  06/08/2014 (d/m/y)
 * --------------------------------------------------------------------------
 */

import SimpleOpenNI.SimpleOpenNI;

SimpleOpenNI context;

PImage img;
int[] depthValues;

//---- key params --------//
boolean switchValue;
int lowestValue;
int highestValue;

void setup(){
  
  size(640+640/2, 480);
  
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  context.enableDepth();
  
  img = createImage(640, 480, ARGB);
  
  setHighestAndLowestValues();

}
void setHighestAndLowestValues(){
  
  lowestValue = 1200;
  highestValue = 2300; 
  
}
void draw(){
  
  background(0);
  context.update();
  
  depthValues = context.depthMap();

  updateDepthMap(lowestValue, highestValue);
  
  img.loadPixels();
  drawDepthMap(0, 0);
  img.updatePixels();
}
void drawDepthMap(int x, int y){
  image(img, x, y);
}

void updateDepthMap(int lValue, int hValue){
  
  for(int j=0; j<img.width; j++){
    
    int cValue;
  
    for(int i=0; i<img.height; i++){
      
      int pixId = i+j*img.height;
      int depthValue = depthValues[pixId];

      if(depthValue >= lValue && depthValue <= hValue){
        
        cValue = (int) map(depthValue, lValue, hValue, 255, 0);
        img.pixels[pixId] = (255 << 24) | (cValue << 16) | (cValue << 8) | cValue;
        
      } else {
        
        cValue = 0;
        img.pixels[pixId] = (0 << 24) | (cValue << 16) | (cValue << 8) | cValue;
  
      }

    }

  }

}
void setSelectedValue(int value) {    
  if(switchValue){
    lowestValue += value;
    lowestValue = constrain(lowestValue, 0, highestValue-100);
    PApplet.println("lowestValue: " + lowestValue);
  } else {
    highestValue += value;
    highestValue = constrain(highestValue, lowestValue+100, 7000);
    PApplet.println("highestValue: " + highestValue);
  }
}
//------------- keyboard ------------------//
void keyPressed() {
  if (key == 'l') {
    switchValue = !switchValue;
  } else if (keyCode == UP) {
    setSelectedValue(+50);
  } else if (keyCode == DOWN) {
    setSelectedValue(-50);
  }
}
