class Bullet {
  float x;
  float y;
  float angle;
  int player;
  
  int rad = 5;
  
  Bullet(float x, float y, float angle, int player) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.player = player;
  }
  
  void moveForward(int speed) {
      x += speed * cos(angle);
      y += speed * sin(angle);
  }
  
  void display() {
    stroke(255, 255, 255);
    fill(255, 255, 255);
    ellipse(x, y, rad, rad);
  }
}
