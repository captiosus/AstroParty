PlayerShip[] players = new PlayerShip[2];

ArrayList<PlayerShip> collisions = new ArrayList<PlayerShip>();

int w;
int h;
int wallLength;
int wallHeight;

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
  wallLength = width/15;
  wallHeight = height/15;
  walls = new Wall[10];
  for (int i = 0; i < walls.length; i ++)
    walls[i] = new Wall((i+1) * wallLength, (i+1) * wallHeight, wallLength, wallHeight, false);
  setupPlayers();
  maxAsteroids = 10;
  asteroids = new Asteroid[int(random(2, maxAsteroids))];
  asteroidsSetup();
  
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
  for (int i = 0; i < walls.length; i ++)
    if (walls[i].isDestroyed == false)
      walls[i].display();
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
  for (int i = 0; i < walls.length; i ++) 
    p.wallCollision(walls[i]);

  if (p.wallConflictT == true)
    p.centroidY --;
  if (p.wallConflictB == true)
    p.centroidY ++;
  if (p.wallConflictL == true)
    p.centroidX --;
  if (p.wallConflictR == true)
    p.centroidX ++;
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
            players[player].collideMove(players[i], speed);
          } else {
            players[player].collideMove(players[i], speed);
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
  int xStart = w * 5;
  int yStart = w * 5;
  players[0] = new PlayerShip(xStart, yStart, 0);
  players[1] = new PlayerShip(width - xStart, height - yStart, 1);
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
