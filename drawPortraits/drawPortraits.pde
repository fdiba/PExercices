import java.util.Date;

HostImage host;
Menu menu;
boolean saturation;
ParticleSystem ps;

void setup(){
  size(640,480);
  frameRate(25);
  smooth();
  background(0);
  menu = new Menu();
  ps = new ParticleSystem();
  host = new HostImage(this, "Scarlett-Johansson-faces.jpg");
  
  if(host.width > width && host.width > host.height){
    int scale = host.width/width;
    host.resize(host.width/scale, host.height/scale); 
  }
}

void draw(){
  
  /*int a = round(10*(mouseX/(float) width));
  int b = round(10*(mouseY/(float) height));
  println(a + " " + b);*/
  
  //image(host.img, host.location.x, host.location.y);
  if(!saturation) {
    image(host.img, host.location.x, host.location.y);
    loadPixels();
      host.withdrawColors();
    updatePixels();
  } else {
    ps.run();
  }
}
void keyPressed(){
  if (key == CODED) {
    if (keyCode == UP && !saturation) {
      menu.addSaturation();
    } else if (keyCode == DOWN && !saturation) {
      menu.reduceSaturation();
    }
  }
}
void mouseMoved(){
  host.contrast = 5f*(mouseX/(float)width); //0 to 5;
  host.brightness = 256*(mouseY/(float)height-0.5); //-128 to +128  
}
void mousePressed(){
  if (!saturation) {
      println("contrast: " + host.contrast + " | brightness: " + host.brightness);
      saturation = true;
      host.img = get(0, 0, width, height); 
      host.init();
      background(0);
      host.setPix();
    } else if (saturation){
      savePicture();
    } 
}
void savePicture(){
  Date date = new Date();
  int num = int(random(1000));
  String name = "data/images/portraits-"+date.getTime()+".png";
  save(name);
}
