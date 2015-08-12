import java.util.Date;
import java.util.Vector;

import java.awt.Frame;
import java.awt.BorderLayout;

import peasy.*;
import controlP5.*;

ControlP5 cp5;
ControlFrame cf;

PeasyCam cam;

PVector cameraCenter, avg, globalOffset;
Vector particles;

int n, rebirth;

boolean paused;

float turbulence, neighborhood;
float rebirthRadius, independence, speed, viscosity, spread, dofRatio;
float cameraRate;

PVector psCenter;
PVector cameraPosition;
float[] camPos;

int def;

//--- shader variables ---//
PShader pointShader;
PShader defaultShader;

boolean drawRoundRect = false;
boolean useColors = false;
float strokeWeight = 2f;
float blurEffect;
boolean useShader = true;

void setup() {

  size(720, 480, OPENGL);
  cam = new PeasyCam(this, 1600);

  cameraRate = .1;

  setParameters();
  cp5 = new ControlP5(this);
  cf = addControlFrame("controlWindow", 350, 270);

  cameraCenter = new PVector();
  avg = new PVector();
  globalOffset = new PVector(0f, 1/3f, 2/3f);

  particles = new Vector();
  for (int i=0; i<n; i++) particles.add(new Particle());

  //-------------- shaders --------------//
  pointShader = loadShader("pointShaderFrag.glsl", "pointShaderVert.glsl");
  PImage textColor =  loadImage("colors.jpg");
  pointShader.set("tex1", textColor);
  pointShader.set("gWidth", (float) 1024);
  pointShader.set("gHeight", (float) 768);

  defaultShader = loadShader("pointfrag.glsl", "pointvert.glsl");
}

void draw() {

  avg.mult(0);

  for (int i=0; i<particles.size (); i++) {
    Particle p = ((Particle) particles.get(i));    
    avg.add(p.pos);
  }

  avg.div(particles.size());

  cameraCenter.mult(1f-cameraRate);
  cameraCenter.add(PVector.mult(avg, cameraRate));

  translate(-cameraCenter.x, -cameraCenter.y, -cameraCenter.z);

  //to calculate distance form plane
  psCenter = avg.get();
  
  camPos = cam.getPosition();
  cameraPosition = new PVector(camPos[0], camPos[1], camPos[2]);
  cameraPosition.normalize();

  //------- update shader --------//
  pointShader.set("useColors", useColors);
  
  pointShader.set("psCenter", psCenter);
  
  pointShader.set("cameraPosition", cameraPosition);

  pointShader.set("drawRoundRect", drawRoundRect);
  pointShader.set("strokeWeight", strokeWeight);
  pointShader.set("dofRatio", dofRatio);
  pointShader.set("blurEffect", blurEffect);

  background(def);
  //background(127, 127, 0);
  
  noFill();
  hint(DISABLE_DEPTH_TEST);

  if (useShader) {

    shader(pointShader);

    for (int i = 0; i < particles.size (); i++) {

      Particle p = ((Particle) particles.get(i));
      if (!paused) p.update();

      p.displayWithSh();
    }
  } else {

    resetShader();
    //shader(defaultShader);

    for (int i = 0; i < particles.size (); i++) {

      Particle p = ((Particle) particles.get(i));
      if (!paused) p.update();

      p.display();
    }
  }



  for (int i=0; i<rebirth; i++) randomParticle().resetPosition();

  if (particles.size() > n) particles.setSize(n);
  while (particles.size () < n) particles.add(new Particle());

  float value = turbulence/neighborhood;
  globalOffset.add(value, value, value);

  //println(frameRate);
}
Particle randomParticle() {
  return ((Particle) particles.get((int) random(particles.size())));
}
void keyPressed() {
  if (key == 'p') paused = !paused;
  else if (key == 's') savePicture();
}
void savePicture() {
  Date date = new Date();
  int num = int(random(1000));
  //String name = "data/images/ps-"+date.getTime()+".png";
  String name = "data/images/ps-"+date.getTime()+".jpg";
  save(name);
}

void setParameters() {

  n = 10000;

  turbulence = 1.3;
  neighborhood = 700f;

  rebirthRadius = 250f;
  independence = .15;
  speed = 24f;
  viscosity = .1;
  spread = 100f;

  dofRatio = 50f;

  rebirth = 0;
}
ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();

  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(10, 10);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

