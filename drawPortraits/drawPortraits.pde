PImage img;
PVector location;
Menu menu;
boolean saturation;
ParticleSystem ps;

void setup(){
  size(640,480);
  //smooth();
  menu = new Menu();
  ps = new ParticleSystem();
  
  img = loadImage("Scarlett-Johansson-faces.jpg");
  if(img.width > width && img.width > img.height){
    int scale = img.width/width;
    println(scale);
    img.resize(img.width/scale, img.height/scale); 
  }
  
  location = new PVector();
  location.y = (height-img.height)/2;
}

void draw(){
  //background(0);
  
  
  if(!saturation) {
    image(img, location.x, location.y);
    loadPixels();
      withdrawColors();
    updatePixels();
  } else {
    ps.run();
  }
}

void withdrawColors(){
  
  for(int x=(int)location.x; x<img.width+location.x; x++){
    for (int y=(int)location.y; y<img.height+location.y; y++){
      
      //color c = color(random(255)); 
      //pixels[x+y*img.width] = c;
      
      int loc = x + y*img.width;
      
      float r = red(pixels[loc]);
      float g = green(pixels[loc]);
      float b = blue(pixels[loc]);
      
      r *= menu.brightness;
      g *= menu.brightness;
      b *= menu.brightness;
      
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
      
      //pixels[loc] = color(r,g,b);
      pixels[loc] = color((r+g+b)/3);
      
    }
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
