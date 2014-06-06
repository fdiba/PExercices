HostImage host;
Menu menu;
boolean saturation;
ParticleSystem ps;

void setup(){
  size(640,480);
  //smooth();
  background(0);
  menu = new Menu();
  ps = new ParticleSystem();
  host = new HostImage(this, "Scarlett-Johansson-faces.jpg");
  
  if(host.width > width && host.width > host.height){
    int scale = host.width/width;
    println(scale);
    host.resize(host.width/scale, host.height/scale); 
  }
  
}

void draw(){
  
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
    //println(menu.brightness);
  }
}
void mousePressed(){
  if(!saturation){
    background(0);
    saturation = true;
  }
}
