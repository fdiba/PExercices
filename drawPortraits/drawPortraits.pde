import java.util.Date;

HostImage host;
ParticleSystem ps;

boolean hasBeenSet;

String[] imageFiles = {"emma-watson-158356_w1000.jpg", "Scarlett-Johansson-faces.jpg"};

void setup(){
  
  size(640, 480);
  frameRate(25);
  background(0);
  smooth();
  
  int id = int(random(imageFiles.length));
  //host = new HostImage(this, imageFiles[id]);
  host = new HostImage(this, imageFiles[1]);
  host.removeColors();
  
  ps = new ParticleSystem();
  
}
void draw(){
  
  if(!hasBeenSet) {
    fill(0);
    rect(0,0,width, height);
    host.editLuminosity();
    host.display();  
  } else {
  
    //image(host.img, 0, 0);
    loadPixels();
    ps.run();
    updatePixels();
    
    println(ps.particles.size());
  
  }
  
}
void startAnim(){
  //println("contrast: " + host.contrast + " | brightness: " + host.brightness);
  hasBeenSet = true;
  
  host.img = get(0, 0, width, height); //update img width and height contrast and brightness
  host.img.loadPixels();
  background(0); 
}
void savePicture(){
  Date date = new Date();
  int num = int(random(1000));
  String name = "data/images/portraits-"+date.getTime()+".png";
  save(name);
}
//------------ keyboard ------------//
void keyPressed(){
  if (key == ENTER && !hasBeenSet){
    noCursor();
    startAnim();
  } else if (key == ENTER && hasBeenSet){
    savePicture();
  }
}
//------------ mouse ------------//
void mouseMoved(){
  if(!hasBeenSet){
    host.contrast = 5f*(mouseX/(float)width); //0 to 5
    host.brightness = 256*(mouseY/(float)height-0.5); //-128 to +128
  }
}
void mousePressed(){
  if (!hasBeenSet){
    startAnim();
  } else if (hasBeenSet){
    savePicture();
  }
}
