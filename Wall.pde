class Wall {
  float xcor;
  float ycor;
  int w;
  int h;
  boolean isDestroyed;


  Wall (float x, float y, int wid, int high, boolean isSmashed) {
    xcor = x;
    ycor = y;
    w = wid;
    h = high;
  }

  void display() {
    stroke(255, 255, 255);
    fill(255, 255, 255);
    rect(xcor, ycor, w, h);
  }
}
