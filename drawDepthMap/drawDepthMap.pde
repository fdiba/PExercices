/* --------------------------------------------------------------------------
 * PExercices / drawDepthMap
 * --------------------------------------------------------------------------
 * prog:  Florent Di Bartolo / Interaction Design / http://webodrome.fr/
 * date:  14/07/2014 (d/m/y)
 * --------------------------------------------------------------------------
 */
 
import SimpleOpenNI.SimpleOpenNI;
import ddf.minim.*;

SimpleOpenNI context;
Minim minim;
AudioPlayer player;

Menu menu;

PVector[] pvectors;
int[] depthValues;
boolean switchValue;
int lowestValue;
int highestValue;

ArrayList<FloatList> buffers;
int ySpace;
int lineNumber;
boolean linesVisibility;

//---- params ------------//
float xTrans = 0;
float yTrans = 0;
float zTrans = 0;
float rotateXangle;
float rotateYangle;
float rotateZangle;
int amplitude;
int depth;


void setup(){
  
  frameRate(12);
  
  size(640, 480, OPENGL);
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  context.enableDepth();
  
  minim = new Minim(this);
  player = minim.loadFile("02-Hourglass.mp3");
  player.loop();
  player.mute(); 
  
  lowestValue = 1700;
  highestValue = 2300;
  
  strokeWeight(2);
  
  setVectors();
  
  menu = new Menu(new PVector(450, 50));
  
  ySpace = 10;
  buffers = new ArrayList<FloatList>();
  lineNumber = 0;
  
  setBuffers(ySpace);
  
  amplitude = 1; 
  linesVisibility = true; 
  
}
void draw(){
  
  background(0);
  context.update();
  menu.update();
  depthValues = context.depthMap();
  //image(depthImage, 0, 0);
  
  addAndEraseBuffers();
  
  pushMatrix();
  
  translate(xTrans, yTrans, zTrans);
  
  rotateX(radians(rotateXangle));
  rotateZ(radians(rotateZangle));
  
  drawVectors(ySpace);
  
  popMatrix();
  
  menu.display();
  
  lineNumber = 0; 
}
void addAndEraseBuffers(){
    
  FloatList bufferValues = new FloatList();
  
  for(int i = 0; i < player.bufferSize(); i++) {  
    float test = map(i, 0, player.bufferSize(), 0, width); 
    bufferValues.append(player.left.get(i));
  }
   
  if(buffers.size() > 0) buffers.remove(0);
  buffers.add(bufferValues);
  
}
void setBuffers(int _ySpace){
  
  for (int i=10; i<height; i+= _ySpace){
    FloatList bufferValues = new FloatList();
    buffers.add(bufferValues);
  }
  
}
void setVectors(){
  
  pvectors = new PVector[width*height]; 
  
  for (int i=0; i<height; i++){
    for(int j=0; j<width; j++){
      pvectors[j+i*width] = new PVector(j, i, 0);
    }
  } 
  
}
void drawVectors(int _ySpace){
  
  PVector oldVector;
  float oldBufferValue;
  int oldDepthValue;
    
  for (int i=10; i<height; i+= _ySpace){
    
    oldVector = null;
    oldDepthValue = 0;
    oldBufferValue = 0;
    
    //--- display the same line ----//
    //FloatList actualBufferValues = buffers.get(buffers.size()-1);
    
    //or display different lines ---//
    FloatList actualBufferValues = buffers.get(lineNumber);
    
    if(actualBufferValues.size() > 0) { 
      editPointsPosition(oldVector, oldBufferValue, i, actualBufferValues, oldDepthValue);
    }
    
    lineNumber++;
    
  } 
}
void editPointsPosition(PVector oldVector, float oldBufferValue, int i, FloatList actualBufferValues, int oldDepthValue){
    
  for(int j=10; j<width; j+=10){
      
    //stroke(255);
    PVector actualVector = pvectors[j+i*width];
    float actualBufferValue = actualBufferValues.get(j);
    int depthValue = depthValues[j+i*width];
    
    //point(actualVector.x, actualVector.y, actualVector.z);
    
    if(oldVector != null){
      
      float alpha = map(i, 0, height, 0, 255);
      
      if(depthValue >= lowestValue && depthValue <= highestValue){
        stroke(255, alpha);
        
        line(oldVector.x, oldVector.y, oldVector.z - oldDepthValue/depth - oldBufferValue*amplitude,
        actualVector.x, actualVector.y, actualVector.z - depthValue/depth - actualBufferValue*amplitude);
        
      } else {
          
        if(depthValue < lowestValue) {
          //depthValue = lowestValue;
          depthValue = highestValue;
        } else if(depthValue > highestValue){
          depthValue = highestValue;
        }
        
      stroke(75, alpha);
      
      if(linesVisibility) line(oldVector.x, oldVector.y, oldVector.z - oldDepthValue/depth - oldBufferValue*amplitude,
      actualVector.x, actualVector.y, actualVector.z - depthValue/depth - actualBufferValue*amplitude);
      
      }
      
      //line(oldVector.x, oldVector.y, oldVector.z - oldDepthValue/depth - oldBufferValue*amplitude,
      //actualVector.x, actualVector.y, actualVector.z - depthValue/depth - actualBufferValue*amplitude);
      
    }
    
    oldVector = actualVector;
    oldDepthValue = depthValue;
    oldBufferValue = actualBufferValue;
    
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
  if (key == 'v') {
    linesVisibility = !linesVisibility;
  } else if (key == 'l') {
    switchValue = !switchValue;
  } else if (keyCode == UP) {
    setSelectedValue(+50);
  } else if (keyCode == DOWN) {
    setSelectedValue(-50);
  }
}
