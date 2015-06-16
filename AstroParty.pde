PlayerShip[] players = new PlayerShip[2];

ArrayList<PlayerShip> collisions = new ArrayList<PlayerShip>();

int w;
int h;

int reload = 5;
int reloadCount = 0;
int speed = 3;
boolean[] keys = new boolean[255];

Wall[] walls;

int maxAsteroids;
Asteroid[] asteroids;
float asteroidSpeed = 0.3;

void setup() {
  size(800, 600);
  frameRate(60);
  players[0] = new PlayerShip(0, 0, 0);
  w = players[0].w;
  h = players[0].h;
  walls = new Wall[34];
  walls[0] = new Wall (140, 100, 30, 30);
  walls[1] = new Wall (140, 130, 30, 30);
  walls[2] = new Wall (140, 160, 30, 30);
  walls[3] = new Wall (110, 160, 30, 30);
  walls[4] = new Wall (80, 160, 30, 30);
  walls[5] = new Wall (140, 70, 30, 30);
  walls[6] = new Wall (50, 160, 30, 30);
  walls[7] = new Wall (width-180, height-140, 30, 30);
  walls[8] = new Wall (width-180, height-110, 30, 30);
  walls[9] = new Wall (width-180, height-170, 30, 30);
  walls[10] = new Wall (width-180, height-200, 30, 30);
  walls[11] = new Wall (width-150, height-200, 30, 30);
  walls[12] = new Wall (width-120, height-200, 30, 30);
  walls[13] = new Wall (width-90, height-200, 30, 30);
  walls[14] = new Wall (340, 210, 30, 30);
  walls[15] = new Wall (310, 210, 30, 30);
  walls[16] = new Wall (430, 210, 30, 30);
  walls[17] = new Wall (460, 210, 30, 30);
  walls[18] = new Wall (460, 240, 30, 30);
  walls[19] = new Wall (460, 330, 30, 30);
  walls[20] = new Wall (460, 360, 30, 30);
  walls[21] = new Wall (430, 360, 30, 30);
  walls[22] = new Wall (340, 360, 30, 30);
  walls[23] = new Wall (310, 360, 30, 30);
  walls[24] = new Wall (310, 330, 30, 30);
  walls[25] = new Wall (310, 240, 30, 30);
  walls[26] = new Wall (0, 350, 30, 30);
  walls[27] = new Wall (30, 350, 30, 30);
  walls[28] = new Wall (60, 350, 30, 30);
  walls[29] = new Wall (90, 350, 30, 30);
  walls[30] = new Wall (770, 250, 30, 30);
  walls[31] = new Wall (740, 250, 30, 30);
  walls[32] = new Wall (710, 250, 30, 30);
  walls[33] = new Wall (680, 250, 30, 30);
  setupPlayers();
  maxAsteroids = 10;
  asteroids = new Asteroid[int(random(2, maxAsteroids))];
  asteroidsSetup();
}
  
void draw() {
  background(0, 0, 0);
  updateKeys();
  movePlayers();
  asteroidsCheck();
  asteroids();
  for (int i = 0; i < players.length; i++) {
    if (!players[i].destroyed) {
      checkBullets(players[i]);
      checkPlayers(i);
      wallCheck(players[i]);
      players[i].update();
      players[i].display();
    }
  }
  for (int i = 0; i < walls.length; i ++) {
    walls[i].display();
  }
}

void keyPressed() {
  keys[keyCode] = true;
}

void keyReleased() {
  keys[keyCode] = false;
}

void updateKeys() {
  if (keys[RIGHT]) {
    players[0].rotate(PI/50);
  }
  if (keys[UP]) {
    if (reloadCount < reload) {
      reloadCount++;
    } else {
      reloadCount = 0;
      players[0].shoot();
    }
  }
  if (keys['D']) {
    players[1].rotate(PI/50);
  }
  if (keys['W']) {
    if (reloadCount < reload) {
      reloadCount++;
    } else {
      reloadCount = 0;
      players[1].shoot();
    }
  }
}

void wallCheck(PlayerShip p) {
  for (int i = 0; i < walls.length; i++)  {
    walls[i].wallCollision(p);
  }
}

void checkPlayers(int player) {
  for (int i = 0; i < players.length; i++) {
    if (i != player) {
      if (players[player].squareCheck(players[i])) {
        if (players[player].circleIntersect(players[i])) {
          if (!(collisions.contains(players[i]))) {
            players[player].shipDetect = true;
            players[i].shipDetect = true;
            collisions.add(players[player]);
            collisions.add(players[i]);
          }
          return;
        } else {
          collisions.remove(players[player]);
          collisions.remove(players[i]);
          players[player].shipDetect = false;
          players[i].shipDetect = false;
        }
      } else {
        collisions.remove(players[player]);
        collisions.remove(players[i]);
        players[player].shipDetect = false;
        players[i].shipDetect = false;
      }
    }
  }
}
 
void checkBullets(PlayerShip player) {
  for (int i = 0; i < (player.bullets).length; i++) {
    if (!(player.bullets[i]).onHold) {
      for (int j = 0; j < players.length; j++) {
        if (players[j] != player) {
          if (players[j].squareCheckBullet(player.bullets[i])) {
            if (players[j].bulletCollide(player.bullets[i])) {
              players[j].destroy();
            }
          }
        }
      }
    }
  }
} 

void setupPlayers() {
  players[0] = new PlayerShip(100, 100, 0);
  players[1] = new PlayerShip(width - 50, height - 100, 1);
  players[1].rotate(PI);
}

void movePlayers() {
  for (int i = 0; i < players.length; i++) {
    players[i].moveForward(speed);
  }
}

void asteroidsCheck() {
  for (int i = 0; i < asteroids.length; i++) {
    for (int j = 0; j < asteroids.length; j++) {
      if (i != j) {
        asteroids[i].asteroidCollide(asteroids[j]);
      }
    }
    for (int k = 0; k < players.length; k++) {
      asteroids[i].playerCollide(players[k]);
    }
  }
}

void asteroidsSetup() {
  for (int i = 0; i < asteroids.length; i++) {
    asteroids[i] = new Asteroid(int(random(5, 8))*5, 
    random(100, width-100), random(100, height-100), asteroidSpeed);
  }
}

void asteroids() {
  for (int i = 0; i < asteroids.length; i++) {
    asteroids[i].move();
    asteroids[i].display();
  }
}
