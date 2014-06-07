class HostImage {

  PImage img;
  PVector location;
  int width;
  int height;
  PApplet parent;
  float contrast;
  float brightness;

  HostImage(PApplet _parent, String str) {
    
    contrast = brightness = 1;
    parent = _parent;
    location = new PVector();

    img = loadImage(str);
    init();
  }
  void resize(int _width, int _height) {
    img.resize(_width, _height); 
    init();
  }
  void init() {
    width = img.width;
    height = img.height;
    location.y = (parent.height - height)/2;
    location.x = (parent.width - width)/2;
  }
  void withdrawColors() {

    for (int x=(int)location.x; x<img.width+location.x; x++) {
      for (int y=(int)location.y; y<img.height+location.y; y++) {

        //color c = color(random(255)); 
        //pixels[x+y*img.width] = c;

        int loc = x + y*img.width;

        color couleur = pixels[loc];

        //float r = red(pixels[loc]);
        int r = (couleur >> 16) & 0xFF;
        int g = (couleur >> 8) & 0xFF;
        int b = couleur & 0xFF;
    
        r = (int) (r*contrast + brightness);
        g = (int) (g*contrast + brightness);
        b = (int) (b*contrast + brightness);

        //r = constrain(r, 0, 255);
        r = r < 0 ? 0 : r > 255 ? 255 : r;
        g = g < 0 ? 0 : g > 255 ? 255 : g;
        b = b < 0 ? 0 : b > 255 ? 255 : b;
        
        int value = (r+g+b)/3;
        //pixels[loc] = color(value);
        pixels[loc] = 0xff000000 | (value << 16) | (value << 8) | value;
      }
    }
  }
}

