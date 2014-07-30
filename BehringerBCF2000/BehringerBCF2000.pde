import javax.sound.midi.MidiMessage; 
import themidibus.*;
MidiBus myBus;

int[] encoders = new int[8];
int[] lights = new int[8];
int[] sliders = new int[8];

int sliderId;

ArrayList<Integer> ramp;

void setup() {
  
  size(640, 480);
  
  MidiBus.list();
  myBus = new MidiBus(this, 0, 3);
  
  createRamp();
  
}
void draw() {
  
  background(0);

  translate(0, 15);
  
  displayEncoders();
  
  translate(150, 140);
  displayGreyAreas();
  displayColorDots(); 
  
  translate(-150, 210);
  displaySliders();
  
}
void displaySliders(){
  
  stroke(255);
  fill(127);
  
  for(int i=0; i<sliders.length; i++){
    
    float w = map(sliders[i], 0, 127, 0, width);
    int h = height/5/encoders.length;

    rect(0, i*h, w, h);
    
  }  
  
}
void displayEncoders(){

  stroke(255);
  fill(127);
  
  for(int i=0; i<encoders.length; i++){
    
    float w = map(encoders[i], 0, 127, 0, width);
    int h = height/5/encoders.length;

    rect(0, i*h, w, h);
    
  }  
  
}
void displayColorDots(){
  
  noStroke();

  for(int i=0; i<lights.length; i++){
    
    int h = height/5/encoders.length;
    
    int y = h*i+10;
    
    for(int j=0; j<lights[i]; j++){
      
      int id = (int) map(j, 0, 15-1, 0, ramp.size()-1);
      color c = ramp.get(id); 
      
      fill(c);
      ellipse(20+j*20, y+10*i, 10, 10); 
      
    }

  }
  
}
void mousePressed(){
  println("sending...");
  
  /*
  
  //edit encoders position
  
  int status = 191; //channel
  int data1 = 1; //note
  int data2 = 0; //value
  
  myBus.sendMessage(status, data1, data2);*/
  
  int status = 185; //channel
  int data1 = 6; //note
  int data2 = 0; //value
  
  //edit sliders position
  myBus.sendMessage(185, 99, 0);
  myBus.sendMessage(185, 98, 0);
  myBus.sendMessage(185, 6, 50); //big one
  myBus.sendMessage(185, 38, 0);//small one ?
}
void displayGreyAreas(){
  
  noStroke();
  fill(127);
  
  for(int i=0; i<lights.length; i++){
    
    int h = height/5/encoders.length;
    
    int y = h*i+10;
    
    for(int j=0; j<15; j++){
    
      ellipse(20+j*20, y+10*i, 10, 10); 
      
    }

  }
  
}

void controllerChange(int channel, int number, int value) {
  
  //println("Channel: "+channel+" Number: "+number+" Value: "+value);
  
  //---- encoders ---//
  if(channel==15){
    
    encoders[number] = value;
    
    int lightNumber = (int) map(value, 0, 127, 0, 15);
    lights[number] = lightNumber;
    
    //println(value);
    
  } else if(channel==9){
  
    //println("Channel: "+channel+" Number: "+number+" Value: "+value);

    if(number==98) sliderId = value;
    
    if(number==6) {
      sliders[sliderId] = value;
    }

  } else {
    
    //println("Channel: "+channel+" Number: "+number+" Value: "+value);
    
  }
  
  //println("Channel: "+channel+" Number: "+number+" Value: "+value);
}

void midiMessage(MidiMessage message, long timestamp, String bus_name) {
   int note = (int)(message.getMessage()[1] & 0xFF) ;
   int vel = (int)(message.getMessage()[2] & 0xFF);
   
   //int channel = (int)(message.getMessage()[0] & 0xFF) +1;
   int channel = (int)(message.getMessage()[0] & 0xFF);
   
   println("Bus " + bus_name + ": Channel " + channel + ", note " + note + ", vel " + vel);
   //invokeNoteHandler(note, vel);
}
void createRamp(){
  
  //from red (FF0000) to yellow (FFFF00) to green (00FF00)
  
  int r = 255;
  int g = 0;
  int b = 0;
  int step = 1;

  ramp = new ArrayList<Integer>();
  
  boolean isDone = false;
  
  while(!isDone){
      
    if(g<255){
      
      g += step;
      g = constrain(g, 0, 255);
      ramp.add(color(r, g, b));
      
    } else if(g==255){

      r -= step;
      r = constrain(r, 0, 255);
      ramp.add(color(r, g, b));
      if(r==0)isDone = true;
    }
    
  }
  //println(ramp.size());
}
