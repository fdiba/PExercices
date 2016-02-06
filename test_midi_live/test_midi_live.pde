import themidibus.*;
import controlP5.*;

MidiBus myBus;
ControlP5 cp5;

Console cs;

int pitchMin = 48;
int pitchMax = 72;

float cBackground;
float linePosY;

int chan;
int pitch;
int velocity;
int delay;

float zoneHeight;

void setup() {
  size(400, 400);

  linePosY = 200;

  cp5 = new ControlP5(this);
  
  zoneHeight = 20;

  chan = 0;
  pitch = pitchMin;
  velocity = 36;
  delay = 200;

  //name, minValue, maxValue, defaultValue, x, y, width, height
  cp5.addSlider("channel", 0, 10, chan, 10, 70, 100, 14).setId(0);
  cp5.addSlider("pitch", 0, 127, pitch, 10, 90, 100, 14).setId(1);
  cp5.addSlider("velocity", 0, 127, velocity, 10, 110, 100, 14).setId(2);
  cp5.addSlider("delay", 200, 1000, delay, 10, 130, 100, 14).setId(3);

  MidiBus.list(); 

  myBus = new MidiBus(this, "loopMIDI Port 2", "loopMIDI Port");

  cs = new Console(10, 20);

  cBackground = 255;
}
public void controlEvent(ControlEvent theEvent) {
  switch(theEvent.getId()) {
    case(0):
    chan = (int)(theEvent.getController().getValue());
    break;
    case(1):
    pitch = (int)(theEvent.getController().getValue());
    break;
    case(2):
    velocity = (int)(theEvent.getController().getValue());
    break;
    case(3):
    delay = (int)(theEvent.getController().getValue());
    break;
  }
}
void draw() {
  background(0);
  cs.display();

  noStroke();
  fill(cBackground);
  rect(0, linePosY, width, height-linePosY);
  
  fill(127);
  rect(0, linePosY-zoneHeight, width, zoneHeight);
   
  stroke(255, 197, 49);
  line(0, linePosY-zoneHeight, width, linePosY-zoneHeight);

  stroke(255, 197, 49);
  line(0, linePosY, width, linePosY);
}
void createDelay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
void mousePressed() {
  
  int myPitch = pitch;

  if (mouseY > linePosY) {

    int randPitch = int(random(pitchMin, pitchMax));
    myPitch = randPitch;
    
    myBus.sendNoteOn(chan, myPitch, velocity);
    createDelay(delay);
    myBus.sendNoteOff(chan, myPitch, velocity);
    
  } else if(mouseY > linePosY-zoneHeight){
    
    myBus.sendNoteOn(chan, myPitch, velocity);
    createDelay(delay);
    myBus.sendNoteOff(chan, myPitch, velocity);
    
  }
}


void noteOn(int channel, int pitch, int velocity) {
  
  cBackground = map(pitch, pitchMin, pitchMax, 0, 255);
  cs.update(channel, pitch, velocity);

  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  /*println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);*/
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}

