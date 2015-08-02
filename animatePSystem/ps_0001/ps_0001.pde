import java.util.Date;
import java.util.Vector;
import peasy.*;

PeasyCam cam;

PVector cameraCenter, avg, globalOffset;
Vector particles;

int n;

boolean paused;

float turbulence, neighborhood;
float rebirthRadius, independence, speed, viscosity, spread;
float cameraRate;

void setup() {

  size(720, 480, OPENGL);
  cam = new PeasyCam(this, 1600);

  setParameters();

  cameraCenter = new PVector();
  avg = new PVector();
  globalOffset = new PVector(0f, 1/3f, 2/3f);

  particles = new Vector();
  for (int i=0; i<n; i++) particles.add(new Particle());
  
}

void draw() {
 
  avg.mult(0);
  
  for(int i=0; i<particles.size(); i++) {
    Particle p = ((Particle) particles.get(i));    
    avg.add(p.pos);
  }
  //avg.scaleSelf(1. / particles.size());
  //avg.mult(1f/particles.size());
  avg.div(particles.size());
  
   //----------- center cam position ----------------//
   
  cameraCenter.mult(1f-cameraRate);
  cameraCenter.add(PVector.mult(avg, cameraRate));
  
  translate(-cameraCenter.x, -cameraCenter.y, -cameraCenter.z);


  background(0);
  noFill();
  hint(DISABLE_DEPTH_TEST);

  for (int i = 0; i < particles.size (); i++) {
    Particle p = ((Particle) particles.get(i));
    if(!paused) p.update();
    p.display();
  }


  if (particles.size() > n) particles.setSize(n);
  while (particles.size() < n) particles.add(new Particle());

  float value = turbulence/neighborhood;
  globalOffset.add(value, value, value);
  
  println(frameRate);
  
}
Particle randomParticle() {
  return ((Particle) particles.get((int) random(particles.size())));
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
  
  cameraRate = .1;
  
}
void keyPressed() {
  if (key == 'p') paused = !paused;
  else if (key == 's') savePicture();
}
void savePicture() {
  Date date = new Date();
  int num = int(random(1000));
  String name = "data/images/ps-"+date.getTime()+".png";
  save(name);
}

