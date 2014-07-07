import SimpleOpenNI.SimpleOpenNI;
import ddf.minim.*;


Minim minim;
AudioPlayer player;

Menu menu;

int lowestValue;
int highestValue;
PVector[] depthMapRealWorld;

int mapWidth;
int oldLine;
int oldI;
boolean switchValue;
PVector oldPoint;

int ySpace;
float zTrans;
float xTrans;
float rotateYangle;
float rotateXangle;
  
SimpleOpenNI context;

void setup(){
  size(640, 480, OPENGL);
  
  minim = new Minim(this);
  player = minim.loadFile("02-Hourglass.mp3");
  player.loop();
  
  lowestValue = 950;
  highestValue = 2300;
    
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  context.enableDepth();  
  mapWidth = context.depthWidth();
  
  menu = new Menu(new PVector(450, 50));
  
}

void draw(){
  background(0);
  
  context.update();
  menu.update();
  
  depthMapRealWorld = context.depthMapRealWorld();
  
  pushMatrix();
  
  translate(width/2 + xTrans, height/2, zTrans);
  rotateX(radians(180));
  rotateY(radians(rotateYangle));
  rotateX(radians(rotateXangle));
  
  oldPoint = null;
  oldLine = 0;
  oldI = 0;
  
  for (int i = 0; i < depthMapRealWorld.length; i += 10) {
    
    int actualLine = i/mapWidth;
    
    if(actualLine != oldLine) {
       stroke(255, 0, 0);
       if(i+mapWidth*ySpace < depthMapRealWorld.length) {
         i+= mapWidth*ySpace;
         oldPoint = null;
       } else {
         i = depthMapRealWorld.length - mapWidth;
       }
       actualLine = i/mapWidth;
       //println(actualLine + " " + oldLine);
       
    } else {
      stroke(255);
    }
    
    PVector currentPoint = depthMapRealWorld[i];
    
    if(currentPoint.z > lowestValue && currentPoint.z < highestValue){
      
      //point(currentPoint.x, currentPoint.y, currentPoint.z);
   
      int j = (int) map(i, 0, depthMapRealWorld.length, 0, player.bufferSize()*480);
      //j = (int) map(j, 0, player.bufferSize(), 0, width);
      
      //println(depthMapRealWorld.length/480+" "+player.bufferSize()+" "+ j);
      
      currentPoint.add(new PVector(0, 0, player.left.get(j/480)*350));
      
      if (oldPoint != null){
        line(oldPoint.x, oldPoint.y, oldPoint.z, currentPoint.x, currentPoint.y, currentPoint.z);
      }
      oldPoint = currentPoint;
    } else {
      oldPoint = null; 
    }
    
    oldLine = actualLine;
    oldI = i;
  }
  
  popMatrix();
  
  menu.display();
  
}
void setSelectedValue(int value) {    
  if(switchValue){
    lowestValue += value;
    lowestValue = constrain(lowestValue, 0, highestValue-100);
    PApplet.println(lowestValue);
  } else {
    highestValue += value;
    highestValue = constrain(highestValue, lowestValue+100, 7000);
    PApplet.println(highestValue);
  }
}
void mouseReleased(){
  menu.resetSliders();
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
