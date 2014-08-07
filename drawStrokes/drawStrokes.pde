/* --------------------------------------------------------------------------
 * PExercices / drawStrokes
 * --------------------------------------------------------------------------
 * prog:  Florent Di Bartolo / Interaction Design / http://webodrome.fr/
 * date:  06/08/2014 (d/m/y)
 * --------------------------------------------------------------------------
 */

import blobDetection.BlobDetection;
import blobDetection.Blob;
import blobDetection.EdgeVertex;
import SimpleOpenNI.SimpleOpenNI;
import javax.sound.midi.MidiMessage; 
import themidibus.*;

SimpleOpenNI context;

PImage depthImg;
int[] depthValues;

Menu menu;
ArrayList<ArrayList<PVector>> contours;

//--------- params -------//
int blurRadius;
int blobThreshold;
int edgeMinNumber;
int distMin;


//--- behringer ----------//
MidiBus midiBus;
boolean BCF2000;
BehringerBCF behringer;

//------ key params --------//
boolean switchValue;
int lowestValue;
int highestValue;

//--- for blob detection ---//
PImage bImg;
BlobDetection blobDetection;


int foo = 0;

void setup(){
  
  size(640+640/2, 480);
  frameRate(14);
  
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  context.enableDepth();
  
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
  
  depthImg = createImage(640, 480, ARGB);
  
  setHighestAndLowestValues();
  
  bImg = new PImage(depthImg.width/2, depthImg.height/2);
  
  blobDetection = new BlobDetection(bImg.width, bImg.height);
  blobDetection.setPosDiscrimination(true); //find bright areas
  blobDetection.setThreshold(0.2f); //between 0.0f and 1.0f

}
void setHighestAndLowestValues(){
  
  lowestValue = 1200;
  highestValue = 2300; 
  
}
void draw(){
  
  background(20);
  context.update();
  
  menu.update();
  
  depthValues = context.depthMap();

  updateDepthMap(lowestValue, highestValue);
  
  depthImg.loadPixels();
  drawDepthMap(0, 0);
  depthImg.updatePixels();
  
  fastblur(depthImg, blurRadius);
  
  bImg.copy(depthImg, 0, 0, depthImg.width, depthImg.height, 0, 0, bImg.width, bImg.height);
  
  createBlackBorder();
  
  image(bImg, depthImg.width, 0);
  
  blobDetection.computeBlobs(bImg.pixels);
  
  menu.display();
  
  createStrokes();
  
  drawStrokes();
  
}
void createBlackBorder(){
  
  bImg.loadPixels();
  
  for(int j=bImg.height-1; j<bImg.height; j++){
    
    for(int i=0; i<bImg.width; i++){
      bImg.pixels[i+j*bImg.width] = color(0);    
    }
    
  }
  
  bImg.updatePixels();
  
}
void drawStrokes(){
  
  for(int i=0; i<contours.size(); i++){
    
    ArrayList<PVector> contour = contours.get(i);
    
    beginShape();
        
    for(int j=0; j<contour.size(); j++){
      
      PVector v = contour.get(j);
      vertex(v.x, v.y);
      
      //checkPosition(j, v, contour.size());

    }
    
    strokeWeight(2);
    stroke(0, 255, 0);
    noFill();
    //fill(255);
    endShape(CLOSE);

  }
  
}
void checkPosition(int j, PVector v, int arraySize){
  
  if(j==0){
        
    noStroke();
    fill(255, 0, 0);
    ellipse(v.x, v.y, 20, 20);
    
  } else if(j==arraySize-1){
    
    noStroke();
    fill(0, 0, 255);
    ellipse(v.x, v.y, 20, 20);
    
  } else if(j==foo){
    
    noStroke();
    fill(0, 255, 0);
    ellipse(v.x, v.y, 20, 20);
    
  } 
}
void createStrokes(){
  
  Blob blob;
  EdgeVertex eA, eB;
  
  contours = new ArrayList<ArrayList<PVector>>();
  
  for(int n=0; n<blobDetection.getBlobNb(); n++){
    
    blob = blobDetection.getBlob(n);
    
    if(blob != null && blob.getEdgeNb() > edgeMinNumber){
      
      ArrayList<PVector> contour = new ArrayList<PVector>();

      for(int i=0; i<blob.getEdgeNb(); i++){
        
        eA = blob.getEdgeVertexA(i);
        eB = blob.getEdgeVertexB(i);
        
        if(i==0){
            
          contour.add(new PVector(eA.x*depthImg.width, eA.y*depthImg.height));
        
        } else {
          
          PVector v = contour.get(contour.size()-1);
          float distance = dist(eB.x*depthImg.width, eB.y*depthImg.height, v.x, v.y);
          if(distance>distMin)contour.add(new PVector(eB.x*depthImg.width, eB.y*depthImg.height));
          
        }
        
      }
      
      if(contour.size()>2) contours.add(contour);
    
    }
    
  }
  
  
}
void drawDepthMap(int x, int y){
  image(depthImg, x, y);
}
void updateDepthMap(int lValue, int hValue){
  
  for(int j=0; j<depthImg.width; j++){
    
    int cValue;
  
    for(int i=0; i<depthImg.height; i++){
      
      int pixId = i+j*depthImg.height;
      int depthValue = depthValues[pixId];

      if(depthValue >= lValue && depthValue <= hValue){
        
        cValue = (int) map(depthValue, lValue, hValue, 255, blobThreshold);
        depthImg.pixels[pixId] = (255 << 24) | (cValue << 16) | (cValue << 8) | cValue;
        
      } else {
        
        cValue = 0;
        depthImg.pixels[pixId] = (0 << 24) | (cValue << 16) | (cValue << 8) | cValue;
  
      }

    }

  }

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
void fastblur(PImage img, int radius){
    
  if (radius<1) return;

  int w = img.width;
  int h = img.height;
  
  int wm = w-1;
  int hm = h-1;
  int wh = w*h;
  
  int div = radius+radius+1;
  
  int r[] = new int[wh];
  int g[] = new int[wh];
  int b[] = new int[wh];
  
  int rsum, gsum, bsum, x, y, i, p, p1, p2, yp, yi, yw;
  
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  
  int[] pix = img.pixels;
  
  int dv[] = new int[256*div]; //?!
  
  for (i=0; i < 256*div; i++) dv[i]=(i/div);

  yw = yi = 0;

  for (y=0; y < h; y++){
    
    rsum = gsum = bsum = 0;
    
    for(i = -radius; i <= radius; i++){
      
      p = pix[yi + min(wm, max(i,0))];
      rsum += (p & 0xff0000) >> 16;
      gsum += (p & 0x00ff00) >> 8;
          bsum += p & 0x0000ff;
    }
    
    for (x=0; x < w; x++){

      r[yi] = dv[rsum];
      g[yi] = dv[gsum];
      b[yi] = dv[bsum];

      if(y == 0){
        
        vmin[x] = PApplet.min(x + radius + 1, wm);
            vmax[x] = PApplet.max(x - radius, 0);
      }
      
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum += ((p1 & 0xff0000)-(p2 & 0xff0000)) >> 16;
          gsum += ((p1 & 0x00ff00)-(p2 & 0x00ff00)) >> 8;
          bsum += (p1 & 0x0000ff)-(p2 & 0x0000ff);
          yi++;
    }
    
    yw += w;
  }

  for (x=0; x < w; x++){
    
    rsum = gsum = bsum = 0;
    yp = -radius*w;
    
    for(i = -radius; i <= radius; i++){
      
      yi = PApplet.max(0,yp)+x;
        rsum += r[yi];
        gsum += g[yi];
        bsum += b[yi];
        yp += w;
    }
    
    yi = x;
    
    for (y=0; y < h; y++){
      
      pix[yi] = 0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      
      if(x == 0){  
        vmin[y] = PApplet.min(y + radius + 1,hm)*w;
        vmax[y] = PApplet.max(y - radius, 0)*w;
      }
      
      p1 = x + vmin[y];
      p2 = x + vmax[y];

        rsum += r[p1] - r[p2];
        gsum += g[p1] - g[p2];
        bsum += b[p1] - b[p2];

        yi+=w;
    }
  }
}
//------------- MIDI ------------------//
void midiMessage(MidiMessage message, long timestamp, String bus_name) {
  
   int channel = message.getMessage()[0] & 0xFF;
   int number = message.getMessage()[1] & 0xFF;
   int value = message.getMessage()[2] & 0xFF;
   
   //println("bus " + bus_name + " | channel " + channel + " | num " + number + " | val " + value);
   
   if(BCF2000)behringer.midiMessage(channel, number, value);
   
}
//-------------- mouse --------------------//
void mouseReleased(){
  menu.resetSliders();
}
void mousePressed(){
 
 foo++;
 println(foo); 
  
}
//------------- keyboard ------------------//
void keyPressed() {
  if (key == 'l') {
    switchValue = !switchValue;
  } else if (keyCode == UP) {
    setSelectedValue(+50);
  } else if (keyCode == DOWN) {
    setSelectedValue(-50);
  }
}
