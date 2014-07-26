import java.util.Date;

HostImage host;
boolean hasBeenSet;
ParticleSystem ps;

void setup(){
  
  size(640,480);
  frameRate(25);
  background(0);
  smooth();
  
  host = new HostImage(this, "Scarlett-Johansson-faces.jpg");
  ps = new ParticleSystem();
  
  if(host._width > width && host._width > host._height){
    int scale = host._width/width;
    host.resize(host._width/scale, host._height/scale); 
  }
}

void draw(){
  
  if(!hasBeenSet) {
    
    image(host.img, host.location.x, host.location.y);
    loadPixels();
      host.withdrawColors();
    updatePixels();
  
  } else {
    
    ps.run();
  
  }
}
void startAnim(){
  println("contrast: " + host.contrast + " | brightness: " + host.brightness);
  hasBeenSet = true;
  host.img = get(0, 0, width, height); 
  
  /*host.width = width;
  host.height = height;*/
  
  host.init();
  background(0);
  host.setPix();
  //noCursor();
}
void savePicture(){
  Date date = new Date();
  int num = int(random(1000));
  String name = "data/images/portraits-"+date.getTime()+".png";
  save(name);
}
//------------ mouse ------------//
void keyPressed(){
  if (key == ENTER && !hasBeenSet){
    startAnim();
  } else if (key == ENTER && hasBeenSet){
    savePicture();
  }
}
void mouseMoved(){
  host.contrast = 5f*(mouseX/(float)width); //0 to 5;
  host.brightness = 256*(mouseY/(float)height-0.5); //-128 to +128  
}
void mousePressed(){
  if (!hasBeenSet){
    startAnim();
  } else if (hasBeenSet){
    savePicture();
  }
}
