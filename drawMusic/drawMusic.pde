/* --------------------------------------------------------------------------
 * PExercices / drawMusic
 * --------------------------------------------------------------------------
 * prog:  Florent Di Bartolo / Interaction Design / http://webodrome.fr/
 * date:  14/07/2014 (d/m/y)
 * --------------------------------------------------------------------------
 */
 
import ddf.minim.*;

Minim minim;
AudioPlayer player;
PVector[] pvectors;
//FloatList bufferValues;

ArrayList<FloatList> buffers;

Menu menu;
int foo = 1;

//---- params ------------//
float xTrans = 0;
float yTrans = 0;
float zTrans = 0;
float rotateXangle;
float rotateYangle;
float rotateZangle;
int amplitude;


int ySpace;

int jCut = 10;

int lineNumber;

void setup(){
  
  frameRate(12);
  
  size(640, 480, OPENGL);
  minim = new Minim(this);
  player = minim.loadFile("02-Hourglass.mp3");
  player.loop();
  player.mute(); 
    
  setVectors();

  menu = new Menu(new PVector(450, 50));
  
  buffers = new ArrayList<FloatList>();
  lineNumber = 0;
  
  ySpace = 40;
  
  setBuffers(ySpace);
  
}
void draw(){
  
  background(0);
  stroke(255);
  strokeWeight(2);
  
  pushMatrix();
  
  translate(xTrans, yTrans, zTrans);
  
  rotateX(radians(rotateXangle));
  rotateZ(radians(rotateZangle));
  
  if(jCut < width) {
    jCut += 20;
  } else {
    jCut = 10; 
  }
  
  menu.update();
  
  addAndEraseBuffers();
   
  drawVectors(ySpace);
   
  popMatrix();
   
  menu.display();
   
  lineNumber = 0;
   
}
void drawVectors(int _ySpace){
  
  PVector oldVector;
  float oldBufferValue;
    
  for (int i=20; i<height; i+= _ySpace){
        
    oldVector = null;
    oldBufferValue = 0;
     
    //--- display the same line ----//
    //FloatList actualBufferValues = buffers.get(buffers.size()-1);
    
    //or display different lines ---//
    FloatList actualBufferValues = buffers.get(lineNumber);
     
    if(actualBufferValues.size() > 0) { 
       editPointsPosition(oldVector, oldBufferValue, i, actualBufferValues);
     }
     
     lineNumber++;
   }
  
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
void editPointsPosition(PVector oldVector, float oldBufferValue, int i, FloatList actualBufferValues){
  
  for(int j=10; j<width; j+=20){
         
    PVector actualVector = pvectors[j+i*width];
    float actualBufferValue = actualBufferValues.get(j);
          
    if(oldVector != null){
         
      if(j != jCut){
        
        float alpha = map(i, 0, height, 255, 0);
        
        stroke(255, 255 - alpha);
        line(oldVector.x, oldVector.y, oldVector.z + oldBufferValue*amplitude,
        actualVector.x, actualVector.y, actualVector.z + actualBufferValue*amplitude);
      }

    }
     
    oldVector = actualVector;
    oldBufferValue = actualBufferValue;
       
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
void setBuffers(int _ySpace){
  
  for (int i=10; i<height; i+= _ySpace){
    FloatList bufferValues = new FloatList();
    buffers.add(bufferValues);
  }
  
}
void mouseReleased(){
  menu.resetSliders();
}
