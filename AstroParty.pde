PlayerShip[] players = new PlayerShip[2];

ArrayList<PlayerShip> collisions = new ArrayList<PlayerShip>();

int w;
int h;

int reload = 20;
int reloadCount = 0;
int speed = 5;
boolean[] keys = new boolean[255];

float[][] boundaries = new float[players.length][2];

void setup() {
  size(800, 600);
  frameRate(60);
  players[0] = new PlayerShip(0, 0, 0);
  w = players[0].w;
  h = players[0].h;
  setupPlayers();
}
void draw() {
  background(0, 0, 0);
  updateKeys();
  movePlayers();
  for (int i = 0; i < players.length; i++) {
    checkPlayers(i);
    players[i].update();
    players[i].display();
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
    }
    else {
      reloadCount = 0;
      players[0].shoot();
    }
  }
  if (keys['D']) {
    players[1].rotate(PI/50);
  }
}


void checkPlayers(int player) {
  for (int i = 0; i < players.length; i++) {
    if (i != player) {
      if (players[player].squareCheck(players[i])) {
        if(players[player].circleIntersect(players[i])) {
          if(!(collisions.contains(players[i]))) {
            players[player].shipDetect = true;
            players[i].shipDetect = true;
            collisions.add(players[player]);
            collisions.add(players[i]);
            players[player].collideMove(players[i], speed);
          }
          else {
            players[player].collideMove(players[i], speed);
          }
          return;
        }
        else {
          collisions.remove(players[player]);
          collisions.remove(players[i]);
          players[player].shipDetect = false;
          players[i].shipDetect = false;
        }
      }
      else {
        collisions.remove(players[player]);
        collisions.remove(players[i]);
        players[player].shipDetect = false;
        players[i].shipDetect = false;
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
