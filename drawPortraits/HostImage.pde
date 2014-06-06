class HostImage {
  
  PImage img;
  PVector location;
  int width;
  int height;
  PApplet parent;
  
  HostImage(PApplet _parent, String str){
    
    parent = _parent;
    location = new PVector();
    
    img = loadImage(str);
    init();  
  }
  void resize(int _width, int _height){
    img.resize(_width, _height); 
    init();
  }
  void init(){
    width = img.width;
    height = img.height;
    location.y = (parent.height - height)/2;  
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
  }}
}
