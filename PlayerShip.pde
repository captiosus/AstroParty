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
  
  int w = 40;
  int h = 40;
  float errorPoint = 10;
  
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
  }
  
  void moveForward(int speed) {
    if (!(coords[0][0] > width || coords[0][0] < 0 || 
    coords[0][1] > height || coords[0][1] < 0) && !(shipDetect)) {
      centroidX += speed * cos(rotateAngle);
      centroidY += speed * sin(rotateAngle);
    }
  }

  void shoot() {
    Bullet b = new Bullet(coords[0][0], coords[0][1],rotateAngle, player);
    bullets.add(b);
  }
  
  boolean intersect(float[] P1 , float[] P2, float[] Q1, float[] Q2) {
    float A = P2[1] - P1[1];
    float B = P1[0] - P2[0];
    float C = A*P1[0] + B*P1[1];
    float A1 = Q2[1] - Q1[1];
    float B1 = Q1[0] - Q2[0];
    float C1 = A*Q1[0] + B*Q1[1];
    float det = A*B1 - A1*B;
    if (abs(det) <= errorPoint) {
      return false;
    }
    else {
      float xIntersect = (B1*C - B*C1)/det;
      float yIntersect = (A*C1 - A1*C)/det;
      if (xIntersect >= min(P1[0], P2[0])-errorPoint && xIntersect <= max(P1[0], P2[0])+errorPoint
      && yIntersect >= min(P1[1], P2[1])-errorPoint && yIntersect <= max(P1[1], P2[1])+errorPoint
      && xIntersect >= min(Q1[0], Q2[0])-errorPoint && xIntersect <= max(Q1[0], Q2[0])+errorPoint
      && yIntersect >= min(Q1[1], Q2[1])-errorPoint&& yIntersect <= max(Q1[1], Q2[1])+errorPoint) {
        return true;
      }
    }
    return false;
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
        return true;
      }
    }
    return false;
  }
  /*
  boolean triangleCheck(float[] P) {
    float area = abs(coords[0][0]*coords[1][1] + coords[1][0]*coords[2][1]
    + coords[2][0]*coords[0][1] - coords[0][0]*coords[2][1]
    - coords[2][0]*coords[1][1] - coords[1][0]*coords[0][1])/2;
    float tri1 = abs(P[0]*coords[1][1] + coords[1][0]*coords[2][1]
    + coords[2][0]*P[1] - P[0]*coords[2][1]
    - coords[2][0]*coords[1][1] - coords[1][0]*P[1])/2;
    float tri2 = abs(coords[0][0]*P[1] + P[0]*coords[2][1]
    + coords[2][0]*coords[0][1] - coords[0][0]*coords[2][1]
    - coords[2][0]*P[1] - P[0]*coords[0][1])/2;
    float tri3 = abs(coords[0][0]*coords[1][1] + coords[1][0]*P[1]
    + P[0]*coords[0][1] - coords[0][0]*P[1]
    - P[0]*coords[1][1] - coords[1][0]*coords[0][1])/2;
    println("1: " + tri1 + " 2: " + tri2 + " 1: " + tri3 + " total: " + area);
    if (abs((tri1 + tri2 + tri3) - area) < errorPoint) {
      return true;
    }
    else {
      return false;
    }
  }*/
  
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
    triangle(coords[0][0], coords[0][1], coords[1][0], coords[1][1], coords[2][0], coords[2][1]);    for (int i = 0; i < bullets.size(); i++) {
      Bullet b = bullets.get(i);
      if (!(b.x > width + b.rad || b.x < 0 - b.rad || 
      b.y > height + b.rad|| b.y < 0 - b.rad)) {
        b.moveForward(5);
      }
      else {
        bullets.remove(i);
        i--;
      }
      b.display();
    }
  }
}
