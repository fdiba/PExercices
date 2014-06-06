import java.util.Date;

HostImage host;
Menu menu;
boolean saturation;
ParticleSystem ps;

void setup(){
  size(640,480);
  frameRate(60);
  //smooth();
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
  //image(host.img, host.location.x, host.location.y);
  if(!saturation) {
    image(host.img, host.location.x, host.location.y);
    loadPixels();
      host.withdrawColors();
    updatePixels();
  } else {
    loadPixels();
    //host.img.loadPixels();
    ps.update();
    //updatePixels();
  }
}
void keyPressed(){
  if (key == CODED) {
    if (keyCode == UP && !saturation) {
      menu.addSaturation();
    } else if (keyCode == DOWN && !saturation) {
      menu.reduceSaturation();
    }
    //println(menu.brightness);
  }
}
void mousePressed(){
  if(!saturation){
    saturation = true;
    host.img = get(0, 0, width, height); 
    host.init();
    background(0);
  } else {
    savePicture();
  }
}
void savePicture(){
  Date date = new Date();
  int num = int(random(1000));
  String name = "data/images/portraits-"+date.getTime()+".png";
  save(name);
}
