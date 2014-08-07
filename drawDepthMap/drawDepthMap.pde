/* --------------------------------------------------------------------------
 * PExercices / drawDepthMap
 * --------------------------------------------------------------------------
 * prog:  Florent Di Bartolo / Interaction Design / http://webodrome.fr/
 * date:  14/07/2014 (d/m/y)
 * --------------------------------------------------------------------------
 */
 
import SimpleOpenNI.SimpleOpenNI;
import ddf.minim.*;
import javax.sound.midi.MidiMessage; 
import themidibus.*;

SimpleOpenNI context;
Minim minim;
AudioPlayer player;

Menu menu;
Ramp ramp;

PVector[] pvectors;
int[] depthValues;

ArrayList<FloatList> buffers;
int ySpace;
int lineNumber;

//--- behringer ----------//
MidiBus midiBus;
boolean BCF2000;
BehringerBCF behringer;

//---- key params --------//
boolean switchValue;
int lowestValue;
int highestValue;

boolean linesVisibility;
boolean multipleBuffers;
boolean useColors;


//---- params ------------//
float xTrans = 0;
float yTrans = 0;
float zTrans = 0;
float rotateXangle;
float rotateYangle;
float rotateZangle;
int amplitude;
int depth;
int maxDist;

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
  
  ramp = new Ramp();
  
  lowestValue = 1200;
  highestValue = 2300;
  
  setVectors();
  
  //--- behringer -----------//
  BCF2000 = true;
  
  if(BCF2000){
    MidiBus.list();
    midiBus = new MidiBus(this, "BCF2000", "BCF2000");
    behringer = new BehringerBCF(midiBus);
  }
  
  //-------------------------//
    
  menu = new Menu(new PVector(450, 50)); //menu depends on BCF2000
  
  if(BCF2000) menu.resetBSliders();
  
  buffers = new ArrayList<FloatList>();
  lineNumber = 0;
  
  setBuffers(ySpace);
  
  linesVisibility = true; 
  
  
  
  println("----------------------------------" + "\n" +
          "depth limits: press l + UP OR DOWN" + "\n" +
          "dark lines visibility: press v" + "\n" +
          "use multiple buffers: press b" + "\n" +
          "use colors: press c" + "\n" +
          "----------------------------------");
  
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
        
        int c;
        
        if(useColors){
          c = ramp.pickColor(depthValue, lowestValue, highestValue);  
        } else {
          c = color(255);
        }
        
        depthValue = setColorWeightDepthValue(depthValue, c);
        
        float ovz = oldVector.z - oldDepthValue*depth - oldBufferValue*amplitude;
        float avz = actualVector.z - depthValue*depth - actualBufferValue*amplitude;
        
        float distance = abs(ovz-avz); 
        if(distance < maxDist)line(oldVector.x, oldVector.y, ovz, actualVector.x, actualVector.y, avz);

      } else {
                
        if(depthValue < lowestValue) {
          //depthValue = lowestValue;
          depthValue = highestValue;
        } else if(depthValue > highestValue){
          depthValue = highestValue;
        }

        int c;
        
        if(useColors){
          c = ramp.pickColor(depthValue, lowestValue, highestValue);  
        } else {
          c = color(75);
        }
        
        depthValue = setColorWeightDepthValue(depthValue, c);
        
        float ovz = oldVector.z - oldDepthValue*depth - oldBufferValue*amplitude;
        float avz = actualVector.z - depthValue*depth - actualBufferValue*amplitude;
        
        float distance = abs(ovz-avz); 
        if(distance < maxDist && linesVisibility)line(oldVector.x, oldVector.y, ovz, actualVector.x, actualVector.y, avz);
             
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
//------------- MIDI ------------------//
void midiMessage(MidiMessage message, long timestamp, String bus_name) {
  
   int channel = message.getMessage()[0] & 0xFF;
   int number = message.getMessage()[1] & 0xFF;
   int value = message.getMessage()[2] & 0xFF;
   
   println("bus " + bus_name + " | channel " + channel + " | num " + number + " | val " + value);
   
   if(BCF2000)behringer.midiMessage(channel, number, value);
   
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
  } else if (key == 'c') {
    useColors = !useColors;
  } else if (key == 'l') {
    switchValue = !switchValue;
  } else if (keyCode == UP) {
    setSelectedValue(+50);
  } else if (keyCode == DOWN) {
    setSelectedValue(-50);
  }
}
