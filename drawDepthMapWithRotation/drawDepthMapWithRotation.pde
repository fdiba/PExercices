import java.util.*;
import javax.sound.midi.MidiMessage; 
import SimpleOpenNI.SimpleOpenNI;
import themidibus.*;

SimpleOpenNI context;

PVector[] pvectors;
PVector centerOfCloud;
int yOffset = 10;
int xOffset = yOffset/2;

Map<String, Integer> params;
int[] colors = {-8410437,-9998215,-1849945,-5517090,-4250587,-14178341,-5804972,-3498634};
Menu menu;

Ramp ramp;

int w;
int h;

int[] depthValues;
PImage img;
int[] valuesOfSelectedLines;

//-------- depthMapControl ----------//
int lowestValue = 1500;
int highestValue = 2300;
boolean switchValue = true; // when true edit lowestValue

//-------- behringer ----------//
MidiBus midiBus;
boolean BCF2000;
BehringerBCF behringer;

void setup() {

  size(640*2, 480, OPENGL);
  
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  context.enableDepth();
  
  w = width/2;
  h = height;
  
  //--- behringer -----------//
  BCF2000 = true;

  if (BCF2000) {
    MidiBus.list();
    midiBus = new MidiBus(this, "BCF2000", "BCF2000");
    behringer = new BehringerBCF(midiBus);
  }

  //-------------------------//
  
  params = new HashMap<String, Integer>();
  
  Object[][] objects = { {"xTrans", -2500, 2500, colors[0], 0, 0, 0},
                         {"yTrans", -2500, 2500, colors[1], 0, 1, 0},
                         {"zTrans", -2500, 2500, colors[2], 0, 2, 0},
                         {"rotateX", -360, 360, colors[0], 0, 3, 0},
                         {"rotateY", -360, 360, colors[1], 0, 4, 0},
                         {"rotateZ", -360, 360, colors[2], 0, 5, 0},
                         {"radius3D", 0, 1000, colors[4], 0, 6, 100},
                         {"lineId", 0, w-1, colors[3], 0, 7, w/2} };
  
  createMenu(objects); //menu depends on BCF2000
  if(BCF2000) menu.resetBSliders();
  
  ramp = new Ramp();
  pvectors = new PVector[640*480];
  create3DPoints();
  
  //--------- controller ---------------//
  img = createImage(640, 480, ARGB);
  
  valuesOfSelectedLines = new int[h];
  
}
void createMenu(Object[][] objects){  
  menu = new Menu(this, new PVector(450, 50), objects);
}
void updateFirstLine() {
  
  //createRdBumps();
  
  float radius = params.get("radius3D");
  
  for (int i=0; i<xOffset; i+=xOffset) {

    for (int j=0; j<h; j+=yOffset) {

      PVector v = pvectors[i+j*w];
      
      // reset z position
      v.z = 0;
      
      float value = valuesOfSelectedLines[j]/255.0 * radius;
           
      println(value);

      PVector rdVector = new PVector(0, 0, value);

      v.add(rdVector);

    }
  }
  
}
void createRdBumps() {

  for (int i=0; i<xOffset; i+=xOffset) {

    for (int j=0; j<h; j+=yOffset) {

      PVector v = pvectors[i+j*w];

      PVector rdVector = new PVector(0, 0, random(-5, 5));

      v.add(rdVector);

    }
  }
}
void updateLines() {

  for (int i=w-1; i>0; i--) {
    
    for (int j=0; j<h; j++) {
      
      int id = i+j*w;

      PVector v = pvectors[id];
      PVector pv = pvectors[id-1];
      
      pvectors[id] = pvectors[id-1].get();
      
    }
  }
}
void drawDepthImg(){
    
  img.loadPixels();

  depthValues = context.depthMap();
  int mapWidth = context.depthWidth();
  int mapHeight = context.depthHeight();
  int threshold = 0;

  int cValue;
  int lValue = lowestValue;
  int hValue = highestValue;

  for (int x = 0; x < mapWidth; x++) {
    
    int pixId = x - mapWidth;

    for (int y = 0; y < mapHeight; y++) {

      pixId += mapWidth;
      
      int currentDepthValue = depthValues[pixId];

      if (currentDepthValue >= lValue && currentDepthValue <= hValue) {

        cValue = (int) map(currentDepthValue, lValue, hValue, 255, threshold);
                
        img.pixels[pixId] = (255 << 24) | (cValue << 16) | (cValue << 8) | cValue;
        
      } else {

        cValue = 0;
        img.pixels[pixId] = (0 << 24) | (cValue << 16) | (cValue << 8) | cValue;
        
      }
      
      if (x==params.get("lineId")) {
        
        img.pixels[pixId] =0xFF00FF00;
        
        valuesOfSelectedLines[y] = cValue;
        
      }
      
    }
    
  }
  
  img.updatePixels();
  
  image(img, 640, 0);
  
}
void draw() {

  background(0);

  context.update();
  
  drawDepthImg();

  centerOfCloud = new PVector(w/2, h/2, 0);

  menu.update();

  updateFirstLine();
  updateLines();

  //---------------- Cloud -----------------------//

  pushMatrix();

  translate(centerOfCloud.x, centerOfCloud.y);

  //translate(-centerOfCloud.x, -centerOfCloud.y);

  //-------- menu ctrl ------------//

  rotateX(radians(params.get("rotateX")));
  rotateY(radians(params.get("rotateY")));
  rotateZ(radians(params.get("rotateZ")));

  translate(params.get("xTrans"), params.get("yTrans"), params.get("zTrans"));

  //-------------------------------

  display3DPointsInRotation();

  popMatrix();

  menu.display();
}
void display3DPointsInRotation() {

  // x is not used

  int c = color(0);

  // not used
  int radius = 0;

  strokeWeight(3);

  for (int i=0; i<w; i+=xOffset) {

    c = ramp.pickColor(i, 0, w); 

    stroke(c);

    for (int j=0; j<h; j+=yOffset) {

      PVector v = pvectors[i+j*w]; 

      point(0, v.y-h/2, v.z+radius);
    }

    rotateY(radians(-360./((float) w/xOffset)));
  }
}
void create3DPoints() {

  for (int i=0; i<w; i++) {
    
    for (int j=0; j<h; j++) {
      pvectors[i+j*w] = new PVector(i, j, 0);
    }
  }
}
//------------ keys -----------// 
void keyPressed() {
  if (key == 'l') {
    toggleValue();
  } else if (keyCode == UP) {
    setSelectedValue(+50);
  } else if (keyCode == DOWN) {
    setSelectedValue(-50);
  }
}
void toggleValue() {
  switchValue = !switchValue;
}
void setSelectedValue(int value) {    

  if (switchValue) {
    lowestValue += value;
    lowestValue = constrain(lowestValue, 0, highestValue-100);
    println(lowestValue);
  } else {
    highestValue += value;
    highestValue = constrain(highestValue, lowestValue+100, 7000);
    println(highestValue);
  }
}
//------------ mouse -----------// 
void mouseReleased() {
  menu.resetSliders();
}
void mousePressed() {
  //savePicture();
}
void savePicture() {
  Date date = new Date();
  int num = int(random(1000));
  String name = "data/images/test-rot-"+date.getTime()+".png";
  save(name);
}
//------------- MIDI ------------------//
void midiMessage(MidiMessage message, long timestamp, String bus_name) {
  
   int channel = message.getMessage()[0] & 0xFF;
   int number = message.getMessage()[1] & 0xFF;
   int value = message.getMessage()[2] & 0xFF;
   
   //println("bus " + bus_name + " | channel " + channel + " | num " + number + " | val " + value);
   
   if(BCF2000)behringer.midiMessage(channel, number, value);
}

