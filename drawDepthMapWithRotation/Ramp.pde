class Ramp{
  
  int[] colors;
  boolean redToGreen = false;
  int step = 1;
 
  Ramp(){
    
    // from red (FF0000) to yellow (FFFF00) to green (00FF00)
  
    if(redToGreen){
      colors = new int[255*2];
    } else {
      colors = new int[255*4];
    }
    
    int i = 0;
  
    int r = 255;
    int g = 0;
    int b = 0;
      
    boolean isDone = false;
    
    while(!isDone){
        
      if(g < 255){
        
        g += step;
        g = constrain(g, 0, 255);
        
        // colors[i] = color(r, g, b);
        colors[i] =  (255 << 24) | (r << 16) | (g << 8) | b; // 255 0 0 --> 255 255 0
        
      } else if(g == 255){ // 255 255 0 to 0 255 0
  
        r -= step;
        r = constrain(r, 0, 255);
        
        colors[i] =  (255 << 24) | (r << 16) | (g << 8) | b;
        
        if(r==0 && redToGreen){
          isDone = true;
        } else if (r==0 && !redToGreen) {
          isDone = true;
          addBlueColors(i);
        }
        
      }
      
      i++;
      
    }

  }
  void addBlueColors(int _id){ // 0 255 0 to 0 0 255
    
    int id = _id + 1;
  
    int r = 0;
    int g = 255;
    int b = 0;
      
    boolean isDone = false;
    
    while(!isDone){
        
      if(b < 255){
        
        b += step;
        b = constrain(b, 0, 255);
        
        //colors[i] = color(r, g, b);
        colors[id] =  (255 << 24) | (r << 16) | (g << 8) | b; // 0 255 0 --> 0 255 255
        
      } else if(b == 255){ // 0 255 255 to 0 0 255
  
        g -= step;
        g = constrain(g, 0, 255);
        
        colors[id] =  (255 << 24) | (r << 16) | (g << 8) | b;
        
        if(g==0){
          isDone = true;
        }
        
      }
      
      id++;
      
    }

    
    
  }
  int pickColor(float depthValue, int lowestValue, int highestValue){
    int colorId = (int) map(depthValue, lowestValue, highestValue, 0, colors.length-1);
    return colors[colorId];
  }
}
