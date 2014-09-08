import java.util.*;
import javax.sound.midi.MidiMessage; 
import themidibus.*; 
import ddf.minim.*;
import toxi.processing.ToxiclibsSupport;
import toxi.geom.mesh2d.Voronoi;
import toxi.geom.Vec2D;
import toxi.geom.Polygon2D;

//--- behringer ----------//
MidiBus midiBus;
boolean BCF2000;
BehringerBCF behringer;

//------- Menu -----------//
Map<String, Integer> params;
int[] colors = {-8410437,-9998215,-1849945,-5517090,-4250587,-14178341,-5804972,-3498634};
Menu menu;

PImage ref;
String[] imageFiles = {"emma-watson-158356_w1000.jpg", "Scarlett-Johansson-faces.jpg"};
PVector location = new PVector();

ToxiclibsSupport gfx;
Voronoi voronoi;

int oldPointsNumber = 0;

boolean hasBeenInit;

void setup(){
  
  size(640, 480);
  frameRate(25);
  background(0);
  smooth();
  
  //--- behringer -----------//
  BCF2000 = true;
  
  if(BCF2000){
    //MidiBus.list();
    midiBus = new MidiBus(this, "BCF2000", "BCF2000");
    behringer = new BehringerBCF(midiBus);
  }
  //-------------------------//
  
  params = new HashMap<String, Integer>();
  
  Object[][] objects = { {"pointsNumber", 1, 2000, colors[0], 0, 0, 180} };
  
  createMenu(objects); //menu depends on BCF2000
  
  if(BCF2000) menu.resetBSliders();
  
  ref = loadImage(imageFiles[1]);
  ref = checkImageSize(ref);
  centerImage(ref);
  
  gfx = new ToxiclibsSupport( this );
  
}
void createVoronoi(int pointsNumber){
  
  if(!hasBeenInit){
    image(ref, location.x, location.y);
    ref = get(0, 0, width, height);
    hasBeenInit = true;
  }
  
  background(0);
  stroke(0);
  
  voronoi = new Voronoi();

  for ( int i=0; i<pointsNumber; i++ ) {
    voronoi.addPoint(new Vec2D(random(width), random(height)));
  }
  
  color[] colors = new color[voronoi.getSites().size()];

  for (Polygon2D polygon : voronoi.getRegions()) {
    for (Vec2D v : voronoi.getSites()) {
      if (polygon.containsPoint(v)) {
        color c = ref.get(int(v.x), int(v.y));
        fill(c);
        gfx.polygon2D( polygon );
      }
    }
  }
  
  oldPointsNumber = pointsNumber;
  
}
void draw(){
  
  menu.update();
  
  int pointsNumber = params.get("pointsNumber");
  if(oldPointsNumber!= pointsNumber)createVoronoi(pointsNumber);
  
  menu.display();
  
}
void centerImage(PImage img){
  location.x = width/2 - img.width/2;
  location.y = height/2 - img.height/2;
}
PImage checkImageSize(PImage img){
    
  int scale = 1;
  
  if(img.width > img.height && img.width > width){      
    scale = img.width/width;
  } else if (img.height > img.width && img.height > height){
    scale = img.height/height;
  }
  
  if(scale != 1){
    img.resize(img.width/scale, img.height/scale);
  }
  
  return img;
  
}
void createMenu(Object[][] objects){  
  menu = new Menu(this, new PVector(450, 50), objects);
}
void savePicture(){
  Date date = new Date();
  String name = "data/images/voronoi-"+date.getTime()+".png";
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
//------------ keyboard ------------//
void keyPressed(){
  if (key == 's'){
    savePicture();
  }
}
void mouseReleased(){
  menu.resetSliders();
}
