import ddf.minim.*;

Minim minim;
AudioPlayer player;
ArrayList<PVector> pvectors;
FloatList bufferValues;
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

void setup(){
  
  size(640, 480, OPENGL);
  minim = new Minim(this);
  player = minim.loadFile("02-Hourglass.mp3");
  player.loop();
    
  pvectors = new ArrayList<PVector>(); 
  
  for (int i=0; i<height; i++){
    for(int j=0; j<width; j++){
      pvectors.add(new PVector(j, i, 0));
    }
  }

  menu = new Menu(new PVector(450, 50));  
}
void draw(){
  background(0);
  stroke(255);
  strokeWeight(2);
  
  pushMatrix();
  
  translate(xTrans, yTrans, zTrans);
  
  rotateX(radians(rotateXangle));
  rotateZ(radians(rotateZangle));
  
  menu.update();
  
  bufferValues = new FloatList();
  
   for(int i = 0; i < player.bufferSize(); i++) {
     
     //float test = map(i, 0, player.bufferSize(), 0, width ); //------------- make controller
     float test = map(i, 0, player.bufferSize(), 0, width );
     
       bufferValues.append(player.left.get(i)*amplitude); //----------------------- make controller
       
   }
   
   for (int i=20; i<height; i+=40){
     
     oldVector = null;
     oldBufferValue = 0;
     
     for(int j=10; j<width; j+=20){
       
       PVector actualVector = pvectors.get(j+i*width);
       
       float actualBufferValue = bufferValues.get(j);
       
       stroke(255);
              
       if(oldVector != null){
         //line(oldVector.x, oldVector.y + oldBufferValue, oldVector.z,
           //   actualVector.x, actualVector.y + actualBufferValue, actualVector.z);
              
         line(oldVector.x, oldVector.y, oldVector.z + oldBufferValue,
              actualVector.x, actualVector.y, actualVector.z + actualBufferValue);
       } else {
         /*noStroke();
         fill(255,0,0);
         ellipse(actualVector.x, actualVector.y, 10, 10);*/
       }
         
       oldVector = actualVector;
       oldBufferValue = actualBufferValue;
     
     }
   }
   
   popMatrix();
   
   menu.display();
}
void mouseReleased(){
  menu.resetSliders();
}
