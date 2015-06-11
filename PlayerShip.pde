class PlayerShip {
  float[][] coords = new float[3][2];
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  float centroidX;
  float centroidY;
  float rotateAngle;
  float triAng1;
  float triAng2;
  float radiusPoint;
  float radiusBase;
  int player;
  int red;
  int green;
  int blue;
  
  boolean wallConflict = false;
  boolean dead = false;
  boolean shipDetect = false;
  
  int w = 50;
  int h = 30;
  float errorPoint = 1;
  
  PlayerShip(int x, int y, int player) {
    coords[0][0] = x;
    coords[0][1] = y;
    coords[1][0] = x - w;
    coords[1][1] = y + h/2;
    coords[2][0] = x - w;
    coords[2][1] = y - h/2;
    centroidX = (coords[0][0] + coords[1][0] + coords[2][0])/3;
    centroidY = (coords[0][1] + coords[1][1] + coords[2][1])/3;
    float c2bX = abs(coords[1][0] - centroidX);
    float c2bY = abs(coords[1][1] - centroidY);
    triAng1 = PI - atan(c2bX/c2bY);
    triAng2 = PI + atan(c2bX/c2bY);
    radiusBase = sqrt(pow(c2bX, 2) + pow(c2bY, 2));
    radiusPoint = abs(x - centroidX);
    if (player == 0) {
      red = 255;
      green = 0;
      blue = 0;
    }
    else if (player == 1) {
      red = 0;
      green = 0;
      blue = 255;
    }
    else if (player == 2) {
      red = 0;
      green = 255;
      blue = 0;
    }
    else if (player == 3) {
      red = 230;
      green = 0;
      blue = 255;
    }
  }
  
  void rotate(float angle) {
    rotateAngle += angle;
    if (rotateAngle > PI) {
      rotateAngle -= 2*PI;
    }
  }
  
  void moveForward(int speed) {
    if (!(coords[0][0] > width || coords[0][0] < 0 || 
    coords[0][1] > height || coords[0][1] < 0) && !(shipDetect)) {
      centroidX += speed * cos(rotateAngle);
      centroidY += speed * sin(rotateAngle);
    }
  }
  
  void collideMove(PlayerShip other, int speed) {
    if (inBounds() && other.inBounds()) {
      float angle = (rotateAngle + other.rotateAngle)/2;
      float resultSpeed = 10;
      centroidX += resultSpeed * cos(angle);
      centroidY += resultSpeed * sin(angle);
      other.centroidX += resultSpeed * cos(angle);
      other.centroidY += resultSpeed * sin(angle);
    }
  }
  
  void bounce() {
    if (inBounds()) {
      centroidX += 1 * cos(abs(PI-rotateAngle));
      centroidY += 1 * sin(abs(PI-rotateAngle));
    }
  }
  
  void shoot() {
    Bullet b = new Bullet(coords[0][0], coords[0][1],rotateAngle, player);
    bullets.add(b);
  }
  
  boolean inBounds() {
    return !(coords[0][0] > width || coords[0][0] < 0 || 
    coords[0][1] > height || coords[0][1] < 0 ||
    coords[1][0] > width || coords[1][0] < 0 || 
    coords[1][1] > height || coords[1][1] < 0 ||
    coords[2][0] > width || coords[2][0] < 0 || 
    coords[2][1] > height || coords[2][1] < 0);
  }
  
  Boolean wallCollision(Obstacle o, PlayerShip p) {
    float[][] wallTop = new float[o.size][2];
    float[][] wallBottom = new float[o.size][2];
    float[][] wallLSide = new float[o.size][2];
    float[][] wallRSide = new float[o.size][2];

    for (int i = 0; i < wallTop.length; i ++) {
      wallTop[i][0] = o.xcor + i;
      wallTop[i][1] = o.ycor;
    }
    for (int i = 0; i < wallBottom.length; i ++) {
      wallBottom[i][0] = o.xcor + i;
      wallBottom[i][1] = o.ycor + o.size;
    }
    for (int i = 0; i < wallLSide.length; i ++) {
      wallLSide[i][0] = o.xcor;
      wallLSide[i][1] = o.ycor + i;
    }
    for (int i = 0; i < wallRSide.length; i ++) {
      wallRSide[i][0] = o.xcor + o.size;
      wallRSide[i][1] = o.ycor + i;
    }  

    for (int i = 0; i < wallTop.length; i ++) {
      if (sqrt(sq(p.centroidX - wallTop[i][0]) + sq(p.centroidY - wallTop[i][1])) <= w)
        wallConflict = true;
    }
    for (int i = 0; i < wallBottom.length; i ++) {
      if (sqrt(sq(p.centroidX - wallBottom[i][0]) + sq(p.centroidY - wallBottom[i][1])) <= w)
        wallConflict = true;
    }
    for (int i = 0; i < wallLSide.length; i ++) {
      if (sqrt(sq(p.centroidX - wallLSide[i][0]) + sq(p.centroidY - wallLSide[i][1])) <= w)
        wallConflict = true;
    }
    for (int i = 0; i < wallRSide.length; i ++) {
      if (sqrt(sq(p.centroidX - wallRSide[i][0]) + sq(p.centroidY - wallRSide[i][1])) <= w)
        wallConflict = true;
    }
    return wallConflict;
  }
  
  boolean intersect(float[] P1 , float[] P2, float[] Q1, float[] Q2) {
    float denominator=((P2[0]-P1[0])*(Q2[1]-Q1[1]))-((P2[1]-P1[1])*(Q2[0]-Q1[0]));
    float num1=((P1[1]-Q1[1])*(Q2[0]-Q1[0]))-((P1[0]-Q1[0])*(Q2[1]-Q1[1]));
    float num2=((P1[1]-Q1[1])*(P2[0]-P1[0]))-((P1[0]-Q1[0])*(P2[1]-P1[1]));
    
    if (denominator == 0) {
      return (num1 == 0 && num2 == 0);
    }
    
    float r = num1 / denominator;
    float s = num2 / denominator;
    
    return (r >= 0 && r <= 1) && (s >= 0 && s<= 1);
  }

  boolean triangleCheck(PlayerShip other) {
    boolean[] tests = new boolean[9];
    tests[0] = intersect(coords[0], coords[1], other.coords[0], other.coords[1]);    
    tests[1] = intersect(coords[0], coords[1], other.coords[1], other.coords[2]); 
    tests[2] = intersect(coords[0], coords[1], other.coords[0], other.coords[2]);  
    tests[3] = intersect(coords[1], coords[2], other.coords[0], other.coords[1]);  
    tests[4] = intersect(coords[1], coords[2], other.coords[1], other.coords[2]);  
    tests[5] = intersect(coords[1], coords[2], other.coords[0], other.coords[2]);  
    tests[6] = intersect(coords[0], coords[2], other.coords[0], other.coords[1]);  
    tests[7] = intersect(coords[0], coords[2], other.coords[1], other.coords[2]);  
    tests[8] = intersect(coords[0], coords[2], other.coords[0], other.coords[2]);  
    for (int x = 0; x < tests.length; x++) {
      if (tests[x]) {
        bounce();
        return true;
      }
    }
    return false;
  }

  boolean squareCheck(PlayerShip other) {
    if (abs(centroidX - other.centroidX) < 2*radiusPoint 
    && abs(centroidY - other.centroidY) < 2*radiusPoint) {
      return true;
    }
    else {
      return false;
    }
  }
  void update() {
    coords[0][0] = centroidX + radiusPoint * cos(rotateAngle);
    coords[0][1] = centroidY + radiusPoint * sin(rotateAngle);
    coords[1][0] = centroidX + radiusBase * cos(rotateAngle + triAng1);
    coords[1][1] = centroidY + radiusBase * sin(rotateAngle + triAng1);
    coords[2][0] = centroidX + radiusBase * cos(rotateAngle + triAng2);
    coords[2][1] = centroidY + radiusBase * sin(rotateAngle + triAng2);
  }

  void display() {
    stroke(255, 255, 255);
    fill(red, green, blue);
    triangle(coords[0][0], coords[0][1], coords[1][0], coords[1][1],
    coords[2][0], coords[2][1]);
    for (int i = 0; i < bullets.size(); i++) {
      Bullet b = bullets.get(i);
      if (!(b.x > width + b.rad || b.x < 0 - b.rad || 
      b.y > height + b.rad|| b.y < 0 - b.rad)) {
        b.moveForward(8);
      }
      else {
        bullets.remove(i);
        i--;
      }
      b.display();
    }
  }
}
