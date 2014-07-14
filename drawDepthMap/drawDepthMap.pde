/* --------------------------------------------------------------------------
 * PExercices / drawDepthMap
 * --------------------------------------------------------------------------
 * prog:  Florent Di Bartolo / Interaction Design / http://webodrome.fr/
 * date:  14/07/2014 (m/d/y)
 * --------------------------------------------------------------------------
 */
 
import SimpleOpenNI.SimpleOpenNI;
import ddf.minim.*;

SimpleOpenNI context;

Menu menu;

ArrayList<PVector> pvectors;
int[] depthValues;
boolean switchValue;
int lowestValue;
int highestValue;

float xTrans = 0;
float yTrans = 0;
float zTrans = 0;
float rotateXangle;
float rotateYangle;
float rotateZangle;

int depth;

void setup(){
  size(640, 480, OPENGL);
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  context.enableDepth();
  
  lowestValue = 1700;
  highestValue = 2300;
  
  strokeWeight(2);
  
  setVectors();
  
  menu = new Menu(new PVector(450, 50));
  
}

void draw(){
  background(0);
  context.update();
  menu.update();
  depthValues = context.depthMap();
  //image(depthImage, 0, 0);
  
  pushMatrix();
  
  translate(xTrans, yTrans, zTrans);
  
  rotateX(radians(rotateXangle));
  rotateZ(radians(rotateZangle));
  
  drawVectors();
  
  popMatrix();
  
  menu.display();
    
}

void setVectors(){
  
  pvectors = new ArrayList<PVector>(); 
  
  for (int i=0; i<height; i++){
    for(int j=0; j<width; j++){
      pvectors.add(new PVector(j, i, 0));
    }
  } 
  
}

void drawVectors(){
  
  PVector oldVector;
  int oldDepthValue;
    
  for (int i=10; i<height; i+=10){
    
    oldVector = null;
    oldDepthValue = 0;
    
    for(int j=10; j<width; j+=10){
      //stroke(255);
      PVector actualVector = pvectors.get(j+i*width);
      
      //point(actualVector.x, actualVector.y, actualVector.z);
      
      int depthValue = depthValues[j+i*width];
      
      
      
      if(oldVector != null){
        
        if(depthValue >= lowestValue && depthValue <= highestValue){
          stroke(255);
        } else {
          
          if(depthValue < lowestValue) {
            //depthValue = lowestValue;
            depthValue = highestValue;
          } else if(depthValue > highestValue){
            depthValue = highestValue;
          }
          stroke(75); 
        }
      
        line(oldVector.x, oldVector.y, oldVector.z - oldDepthValue/depth,
        actualVector.x, actualVector.y, actualVector.z - depthValue/depth);
        
      }
      
      oldVector = actualVector;
      oldDepthValue = depthValue;
      
    }
  } 
}
void mouseReleased(){
  menu.resetSliders();
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
void keyPressed() {
  if (key == 'l') {
    switchValue = !switchValue;
  }else if (keyCode == UP) {
    setSelectedValue(+50);
  } else if (keyCode == DOWN) {
    setSelectedValue(-50);
  }
}
