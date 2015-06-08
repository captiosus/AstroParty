class Obstacle {
  float xcor;
  float ycor;
  int size;


  Obstacle (float x, float y, int sideLen) {
    xcor = x;
    ycor = y;
    size = sideLen;
  }

  void display() {
    stroke(255, 255, 255);
    fill(255, 255, 255);
    rect(xcor, ycor, size, size);
  }
}
