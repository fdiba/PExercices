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

ArrayList<FloatList> buffers;
int ySpace;
int lineNumber;

//---- key params --------//
boolean linesVisibility;
boolean multipleBuffers;
int lowestValue;
int highestValue;

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
  
  setVectors();
  
  menu = new Menu(new PVector(450, 50));
  
  //ySpace = 10;
  buffers = new ArrayList<FloatList>();
  lineNumber = 0;
  
  setBuffers(ySpace);
  
  linesVisibility = true; 
  
  println("depth limits: press l + UP OR DOWN" + "\n" +
          "dark lines visibility: press v" + "\n" +
          "use multiple buffers: press b"); 
  
}
void draw(){
  
  background(0);
  context.update();
  menu.update();
  depthValues = context.depthMap();
  
  addAndEraseBuffers();
  
  pushMatrix();
    
  translate(width/2 + xTrans, height/2 + yTrans, zTrans);
  
  rotateX(radians(rotateXangle));
  rotateY(radians(rotateYangle));
  rotateZ(radians(rotateZangle));
  
  translate(-width/2, -height/2, 0);
  
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
  float oldDepthValue;
    
  for (int i=10; i<height; i+= _ySpace){
    
    oldVector = null;
    oldDepthValue = 0;
    oldBufferValue = 0;
    
    FloatList actualBufferValues;
    
    if(multipleBuffers){
      //display different lines
      actualBufferValues = buffers.get(lineNumber);
    } else {
      //display the same line
      actualBufferValues = buffers.get(buffers.size()-1); 
    }
    
    if(actualBufferValues.size() > 0) { 
      editPointsPosition(oldVector, oldBufferValue, i, actualBufferValues, oldDepthValue);
    }
    
    lineNumber++;
    
  } 
}
void editPointsPosition(PVector oldVector, float oldBufferValue, int i, FloatList actualBufferValues, float oldDepthValue){
    
  for(int j=0; j<width; j+=10){
      
    //stroke(255);
    PVector actualVector = pvectors[j+i*width];
    float actualBufferValue = actualBufferValues.get(j);
    float depthValue = depthValues[j+i*width];
    
    //point(actualVector.x, actualVector.y, actualVector.z);
    
    if(oldVector != null){
            
      if(depthValue >= lowestValue && depthValue <= highestValue){
        
        depthValue = setColorWeightDepthValue(depthValue, color(255));
        
        line(oldVector.x, oldVector.y, oldVector.z - oldDepthValue*depth - oldBufferValue*amplitude,
             actualVector.x, actualVector.y, actualVector.z - depthValue*depth - actualBufferValue*amplitude);

      } else {
                
        if(depthValue < lowestValue) {
          //depthValue = lowestValue;
          depthValue = highestValue;
        } else if(depthValue > highestValue){
          depthValue = highestValue;
        }

        depthValue = setColorWeightDepthValue(depthValue, color(75));
        
        if(linesVisibility) line(oldVector.x, oldVector.y, oldVector.z - oldDepthValue*depth - oldBufferValue*amplitude,
                                 actualVector.x, actualVector.y, actualVector.z - depthValue*depth - actualBufferValue*amplitude);
             
      }
      
    }
    
    oldVector = actualVector;
    oldDepthValue = depthValue;
    oldBufferValue = actualBufferValue;
    
  }
  
}
float setColorWeightDepthValue(float depthValue, int couleur){
  
  float weight = map(depthValue, lowestValue, highestValue, 4, 1);
  depthValue = map(depthValue, lowestValue, highestValue, -1, 1);
      
  stroke(couleur);
  strokeWeight(weight);
        
  return depthValue;
  
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
void mouseReleased(){
  menu.resetSliders();
}
void keyPressed() {
  if (key == 'v') {
    linesVisibility = !linesVisibility;
  } else if (key == 'b') {
    multipleBuffers = !multipleBuffers;
  } else if (key == 'l') {
    switchValue = !switchValue;
  } else if (keyCode == UP) {
    setSelectedValue(+50);
  } else if (keyCode == DOWN) {
    setSelectedValue(-50);
  }
}
