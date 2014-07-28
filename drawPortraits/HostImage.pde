class HostImage {
  
  PImage img;
  PImage imgEdited;
  PVector location;
  
  boolean[] pix;
  
  //--- param ---//
  float contrast = 1;
  float brightness = 1;
  
  HostImage(PApplet _parent, String imgFile){
        
    location = new PVector();
    img = loadImage(imgFile);
    checkImageSize();
    setPix();
    
  }
  void setPix(){
    
    pix = new boolean[width*height];
    
    for (int i=0; i<pix.length; i++){
      pix[i] = false;
    }
    
  }
  void checkImageSize(){
    
    int scale = 1;
    
    if(img.width > img.height && img.width > width){      
      scale = img.width/width;
    } else if (img.height > img.width && img.height > height){
      scale = img.height/height;
    }
    
    if(scale != 1){
      img.resize(img.width/scale, img.height/scale);
    }
    
    centerImage();
    
  }
  void centerImage(){ 
    location.x = width/2 - img.width/2;
    location.y = height/2 - img.height/2;
  }
  void display(){
  
    image(imgEdited, location.x, location.y);
    
  }
  void editLuminosity(){
    
    imgEdited = img.get(0, 0, img.width, img.height); 
    
    imgEdited.loadPixels();
    
    for (int x=0; x<imgEdited.width; x++) {
      for (int y=0; y<imgEdited.height; y++) {

        int loc = x + y*imgEdited.width;

        color c = imgEdited.pixels[loc];

        //float r = red(img.pixels[loc]);
        int r = (c >> 16) & 0xFF;
        int g = (c >> 8) & 0xFF;
        int b = c & 0xFF;
    
        r = (int) (r*contrast + brightness);
        g = (int) (g*contrast + brightness);
        b = (int) (b*contrast + brightness);

        //r = constrain(r, 0, 255);
        r = r < 0 ? 0 : r > 255 ? 255 : r;
        g = g < 0 ? 0 : g > 255 ? 255 : g;
        b = b < 0 ? 0 : b > 255 ? 255 : b;
        
        int value = (r+g+b)/3;
        
        //img.pixels[loc] = color(value);
        imgEdited.pixels[loc] = 0xff000000 | (value << 16) | (value << 8) | value;
      }
    }
    
    imgEdited.updatePixels();
    
  }
  void removeColors(){
    
    img.loadPixels();
    
    for (int x=0; x<img.width; x++) {
      for (int y=0; y<img.height; y++) {

        int loc = x + y*img.width;

        color c = img.pixels[loc];

        //float r = red(img.pixels[loc]);
        int r = (c >> 16) & 0xFF;
        int g = (c >> 8) & 0xFF;
        int b = c & 0xFF;
        
        int value = (r+g+b)/3;
        
        //img.pixels[loc] = color(value);
        img.pixels[loc] = 0xff000000 | (value << 16) | (value << 8) | value;
      }
    }
    
    img.updatePixels();
    
  }
  
}
