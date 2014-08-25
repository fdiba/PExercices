import java.util.*;
import themidibus.*;
import processing.serial.*;
import cc.arduino.*;

Map<String, Integer> params;
int[] colors = {-8410437,-9998215,-1849945,-5517090,-4250587,-14178341,-5804972,-3498634};
Menu menu;

Arduino arduino;
int motorPin = 12;
int brakePin = 9;

boolean reverse;

//--- behringer ----------//
MidiBus midiBus;
boolean BCF2000;
BehringerBCF behringer;

void setup(){
  
  size(640, 480);
  
  //--- behringer -----------//
  BCF2000 = false;

  if (BCF2000) {
    MidiBus.list();
    midiBus = new MidiBus(this, "BCF2000", "BCF2000");
    behringer = new BehringerBCF(midiBus);
  }
  
  //-------------------------//
  
  params = new HashMap<String, Integer>();
  
  Object[][] objects = { {"speed", 0, 255, colors[0], 0, 0, 255} };
  
  createMenu(objects);
  
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  arduino.pinMode(motorPin, Arduino.OUTPUT); //Initiates Motor Channel A pin
  arduino.pinMode(brakePin, Arduino.OUTPUT); //Initiates Brake Channel A pin
  
}
void draw(){
  
  background(0);
  
  menu.update();
  
  if(reverse){
    
    arduino.digitalWrite(motorPin, Arduino.LOW);
    arduino.digitalWrite(brakePin, Arduino.LOW);
    arduino.analogWrite(3, params.get("speed"));
    
  } else {
  
    arduino.digitalWrite(motorPin, Arduino.HIGH);
    arduino.digitalWrite(brakePin, Arduino.LOW);
    arduino.analogWrite(3, params.get("speed"));
  
  }
  
  menu.display(true);
  
}
void createMenu(Object[][] objects){  
  menu = new Menu(this, new PVector(450, 50), objects);
}
void useBrake(){
  arduino.digitalWrite(9, Arduino.HIGH); //Engage the Brake for Channel A
}
//----------- key ------------------//
void keyPressed() {
  if (key == 'r') {
    toggleValue();
  }
}
void toggleValue() {
  reverse = !reverse;  
  useBrake();
  delay(1000);
}
//----------- mouse ----------------//
void mouseReleased() {
  menu.resetSliders();
}
//------------- EXIT ---------------//
void exit() {
  useBrake();
  println("exiting");
  super.exit();
}
