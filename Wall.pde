class Wall {
  float xcor;
  float ycor;
  int w;
  int h;

  Wall (float x, float y, int wid, int high) {
    xcor = x;
    ycor = y;
    w = wid;
    h = high;
  }

  void wallCollision(PlayerShip p) {
    float wallT = ycor;
    float wallB = ycor + h;
    float wallL = xcor;
    float wallR = xcor + w;
    float playerT = p.centroidY - 10;
    float playerB = p.centroidY + 10;
    float playerL = p.centroidX - 10;
    float playerR = p.centroidX + 10;
    
    if (playerT < wallB && playerT > wallT && playerL > wallL && playerL < wallR) {
      float ydif = wallB - playerT;
      float xdif = wallR - playerL;
      if (ydif < xdif) {
        p.centroidY += ydif;
      }
      else {
        p.centroidX += xdif;
      }
    }
    else if (playerT < wallB && playerT > wallT && playerR < wallR && playerR > wallL) {
      float ydif = wallB - playerT;
      float xdif = playerR - wallL;
      if (ydif < xdif) {
        p.centroidY += ydif;
      }
      else {
        p.centroidX -= xdif;
      }
    }
    else if (playerB < wallB && playerB > wallT && playerL > wallL && playerL < wallR) {
      float ydif = playerB - wallT;
      float xdif = wallR - playerL;
      if (ydif < xdif) {
        p.centroidY -= ydif;
      }
      else {
        p.centroidX += xdif;
      }
    }
    else if (playerB < wallB && playerB > wallT && playerR < wallR && playerR > wallL) {
      float ydif = playerB - wallT;
      float xdif = playerR - wallL;
      if (ydif < xdif) {
        p.centroidY -= ydif;
      }
      else {
        p.centroidX -= xdif;
      }
    }
  }
  
  void bulletCollision (PlayerShip p){
    for (int i = 0; i < (p.bullets).length; i++) {
      if (!p.bullets[i].onHold) {
        float wallT = ycor;
        float wallB = ycor + h;
        float wallL = xcor;
        float wallR = xcor + w;
        float bulletT = p.centroidY - 10;
        float bulletB = p.centroidY + 10;
        float bulletL = p.centroidX - 10;
        float bulletR = p.centroidX + 10;
      }
    }
  }

  void display() {
    stroke(255, 255, 255);
    fill(255, 255, 255);
    rect(xcor, ycor, w, h);
  }
}
