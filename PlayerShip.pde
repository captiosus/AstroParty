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
  
  int w = 20;
  int h = 40;
  float errorPoint = 100;
  
  PlayerShip(int x, int y, int player) {
    coords[0][0] = x;
    coords[0][1] = y;
    coords[1][0] = x  - h;
    coords[1][1] = y + w/2;
    coords[2][0] = x - h;
    coords[2][1] = y - w/2;
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
  
  /*boolean onSegment(float[] P , float[] Q, float[] R) {
    if (Q[0] <= max(P[0], R[0]) && Q[0] >= min(P[0], R[0]) 
    && Q[1] <= max(P[1], R[1]) && Q[1] >= min(P[1], R[1])) {
      return true;
    }
    return false;
  }
  
  int orientation(float[] P , float[] Q, float[] R) {
    float val = (Q[1] - P[1]) * (R[0] - Q[0]) - (Q[0] - P[0]) * (R[1] - Q[1]);
    
    if (val == 0) {
      return 0;
    }
    else if (val > 0) {
      return 1;
    }
    else {
      return 2;
    }
  }
  
  boolean intersect(float[] P1 , float[] P2, float[] Q1, float[] Q2) {
    int o1 = orientation(P1, Q1, P2);
    int o2 = orientation(P1, Q1, Q2);
    int o3 = orientation(P2, Q2, P1);
    int o4 = orientation(P2, Q2, Q1); 
    
    if (o1 != o2 && o3 != o4) {
      return true;
    }
    return false;
  }

  boolean triangleIntersect(PlayerShip other) {
    stroke(0,255, 255);
    strokeWeight(10);
    line(coords[0][0], coords[0][1], coords[2][0], coords[2][1]);
    line(other.coords[0][0], other.coords[0][1], other.coords[1][0], other.coords[1][1]);
    strokeWeight(1);
    boolean[][] tests = new boolean[9][2];
    //tri1
    tests[0][0] = intersect(coords[0], coords[2], other.coords[0], other.coords[1]);
    tests[0][1] = intersect(coords[0], coords[1], other.coords[0], other.coords[1]);
    
    tests[1][0] = intersect(coords[0], coords[2], other.coords[1], other.coords[2]);
    tests[1][1] = intersect(coords[0], coords[1], other.coords[1], other.coords[2]);
    
    tests[2][0] = intersect(coords[0], coords[2], other.coords[0], other.coords[2]);
    tests[2][1] = intersect(coords[0], coords[1], other.coords[0], other.coords[2]);
    
    //tri2
    tests[3][0] = intersect(coords[0], coords[1], other.coords[0], other.coords[1]);
    tests[3][1] = intersect(coords[1], coords[2], other.coords[0], other.coords[1]);
       
    tests[4][0] = intersect(coords[0], coords[1], other.coords[1], other.coords[2]);
    tests[4][1] = intersect(coords[1], coords[2], other.coords[1], other.coords[2]);
    
    tests[5][0] = intersect(coords[0], coords[1], other.coords[0], other.coords[2]);
    tests[5][1] = intersect(coords[1], coords[2], other.coords[0], other.coords[2]);
    
    //tri3
    tests[6][0] = intersect(coords[0], coords[2], other.coords[0], other.coords[1]);
    tests[6][1] = intersect(coords[1], coords[2], other.coords[0], other.coords[1]);
    
    tests[7][0] = intersect(coords[0], coords[2], other.coords[1], other.coords[2]);
    tests[7][1] = intersect(coords[1], coords[2], other.coords[1], other.coords[2]);
    
    tests[8][0] = intersect(coords[0], coords[2], other.coords[0], other.coords[2]);
    tests[8][1] = intersect(coords[1], coords[2], other.coords[0], other.coords[2]);
    for (int x = 0; x < tests.length; x++) {
      if (tests[x][0] && tests[x][1]) {
        return true;
      }
    }
    return false;
  }*/
  
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
