// main.pde
// MAIN FILE handling setup, draw, game logic, collisions, and wave management

// ---------------------------------------
// GLOBAL VARIABLES AND SETTINGS
// ---------------------------------------

//Health Pack
PImage healthImage;
boolean healthPackActive = false;
float healthPackX, healthPackY;
float healthPackRadius =32; // Adjust based on image size


// Player and Game state variables
float playerX, playerY;
float playerSpeed = 5;
float playerHomeX, playerHomeY;
boolean movingLeft = false, movingRight = false, movingUp = false, movingDown = false;
boolean shooting = false;
boolean playerAlive = true;
int maxHealth = 100;
int playerHealth = maxHealth;
float playerRadius = 15;

boolean canShoot = true; // so we shoot only once per Space press

// Player animation
PImage[] playerFrames;
int playerFrameCount = 64;
int currentPlayerFrame = 0;
float playerFrameTimer = 0.0;
float playerFrameDelay = 0.05;

// World boundaries
float worldLeft, worldRight, worldTop, worldBottom;

// Bullets and Enemies are in other files
ArrayList<Bullet> playerBullets;
ArrayList<Bullet> enemyBullets;
ArrayList<Enemy> enemies;

// Wave logic for enemies
int waveIndex = 0;

// Owners for bullets
final int OWNER_PLAYER = 1;
final int OWNER_ENEMY = 2;
float bulletRadius = 5;
int enemyBulletDamage = 25;

// Camera/Projection
float nearDist = 50;
float farDist = 2000;
float fov = PI/3.0;

// Explosion stuff in Explosion.pde
ArrayList<Explosion> explosions;

// Score
int kills = 0;

// Flags for textures, collisions
boolean doTextures = true;
boolean doCollision = false;

void setup() {
  setupAudio();
  size(600, 600, P3D);
  initGame();
}

void initGame() {
  
  healthPackActive = false;
  healthImage = loadImage("health.png");
  textureMode(NORMAL);
  textureWrap(REPEAT);

  float aspect = float(width)/float(height);
  float t = nearDist * tan(fov/2.0);
  float l = -t*aspect;
  float r = t*aspect;
  float top = -t;   
  float bottom = t; 
  frustum(l, r, top, bottom, nearDist, farDist);

  // Just making the world symmetrical
  worldLeft = -300;
  worldRight = 300;
  worldTop = -300;
  worldBottom = 300;

  playerX = 0;
  playerY = 200;
  playerHomeX = playerX;
  playerHomeY = playerY;
  
  playerBullets = new ArrayList<Bullet>();
  enemyBullets = new ArrayList<Bullet>();

  playerFrames = new PImage[playerFrameCount];
  for (int i=0; i<playerFrameCount; i++) {
    playerFrames[i] = loadImage("player/player ("+(i+1)+").png");
  }

  loadEnemyImages(); // from Enemy.pde
  enemies = new ArrayList<Enemy>();
  
  // Load the boss image
  bossImage = loadImage("boss.png");
  
  waveIndex = 0;
  spawnWave(); // first wave of enemies

  initGalaxy(); // from Galaxy.pde
  explosions = new ArrayList<Explosion>();
  
  playerAlive = true;
  playerHealth = 100;
  enemyDifficulty = 0;
  kills = 0;
  
  canShoot = true;
  smooth(8);
}

void draw() {
  background(0);
  
  camera(0,0,500, 0,0,0, 0,1,0);

  drawSpiralGalaxy(); // from Galaxy.pde
  
  if (playerAlive) {
    updatePlayer();
  }

  // Update enemies
  for (int i=0; i<enemies.size(); i++) {
    enemies.get(i).update();
  }
  
  // Update bullets
  for (int i = playerBullets.size()-1; i>=0; i--) {
    Bullet b = playerBullets.get(i);
    b.update();
    if (b.offScreen()) {
      playerBullets.remove(i);
    }
  }
  
  for (int i = enemyBullets.size()-1; i>=0; i--) {
    Bullet b = enemyBullets.get(i);
    b.update();
    if (b.offScreen()) {
      enemyBullets.remove(i);
    }
  }
  
  if (playerAlive) {
    checkCollisions();
  }

  // Draw enemies
  for (Enemy e : enemies) e.drawMe();
  // Draw bullets
  for (Bullet b : playerBullets) b.drawMe();
  for (Bullet b : enemyBullets) b.drawMe();
  
  // Draw explosions
  for (int i = explosions.size()-1; i>=0; i--) {
    Explosion ex = explosions.get(i);
    ex.update();
    ex.drawMe();
    if (ex.isDone()) explosions.remove(i);
  }
  
  if (playerAlive) drawPlayer();
  
  // Draw health pack if active
  if (healthPackActive) {
    image(healthImage, healthPackX, healthPackY); //data comes from enemy.pde (when boss dies)

  }

  hint(DISABLE_DEPTH_TEST);
  camera(); 
  noLights();
  
  drawUI();
  
  if (!playerAlive) {
    drawGameOverScreen();
  }
  
  
  
  hint(ENABLE_DEPTH_TEST);
}

void checkCollisions() {
  
  // Player vs health pack
  if (healthPackActive && circleCollision(playerX, playerY, playerRadius, healthPackX, healthPackY, healthPackRadius)) {
    playerHealth = maxHealth; // Restore full health
    healthPackActive = false; // Remove the health pack
  }
  
  // bullet vs player
  for (int i=enemyBullets.size()-1; i>=0; i--) {
    Bullet eb = enemyBullets.get(i);
    if (circleCollision(playerX, playerY, playerRadius, eb.x, eb.y, bulletRadius)) {
      playerHealth -= enemyBulletDamage;
      enemyBullets.remove(i);
      if (playerHealth <= 0) {
        killPlayer();
      }
    }
  }

  // player vs enemies
  if (playerAlive) {
    for (int i=enemies.size()-1; i>=0; i--) {
      Enemy e = enemies.get(i);
      if (circleCollision(playerX, playerY, playerRadius, e.x, e.y, enemyRadius)) {
        killsEnemy(e);
        killPlayer();
        break;
      }
    }
  }

  // player bullets vs enemies
  // player bullets vs enemies
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    for (int j = playerBullets.size() - 1; j >= 0; j--) {
      Bullet pb = playerBullets.get(j);
      if (circleCollision(e.x, e.y, e.myRadius, pb.x, pb.y, bulletRadius)) {
        e.health -= 1; // Decrement health
        playerBullets.remove(j); // Remove the bullet that hit
        
        if (e.health <= 0) {
          e.postDeathEffects();
          killsEnemy(e);
        }
        break; // No need to check other bullets once its hit
      }
    }
  }
 //<>//

  // If wave cleared
  if (playerAlive) {
    if (enemies.size() == 0) {
      waveIndex++;
      spawnWave();
    }
  }

  // bullet vs bullet
  for (int i=playerBullets.size()-1; i>=0; i--) {
    Bullet pb = playerBullets.get(i);
    for (int j=enemyBullets.size()-1; j>=0; j--) {
      Bullet eb = enemyBullets.get(j);
      if (circleCollision(pb.x, pb.y, bulletRadius, eb.x, eb.y, bulletRadius)) {
        playerBullets.remove(i);
        enemyBullets.remove(j);
        break;
      }
    }
  }
}

boolean circleCollision(float x1, float y1, float r1, float x2, float y2, float r2) {
  float dx = x2 - x1;
  float dy = y2 - y1;
  float distSq = dx*dx + dy*dy;
  float sum = (r1+r2);
  return distSq <= sum*sum;
}

void killPlayer() {
  playerHealth = 0;
  playerDeath(); // Play the player death sound
  playerAlive = false;
  spawnExplosion(playerX, playerY, true); // BIG explosion for player
}

void killsEnemy(Enemy e) {
  enemyDeath(); // Play the enemy death sound
  spawnExplosion(e.x, e.y, false); // normal explosion
  enemies.remove(e);
  incrementDifficulty();
  kills++;
}

void incrementDifficulty() {
  enemyDifficulty += 1;
}

void spawnWave() {
  int startIndex = (waveIndex * 3) % 10;

  // Normal enemies
  for (int i=0; i<numberOfEnemies; i++) {
    int imgIndex = (startIndex + i) % 10;
    enemies.add(spawnEnemy(enemyImages[imgIndex], false));
  }

  // Every 5th wave, spawn a boss
  if (waveIndex > 0 && waveIndex % 5 == 0) {
    spawnBoss();
  }
}

void resetGame() {
  initGame();
}
