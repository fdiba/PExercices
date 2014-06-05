PImage img;
PVector location;

void setup(){
  size(640,480);
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
  loadPixels();
  withdrawColors();
  updatePixels();
}
void withdrawColors(){
  
}
