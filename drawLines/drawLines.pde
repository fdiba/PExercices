import SimpleOpenNI.SimpleOpenNI;

int lowestValue;
int highestValue;
PVector[] depthMapRealWorld;

int mapWidth;
int oldLine;
int ySpace;
int oldI;
boolean switchValue;

PVector oldPoint;

SimpleOpenNI context;

void setup(){
  size(640, 480, OPENGL);
  
  lowestValue = 950;
  highestValue = 2300;
  
  ySpace = 10;
  
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  context.enableDepth();  
  mapWidth = context.depthWidth();
  println(mapWidth);
  
}

void draw(){
  background(0);
  
  context.update();
  
  depthMapRealWorld = context.depthMapRealWorld();
  
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  
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
void keyPressed() {
  if (key == 'l') {
    switchValue = !switchValue;
  }else if (keyCode == UP) {
    setSelectedValue(+50);
  } else if (keyCode == DOWN) {
    setSelectedValue(-50);
  }
}
