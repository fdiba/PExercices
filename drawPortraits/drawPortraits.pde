PImage img;
PVector location;
Menu menu;
boolean saturation;

void setup(){
  size(640,480);
  menu = new Menu();
  
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
  background(0);
  image(img, location.x, location.y);
  
  if(!saturation) {
    loadPixels();
      withdrawColors();
    updatePixels();
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
    if (keyCode == UP) {
      menu.addSaturation();
    } else if (keyCode == DOWN) {
      menu.reduceSaturation();
    }
  }
}
