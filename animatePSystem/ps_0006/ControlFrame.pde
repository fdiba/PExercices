public class ControlFrame extends PApplet {

  int w, h;

  int abc = 100;

  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

    int x = 10;
    int y = 0;
    int sw = 256;
    int sh = 9;

    // name, minValue, maxValue, defaultValue, x, y, width, height
    cp5.addSlider("n", 1, 20000, 10000, x, y+=10, sw, sh).plugTo(parent, "n");
    cp5.addSlider("dofRatio", 1, 200, 50f, x, y+=10, sw, sh).plugTo(parent, "dofRatio");
    cp5.addSlider("neighborhood", 1, width * 2, 700f, x, y+=10, sw, sh).plugTo(parent, "neighborhood");
    cp5.addSlider("speed", 0, 100, 24f, x, y+=10, sw, sh).plugTo(parent, "speed");
    cp5.addSlider("viscosity", 0, 1, .1, x, y+=10, sw, sh).plugTo(parent, "viscosity");
    cp5.addSlider("spread", 50, 200, 100f, x, y+=10, sw, sh).plugTo(parent, "spread");
    cp5.addSlider("independence", 0, 1, .15, x, y+=10, sw, sh).plugTo(parent, "independence");
    cp5.addSlider("rebirth", 0, 100, 0, x, y+=10, sw, sh).plugTo(parent, "rebirth");
    cp5.addSlider("rebirthRadius", 1, width, 250f, x, y+=10, sw, sh).plugTo(parent, "rebirthRadius");
    cp5.addSlider("turbulence", 0, 4, 1.3, x, y+=10, sw, sh).plugTo(parent, "turbulence");
    cp5.addToggle("paused", false, x, y+=11, 9, sh).plugTo(parent, "paused");

    cp5.addToggle("useColors", false, x+40, y, 9, sh).plugTo(parent, "useColors");
    cp5.addToggle("useShader", true, x+40*2+10, y, 9, sh).plugTo(parent, "useShader");
    cp5.addSlider("blurEffect", 0, 15, 0f, x, y+=30, sw, sh).plugTo(parent, "blurEffect");
  }

  public void draw() {
    background(abc);
  }

  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }


  public ControlP5 control() {
    return cp5;
  }


  ControlP5 cp5;

  Object parent;
}

