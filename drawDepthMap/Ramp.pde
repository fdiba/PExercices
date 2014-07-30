class Ramp{
  
  int[] colors;
 
  Ramp(){
    
    //from red (FF0000) to yellow (FFFF00) to green (00FF00)
  
    colors = new int[255*2];
    int i = 0;
  
    int r = 255;
    int g = 0;
    int b = 0;
    int step = 1;
      
    boolean isDone = false;
    
    while(!isDone){
        
      if(g<255){
        
        g += step;
        g = constrain(g, 0, 255);
        
        //colors[i] = color(r, g, b);
        colors[i] =  (255 << 24) | (r << 16) | (g << 8) | b;
        
      } else if(g==255){
  
        r -= step;
        r = constrain(r, 0, 255);
        
        colors[i] =  (255 << 24) | (r << 16) | (g << 8) | b;
        
        if(r==0)isDone = true;
      }
      
      i++;
      
    }

  }
  int pickColor(float depthValue, int lowestValue, int highestValue){
    int colorId = (int) map(depthValue, lowestValue, highestValue, 0, colors.length-1);
    return colors[colorId];
  }
}
