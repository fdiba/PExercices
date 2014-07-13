import ddf.minim.*;

Minim minim;
AudioPlayer player;
ArrayList<PVector> pvectors;
//FloatList bufferValues;

ArrayList<FloatList> buffers;

PVector oldVector;
float oldBufferValue;
Menu menu;
int amplitude;
int foo = 1;

float xTrans = 0;
float yTrans = 0;
float zTrans = 0;
float rotateXangle;
float rotateYangle;
float rotateZangle;

int jCut = 10;

int lineNumber;

void setup(){
  
  frameRate(12);
  
  size(640, 480, OPENGL);
  minim = new Minim(this);
  player = minim.loadFile("02-Hourglass.mp3");
  player.loop();
  player.mute(); 
    
  pvectors = new ArrayList<PVector>(); 
  
  for (int i=0; i<height; i++){
    for(int j=0; j<width; j++){
      pvectors.add(new PVector(j, i, 0));
    }
  }

  menu = new Menu(new PVector(450, 50));
  
  buffers = new ArrayList<FloatList>();
  lineNumber = 0;
  
  for (int i=20; i<height; i+=40){
    
    FloatList bufferValues = new FloatList();
    buffers.add(bufferValues);
    
  }
  
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
  
  FloatList bufferValues = new FloatList();
  
   for(int i = 0; i < player.bufferSize(); i++) {
       
     float test = map(i, 0, player.bufferSize(), 0, width ); 
     bufferValues.append(player.left.get(i)*amplitude);
       
   }
   
   if(buffers.size() > 0) buffers.remove(0);
   buffers.add(bufferValues);
   
   for (int i=20; i<height; i+=40){
     
     oldVector = null;
     oldBufferValue = 0;
     
     //display the same line
     //FloatList actualBufferValues = buffers.get(buffers.size()-1);
     //display different lines
     FloatList actualBufferValues = buffers.get(lineNumber);
     
     if(actualBufferValues.size() > 0) {
     
       editPointsPosition(i, actualBufferValues);
       
     }
     
     lineNumber++;
   }
   
   popMatrix();
   
   menu.display();
   
   lineNumber = 0;
   
}

void editPointsPosition(int i, FloatList actualBufferValues){
  
  for(int j=10; j<width; j+=20){
         
    PVector actualVector = pvectors.get(j+i*width);
       
    float actualBufferValue = actualBufferValues.get(j);
          
    if(oldVector != null){
         
      if(j != jCut){
        
        float alpha = 255/(lineNumber+1);
        
        stroke(255, 255 - alpha);
        line(oldVector.x, oldVector.y, oldVector.z + oldBufferValue,
        actualVector.x, actualVector.y, actualVector.z + actualBufferValue);
      }

    }
     
    oldVector = actualVector;
    oldBufferValue = actualBufferValue;
       
  }
}

void mouseReleased(){
  menu.resetSliders();
}
