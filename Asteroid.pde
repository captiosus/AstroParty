class Asteroid {

  int diameter;
  float xpos;
  float ypos;
  boolean isSmashed;

  Asteroid(int d, float x, float y, boolean b) {
    diameter = d;
    xpos = x;
    ypos = y;
    isSmashed = b;
  }

  void display() {
    stroke(255, 255, 255);
    fill(255, 255, 255);
    ellipse(xpos, ypos, diameter, diameter);
  }
}
